#!/usr/bin/env bash
# Stage only the validated public binary on a disposable branch for native CI upload.
set -euo pipefail
archive=${1:?Usage: stage-release.sh /path/CatAtlas-Windows.zip [--prepare-only|--publish]}
mode=${2:---prepare-only}
case "$mode" in --prepare-only|--publish) ;; *) echo 'Expected --prepare-only or --publish' >&2; exit 2 ;; esac
archive=$(realpath -- "$archive")
repository=$(git -C "$(dirname -- "${BASH_SOURCE[0]}")/.." rev-parse --show-toplevel)
workflow="$repository/.github/workflows/publish-staged-release.yml"
[[ -f "$workflow" ]] || { echo 'Publishing workflow template is missing' >&2; exit 1; }
bash "$repository/scripts/publish-release.sh" "$archive" --verify-only
expected=ae54c340b146b0e0078e26b7c5d7245661515f9c0cb15843c7b485414b425848
tag=cat-atlas-windows-20261107
branch="release-upload/$tag-$(date -u +%Y%m%dT%H%M%SZ)-$$"
git check-ref-format --branch "$branch" > /dev/null
staging=$(mktemp -d)
trap 'rm -rf -- "$staging"' EXIT
split --bytes=62914560 --numeric-suffixes=1 --suffix-length=3 -- "$archive" "$staging/CatAtlas-Windows.zip.part"
parts=("$staging"/CatAtlas-Windows.zip.part*)
[[ ${#parts[@]} -eq 2 ]] || { echo 'Expected exactly two archive parts' >&2; exit 1; }
printf '%s  CatAtlas-Windows.zip\n' "$expected" > "$staging/CatAtlas-Windows.zip.sha256"
index="$staging/git-index"
index_git() { GIT_INDEX_FILE="$index" git -C "$repository" "$@"; }
stage_file() {
  local blob
  blob=$(git -C "$repository" hash-object -w --no-filters -- "$1")
  index_git update-index --add --cacheinfo "100644,$blob,$2"
}
index_git read-tree --empty
stage_file "${parts[0]}" release-upload/CatAtlas-Windows.zip.part001
first_tree=$(index_git write-tree)
first_commit=$(git -C "$repository" commit-tree "$first_tree" -m 'Stage first verified Windows package part')
# No workflow is present in this first orphan commit, so the first push cannot publish.
stage_file "${parts[1]}" release-upload/CatAtlas-Windows.zip.part002
stage_file "$staging/CatAtlas-Windows.zip.sha256" release-upload/CatAtlas-Windows.zip.sha256
stage_file "$workflow" .github/workflows/publish-staged-release.yml
final_tree=$(index_git write-tree)
final_commit=$(git -C "$repository" commit-tree "$final_tree" -p "$first_commit" -m 'Publish the verified Windows package with native GitHub credentials')
printf 'STAGING_BRANCH=%s\nFIRST_COMMIT=%s\nFINAL_COMMIT=%s\n' "$branch" "$first_commit" "$final_commit"
if [[ "$mode" == --prepare-only ]]; then
  echo 'Prepared local Git objects only; main, index and remote refs are unchanged.'
  exit 0
fi
origin=$(git -C "$repository" remote get-url origin)
case "$origin" in
  https://github.com/WhiliMior/CatAtlas-Releases|https://github.com/WhiliMior/CatAtlas-Releases.git|git@github.com:WhiliMior/CatAtlas-Releases.git) ;;
  *) echo 'Origin must be the public WhiliMior/CatAtlas-Releases repository' >&2; exit 1 ;;
esac
if git -C "$repository" ls-remote --exit-code origin "refs/heads/$branch" > "$staging/remote-ref"; then
  echo 'Staging branch already exists; refusing to replace it' >&2
  exit 1
else
  result=$?
  [[ "$result" -eq 2 ]] || exit "$result"
fi
git -C "$repository" push origin "$first_commit:refs/heads/$branch"
git -C "$repository" push origin "$final_commit:refs/heads/$branch"
printf 'Publishing workflow triggered on %s. It removes the branch only after successful publication and public download verification.\n' "$branch"

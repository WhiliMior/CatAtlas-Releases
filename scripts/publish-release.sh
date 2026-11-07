#!/usr/bin/env bash
# Publish the supplied Windows archive without putting large binaries into Git.
set -euo pipefail
archive=${1:?Usage: publish-release.sh /path/CatAtlas-Windows.zip [--publish]}
mode=${2:---verify-only}
if [[ "$mode" != --publish && "$mode" != --verify-only ]]; then
  echo 'Second argument must be --verify-only or --publish.' >&2
  exit 2
fi
archive=$(realpath -- "$archive")
expected=ae54c340b146b0e0078e26b7c5d7245661515f9c0cb15843c7b485414b425848
actual=$(sha256sum -- "$archive")
actual=${actual%% *}
[[ "$actual" == "$expected" ]] || { echo 'Archive SHA-256 differs from the validated upload.' >&2; exit 1; }
python3 - "$archive" <<'PY'
from pathlib import PurePosixPath
import sys, zipfile
with zipfile.ZipFile(sys.argv[1]) as bundle:
    names = set(bundle.namelist())
    required = {'CatAtlas.exe', 'CatAtlas.pck', 'design_config.json', 'localization.json'}
    assert required <= names, 'Required game files are missing'
    for name in names:
        path = PurePosixPath(name)
        assert not path.is_absolute() and '..' not in path.parts and chr(92) not in name
    assert bundle.testzip() is None, 'ZIP CRC check failed'
print('ZIP structure, CRC, and expected SHA-256 verified.')
PY
[[ "$mode" == --publish ]] || exit 0
repository=WhiliMior/CatAtlas-Releases
tag=cat-atlas-windows-20261107
# Check API access before making changes. Do not replace existing releases.
gh api "repos/$repository" --jq .full_name
release_probe=$(mktemp)
cleanup_probe() { rm -f -- "$release_probe"; }
trap cleanup_probe EXIT
if gh release view "$tag" --repo "$repository" >"$release_probe" 2>&1; then
  echo "Release $tag already exists; inspect it instead of overwriting it." >&2
  exit 1
elif ! rg -qi 'release not found|HTTP 404|Not Found' "$release_probe"; then
  cat "$release_probe" >&2
  exit 1
fi
staging=$(mktemp -d)
cleanup() { rm -rf -- "$staging"; rm -f -- "$release_probe"; }
trap cleanup EXIT
ln -s -- "$archive" "$staging/CatAtlas-Windows.zip"
printf '%s  CatAtlas-Windows.zip\n' "$expected" > "$staging/CatAtlas-Windows.zip.sha256"
cat > "$staging/notes.md" <<'NOTES'
Cat Atlas · 猫咪环游手记 — Windows x64 build

Download `CatAtlas-Windows.zip` (115.92 MiB), extract every file into one folder, and run `CatAtlas.exe`.
Keep `CatAtlas.pck`, both JSON files, and `licenses/` beside the EXE. The game includes English and Simplified Chinese.

下载 ZIP 后完整解压，再运行 `CatAtlas.exe`。请将 PCK、两个 JSON 文件和许可证目录保留在同一目录。

The supplied archive has passed ZIP integrity and file-structure checks. Windows runtime behavior has not been tested in this Linux environment.
NOTES
gh release create "$tag" --repo "$repository" --target main --draft \
  --title 'Cat Atlas — Windows build (2026-11-07)' --notes-file "$staging/notes.md" \
  "$staging/CatAtlas-Windows.zip" "$staging/CatAtlas-Windows.zip.sha256"
mkdir "$staging/verify"
gh release download "$tag" --repo "$repository" --pattern CatAtlas-Windows.zip --dir "$staging/verify"
(cd "$staging/verify" && sha256sum -c ../CatAtlas-Windows.zip.sha256)
gh release edit "$tag" --repo "$repository" --draft=false
public_url="https://github.com/$repository/releases/download/$tag/CatAtlas-Windows.zip"
curl --fail --silent --show-error --location --head --max-time 30 "$public_url" >/dev/null
printf 'Verified public download: %s\n' "$public_url"

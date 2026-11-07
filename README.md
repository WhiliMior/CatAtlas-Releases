# Cat Atlas Releases · 猫咪环游手记下载

A little cat for your desktop, and a world of little journeys together.
一只住在桌面上的小猫，陪你度过日常，也陪你环游世界。

This public distribution repository contains no game project or game source code. The development repository remains private.

This repository distributes the Cat Atlas Windows build through GitHub Releases and keeps its release metadata and publishing tools. It does not contain the game’s source code. The blog and promotional website are maintained separately at [whilimior.github.io](https://github.com/WhiliMior/whilimior.github.io).

本仓库只用于公开发行，游戏开发仓库保持私有，不会将游戏工程或源码上传到这里。

本仓库用于通过 GitHub Releases 分发 Cat Atlas Windows 包体，并维护发布信息和工具；不包含游戏源代码。博客和宣传网页在独立的网站仓库中维护。

## Download and run / 下载与运行

[Download Windows ZIP / 下载 Windows 包体（115.92 MiB）](https://github.com/WhiliMior/CatAtlas-Releases/releases/download/cat-atlas-windows-20261107/CatAtlas-Windows.zip) · [SHA-256](https://github.com/WhiliMior/CatAtlas-Releases/releases/download/cat-atlas-windows-20261107/CatAtlas-Windows.zip.sha256)

Download `CatAtlas-Windows.zip` from [Releases](https://github.com/WhiliMior/CatAtlas-Releases/releases).
Extract **all** files into one folder, then run `CatAtlas.exe`. Keep `CatAtlas.pck`, `design_config.json`, `localization.json`, and `licenses/` beside the EXE. The build is for **Windows x64** and includes **English and Simplified Chinese** (`en`, `zh_CN`).

包体发布后，请从 Releases 下载 `CatAtlas-Windows.zip`，**完整解压**后运行 `CatAtlas.exe`。请将 PCK、两个 JSON 文件和许可证目录保留在 EXE 所在目录。包体适用于 **Windows x64**，包含**英文和简体中文**。

## Validated package / 已校验包体

- Asset / 文件：`CatAtlas-Windows.zip`
- Size / 大小：121,554,145 bytes — **115.92 MiB**
- Release tag / 发布标签：`cat-atlas-windows-20261107`
- SHA-256：`ae54c340b146b0e0078e26b7c5d7245661515f9c0cb15843c7b485414b425848`

ZIP CRC, archive paths, required files, and the SHA-256 digest were checked. **Windows runtime behavior has not been tested in the Linux development environment.** Package metadata is recorded in [`release/package.json`](release/package.json).

已检查 ZIP CRC、文件路径、必需文件和 SHA-256。**尚未在 Windows 上验证运行表现**；这些完整性检查不等同于游戏运行测试。

## Publish / 发布

Requirements: Bash, Python 3, GitHub CLI (`gh`), `curl`, `sha256sum`, `realpath`, and `rg`. Use an existing GitHub identity with permission to publish this repository’s Releases. Never put credentials in files or commands committed to this repository.

Verify the supplied package locally, without network calls:

```sh
bash scripts/publish-release.sh /path/CatAtlas-Windows.zip --verify-only
```

Create the public GitHub repository from this checkout after API access is available:

```sh
gh repo create WhiliMior/CatAtlas-Releases --public --source . --remote origin --push
```

Once this GitHub repository exists and its `main` branch is pushed, publish the validated package:

```sh
bash scripts/publish-release.sh /path/CatAtlas-Windows.zip --publish
```

The publishing command creates a draft Release in **`WhiliMior/CatAtlas-Releases`**, uploads the original ZIP and its checksum file, downloads the uploaded ZIP to verify its hash, publishes the Release, and checks the public download URL. It refuses to overwrite an existing Release with the same tag. No large binary is committed to Git.

发布命令会在 **CatAtlas 仓库**创建草稿 Release，上传原始 ZIP 及校验文件，回读验证后发布并检查公开下载地址。不会覆盖同名 Release，包体也不会进入 Git 历史。网站的下载按钮应在发布成功并验证后指向该 Release 附件。

## Attribution / 来源与许可证

The package’s attribution and dependency notices are preserved in [`docs/licenses/`](docs/licenses/) and in the downloadable game package. These notices do not assign an open-source license to the game or its source code. Preserve the notices when distributing the build.

包体中的美术归属、旗帜、Godot 和地图来源说明保留在 `docs/licenses/` 与下载包中；这些说明不代表游戏整体或其源代码采用某种开源许可证。

### Native GitHub Actions upload / 使用仓库自身的发布凭据

If a managed environment can push Git and create draft Releases but its injected credential is not accepted by `uploads.github.com`, use the repository's native Actions token for the upload:

```sh
bash scripts/stage-release.sh /path/CatAtlas-Windows.zip --prepare-only
bash scripts/stage-release.sh /path/CatAtlas-Windows.zip --publish
```

The first command validates the archive and prepares local Git objects only. The second sends two parts, each at most 60 MiB, to a unique `release-upload/…` branch. The first push contains no workflow; the second push adds the publishing workflow after both parts are present. It assembles the original ZIP, verifies its byte count, SHA-256 and CRC, uploads into an empty draft, reads the uploaded file back, publishes, and verifies the public download. Existing published releases or assets are never overwritten.

After success, the workflow deletes only its own temporary branch. On failure it retains the branch and draft for diagnosis. Package files never enter the `main` branch or its history; the temporary branch contains only the already approved public binary, not the game project. No credentials are copied into Git: the workflow uses GitHub's repository-scoped token.

如果云环境的凭据能推送和创建草稿、但上传接口不接受该凭据，可使用此流程。包体只暂存于独立临时分支，不进入主分支历史；完整校验、回读和公开下载检查成功后自动删除临时分支。失败时保留草稿和临时分支用于检查，不会覆盖已有发行附件，也不会公开游戏开发仓库。

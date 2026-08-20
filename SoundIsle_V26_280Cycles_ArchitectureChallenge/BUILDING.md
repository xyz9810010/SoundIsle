# SoundIsle Building

## Rule
Do not write "latest version". Record the exact versions observed in the development environment.

## Required Toolchain Record (verified 2026-08-20)
```text
DevEco Studio:    6.1.1.300 (build 243.24978.46.36.611300)
HarmonyOS SDK/API: HarmonyOS 6.1.1 / API 24 (SDK version 6.1.1.125)
ArkTS:            API 24 toolchain (bundled with DevEco Studio)
Hvigor:           6.24.4 (@ohos/hvigor)
ohpm:             6.1.2.285
Node:             v18.20.1 (DevEco-bundled: C:\Program Files\Huawei\DevEco Studio\tools\node)
JDK:              21.0.8 JBR (DevEco-bundled jbr; system Temurin 21.0.12 also present)
Host OS:          Microsoft Windows 11 (10.0.26100), PowerShell 5.1.26100.4652
```

The SDK uses DevEco Studio's "all-in-one" install: the SDK lives under
`C:\Program Files\Huawei\DevEco Studio\sdk\default` and is located via the
`DEVECO_SDK_HOME` environment variable (pointing at `...\DevEco Studio\sdk`).
Do **not** add a `local.properties` pointing at an empty `%LOCALAPPDATA%\Huawei\Sdk`.

## Clean Build
From the repository root (the directory containing `build.ps1`):

```powershell
./build.ps1
```

`build.ps1` sets `DEVECO_SDK_HOME`, `JAVA_HOME` (jbr), prepends the DevEco node to
`PATH`, then invokes:

```text
node.exe "<DevEco>\tools\hvigor\bin\hvigorw.js" assembleHap --mode module -p product=default -p buildMode=debug --no-daemon
```

Output: `entry\build\default\outputs\default\entry-default-unsigned.hap`.
(Unsigned build is expected for M0; the "No signingConfig" WARN is informational.)

## Tests
```powershell
# one-time dependency install
Set-Location entry
& "C:\Program Files\Huawei\DevEco Studio\tools\ohpm\bin\ohpm.bat" install

# run baseline unit tests (host-side, @ohos/hypium 1.0.28)
Set-Location ..
$env:DEVECO_SDK_HOME = "C:\Program Files\Huawei\DevEco Studio\sdk"
$env:JAVA_HOME = "C:\Program Files\Huawei\DevEco Studio\jbr"
$env:PATH = "C:\Program Files\Huawei\DevEco Studio\jbr\bin;C:\Program Files\Huawei\DevEco Studio\tools\node;$env:PATH"
& "C:\Program Files\Huawei\DevEco Studio\tools\node\node.exe" "C:\Program Files\Huawei\DevEco Studio\tools\hvigor\bin\hvigorw.js" test
```

Result report: `entry\.test\default\outputs\test\reports\index.html`.

## Device Install / Signing
A Huawei AGC debug provisioning profile for `com.soundisle.app` + the target device
UDID is configured via DevEco Studio auto-signing; `build-profile.json5` references
`signingConfig: "default"` and the build now emits `entry-default-signed.hap`.

```powershell
# list targets
& "C:\Program Files\Huawei\DevEco Studio\sdk\default\openharmony\toolchains\hdc.exe" list targets

# install the signed HAP
& "C:\Program Files\Huawei\DevEco Studio\sdk\default\openharmony\toolchains\hdc.exe" install entry\build\default\outputs\default\entry-default-signed.hap

# launch
& "C:\Program Files\Huawei\DevEco Studio\sdk\default\openharmony\toolchains\hdc.exe" shell aa start -a EntryAbility -b com.soundisle.app
```

Note: the signing material (in `~/.ohos/config/default_SoundIsle_*`) and the
`signingConfigs.material` block in `build-profile.json5` are machine/account-specific
(absolute paths + encrypted keystore passwords) and must not be committed to VCS.

## AI Handoff
Before modifying code, an AI agent must:
1. read MASTER_PLAN.md and DOCUMENT_PRECEDENCE.md
2. read CURRENT_MILESTONE.md
3. read TASKS.md
4. read ARCHITECTURE.md
5. read AUDIO_ARCHITECTURE.md for playback work
6. run the documented baseline build/tests
7. update PROJECT_STATUS.md after material changes

## Autonomous Agent
Agents must also read `AGENTS.md` before implementation.

## No Guessed Commands
Build/test commands above are the exact commands verified against this repository's
real toolchain; they are not invented Hvigor/ohpm syntax.

fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios beta

```sh
[bundle exec] fastlane ios beta
```

构建并上传到 TestFlight

### ios upload

```sh
[bundle exec] fastlane ios upload
```

仅上传已构建的 IPA（跳过 flutter build，需先 flutter build ipa）

### ios release

```sh
[bundle exec] fastlane ios release
```

构建并提交 App Store 审核（默认不自动提交）

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).

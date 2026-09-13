<div align="center">

# <img src="icon.svg" width="36" height="36" align="top" alt="Icon"> Anti-Debugger Bypass

[![Chrome Extension](https://img.shields.io/badge/Chrome-Extension-4285F4?logo=googlechrome&logoColor=white)](https://google.com/chrome)
[![GitHub stars](https://img.shields.io/github/stars/mingnhat99/anti-debugger?style=social)](https://github.com/mingnhat99/anti-debugger/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/mingnhat99/anti-debugger?style=social)](https://github.com/mingnhat99/anti-debugger/network/members)
[![GitHub issues](https://img.shields.io/github/issues/mingnhat99/anti-debugger)](https://github.com/mingnhat99/anti-debugger/issues)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

*A powerful Chrome extension to bypass common anti-debugging scripts and DevTools traps.*

[Installation](#-installation) • [Features](#-features) • [Usage](#-usage) • [Contributing](#-contributing)

</div>

## 📖 Overview

**Anti-Debugger Bypass** is a lightweight Google Chrome extension designed to neutralize common client-side JavaScript anti-debugging techniques. By injecting a script at `document_start`, this extension intercepts and neutralizes traps designed to crash or halt your browser's Developer Tools (DevTools).

Whether you're a security researcher, a penetration tester, or just trying to inspect elements without being interrupted by infinite `debugger` statements, this extension ensures a smooth debugging experience.


## ✨ Features

- 🛑 **Eval Debugger Block**: Intercepts and neutralizes `eval("debugger")`.
- 🛡️ **Safe Function Constructor**: Patches `window.Function` to prevent `Function("debugger")()` calls cleanly across multiple layers.
- ⏱️ **SetInterval Protection**: Blocks malicious loops using `setInterval` that execute `debugger` or `eval`.
- 🔗 **Redirect Prevention**: Prevents aggressive anti-debug scripts from redirecting `location.href` away from the current page.
- 📴 **Console Tamper Protection**: Temporarily disables console output clearing (`console.clear`) and timing checks during page load, restoring them automatically afterward.
- 🔐 **CSP Enforcement**: Uses a Content-Security-Policy meta tag to help neutralize inline `eval` payloads.

## 🚀 Installation

Since this extension is not currently on the Chrome Web Store, you can install it manually in one of the following ways:

### Option 1: Download the prebuilt `.crx` (easiest)

1. Download `anti-debugger-bypass-<version_name>.crx` (e.g. `anti-debugger-bypass-1.1-rc1.crx`) from the latest [Release](../../releases/latest) (built automatically by CI), or the committed copy in the [`dist/`](dist) folder.
2. Open Google Chrome and navigate to `chrome://extensions/`.
3. Enable **Developer mode** using the toggle switch in the top right corner.
4. Drag and drop the downloaded `.crx` file onto the page.
5. The extension is now installed and active! 🎉

> **Note:** Chrome sometimes blocks extensions installed outside the Web Store. If the drag & drop is rejected, download the matching `.zip` from the same place, unzip it, and follow Option 2 below with the unzipped folder.

### Option 2: Load unpacked

1. **Clone or Download the repository:**
   ```bash
   git clone https://github.com/mingnhat99/anti-debugger.git
   ```
2. Open Google Chrome and navigate to `chrome://extensions/`.
3. Enable **Developer mode** using the toggle switch in the top right corner.
4. Click on the **Load unpacked** button in the top left.
5. Select the `anti-debugger` directory you just cloned/downloaded.
6. The extension is now installed and active! 🎉

### Building the `.crx` yourself

```bash
make        # builds dist/anti-debugger-bypass-<version_name>.crx (signed, requires Chrome)
make zip    # builds dist/anti-debugger-bypass-<version_name>.zip
make clean  # removes build artifacts
```

On the first run a private signing key (`extension.pem`) is generated automatically and reused afterwards, so the extension ID stays the same across builds. Keep this key private — it is git-ignored and must never be committed or lost.

### Automated releases (CI)

A GitHub Actions workflow (`.github/workflows/release.yml`) builds and attaches the `.crx`/`.zip` to a new GitHub release whenever the version in `manifest.json` changes and is pushed to `main`. Releases and files are named after `version_name` (free-form, e.g. `v1.1-rc1`), falling back to `version` when `version_name` is not set. It requires the base64-encoded signing key to be stored as the repository secret `CRX_PRIVATE_KEY`:

```bash
base64 -i extension.pem | pbcopy   # then paste into Settings > Secrets and variables > Actions
```

## 💻 Usage

Once installed and enabled, the extension runs automatically on all web pages (`<all_urls>`). 

1. Simply open Chrome Developer Tools (`F12` or `Ctrl+Shift+I` / `Cmd+Option+I`).
2. Navigate to a site with anti-debugging protections.
3. The extension seamlessly patches global functions in the `MAIN` execution world before scripts load.
4. Check your console. You should see the message: `[bypass] DevTools protection disabled. Console restored.` after the page is fully loaded.

## ⚠️ Disclaimer

This tool is created for **educational and security research purposes only**. Do not use it to violate the terms of service of websites or for malicious activities. The developers assume no liability and are not responsible for any misuse or damage caused by this program.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

If you like this project, please consider giving it a ⭐️!

## 📝 License

Distributed under the MIT License. See `LICENSE` for more information.

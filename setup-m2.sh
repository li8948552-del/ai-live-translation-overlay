#!/bin/bash
# One-shot setup for Japanese -> Simplified Chinese on Apple Silicon.
set -euo pipefail
cd "$(dirname "$0")"

if [ "$(uname -s)" != "Darwin" ] || [ "$(uname -m)" != "arm64" ]; then
    echo "Error: this package requires an Apple Silicon Mac."
    exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew is required. Install it from https://brew.sh and run this script again."
    exit 1
fi

echo "==> 1/6 Installing system dependencies"
brew install ffmpeg python@3.12
brew install --cask blackhole-2ch
PYTHON_BIN="$(brew --prefix python@3.12)/bin/python3.12"

echo "==> 2/6 Creating an isolated Python environment"
if [ ! -d .venv ]; then
    "$PYTHON_BIN" -m venv .venv
fi
./.venv/bin/python -m pip install --upgrade pip
./.venv/bin/python -m pip install -r requirements.lock.txt

echo "==> 3/6 Saving your OpenAI API Key to macOS Keychain"
./set-openai-key.sh

echo "==> 4/6 Choosing the Whisper speech-recognition model"
MEM_BYTES="$(/usr/sbin/sysctl -n hw.memsize)"
if [ "$MEM_BYTES" -lt 12000000000 ]; then
    WHISPER_REPO="mlx-community/whisper-small-mlx"
else
    WHISPER_REPO="mlx-community/whisper-medium-mlx"
fi

echo "==> 5/6 Downloading $WHISPER_REPO"
./.venv/bin/python -c "from huggingface_hub import snapshot_download; snapshot_download('$WHISPER_REPO')"

echo "==> 6/6 Installing LiveTranslate into your user Applications folder"
mkdir -p "$HOME/Applications"
./install-app.sh "$HOME/Applications"

echo
echo "Installation complete."
echo "Configure the Multi-Output Device as described in README_DEPLOY_ZH.md,"
echo "then open ~/Applications/LiveTranslate.app."

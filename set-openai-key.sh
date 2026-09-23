#!/bin/bash
set -euo pipefail

SERVICE="LiveTranslate OpenAI API Key"

echo "Paste your OpenAI API Key. Input is hidden and the key is stored in macOS Keychain."
IFS= read -r -s OPENAI_KEY
echo

if [ -z "$OPENAI_KEY" ]; then
    echo "No key entered; nothing changed."
    exit 1
fi

/usr/bin/security add-generic-password \
    -a "$USER" \
    -s "$SERVICE" \
    -w "$OPENAI_KEY" \
    -U >/dev/null

unset OPENAI_KEY
echo "OpenAI API Key saved to macOS Keychain."

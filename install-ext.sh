#!/bin/bash

JSON_FILE="vscode/extensions.json"

if [[ ! -f "$JSON_FILE" ]]; then
    echo "❌ Error: Could not find $JSON_FILE"
    exit 1
fi

# Use Python 3 one-liner to parse JSON and print extensions
python3 -c "import sys, json; print('\n'.join(json.load(open('$JSON_FILE'))['recommendations']))" | while read -r extension; do
    if [[ -n "$extension" ]]; then
        echo "⬇️  Installing: $extension..."
        code --install-extension "$extension" --force
    fi
done

echo "✅ All extensions processed!"
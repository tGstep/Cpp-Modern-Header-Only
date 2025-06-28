#!/usr/bin/env bash

AWESOME_MD="awesome-hpp.md"
AWESOME_URL="https://raw.githubusercontent.com/p-ranav/awesome-hpp/master/README.md"
DEPS_JSON="deps.json"

# Ensure file is available
if [[ ! -f $AWESOME_MD ]]; then
  echo "Downloading header-only library list..."
  curl -sSL "$AWESOME_URL" -o "$AWESOME_MD"
fi

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <query>"
  exit 1
fi

QUERY="$1"

# Extract markdown-style GitHub links
mapfile -t matches < <(grep -Eo '\[[^]]+\]\(https://github.com/[^)]+\)' "$AWESOME_MD" | grep -i "$QUERY")

if [[ ${#matches[@]} -eq 0 ]]; then
  echo "No matches found for \"$QUERY\""
  exit 0
fi

echo "Found matches:"
for i in "${!matches[@]}"; do
  NAME=$(echo "${matches[$i]}" | grep -oP '\[\K[^\]]+')
  URL=$(echo "${matches[$i]}" | grep -oP 'https://github.com/[^\)]+')
  echo "[$i] $NAME -> $URL"
done

read -p "Select a library number to add to deps.json: " INDEX
SELECTED="${matches[$INDEX]}"
NAME=$(echo "$SELECTED" | grep -oP '\[\K[^\]]+')
REPO=$(echo "$SELECTED" | grep -oP 'https://github.com/[^\)]+').git

# Create deps.json if missing
[[ ! -f $DEPS_JSON ]] && echo "[]" > "$DEPS_JSON"

# Append to JSON
TMP=$(mktemp)
jq --arg name "$NAME" --arg repo "$REPO" '. += [{name: $name, repo: $repo, includes: "include"}]' "$DEPS_JSON" > "$TMP" && mv "$TMP" "$DEPS_JSON"

echo "✔ Added $NAME to deps.json"
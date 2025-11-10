#!/usr/bin/env bash

# Script to convert GitHub Actions from tag pins to SHA pins
# Usage: ./convert_gha_to_sha.sh

GH_TOKEN="$(gh auth token)"

if [ ! -f "$1" ] && [ "$1" != "" ]; then
  echo "File not found: $1"
  echo "Usage: $0 [workflow-file.yml]"
  echo "If no file specified, will process all .yml files in .github/workflows/"
  exit 1
fi

# Function to get SHA for a GitHub action
get_action_sha() {
  action="$1"
  version="$2"

  # Extract owner/repo from action (e.g., "actions/checkout" from "actions/checkout@v4")
  repo=$(echo "$action" | cut -d'@' -f1)

  echo "Looking up $repo@$version..." >&2

  # Use GitHub API to get the SHA for the tag
  sha=$(curl -s "https://api.github.com/repos/$repo/git/refs/tags/$version" \
    --header "Authorization: Bearer $GH_TOKEN" |
    jq -r '.object.sha // empty' 2>/dev/null)

  if [ -z "$sha" ]; then
    # Try without 'v' prefix if it failed
    clean_version=${version#v}
    sha=$(curl -s "https://api.github.com/repos/$repo/git/refs/tags/v$clean_version" \
      --header "Authorization: Bearer $GH_TOKEN" |
      jq -r '.object.sha // empty' 2>/dev/null)
  fi

  if [ -z "$sha" ]; then
    echo "Could not find SHA for $repo@$version" >&2
    echo "$action@$version"
  else
    echo "$action@${sha:0:40} # $version"
  fi
}

# Function to process a single workflow file
process_file() {
  local file
  file="$1"
  echo "Processing $file..."

  # Find all uses: lines with @ tags (not already SHA)
  grep -n "uses:" "$file" | grep "@" | grep -v "@[a-f0-9]\{40\}" | while IFS=: read -r line_num line_content; do
    # Extract the action and version
    uses_part=$(echo "$line_content" | sed 's/.*uses: *//; s/ *#.*//')
    action=$(echo "$uses_part" | cut -d'@' -f1)
    version=$(echo "$uses_part" | cut -d'@' -f2)

    echo "Found: $action@$version on line $line_num"

    # Get the SHA version
    sha_version=$(get_action_sha "$action" "$version")

    # Replace in the file
    if [[ $sha_version != "$action@$version" ]]; then
      sed -i "${line_num}s|uses: *${action}@${version}.*|uses: $sha_version|" "$file"
      echo "  Updated to: $sha_version"
    else
      echo "  Skipped (could not resolve SHA)"
    fi
  done
}

# Check if jq is installed
if ! command -v jq &>/dev/null; then
  echo "Error: jq is required but not installed."
  echo "Install with: sudo apt-get install jq  # Ubuntu/Debian"
  echo "           or: brew install jq         # macOS"
  exit 1
fi

# Process files
if [ -z "$1" ]; then
  # Process all workflow files
  for file in .github/workflows/*.yml .github/workflows/*.yaml; do
    if [ -f "$file" ]; then
      process_file "$file"
    fi
  done
else
  # Process specific file
  process_file "$1"
fi

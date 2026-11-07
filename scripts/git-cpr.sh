#!/usr/bin/env bash

# Usage: ./pr-cpr.sh <PR_NUMBERS>

set -e

if [ $# -eq 0 ]; then
  echo "Usage: $0 <PR_NUMBER> [PR_NUMBER...]"
  echo "Example: $0 123 456 789"
  exit 1
fi

for PR_NUMBER in "$@"; do
  echo "=== Processing PR #$PR_NUMBER ==="

  # Get PR info using gh cli
  echo "Getting PR info..."
  PR_INFO=$(gh pr view $PR_NUMBER --json baseRefName,headRefName,headRefOid)
  BASE_BRANCH=$(echo "$PR_INFO" | jq -r '.baseRefName')
  HEAD_SHA=$(echo "$PR_INFO" | jq -r '.headRefOid')

  echo "PR #$PR_NUMBER: base=$BASE_BRANCH head=$HEAD_SHA"

  echo "Fetching PR branch..."
  git fetch origin pull/$PR_NUMBER/head:pr-$PR_NUMBER

  # Get the merge base between the PR branch and the base branch
  MERGE_BASE=$(git merge-base origin/$BASE_BRANCH pr-$PR_NUMBER)

  echo "Merge base: $MERGE_BASE"

  # Get commits that are in the PR but not in the base branch
  echo "Getting commits from PR via GitHub API..."
  # Ask gh for all commit OIDs in the PR, separated by newlines
  COMMITS=$(gh pr view $PR_NUMBER --json commits --jq '.commits[].oid')

  if [ -z "$COMMITS" ]; then
    echo "No new commits found in PR #$PR_NUMBER"
    git branch -D pr-$PR_NUMBER 2>/dev/null || true
    continue
  fi

  echo "Found commits:"
  git log --oneline $MERGE_BASE..pr-$PR_NUMBER

  echo ""
  echo "Cherry-picking commits..."
  echo "$COMMITS" | while read commit; do
    echo "Cherry-picking $commit"
    git cherry-pick -x $commit
  done
  echo "Done with PR #$PR_NUMBER!"
  echo ""

  # Cleanup
  git branch -D pr-$PR_NUMBER 2>/dev/null || true
done

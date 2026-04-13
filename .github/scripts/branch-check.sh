#!/bin/bash
# Enforce branch merge order:
# dev → stg → main
# Prevents skipping environments (e.g., merging dev directly to main)

set -e

BASE_BRANCH="${BASE_BRANCH}"
HEAD_BRANCH="${HEAD_BRANCH}"

echo "PR: $HEAD_BRANCH → $BASE_BRANCH"

if [ "$BASE_BRANCH" == "main" ]; then
  REQUIRED_ANCESTOR="stg"
elif [ "$BASE_BRANCH" == "stg" ]; then
  REQUIRED_ANCESTOR="dev"
else
  echo "No merge order rule for target branch: $BASE_BRANCH — skipping check"
  exit 0
fi

echo "Checking that '$HEAD_BRANCH' contains all commits from '$REQUIRED_ANCESTOR'..."

git fetch origin "$REQUIRED_ANCESTOR" --depth=100 2>/dev/null || true

MISSING=$(git log "origin/${REQUIRED_ANCESTOR}..${HEAD_BRANCH}" --oneline 2>/dev/null | wc -l)

# Check if HEAD_BRANCH is behind REQUIRED_ANCESTOR
BEHIND=$(git log "${HEAD_BRANCH}..origin/${REQUIRED_ANCESTOR}" --oneline 2>/dev/null | wc -l)

if [ "$BEHIND" -gt "0" ]; then
  echo ""
  echo "❌ MERGE ORDER VIOLATION"
  echo "Branch '$HEAD_BRANCH' is missing $BEHIND commit(s) from '$REQUIRED_ANCESTOR'."
  echo "Please merge '$REQUIRED_ANCESTOR' into '$HEAD_BRANCH' before opening this PR."
  echo ""
  git log "${HEAD_BRANCH}..origin/${REQUIRED_ANCESTOR}" --oneline
  exit 1
fi

echo "✅ Branch order check passed — '$HEAD_BRANCH' is up to date with '$REQUIRED_ANCESTOR'"

#!/bin/bash

# Simulate GitHub Action environment variables
export GITHUB_ENV="/tmp/github_env_test"
echo "" > $GITHUB_ENV

# Test with yasulab as triggering_actor
echo "=== Testing with yasulab as requestor ==="
requestor="yasulab"
requestee="rakuda-san-desu"

# Fetch username mapping from members.json API
members_json=$(curl -s https://yasslab.jp/members.json || echo "[]")

# Function to map GitHub username to Slack username
map_username() {
  local github_username=$1
  local slack_username=""

  # Special handling for bots
  if [[ "$github_username" == "dependabot[bot]" ]]; then
    echo "dependabot"
    return
  fi

  # Try to find mapping in members.json
  # ユーザー名は Ruby のコードに埋め込まず、引数で渡す（action.yml と同じ）
  slack_username=$(echo "$members_json" | ruby -r json -e '
    members = JSON.parse(STDIN.read)
    member = members.find { |m| m["username_github"] == ARGV[0] }
    puts member["username_slack"] if member
  ' "$github_username")

  # If mapping found, use it; otherwise use GitHub username as fallback
  if [[ -n "$slack_username" ]]; then
    echo "$slack_username"
  else
    echo "$github_username"
  fi
}

# Map usernames
REQUESTOR=$(map_username "$requestor")
REQUESTEE=$(map_username "$requestee")

# Export to environment (simulating GitHub Actions)
echo "REQUESTOR=$REQUESTOR" >> $GITHUB_ENV
echo "REQUESTEE=$REQUESTEE" >> $GITHUB_ENV

# Display results
echo "Input GitHub usernames:"
echo "  Requestor: $requestor"
echo "  Requestee: $requestee"
echo ""
echo "Mapped Slack usernames:"
echo "  REQUESTOR: $REQUESTOR"
echo "  REQUESTEE: $REQUESTEE"
echo ""
echo "Environment file contents:"
cat $GITHUB_ENV

# Cleanup
rm -f $GITHUB_ENV
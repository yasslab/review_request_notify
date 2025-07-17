#!/bin/bash

# Test script for username mapping
# Usage: ./test_mapping.sh <github_username>

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
  slack_username=$(echo "$members_json" | ruby -r json -e "
    members = JSON.parse(STDIN.read)
    member = members.find { |m| m['username_github'] == '$github_username' }
    puts member['username_slack'] if member
  ")
  
  # If mapping found, use it; otherwise use GitHub username as fallback
  if [[ -n "$slack_username" ]]; then
    echo "$slack_username"
  else
    echo "$github_username"
  fi
}

# Test with provided username or default test cases
if [[ -n "$1" ]]; then
  echo "Testing mapping for: $1"
  result=$(map_username "$1")
  echo "GitHub: $1 -> Slack: $result"
else
  # Test cases
  echo "Testing username mappings..."
  echo "=========================="
  
  test_users=("rakuda-san-desu" "yasulab" "nacchan99" "dependabot[bot]" "unknown-user")
  
  echo "GitHub -> Slack"
  echo "---------------"
  for user in "${test_users[@]}"; do
    result=$(map_username "$user")
    printf "%-20s -> %s\n" "$user" "$result"
  done
fi

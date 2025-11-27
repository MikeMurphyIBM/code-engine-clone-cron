#!/bin/sh

# Fail on any error
set -e

# Your Schematics workspace ID (already correct)
WORKSPACE_ID="us-south.workspace.clone-test.f1da6c21"

# API key injected securely from Code Engine secret
APIKEY="$IBM_CLOUD_API_KEY"

# Get IAM access token
TOKEN=$(curl -s -X POST \
  "https://iam.cloud.ibm.com/identity/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey=$APIKEY" \
  | jq -r .access_token)

echo "IAM token acquired."

# Trigger Schematics APPLY action
echo "Triggering Schematics apply on workspace $WORKSPACE_ID ..."

curl -s -X POST \
  "https://us-south.schematics.cloud.ibm.com/v2/workspaces/${WORKSPACE_ID}/actions/apply?refresh_token=${TOKEN}" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{}' \
  -o /tmp/apply_response.json

echo "Schematics apply triggered. Response saved to /tmp/apply_response.json"

# Print response to logs
cat /tmp/apply_response.json

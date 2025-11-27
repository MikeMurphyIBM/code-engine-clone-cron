#!/bin/sh
set -e

WORKSPACE_ID="us-south.workspace.clone-test.f1da6c21"

APIKEY="$IBM_CLOUD_API_KEY"

# Get IAM token
TOKEN=$(curl -s -X POST \
  "https://iam.cloud.ibm.com/identity/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey=$APIKEY" \
  | jq -r .access_token)

echo "IAM token acquired."

echo "Triggering Schematics APPLY on workspace $WORKSPACE_ID ..."

curl -s -X POST \
  "https://us-south.schematics.cloud.ibm.com/v2/workspaces/${WORKSPACE_ID}/actions" \
  -H "Authorization: Bearer $TOKEN" \
  -H "refresh_token: $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"action":"apply"}' \
  -o /tmp/apply_response.json

echo "Schematics APPLY triggered. Response saved."

cat /tmp/apply_response.json

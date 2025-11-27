#!/bin/sh
set -e

# Schematics workspace ID
WORKSPACE_ID="us-south.workspace.clone-test.f1da6c21"

# API key securely injected from Code Engine secret
APIKEY="$IBM_CLOUD_API_KEY"

echo "Getting IAM token..."
TOKEN=$(curl -s -X POST \
  "https://iam.cloud.ibm.com/identity/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey=$APIKEY" \
  | jq -r '.access_token')

echo "IAM token acquired."

echo "Triggering Schematics APPLY on workspace $WORKSPACE_ID ..."

curl -s -X POST \
  "https://us-south.schematics.cloud.ibm.com/v1/workspaces/${WORKSPACE_ID}/actions" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
        "action_id": "apply",
        "comment": "Triggered from Code Engine job"
      }' \
  -o /tmp/apply_response.json


echo "Schematics APPLY triggered. Response saved."
cat /tmp/apply_response.json

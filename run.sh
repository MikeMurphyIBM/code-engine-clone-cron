#!/bin/sh

# Fail on any error
set -e

WORKSPACE_ID="us-south.workspace.clone-test.f1da6c21"

# API key injected from Code Engine secret
APIKEY="$IBM_CLOUD_API_KEY"

# -----------------------------------------------------
# Get IAM access_token AND refresh_token
# -----------------------------------------------------
IAM_RESPONSE=$(curl -s -X POST \
  "https://iam.cloud.ibm.com/identity/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey=$APIKEY")

ACCESS_TOKEN=$(echo "$IAM_RESPONSE" | jq -r .access_token)
REFRESH_TOKEN=$(echo "$IAM_RESPONSE" | jq -r .refresh_token)

echo "IAM token acquired."

# -----------------------------------------------------
# Trigger APPLY action
# -----------------------------------------------------
echo "Triggering Schematics apply on workspace $WORKSPACE_ID ..."

curl -s -X POST \
  "https://us-south.schematics.cloud.ibm.com/v1/workspaces/${WORKSPACE_ID}/actions?refresh_token=${REFRESH_TOKEN}" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{"action_id": "apply"_

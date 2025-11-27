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

# --- START DEBUG STATEMENTS ---
echo "DEBUG: Schematics Private Endpoint Confirmed."
echo "DEBUG: Workspace ID value (in brackets): [${WORKSPACE_ID}]"
echo "DEBUG: WORKSPACE_ID character length: $(echo -n "${WORKSPACE_ID}" | wc -c)"
echo "DEBUG: Full API URL Attempted:"
echo "https://private-us-south.schematics.cloud.ibm.com/v1/workspaces/${WORKSPACE_ID}/actions/apply"
# --- END DEBUG STATEMENTS ---

curl -s -X PUT \
  "https://private-us-south.schematics.cloud.ibm.com/v1/workspaces/${WORKSPACE_ID}/apply" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{}' \
  -o /tmp/apply_response.json


echo "Schematics APPLY triggered. Response saved."

cat /tmp/apply_response.json

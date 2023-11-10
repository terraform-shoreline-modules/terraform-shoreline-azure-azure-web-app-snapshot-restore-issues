#!/bin/bash

# Set variables
RESOURCE_GROUP=${RESOURCE_GROUP_NAME}
WEB_APP_NAME=${WEB_APP_NAME}

# Get the most recent backup time
time=$(az webapp config snapshot list --name $WEB_APP_NAME --resource-group $RESOURCE_GROUP --output json | jq -r '.[-1].time')

# Restore the webapp from snapshot

az webapp config snapshot restore --resource-group $RESOURCE_GROUP --name $WEB_APP_NAME --time $time
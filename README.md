
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Azure Web App Snapshot Restore Issues

This incident type refers to issues related to restoring a snapshot of an Azure Web App. The incident may occur due to various reasons such as unavailability or inaccessibility of the backup, incorrect resource group or web app name, invalid restore point, incorrect snapshot configuration, and inadequate access permissions. These issues can prevent successful restoration of the snapshot, causing downtime or data loss for the Azure Web App.

### Parameters

```shell
export RESOURCE_GROUP_NAME="PLACEHOLDER"
export WEB_APP_NAME="PLACEHOLDER"
export USER_OR_GROUP_PRINCIPAL_ID="PLACEHOLDER"
```

## Debug

### Check resource group and web app name

```shell
az webapp list --resource-group ${RESOURCE_GROUP_NAME} --output table
```

### Check the web app

```shell
az webapp show --name ${WEB_APP_NAME} --resource-group ${RESOURCE_GROUP_NAME}
```

### Verify the application settings for a specific web app

```shell
az webapp config appsettings list --name ${WEB_APP_NAME} --resource-group ${RESOURCE_GROUP_NAME}
```

### Check snapshot configuration and settings

```shell
az webapp config snapshot list --name ${WEB_APP_NAME} --resource-group ${RESOURCE_GROUP} --output table
```

### Review access permissions

```shell
az role assignment list --assignee ${USER_OR_GROUP_PRINCIPAL_ID} --all
```

## Repair

### Restore the app from the recent verified snapshot

```shell
#!/bin/bash

# Set variables
RESOURCE_GROUP=${RESOURCE_GROUP_NAME}
WEB_APP_NAME=${WEB_APP_NAME}

# Get the most recent backup time
time=$(az webapp config snapshot list --name $WEB_APP_NAME --resource-group $RESOURCE_GROUP --output json | jq -r '.[-1].time')

# Restore the webapp from snapshot

az webapp config snapshot restore --resource-group $RESOURCE_GROUP --name $WEB_APP_NAME --time $time
```
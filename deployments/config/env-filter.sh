#!/bin/bash

# env
echo $image

# path
tfvars_path="deployments/terraform/apps.tfvars"

# deployment
sed -i "s|{{ image }}|$image|g" $tfvars_path
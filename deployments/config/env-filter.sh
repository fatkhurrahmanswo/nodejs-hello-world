#!/bin/bash

# env
echo $image

# path
deployment_path="deployments/terraform/apps.tfvars"

# deployment
# sed -i "s|{{ image }}|$image|g" $deployment_path
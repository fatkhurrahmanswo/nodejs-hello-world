#!/bin/bash

# env
$image = ${{ steps.build-image.outputs.image }}
echo "image"
echo $image

# path
deployment_path="deployments/terraform/apps.tfvars"

# deployment
# sed -i "s|{{ image }}|$image|g" $deployment_path
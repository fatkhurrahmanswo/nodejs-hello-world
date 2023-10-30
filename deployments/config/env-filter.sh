#!/bin/bash

# env
echo $image

# path
prod_tfvars_path="deployments/terraform/production/apps.tfvars"

# deployment
sed -i "s|{{ image }}|$image|g" $prod_tfvars_path
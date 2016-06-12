#!/bin/bash
terraform validate
echo "review validate messages above if present"
echo "press any key to continue"
read ans
rm -rf .terraform/modules
terraform get
terraform plan
echo ""
echo "Press Ctrl+C to quit or any other key to apply"
read ans
terraform apply
exit

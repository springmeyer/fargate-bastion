#!/bin/sh
set -e
set -u
set -o pipefail

keyFile=~/.ssh/id_rsa.pub
stackName=${2:-bastion-dev}

echo "getting accountId..."
accountId=$(set -e; aws sts get-caller-identity --query 'Account' --output text)

aws s3 cp ${keyFile} s3://${stackName}-keyfiles-${accountId}/user-keys/ 

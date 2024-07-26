#! /bin/bash
# Make sure that the localstack will always be in a clena state
if localstack status docker -f plain | grep False
then
  echo -e "\nStarting LocalStack"
  nohup localstack start &
else
  echo -e "\nCleaning LocalStack"
  localstack stop
  nohup localstack start &
fi

pip install terraform-local
pip install awscli-local

# Configure main terraform stete bucket
awslocal s3api create-bucket --bucket terraform
awslocal iam create-policy \
      --policy-name TFStatePolicy \
      --policy-document \
  '{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "s3:ListBucket",
        "Resource": "arn:aws:s3:::terraform"
      },
      {
        "Effect": "Allow",
        "Action": ["s3:GetObject", "s3:PutObject"],
        "Resource": "arn:aws:s3:::terraform/*"
      }
    ]
  }'

# Config AWS
aws configure set aws_access_key_id "local_aws_access_key_id" --profile default
aws configure set aws_secret_access_key "local_aws_secret_access_key" --profile default
aws configure set region "us-east-1" --profile default 
aws configure set output "json" --profile default

# Install project
cd /workspaces/node-localstack-devcontainer/src
npm install

cd /workspaces/node-localstack-devcontainer/terraform
tflocal init
tflocal apply -var-file=local.tfvars -auto-approve

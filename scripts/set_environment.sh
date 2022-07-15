#!/usr/bin/env bash

set -e

export COLOR='\033[0;32m'
export NC='\033[0m'
export ERR='\033[0;31m'

export TAG_NAME=${TAG:-"latest-$(git rev-parse HEAD)"}
export AWS_PROFILE_PARAM=''
export ENV_FILE_PATH='.env'
export ENV_NAME='STAGING'

# todo: REPLACE HERE: environment for Test instance
export AWS_ACCOUNT_ID='050309102952'
export AWS_INSTANCE_REGION='us-east-1'
export AWS_ECR_REPO_NAME='web-demo-should-be-deleted'
export AWS_ECR_REPO_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_INSTANCE_REGION}.amazonaws.com/${AWS_ECR_REPO_NAME}:${TAG_NAME}"
export AWS_INSTANCE_URL='REPLACE_YOUR_EC2_INSTANCE_IP_HERE'
export AWS_SECURITY_GROUP_ID='REPLACE_YOUR_GENERATED_SECURITY_GROUP_IN_TERRAFORM_HERE'
export ENV_FILE_PATH='.env.staging'
export ENV_NAME='STAGING'
export AWS_ENV_SECRET_NAME='demo/web/need-to-be-deleted'
# todo: choose correct script, deploy for normal web instance, deploy-server for server
# deploy.sh and deploy-server is by default for test enviroment
export AWS_INSTANCE_DEPLOY_SCRIPT='./deploy.sh'
#export AWS_INSTANCE_DEPLOY_SCRIPT='./deploy-server.sh'

if [ "$ENV" == "production" ] || [ "$CIRCLE_BRANCH" == "production" ]; then
  echo -e "${COLOR}:::::::::::::Setting environment for PRODUCTION::::::::::::::${NC}"
  # todo: REPLACE HERE: environment for Production instance
  export AWS_ECR_REPO_PRODUCTION_NAME='web-demo-should-be-deleted'
  export AWS_INSTANCE_REGION='us-east-1'
  export AWS_ECR_REPO_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_INSTANCE_REGION}.amazonaws.com/${AWS_ECR_REPO_PRODUCTION_NAME}:latest"
  # Production could be deployed on different region from test (Ex: client in Aus but marketplace is for US)
  export ENV_FILE_PATH='.env.prod'
  export ENV_NAME='PRODUCTION'
  # Remember to fill manually
  export AWS_ENV_SECRET_NAME='demo/web/need-to-be-deleted'
  
else
  echo -e "${COLOR}:::::::::::::Setting environment for TEST::::::::::::::${NC}"
fi

if [ "$CIRCLECI" == "true" ]; then
  echo -e "${COLOR}:::::::::::::Deploying by the CIRCLE CI::::::::::::::${NC}"
  export AWS_PRIVATE_KEY_PATH='permission.pem'

  if [ "$CIRCLE_BRANCH" != "master" ] && [ "$CIRCLE_BRANCH" != "main" ] && [ "$CIRCLE_BRANCH" != "production" ]; then
    echo -e "${COLOR}:::::::::Current branch $CIRCLE_BRANCH will not be deployed from the CI:::::::::${NC}"
    echo -e "${COLOR}:::::::::Exiting:::::::::${NC}"
    exit 0
  fi
fi
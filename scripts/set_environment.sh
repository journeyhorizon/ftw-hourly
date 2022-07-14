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
export AWS_INSTANCE_REGION='us-west-1'
export AWS_ECR_REPO_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_INSTANCE_REGION}.amazonaws.com/${AWS_ECR_REPO_NAME}:${TAG_NAME}"
export ENV_FILE_PATH='.env.staging'
export ENV_NAME='STAGING'

if [ "$ENV" == "production" ] || [ "$CIRCLE_BRANCH" == "production" ]; then
  echo -e "${COLOR}:::::::::::::Setting environment for PRODUCTION::::::::::::::${NC}"
  # todo: REPLACE HERE: environment for Production instance
  # Production could be deployed on different region from test (Ex: client in Aus but marketplace is for US)
  export AWS_INSTANCE_REGION='us-west-1'
  export AWS_ECR_REPO_NAME='web-fargate-test'
  export AWS_ECR_REPO_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_INSTANCE_REGION}.amazonaws.com/${AWS_ECR_REPO_NAME}:latest"
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

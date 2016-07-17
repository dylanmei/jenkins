#!/bin/sh
region=ap-southeast-2
if aws --region ${region} cloudformation describe-stacks --stack-name ${JOB_NAME}; then
  action=update-stack
  wait=stack-update-complete
else
  action=create-stack
  wait=stack-create-complete
fi
aws --region ${region} cloudformation ${action} \
  --stack-name ${JOB_NAME} \
  --capabilities CAPABILITY_IAM \
  --template-body file://cloudformation.json \
  --parameters \
  ParameterKey=AnsibleUrl,ParameterValue=${GIT_URL} \
  ParameterKey=InstanceType,ParameterValue=t2.nano \
  ParameterKey=KeyName,ParameterValue=diogenes
aws --region ${region} cloudformation wait ${wait} \
  --stack-name ${JOB_NAME}

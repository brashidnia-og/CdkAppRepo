#! /bin/sh

echo "Install dependencies from infrastucture/package.json"
cd infrastructure/
npm install

echo "Compile Typescript"
tsc

echo "Setup AWS credentials using IAM user with AdministratorAccess"
aws configure

echo "Bootstrap CDK for all Stages in Pipeline (Account/Region combinations)"
cdk bootstrap

echo "Deploy CDK pipeline to create intial CodeCommit Repository"
cdk deploy CdkPipelineStack 

echo "Set project origin to CodeCommit in the region of the CodePipeline"
cd ../
aws codecommit create-repository CdkAppRepo
git remote add origin https://git-codecommit.us-west-2.amazonaws.com/v1/repos/CdkAppRepo

echo "Upload project to CodeCommit Repo"
git add --all
git commit -m "Initial pipeline with alpha and beta stage"
git push --set-upstream origin master

echo "Changes will now build and deploy through CodePipeline"
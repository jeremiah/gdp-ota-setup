#!/bin/bash

DATE=$(date '+%Y%m%d%H%M%S')
AWS_S3_BUCKET=${AWS_S3_BUCKET-openivi-releases}

docker run --rm -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} -e AWS_DEFAULT_REGION=eu-central-1 -v ${PWD}:/root advancedtelematic/aws-cli:latest s3 cp tmp/deploy/images/qemux86-64/bzImage s3://$AWS_S3_BUCKET/gdp-$DATE.bzImage --acl public-read
docker run --rm -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} -e AWS_DEFAULT_REGION=eu-central-1 -v ${PWD}:/root advancedtelematic/aws-cli:latest s3 cp tmp/deploy/images/qemux86-64/genivi-dev-platform-qemux86-64.ext4 s3://$AWS_S3_BUCKET/gdp-$DATE.ext4 --acl public-read

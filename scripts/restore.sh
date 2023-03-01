#!/bin/sh

# get latest backup
OBJECT="$(aws s3 ls s3://$AWS_S3_BUCKET/$AWS_S3_PREFIX/ | sort | tail -n 1 | awk '{print $4}')"

# fetch and extract
aws s3 cp s3://$AWS_S3_BUCKET/$AWS_S3_PREFIX/$OBJECT - | tar -xvz -C $TARGET_DIR

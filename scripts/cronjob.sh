#!/bin/sh

# gzip contents
tar -zcvf /tmp/backup.tar.gz -C $TARGET_DIR .

# format date
DATE=$(date '+%Y-%m-%d-%H-%M-%S')

# upload to S3
aws s3 cp /tmp/backup.tar.gz \
  s3://$AWS_S3_BUCKET/$AWS_S3_PREFIX/backup-$DATE.tar.gz \
  --region $AWS_DEFAULT_REGION

#!/bin/sh

# create config
cat <<EOF > /etc/yacron.d/yacrontab.yaml
jobs:
  - name: backup
    schedule: "$CRON_SCHEDULE"
    shell: /bin/sh
    command: /pvs3/cronjob.sh
    environment:
      - key: TARGET_DIR
        value: $TARGET_DIR
      - key: AWS_ACCESS_KEY_ID
        value: $AWS_ACCESS_KEY_ID
      - key: AWS_SECRET_ACCESS_KEY
        value: $AWS_SECRET_ACCESS_KEY
      - key: AWS_DEFAULT_REGION
        value: $AWS_DEFAULT_REGION
      - key: AWS_S3_BUCKET
        value: $AWS_S3_BUCKET
      - key: AWS_S3_PREFIX
        value: $AWS_S3_PREFIX
EOF

# start crons
/yacron/bin/yacron

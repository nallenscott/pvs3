FROM ubuntu:latest
USER root

ARG TARGET_DIR
ARG CRON_SCHEDULE
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_DEFAULT_REGION
ARG AWS_S3_BUCKET
ARG AWS_S3_PREFIX

ENV TARGET_DIR=$TARGET_DIR
ENV CRON_SCHEDULE=$CRON_SCHEDULE
ENV AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
ENV AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
ENV AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION
ENV AWS_S3_BUCKET=$AWS_S3_BUCKET
ENV AWS_S3_PREFIX=$AWS_S3_PREFIX

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
  python3 virtualenv awscli

RUN virtualenv -p /usr/bin/python3 /yacron \
  && /yacron/bin/pip install yacron \
  && mkdir -p /etc/yacron.d

COPY scripts/entrypoint.sh /pvs3/
RUN chmod +x /pvs3/entrypoint.sh

COPY scripts/cronjob.sh /pvs3/
RUN chmod +x /pvs3/cronjob.sh

COPY scripts/backup.sh /pvs3/actions/
RUN chmod +x /pvs3/actions/backup.sh

COPY scripts/restore.sh /pvs3/actions/
RUN chmod +x /pvs3/actions/restore.sh

ENTRYPOINT ["/pvs3/entrypoint.sh"]

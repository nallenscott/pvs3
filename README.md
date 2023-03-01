<h1 align="center">
  <img src="pvs3.png" width=400 alt=""><br>
  pvs3<br>
</h1>

## Introduction

pvs3 is a simple docker image for backing up and restoring directories using S3. It's based on [yacron](https://github.com/gjcarneiro/yacron), and is meant to be used as a sidecar for backups, or as an init container for restores.

## Backup

Files are stored in the target bucket/prefix as `backup-YYYY-MM-DD-HH-MM-SS.tar.gz`. You may need to include a volume mount for `/etc/yacron.d`, depending on your docker setup.

### Docker Example

```bash
docker run \
  -e TARGET_DIR="/var/lib/grafana" \
  -e CRON_SCHEDULE="*/15 * * * *" \
  -e AWS_ACCESS_KEY_ID="<AWS_ACCESS_KEY_ID>" \
  -e AWS_SECRET_ACCESS_KEY="<AWS_SECRET_ACCESS_KEY>" \
  -e AWS_S3_BUCKET="backups" \
  -e AWS_S3_PREFIX="grafana" \
  pvs3 backup
```

### Kubernetes Example

```yaml
# manifest.yaml
extraContainers:
  - name: backup
    image: <REPO_URL>:latest
    command: ['/pvs3/entrypoint.sh']
    args: ['backup']
    volumeMounts:
      - name: storage
        mountPath: /var/lib/grafana
      - name: yacrontab
        mountPath: /etc/yacron.d
    env:
      - name: TARGET_DIR
        value: /var/lib/grafana
      - name: CRON_SCHEDULE
        value: "*/15 * * * *"
      - name: AWS_ACCESS_KEY_ID
        value: <AWS_ACCESS_KEY_ID>
      - name: AWS_SECRET_ACCESS_KEY
        value: <AWS_SECRET_ACCESS_KEY>
      - name: AWS_DEFAULT_REGION
        value: us-east-1
      - name: AWS_S3_BUCKET
        value: backups
      - name: AWS_S3_PREFIX
        value: grafana
```

## Restore

This will overwrite the contents of the target directory with the most recent backup.

### Docker Example

```bash
docker run \
  -e TARGET_DIR="/var/lib/grafana" \
  -e AWS_ACCESS_KEY_ID="<AWS_ACCESS_KEY_ID>" \
  -e AWS_SECRET_ACCESS_KEY="<AWS_SECRET_ACCESS_KEY>" \
  -e AWS_S3_BUCKET="revcontent-datalake" \
  -e AWS_S3_PREFIX="grafana" \
  pvs3 restore
```

### Kubernetes Example

```yaml
# manifest.yaml
initContainers:
  - name: restore
    image: <REPO_URL>:latest
    command: ['/pvs3/entrypoint.sh']
    args: ['restore']
    volumeMounts:
      - name: storage
        mountPath: /var/lib/grafana
    env:
      - name: TARGET_DIR
        value: /var/lib/grafana
      - name: AWS_ACCESS_KEY_ID
        value: <AWS_ACCESS_KEY_ID>
      - name: AWS_SECRET_ACCESS_KEY
        value: <AWS_SECRET_ACCESS_KEY>
      - name: AWS_DEFAULT_REGION
        value: us-east-1
      - name: AWS_S3_BUCKET
        value: backups
      - name: AWS_S3_PREFIX
        value: grafana
```

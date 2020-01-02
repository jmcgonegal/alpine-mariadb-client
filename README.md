# MariaDB client on Alpine Linux

Made to do mysqldump backups on kubernetes cron.

Built for amd64 and arm64.

Example Kubernetes cronjob

```
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: cron-backup
spec:
  # backup at 3am every day
  schedule: "0 3 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: daily-database-backup
            image: jmcgonegal/alpine-mariadb-client
            args:
            - /bin/sh
            - -c
            # gzip the backup to save space (do incremental backups if you want more)
            - mysqldump --host=my_host --port=3306 --user=my_user --password=my_password my_database | gzip > /mnt/backup-`date +%m-%d-%Y`.sql.gz
            volumeMounts:
            - name: my-backup
              mountPath: "/mnt"
          restartPolicy: OnFailure
          volumes:
          - name: my-backup
            nfs:
              server: my_nfs_server
              # folder must exist
              path: "/my_path"
```

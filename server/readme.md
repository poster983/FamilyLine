# Server Setup


## Requirements
1. NodeJS 17+
2. S3 Compatible service (Backblaze, Amazon, Minio)
3. MongoDB Instance
4. A private and public key for JWT signing.  Run: `ssh-keygen -t rsa -b 4096 -m PEM -f jwtRS256.key`
5. 
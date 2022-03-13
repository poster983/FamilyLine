# Server Setup


## Requirements
1. NodeJS 17+
2. S3 Compatible service (Backblaze, Amazon, Minio)
3. MongoDB Instance setup as a replica set (single replica set is okay. (See More)[https://docs.mongodb.com/manual/tutorial/convert-standalone-to-replica-set/]) 
4. A private and public key for JWT signing.  Run: `ssh-keygen -t rsa -b 4096 -m PEM -f jwtRS256.key`

## Instructions
1. Edit the .env file.  See .env.example
2. run `npm start`
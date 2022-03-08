import S3rver from "S3rver";

const s3rver = new S3rver({
    configureBuckets: [
      {
        port: 4569,
        address: 'localhost',
        name: 'FamilyLine',
        directory: "./localS3"
        //configs: [fs.readFileSync(corsConfig), fs.readFileSync(websiteConfig)],
      },
    ],
  });


s3rver.run();
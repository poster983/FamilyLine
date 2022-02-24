import SMCloudStore from 'smcloudstore';

const connection = {
    endPoint: process.env.S3_ENDPOINT,
    accessKey: process.env.S3_KEY_ID,
    secretKey: process.env.S3_APPLICATION_KEY,
    region: process.env.S3_REGION,
    pathStyle: (process.env.S3_PATH_STYLE.toLowerCase()==='true')?true:false
}
// Return an instance of the GenericS3Provider class
export default  SMCloudStore.Create('generic-s3', connection)
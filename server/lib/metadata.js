import exiftool from 'node-exiftool';
import exiftoolBin  from 'dist-exiftool';
import ms from 'ms';
import {DateTime, Duration} from 'luxon';
const ep = new exiftool.ExiftoolProcess(exiftoolBin)

const DTfromEXIF = (dt) => DateTime.fromFormat(dt,"yyyy:MM:dd HH:mm:ss").setZone("utc", { keepLocalTime: true });

function ParseDMS(input) {
    var parts = input.split(/[^\d\w\.]+/);    
    var lat = ConvertDMSToDD(parts[0], parts[2], parts[3], parts[4]);
    var lng = ConvertDMSToDD(parts[5], parts[7], parts[8], parts[9]);

    return {
        Latitude : lat,
        Longitude: lng,
        //Position : lat + ',' + lng
    }
}


function ConvertDMSToDD(degrees, minutes, seconds, direction) {   
    var dd = Number(degrees) + Number(minutes)/60 + Number(seconds)/(60*60);

    if (direction == "S" || direction == "W") {
        dd = dd * -1;
    } // Don't do anything for N or E
    return dd;
}

/**
 * 
 * @param {String} position - GPS String to parse 
 * @returns {Object}
 */
function parseGPS(position) {
    let data = {
        latitude: null,
        longitude: null,
    }
    //preprocess gps data (ios: 11 deg 22' 33.44" N, 99 deg 88' 0.08" W)
    const gps = ParseDMS(position);
    data.latitude = gps.Latitude;
    data.longitude = gps.Longitude;
    //iPreprocess gps data for google photos ('+11.9999-022.7777/')
    if(!data.latitude || !data.longitude  && position.at(-1) == "/") {
        data.latitude = parseFloat(position.substring(0, 8));
        data.longitude = parseFloat(position.substring(8, 17));
    }

    return data
}

/**
 * Parses an EXIF duration string
 * @param {String} duration - accepts a valid ms string or duration string in format 0:00:00.000
 * @returns {Number} duration in MS
 */
function parseDuration(duration) {
    let dur = ms(duration);

    //parse 0:00:00 duration
    if(!dur) {
       //find the number of occurrences of ":" in the string
       if(duration.indexOf(":") == 1) {
            dur = "0"+duration;
            dur = Duration.fromISOTime(dur).toMillis();
        }
    }

    return dur || null;
}

/**
 * Parses file metadata
 * @param {*} filepath - Path of file to be parsed
 * @returns {Promise} - Resolves with metadata
 */
export function readMetadata(filepath) {
  return new Promise((resolve, reject) => {
    ep.open()
      .then(() =>  ep.readMetadata(filepath))
      .then(metadata => {
        //console.log(metadata);
        if(metadata.error) {
          return reject(metadata.error);
        }
        if(metadata.data?.length == 0) {
          return reject("No metadata found");
        }
        const data = metadata.data[0];

        //Preprocess GPS data
        if(data.GPSPosition || data.UserData_xyz) {
            const gps = parseGPS(data.GPSPosition || data.UserData_xyz);
            data.GPSLatitude = gps.latitude;
            data.GPSLongitude = gps.longitude;
        }
        
        //parse avalable metadata 
        let parsedMetadata = {
          metadata: {
            //gps
            gpsLatitude: data.GPSLatitude || undefined,
            gpsLongitude: data.GPSLongitude || undefined,
            gpsAltitude: data.GPSAltitude || undefined,
            
            //media 
            mediaFramerate: data.VideoFrameRate ?? undefined,
            mediaDuration: parseDuration(data.Duration || data.TrackDuration || " ") ?? undefined,
            mediaWidth: data.ImageWidth ?? data.ExifImageWidth ?? undefined,
            mediaHeight: data.ImageHeight ?? data.ExifImageHeight?? undefined,
            mediaVideoBitrate: data.AvgBitrate ?? undefined,
            mediaAudioSampleRate: data.AudioSampleRate ?? undefined,

            //device 
            cameraMake: data.LensMake ?? data.Make ?? undefined,
            cameraModel: data.LensModel ?? data.Model ?? undefined,
            osVersion: data.Software ?? undefined,
            //camera
            cameraMegapixels: data.Megapixels ?? undefined,
            cameraFstop: data.FNumber ?? data.ApertureValue ?? undefined,
            cameraFocalLength: data.FocalLength ?? undefined,
            cameraISO: data.ISO ?? undefined,
            cameraRotation: data.Rotation ?? undefined,
            cameraShutterSpeed: data.ShutterSpeed ?? undefined,
            
            dtOffset: data.OffsetTime ?? data.OffsetTimeOriginal ?? undefined
          },
          original: {
            mimetype: data.MIMEType ?? null,
          },
          creationDate: (data.CreateDate)?DTfromEXIF(data.CreateDate).toMillis():Date.now(),  //TODO: Some dates have a offset and soem dont
        };


        const o = Object.fromEntries(Object.entries(parsedMetadata.metadata).filter(([_, v]) => v != undefined));
        parsedMetadata.metadata = o;
        resolve({parsed: parsedMetadata, original: data});
      })
      .catch(err => {
        console.error(err)
        reject(err)
      })
      .finally(() => ep.close());
  })
}

// const myArgs = process.argv.slice(2);

// try {
//     let result = await readMetadata(myArgs[0]);
//     console.dir(result, { depth: null }); 
// } catch (e) {
//     console.error(e);
// }


// // console.log(Duration.fromISOTime("00:02:36"))
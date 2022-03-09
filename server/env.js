import dotenv from 'dotenv'
dotenv.config({ silent: true });
import {
    promises as fsP
  } from 'fs';

try {
    const file = await fsP.readFile(process.env.AUTH_JWT_PRIVATE_KEY)
    process.env.AUTH_JWT_PRIVATE_KEY = file;
} catch(e) {
    throw e
}

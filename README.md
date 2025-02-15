# Simple Drive API
This is a simple implementation of a drive API that allows you to store files in different storage backends.

## Getting Started
You may want to set up your desired config in the docker-compose.yml file.

Then run the following command to start the project.
```bash
    docker compose up -d
```


## API Endpoints
The API has the following endpoints:
- POST /api/v1/blobs/upload
- GET /api/v1/blobs/{blob_id}

You may want to check the API documentation for more details.
- http://localhost:8000/docs

You must have a token to access the API.
- http://localhost:8000/docs/api/v1/auth/register # Register using the example in docs
- http://localhost:8000/docs/api/v1/auth/login # Login using the example in docs
- Copy the token and use it in the Authorization header as Bearer Token

## Supported Storage Backends
- [x] Object Storage (AWS S3, Digital Ocean Spaces, etc); AWS S3 V4 Signature only
- [x] Database Table
- [x] Local File System
- [ ] FTP


## Running Tests
Coverage test is already set, but test cases aren't yet implemented.

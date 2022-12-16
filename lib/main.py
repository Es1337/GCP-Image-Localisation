from google.cloud import storage


def save_blob(request):
    json_data = request.get_json()
    BUCKET_NAME = 'image-bucket-test-8549-mk'
    BLOB_NAME = 'test'
    BLOB_STR = '{"test": "test"}'

    client = storage.Client()
    bucket = client.get_bucket(BUCKET_NAME)
    blob = bucket.blob(BLOB_NAME)

    blob.upload_from_string(BLOB_STR)

    print('Blob uploaded to {}'.format(BLOB_NAME))

    return 'LMAO'

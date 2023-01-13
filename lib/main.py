from google.cloud import vision
import firebase_admin
from firebase_admin import firestore

def process_new_image(data, context):
    if not firebase_admin._apps:
        app = firebase_admin.initialize_app()
    db = firestore.client()

    print(data.items())
    BUCKET_NAME = 'image-bucket-test-8549-mk'

    uri = "gs://{}/{}".format(BUCKET_NAME, data["name"])

    doc_ref = db.collection(u'images').document(data["name"])

    client = vision.ImageAnnotatorClient()
    image = vision.Image()
    image.source.image_uri = uri

    response = client.text_detection(image=image)
    texts = response.text_annotations
    result = 'Texts:'

    for text in texts:
        result += '\n"{}"'.format(text.description)

    if response.error.message:
        raise Exception(
            '{}\nFor more info on error messages, check: '
            'https://cloud.google.com/apis/design/errors'.format(
            response.error.message))
    elif not doc_ref.get().exists:
        doc_ref.set({
            u'labels': result
        })
    elif doc_ref.get().exists:
        doc_ref.update({u'labels': result})

    print(result)


def save_user(request):
    if not firebase_admin._apps:
        app = firebase_admin.initialize_app()
    db = firestore.client()

    request_json = request.get_json(silent=True)

    doc_ref = db.collection(u'test-app').document(request_json["username"])
    doc_ref.set({
        u'pass': request_json["pass"]
    })

    if doc_ref.get().exists:
        result = "User created"
    else:
        result = "Failure"

    return result

def get_result(request):
    if not firebase_admin._apps:
        app = firebase_admin.initialize_app()
    db = firestore.client()

    request_json = request.get_json(silent=True)

    user_doc_ref = db.collection(u'test-app').document(request_json["username"])
    result_doc_ref = db.collection(u'images').document(request_json["image"])

    user_doc = user_doc_ref.get()
    result_doc = result_doc_ref.get()

    if not user_doc.exists:
        return "Unauthorised"

    if user_doc.to_dict()["pass"] != request_json["pass"]:
        return "Wrong pass"

    if not result_doc.exists:
        return "No result for image: {}".format(request_json["image"])

    return result_doc.to_dict()["labels"]




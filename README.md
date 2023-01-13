# GCP Image to Text

The goal of the project is to create an API for detecting text from a photo.
The API will be built using Google Cloud Platform, with API code being written in Python and split into Cloud Functions. For text detection on an imageI'll use Cloud Vision API, for storing images - Cloud Storage, to keep user data - Firestore. 
API will consist fo three Functions:
* one triggered by uploading image to Google Storage, getting it processed, and saving the result to Firestore
* one for user to save their credentials in Firestore
* one for the user to get the result back from Firestore
The second aim of the project is for it to be mostly automated, in terms of deployment, testing and maintenance. Infrastructure will be provisioned with Terraform.


![diagram](https://user-images.githubusercontent.com/43972504/212291774-110c05db-6847-4c6b-be22-5b8296f9b98c.jpg)

# Build
To build the project you need use `terraform init` in root project directory, then use `terraform apply`, providing Project Id from GCP. 

# How to use
Sample requests and images are inside `sandbox` directory

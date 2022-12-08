# GCP Image Localisation

The goal of the project is to create an API for detecting the localisation of origin of a photo.
The API will be built using Google Cloud Platform, with main web application code being written in Java. For text detection on an image as well as it's translation I'll use Cloud Vision API, for storing images - Cloud Storage, to keep user data - Datastore. 
The second aim of the project is for it to be mostly automated, in terms of deployment, testing and maintenance. Infrastructure will be provisioned with Terraform.

![Container Diagram](https://imgur.com/a/REFAdqR "Diagram")

#!/bin/bash

gcloud compute instances create reddit-app-immutable\
  --image-family reddit-full \
  --zone europe-west3-a \
  --tags puma-server \
  --restart-on-failure

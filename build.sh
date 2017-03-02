#!/bin/bash -e

export CURR_JOB="buildApp"
export HUB_ORG="chetantarale"
export IMAGE_NAME="sampleapp"
export IMAGE_TAG=master.5

export RES_REPO="sampleApp_repo"
export RES_IMAGE="app_img"
export RES_MICROBASE_IMAGE="microbase_img"

export RES_REPO_UP=$(echo $RES_REPO | awk '{print toupper($0)}')
export RES_REPO_COMMIT=$(eval echo "$"$RES_REPO_UP"_COMMIT")
export RES_IMAGE_VER_NAME=$(eval echo "$"$RES_REPO_UP"_VERSIONNAME")

set_context() {
  echo "CURR_JOB=$CURR_JOB"
  echo "HUB_ORG=$DOCKERHUB_ORG"
  echo "IMAGE_NAME=$IMAGE_NAME"
  echo "IMAGE_TAG=$IMAGE_TAG"
  echo "RES_REPO=$RES_REPO"
  echo "RES_IMAGE=$RES_IMAGE"
  echo "RES_IMAGE_VER_NAME=$RES_IMAGE_VER_NAME"
}

build_tag_push_image() {
  echo "Starting Docker build for" $HUB_ORG/$IMAGE_NAME:$RES_IMAGE_VER_NAME
  cd ./IN/$RES_REPO/gitRepo
  sudo docker build -t=$HUB_ORG/$IMAGE_NAME:$RES_IMAGE_VER_NAME .
  sudo docker push $HUB_ORG/$IMAGE_NAME:$RES_IMAGE_VER_NAME
  echo "Completed Docker build for" $HUB_ORG/$IMAGE_NAME:$RES_IMAGE_VER_NAME
}

create_image_version() {
  echo "Creating a state file for" $RES_IMAGE
  echo versionName=$IMAGE_TAG > /build/state/$RES_IMAGE.env
  echo IMG_REPO_COMMIT_SHA=$RES_REPO_COMMIT >> /build/state/$RES_IMAGE.env
  echo "Completed creating a state file for" $RES_IMAGE
}

main() {
  set_context
  build_tag_push_image
  create_image_version
}

main

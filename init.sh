#!/bin/bash

PROJECT=$1
REGION=$2
BUCKET=$3
BASENAME=`pwd | xargs basename`

set -x

gsutil mb -p ${PROJECT} -l ${REGION} gs://${BUCKET}

cat > backend.tf <<EOF
terraform {
 backend "gcs" {
   bucket  = "${BUCKET}"
   path    = "${BASENAME}"
   project = "${PROJECT}"
 }
}
EOF

gsutil versioning set on gs://${BUCKET}


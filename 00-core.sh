#!/bin/bash

aws --profile default configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
aws --profile default configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
aws --profile default configure set region "$REGION"
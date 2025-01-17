#!/bin/bash

# path to lambda_function no mater where the script is executed
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

# Package main Lambda function
echo "Packaging main Lambda function..."
cd $SCRIPTPATH/lambda_function

# Clean up previous builds
rm -rf package lambda_function.zip

# Create a fresh package directory
mkdir -p package

# Install dependencies from requirements.txt into package directory
pip install --target ./package -r requirements.txt

# Create the zip file with dependencies
cd package
zip -r ../lambda_function.zip .

# Add the lambda function to the zip
cd ..
zip -g lambda_function.zip lambda_function.py

# Move the zip to the correct location
mv lambda_function.zip ..

echo "Main Lambda packaging complete"

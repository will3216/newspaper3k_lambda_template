# newspaper3k_lambda_template
This provides a template for creating a lambda function using newspaper3k without needing to deal with the pain of actually doing it yourself.

## Usage
Just change the contents of ./lib/newspaper_lambda.py to whatever you need, along with adding whatever dependencies you require to the Pipfile and then simply run:
```
make
```

This will spin up a docker image of the Amazon Linux AMI, install your dependencies and build your package on it, and then export the built lambda package into `dist/newspaper_lambda.zip`

Note, if you change the name of the project folder you will need to do a find/replace of this repo: newspaper3k_lambda_template -> $NEW_PROJECT_NAME

## Requirements
+ Make
+ Python3
+ Pip3
+ Docker

## Testing
This project doesn't have any actual tests, but the nosetest framework is setup so you can add your own!

To run your nosetests run:
```
make test
```

## Trouble-shooting
The Amazon Linux distribution of python3 doesn't play well with all packages. You may be required to add additional steps to build some packages correctly. This project is super helpful for finding pre-built packages you can use to replace them: https://github.com/Miserlou/lambda-packages

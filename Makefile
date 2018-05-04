.PHONY: all build test clean copy_working_file copy_dependencies _copy_dependencies zip_dist

prepare:
	-pip3 install pipenv
	-pipenv --rm
	pipenv install --ignore-pipfile

prepare_dev:
	-pip install pipenv
	pipenv install --dev

test: prepare_dev
	pipenv install --dev --ignore-pipfile > /dev/null
	pipenv run nosetests ${FILE}
	make prepare > /dev/null

clean:
	-rm -rf ./dist
	-mkdir ./dist

build_base: prepare clean copy_dependencies zip_base

copy_dependencies:
	pipenv shell "make _copy_dependencies; exit"

_copy_dependencies:
	wget 'https://github.com/Miserlou/lambda-packages/files/1425358/_sqlite3.so.zip'
	unzip -uo _sqlite3.so.zip -d $$VIRTUAL_ENV/lib/python3.6/site-packages
	rm _sqlite3.so.zip
	cp -a ./nltk_data/ ./dist/
	cp -a $$VIRTUAL_ENV/lib/python3.6/site-packages/. ./dist/

zip_base:
	-rm ./base.zip
	cd dist && sed -i -e 's/\.newspaper_scraper/\/tmp\/.newspaper_scraper/g' ./newspaper/settings.py
	cd dist && zip -r ../base.zip . > /dev/null && echo "Build Complete!"

# These steps require you to add a server location to you ~/.ssh/config under the name lambda_builder, it will need to be built with an Amazon Linux AMI
build.start: clean
	-ssh lambda_builder -C "rm -rf newspaper3k_lambda_template"
	-ssh lambda_builder -C "mkdir newspaper3k_lambda_template"
	scp -r ./lib/ lambda_builder:~/newspaper3k_lambda_template/lib/
	scp -r ./nltk_data/ lambda_builder:~/newspaper3k_lambda_template/nltk_data/
	scp ./Pipfile lambda_builder:~/newspaper3k_lambda_template/Pipfile
	scp ./Pipfile.lock lambda_builder:~/newspaper3k_lambda_template/Pipfile.lock
	scp ./Makefile lambda_builder:~/newspaper3k_lambda_template/Makefile
	echo "Now run:\n\tssh lambda_builder\n\tcd ~/newspaper3k_lambda_template\n\tmake build_base\n\texit\n\tmake build.continue"

build.continue:
	scp -rp lambda_builder:~/newspaper3k_lambda_template/base.zip ./lib/base.zip

build:
	-rm -rf ./build
	mkdir ./build
	cp ./lib/base.zip ./build/newspaper_lambda.zip
	cp ./lib/newspaper_lambda.py ./build/newspaper_lambda.py
	cd build && zip -u newspaper_lambda.zip ./newspaper_lambda.py

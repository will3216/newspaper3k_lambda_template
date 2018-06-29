.PHONY: test clean all build build.container clean.container build.native build.export

all: test build.container clean build.export

test:
	-pip3 install pipenv
	pipenv install --dev
	pipenv install --dev --ignore-pipfile > /dev/null
	pipenv run nosetests ${FILE}

clean:
	-rm -rf ./dist
	-mkdir ./dist

build: build.container

build.container: clean.container
	docker build -t newspaper3k_lambda_template .

clean.container:
	docker image rm newspaper3k_lambda_template -f

build.native:
	rm -rf dist build
	mkdir -p dist build
	PIP_USER=no PIPENV_VENV_IN_PROJECT=1 pipenv install --ignore-pipfile
	cp -R .venv/lib/python3.6/site-packages/. build/
	cp -R nltk_data build/
	cd build ; curl -sL https://raw.githubusercontent.com/Miserlou/lambda-packages/master/lambda_packages/sqlite3/python3.6-sqlite3-3.6.0.tar.gz | tar xz
	cd build ; sed -i -e 's/\.newspaper_scraper/\/tmp\/.newspaper_scraper/g' ./newspaper/settings.py
	cp lib/newspaper_lambda.py build/
	cd build; zip -r ../dist/newspaper_lambda.zip . > /dev/null

build.export:
	mkdir -p dist
	BUILDER_ID=$(shell openssl rand -hex 4) && \
	docker run --name $$BUILDER_ID newspaper3k_lambda_template && \
	docker cp $$BUILDER_ID:/opt/newspaper3k_lambda_template/dist/newspaper_lambda.zip dist/newspaper_lambda.zip && \
	docker rm -fv $$BUILDER_ID

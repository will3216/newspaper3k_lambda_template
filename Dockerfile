FROM amazonlinux

#RUN yum update -y
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV PATH $PATH:/root/.local/bin
RUN yum install -y python36.x86_64 which.x86_64 zip.x86_64 unzip.x86_64
RUN curl -sL https://bootstrap.pypa.io/get-pip.py | python3 - --user
RUN pip3 install pipenv --user
COPY Pipfile* Makefile /opt/newspaper3k_lambda_template/
COPY lib/ /opt/newspaper3k_lambda_template/lib/
COPY nltk_data/ /opt/newspaper3k_lambda_template/nltk_data/
RUN cd /opt/newspaper3k_lambda_template ; make build.native

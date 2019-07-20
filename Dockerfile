FROM amazonlinux

#RUN yum update -y
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV PATH $PATH:/root/.local/bin
# RUN yum install -y python36.x86_64 which.x86_64 zip.x86_64 unzip.x86_64
RUN yum -y groupinstall "Development Tools"
RUN yum -y groupinstall development
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum -y install https://centos7.iuscommunity.org/ius-release.rpm
RUN yum -y install zlib-devel
RUN yum -y install openssl-devel
RUN yum -y install libffi-devel
RUN yum -y install python36u python36u-pip python36u-devel
RUN yum -y install which.x86_64 zip.x86_64 unzip.x86_64

RUN python3.6 -m pip install --upgrade --user pip

RUN pip install pipenv --user
COPY Pipfile* Makefile /opt/newspaper3k_lambda_template/
COPY lib/ /opt/newspaper3k_lambda_template/lib/
COPY nltk_data/ /opt/newspaper3k_lambda_template/nltk_data/
RUN cd /opt/newspaper3k_lambda_template ; make build.native
#/usr/include/python3.6m/Python.h

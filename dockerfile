# base image
FROM ubuntu:latest


# non interactive
ENV DEBIAN_FRONTEND noninteractive 

#\ TZ=Europe/Paris

# update packages
RUN apt-get update \
    && apt-get install -y apt-utils

# install supporting software
RUN apt install software-properties-common -y \
    && add-apt-repository ppa:deadsnakes/ppa -y


# install python
RUN apt-get install python3.9 -y \
    && apt install python3.10-venv -y \
    && apt-get install python3-pip -y

# define the work directory
WORKDIR /usr/src/app

# create virtual env and activate env
RUN python3 -m venv venv

RUN . venv/bin/activate

# install requirements
COPY requirements.txt ./

RUN python3 -m pip install --upgrade pip

# remove pkg_resources 0.0.0
RUN sed -i 's/pkg_resources==0.0.0//g' requirements.txt

RUN python3 -m pip install -r requirements.txt

# copy sources

# main project
# COPY . .

# starter on root
COPY . .

# solution
# COPY ./mslearn-django-models-data/solution .

# expose app port
EXPOSE 8000

# entry point
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]
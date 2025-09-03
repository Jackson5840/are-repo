# our base image
FROM ubuntu:18.04

# Add the PostgreSQL PGP key to verify their Debian packages.
# It should be the same key as https://www.postgresql.org/media/keys/ACCC4CF8.asc

RUN apt-get update -y && \
    apt-get install -y python3-pip python3-dev


# Install python and pip
MAINTAINER Bengt Ljungquist "bljungqu@gmu.edu"

RUN apt-get update -y && \
    apt-get install -y python3-pip python3-dev libopenblas-base libomp-dev


# install Python modules needed by the Python app
COPY requirements.txt /app/

WORKDIR /app

RUN pip3 install --no-cache-dir -r /app/requirements.txt

# copy files required for the app to run
COPY flask_ingestionUI.py /app/
COPY dumpall.sql /app/tmp/
COPY are/cfg.py /app/are/
COPY are/com.py /app/are/
COPY are/check.py /app/are/
COPY are/ingest.py /app/are/
COPY are/io.py /app/are/
COPY initpostgres.sh /app/

ADD ui/ /app/




ENTRYPOINT [ "flask" ]

ENV FLASK_APP=flask_ingestionUI.py
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8


# tell the port number the container should expose
EXPOSE 5000

# run the application
CMD ["run", "--host", "0.0.0.0"]
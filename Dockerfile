FROM python:2.7.15-alpine3.9

RUN apk add --update --no-cache \
    gcc \
    libc-dev \
    mariadb-dev \ 
    libxml2-dev \ 
    libxslt-dev \
    && rm -rf /var/cache/apk/*

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY requirements.txt /usr/src/app
RUN pip install --no-cache-dir -r requirements.txt
COPY . /usr/src/app
ENV FLASK_APP=views.py
CMD flask db upgrade && \
    rq worker --url redis://redis:6379 quizext & && \
    flask run --with-threads --host=0.0.0.0

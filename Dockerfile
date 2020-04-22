FROM python:3.7.7-alpine3.11

RUN apk add --no-cache --virtual .build-deps \
        g++ \
        python3-dev \
        libxml2 \
        libxml2-dev

RUN apk add \
        libxslt-dev \
        su-exec

WORKDIR /opt

COPY resources/requirements/production.txt requirements.txt
RUN pip3 --no-cache-dir install -r requirements.txt

COPY . .
RUN python3 setup.py install

RUN apk del .build-deps

EXPOSE 9705

CMD ["sh", "/opt/docker-run.sh"]

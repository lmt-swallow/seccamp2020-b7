FROM ubuntu:18.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl python3-pip python3-wheel  \
    && pip3 install -U pip setuptools \
    && pip install flask gunicorn[gevent]==20.0.0 requests \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY ./src /app
COPY ./gunicorn.conf.py /etc/

RUN chmod 444 /app/app.py /app/store.py \
    && chmod 400 /etc/gunicorn.conf.py \
    && useradd -UM app

CMD ["gunicorn", "--config=/etc/gunicorn.conf.py", "app:app"]

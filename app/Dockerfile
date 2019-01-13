FROM alpine:latest
LABEL maintainer="Anton Illarionov"

RUN apk add python3 \
  && pip3 install flask \
  && mkdir -p /var/opt/www

COPY main.py /var/opt/www
COPY templates/ /var/opt/www/templates

EXPOSE 8001

WORKDIR /var/opt/www

CMD ["python3", "main.py"]

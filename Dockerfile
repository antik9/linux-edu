FROM centos:7

LABEL maintainer="Anton Illarionov"

RUN yum install -y epel-release \
 && yum install -y nginx gcc wget curl git python-devel \
 && curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" \
 && python get-pip.py \
 && rm get-pip.py \
 && pip install requests uwsgi

WORKDIR /home/
RUN git clone -b 08-rpm https://github.com/antik9/linux-otus.git ip2w

# Change nginx.conf
RUN  cp /home/ip2w/nginx_ip2w.conf /etc/nginx/default.d/nginx_ip2w.conf \
 && cp /home/ip2w/server/config_ip2w.json /usr/local/etc/config_ip2w.json \
 && cp /home/ip2w/server/ip2w.py /usr/local/bin/ip2w.py \
 && mkdir /run/uwsgi

# Open 80 port from container
EXPOSE 80

WORKDIR /home/ip2w/server

ENTRYPOINT /usr/sbin/nginx \
 && uwsgi --ini ip2w.ini

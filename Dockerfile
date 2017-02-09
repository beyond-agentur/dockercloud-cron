FROM alpine:3.4
MAINTAINER Feng Honglin <hfeng@tutum.co>

COPY . /haproxy-src

RUN apk update && \
    apk --no-cache add tini crond py-pip build-base python-dev ca-certificates && \
    cp /cron-src/reload.sh /reload.sh && \
    cd /cron-src && \
    pip install -r requirements.txt && \
    pip install . && \
    apk del build-base python-dev && \
    rm -rf "/tmp/*" "/root/.cache" `find / -regex '.*\.py[co]'`

ENV RSYSLOG_DESTINATION=127.0.0.1

EXPOSE 80 443 1936
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["dockercloud-cron"]

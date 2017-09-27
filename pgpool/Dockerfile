FROM alpine:3.6
RUN apk --update --no-cache add pgpool py2-pip && \
	pip install --no-cache-dir --upgrade pip awscli
RUN mkdir /var/run/pgpool
EXPOSE 5432

RUN apk --no-cache add jq
COPY config.sh run.sh passwd.sh /root/
COPY pool_hba.conf /etc/
WORKDIR /root

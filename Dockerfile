FROM python:3.9-alpine3.12 as builder

LABEL maintainer="Jacob Lemus Peschel <jacob@tlacuache.us>"

RUN	apk update --no-cache && apk add libmilter-dev build-base libffi-dev
RUN     python3 -m venv /opt/venv && /opt/venv/bin/pip install wheel && /opt/venv/bin/pip install dkimpy-milter

FROM	python:3.9-alpine3.12 as base

COPY	--from=builder /opt/venv /opt/venv
COPY	entrypoint.sh /entrypoint.sh

RUN	apk update --no-cache && apk add libmilter && chmod +x /entrypoint.sh

ENV UID=500
ENV GID=500

VOLUME ["/config", "/socket", "/data"]

ENTRYPOINT ["/entrypoint.sh"]

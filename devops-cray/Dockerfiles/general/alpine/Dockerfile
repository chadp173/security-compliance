# Python 3 Dockerfile v1.0.0

FROM python:3.7-alpine
MAINTAINER Scott C. King <sking@cray.com>

# Install required tools.
RUN apk add -u bash musl-dev libffi-dev openssl-dev gcc make

RUN pip install fabric \
  cryptography==2.4.2 \
  logzero

CMD ["/bin/bash"]

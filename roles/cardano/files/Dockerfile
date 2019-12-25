FROM alpine:latest

RUN apk add --no-cache --upgrade curl wget tzdata

# copy and update config
COPY config.yaml /stakepool-config.yaml
ARG LISTEN_ADDR='/ip4/0.0.0.0/tcp/3000'
ARG PUBLIC_ADDR='/ip4/0.0.0.0/tcp/3000'
RUN sed -i "s|\"listen_address\": \".*\"|\"listen_address\": \"$LISTEN_ADDR\"|" /stakepool-config.yaml && \
    sed -i "s|\"public_address\": \".*\"|\"public_address\": \"$PUBLIC_ADDR\"|" /stakepool-config.yaml

# set time zone
ARG TIME_ZONE=Etc/UTC
RUN ln -sf "/usr/share/zoneinfo/$TIME_ZONE" /etc/localtime && echo "$TIME_ZONE" > /etc/timezone

# download latest jormungandr and install to /usr/bin
ENV URL='https://api.github.com/repos/input-output-hk/jormungandr/releases/latest'
RUN curl -s "$URL" | grep 'browser_download_url.*x86_64-unknown-linux-musl' | cut -d '"' -f4 | wget -qi - && \
    tar xzf jormungandr*.tar.gz && \
    mv jcli jormungandr /usr/bin/

VOLUME ["/data"]

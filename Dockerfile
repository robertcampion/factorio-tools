# syntax=docker/dockerfile:1
FROM ubuntu:24.04
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update && apt install -y --no-install-recommends golang-go build-essential lua5.3 liblua5.3-dev luarocks libzzip-dev git ca-certificates
ENV GOPATH="/go"
ENV PATH="$GOPATH/bin:$PATH"
RUN --mount=type=cache,target=/go/pkg/mod \
    go install github.com/gobuffalo/packr/v2/packr2@latest
RUN luarocks install luafilesystem && luarocks install luazip
COPY . /factorio-tools
WORKDIR /factorio-tools/factoriocalc
RUN --mount=type=cache,target=/go/pkg/mod \
    packr2 --legacy build
CMD ["./factoriocalc", "-browser=false", "-gamedir=/var/game", "-moddir=/var/mod", "-http-addr=0.0.0.0:80"]

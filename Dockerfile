FROM emscripten/emsdk:3.1.36 as build

WORKDIR /tmp
RUN apt-get update
RUN apt-get install dh-autoreconf autogen automake libtool shtool pkg-config -y

RUN git clone https://github.com/cloudflare/doom-wasm.git
WORKDIR ./doom-wasm
RUN ls -l
RUN ./scripts/clean.sh
RUN ./scripts/build.sh

FROM ubuntu:22.04

WORKDIR /opt
COPY --from=build /tmp/doom-wasm ./
RUN apt-get update && apt-get install curl python3 -y
RUN curl -o ./src/doom1.wad https://distro.ibiblio.org/slitaz/sources/packages/d/doom1.wad
WORKDIR src

EXPOSE 8000
CMD python3 -m http.server 8000 
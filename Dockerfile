FROM emscripten/emsdk:3.1.69 AS build

WORKDIR /tmp
RUN apt update && apt install dh-autoreconf autogen automake libtool shtool pkg-config -y && apt clean

RUN git clone https://github.com/cloudflare/doom-wasm.git
WORKDIR /tmp/doom-wasm
RUN ls -l
RUN ./scripts/clean.sh
RUN ./scripts/build.sh

FROM ubuntu:24.04

ARG USERNAME=doom
ARG USER_UID=1024
ARG USER_GID=$USER_UID
ARG USER_WORKDIR=/home/$USERNAME/doom-wasm

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -d /home/$USERNAME -m $USERNAME \
    && apt update \
    && apt install -y sudo && apt clean \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
COPY --from=build --chown=$USERNAME:$USERNAME /tmp/doom-wasm $USER_WORKDIR

USER $USERNAME

WORKDIR $USER_WORKDIR/src
RUN sudo apt update && sudo apt install curl python3 -y && sudo apt clean
RUN curl -o ./doom1.wad https://distro.ibiblio.org/slitaz/sources/packages/d/doom1.wad

EXPOSE 8000
CMD python3 -m http.server 8000 
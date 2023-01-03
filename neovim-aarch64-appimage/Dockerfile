FROM ubuntu:18.04 as build

ARG BRANCH=master
ENV DEBIAN_FRONTEND=noninteractive

RUN \
  apt update && \
  apt upgrade -y && \
  apt install -y autoconf automake build-essential cmake curl gettext git libtool-bin locales ninja-build pkg-config unzip && \
  git clone -b ${BRANCH} --single-branch --depth 1 https://github.com/neovim/neovim.git

WORKDIR neovim

ADD nvim-appimage-appimagetool.patch nvim-appimage-appimagetool.patch

RUN \
  patch -p1 <nvim-appimage-appimagetool.patch && \
  make appimage-latest

FROM busybox

COPY --from=build /neovim/build/bin/nvim.appimage /nvim.appimage

# Aria2-AriaNG
<p align="center">
  <img src="https://raw.githubusercontent.com/mayswind/AriaNg-Native/master/assets/AriaNg.ico" />
</p>

Docker image to run [Aria2](https://github.com/aria2/aria2) + [AriaNg Web UI](https://github.com/mayswind/AriaNg) based on [linuxserver.io](https://www.linuxserver.io) image.

Heavily inspired by [hurlenko/aria2-ariang-docker](https://github.com/hurlenko/aria2-ariang-docker)
The main difference between the images it that this image is using the [s6-overlay](https://github.com/just-containers/s6-overlay#init-stages) so the functionality of the container can be changed.

## Introduction

AriaNg is a modern web frontend making [aria2](https://github.com/aria2/aria2) easier to use. AriaNg is written in pure HTML & JavaScript, thus it does not need any compilers or runtime environment.

## Usage

### Docker

```bash
docker run -d \
    --name aria2 \
    -p 8080:8080 \
    -v /downloads/path/on/disk:/aria2/data \
    -v /config/path/on/disk:/aria2/conf \
    -e PUID=1000 \
    -e PGID=1000 \
    -e RPC_SECRET=SOMESECRETSTRING \
    viajusta/aria2-ariang
```

### docker-compose

Minimal `docker-compose.yml` may look like this:

```yaml
version: "3"

services:
  ariang:
    image: viajusta/aria2-ariang
    ports:
      - 8080:8080
    volumes:
      - /downloads/path/on/disk:/aria2/data
      - /config/path/on/disk:/aria2/conf
    environment:
      - PUID=1000
      - PGID=1000
      - RPC_SECRET=SOMESECRETSTRING
      - ARIA2RPCPORT=8080
    restart: always
```

### Supported environment variables

- `PUID` - Userid who will own all downloaded files and configuration files (Default `0` which is root)
- `PGID` - Groupid who will own all downloaded files and configuration files (Default `0` which is root)
- `RPC_SECRET` - The Aria2 RPC secret token (Default: not set)
- `EMBED_RPC_SECRET` - INSECURE: embeds `RPC_SECRET` into web ui js code. This allows you to skip entering the secret but everyone who has access to the web UI will be able to see it. Only use this with some sort of authentication (e.g. basic auth)
- `BASIC_AUTH_USERNAME` - username for basic auth
- `BASIC_AUTH_PASSWORD` - password for basic auth
- `ARIA2RPCPORT` - The port that will be used for rpc calls to aria2. Usually you want to set it to the port your website is running on. For example if your AriaNg instance is accessible on `https://ariang.mysite.com` you need to set `ARIA2RPCPORT` to `443` (default https port), otherwise AriaNg won't be able to access aria2 rpc running on the default port `8080`. You can set the port in the web ui by going to `AriaNg Settings` > `Rpc` tab > `Aria2 RPC Address` field, and changing the default rpc port to whatever you need, but this has to be done per browser.

> Note, both `BASIC_AUTH_USERNAME` and `BASIC_AUTH_PASSWORD` must be set in order to enable basic authentication.

### Supported volumes

- `/aria2/data` The folder of all Aria2 downloaded files
- `/aria2/conf` The Aria2 configuration file

### User / Group identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1001` and `PGID=1001`, to find yours use `id user` as below:

```bash
id username
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

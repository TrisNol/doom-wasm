# Doom WASM
There is a meme in the IT community about running Doom on any device possible - be it calculators or really anything with a display. This repository provides a dockerized way to host Doom 1 as a webservice making it publicly available to any clients with a keyboard.

To run the image, you can wrap it in a `docker-compose.yml` like this:
```yaml
version: "3.8"
services:
  doom-wasm:
    image: ghcr.io/trisnol/doom-wasm:main
    restart: unless-stopped
    ports:
      - 8080:8000

```

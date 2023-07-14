## Building locally

Before using the Image you have to build it with podman build as following:
```
podman build \
  --no-cache \
  --pull \
  -t infosec/evilginx3:latest .
```

## Usage

Here are some example snippets to help you get started creating a new container.

### Generic podman-syntax

```
podman run \
  --name=evilginx3 \
  -e TZ=Europe/Zurich \
  -p 8443:443 \
  -p 8080:80 \
  -v <path to data>:/config \
  -v <path to data>:/phishlets
  --restart unless-stopped \
  infosec/evilginx3:latest
```

### Test run on Phishing-Node 001
```
/usr/bin/podman run -it --name evilginx3-main -p 5080:80 -p 5443:443 -v /opt/podman-evilginx3-main/config:/config:Z -v /opt/podman-evilginx3-main/phishlets:/phishlets:Z infosec/evilginx3:latest
```

### Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 80` | The port for HTTP traffic |
| `-p 443` | The port for HTTPS traffic |
| `-e TZ=Europe/Zurich` | Specify a timezone to use EG Europe/Zurich|
| `-v /config` | evilginx2 configs |
| `-v /phishlets` | evilginx2 phishlets |

## Nice to know

* Shell access whilst the container is running: `podman exec -it evilginx3 /bin/bash`
* To monitor the logs of the container in realtime: `podman logs -f evilginx3`

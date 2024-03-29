# SUI auto discovery

Tiny Go program to automatically add apps to the [SUI](https://github.com/jeroenpardon/sui) apps section by using Docker labels

## How it works

The Go binary does the following: 

1. Fetch all containers from the Docker socket
2. Look for containers with sui.app.xxx labels
3. Write these labels to the JSON config file used by SUI.

## Deployment

1. Install Docker Compose
2. Clone the repository
3. Run `docker-compose up -d`. The `docker-compose.yml` includes SUI as well.
4. Attach labels to containers to be added to the apps section as instructed [here](#container-labels).
5. Go to `localhost:4000`

### Container labels

For now only containers can be automatically added to the 'apps' section. To do so, attach the following labels (and label values) to your container:

1. `sui.app.icon=< Material Design icon to display>` [See: materialdesignicons.com](https://materialdesignicons.com/)
2. `sui.app.name=<name to display>`
3. `sui.app.url=<url to display>`

*examples:*

```sh
docker run -d \
--name nginx \
--label "sui.app.icon=web" \
--label "sui.app.name=nginx" \
--label "sui.app.url=nginx.mydomain.xyz" \
nginx
```

```yml
version: "3.5"

services:
  nginx:
    image: nginx
    container_name: nginx
    ports:
      - "80:80"
    labels:
      - "sui.app.icon=web"
      - "sui.app.name=nginx"
      - "sui.app.url=nginx.mydomain.xyz"
```

### Flags

`apps-config`: Location of apps.json file (default "/config/apps.json")

### Security

To discover labels attached to containers, the Docker Socket has to be reachable.
This is a security [risk](https://raesene.github.io/blog/2016/03/06/The-Dangers-Of-Docker.sock/).

To mitigate the risk, one could put a proxy in front of the Docker Socket. This has security implications as well, as the proxy container has to be trusted. And this container might be more complicated than my code.

If you are currently already using a Docker Socket proxy, I would advise to use the proxy for sui-auto-discovery as well: see `docker-compose-with-proxy.yml` for an example.

If not using a Docker Socket proxy already, I would advise to run the container directly (i.e. without a proxy), as introducing a (potentially complicated) proxy has security implications as well. (i.e. you have to decide who you trust more, sui-auto-discovery vs. the proxy)

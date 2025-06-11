## Docker In Docker (DinD)

### Docker-in-Docker with TLS enabled in the Docker executor


```shell
sudo gitlab-runner register -n \
  --url "https://gitlab.ams-ix.net/" \
  --registration-token GR1348941g7W4BiZngVDzvzebyCwF \
  --executor docker \
  --description "docker:24.0.5@cont-node-02" \
  --docker-image "docker:24.0.5" \
  --docker-privileged \
  --docker-volumes "/certs/client" \
  --docker-volumes "/cache" \
  --tag-list "cont-node-02,docker,dind,dockerv24,buildx,builder" \
  --docker-volume-driver=overlay2

```

```toml  
[[runners]]
  url = "https://gitlab.com/"
  token = TOKEN
  executor = "docker"
  [runners.docker]
    tls_verify = false
    image = "docker:24.0.5"
    privileged = true
    disable_cache = false
    volumes = ["/certs/client", "/cache"]
  [runners.cache]
    [runners.cache.s3]
    [runners.cache.gcs]

```

```yml
default:
  image: docker:24.0.5
  services:
    - docker:24.0.5-dind
  before_script:
    - docker info

variables:
  # When you use the dind service, you must instruct Docker to talk with
  # the daemon started inside of the service. The daemon is available
  # with a network connection instead of the default
  # /var/run/docker.sock socket. Docker 19.03 does this automatically
  # by setting the DOCKER_HOST in
  # https://github.com/docker-library/docker/blob/d45051476babc297257df490d22cbd806f1b11e4/19.03/docker-entrypoint.sh#L23-L29
  #
  # The 'docker' hostname is the alias of the service container as described at
  # https://docs.gitlab.com/ee/ci/services/#accessing-the-services.
  #
  # Specify to Docker where to create the certificates. Docker
  # creates them automatically on boot, and creates
  # `/certs/client` to share between the service and job
  # container, thanks to volume mount from config.toml

  # When using dind service, you must instruct docker to talk with the
  # daemon started inside of the service. The daemon is available with
  # a network connection instead of the default /var/run/docker.sock socket.
  #
  # The 'docker' hostname is the alias of the service container as described at
  # https://docs.gitlab.com/ee/ci/docker/using_docker_images.html#accessing-the-services
  #
  DOCKER_HOST: tcp://docker:2375
  #
  # This instructs Docker not to start over TLS.
  DOCKER_TLS_CERTDIR: "/certs"
  DOCKER_DRIVER: overlay2
build:
  stage: build
  script:
    - docker build -t my-docker-image .
    - docker run my-docker-image /script/to/run/tests
```

### Use a Unix socket on a shared volume between Docker-in-Docker and build container


```toml
[[runners]]
  url = "https://gitlab.com/"
  token = TOKEN
  executor = "docker"
  [runners.docker]
    image = "docker:24.0.5"
    privileged = true
    volumes = ["/runner/services/docker"] # Temporary volume shared between build and service containers.
```

```yml
default:
  image: docker:24.0.5
  services:
    - docker:24.0.5-dind
  before_script:
    - docker info

variables:
  # When using dind service, you must instruct docker to talk with the
  # daemon started inside of the service. The daemon is available with
  # a network connection instead of the default /var/run/docker.sock socket.
  #
  # The 'docker' hostname is the alias of the service container as described at
  # https://docs.gitlab.com/ee/ci/docker/using_docker_images.html#accessing-the-services
  #
  DOCKER_HOST: tcp://docker:2375
  #
  # This instructs Docker not to start over TLS.
  DOCKER_TLS_CERTDIR: ""

build:
  stage: build
  script:
    - docker build -t my-docker-image .
    - docker run my-docker-image /script/to/run/tests
```

### Use the Docker executor with Docker socket binding

sudo gitlab-runner register -n \
  --url "https://gitlab.com/" \
  --registration-token REGISTRATION_TOKEN \
  --executor docker \
  --description "My Docker Runner" \
  --docker-image "docker:24.0.5" \
  --docker-volumes /var/run/docker.sock:/var/run/docker.sock

[[runners]]
  url = "https://gitlab.com/"
  token = RUNNER_TOKEN
  executor = "docker"
  [runners.docker]
    tls_verify = false
    image = "docker:24.0.5"
    privileged = false
    disable_cache = false
    volumes = ["/var/run/docker.sock:/var/run/docker.sock", "/cache"]
  [runners.cache]
    Insecure = false
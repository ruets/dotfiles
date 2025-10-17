To install repo, do :

```bash
bash <(curl -s RAW_URL)
```

To testing in docker container, run:

```bash
docker run -it --rm \
        --name dotfiles-test \
        -v $HOME/.ssh:/root/.ssh:ro \
        ubuntu:24.04 bash -c "\
      apt update && \
      DEBIAN_FRONTEND=noninteractive apt install -y git curl xz-utils nano && \
      bash"
```

packages :

adb
pvpn-cli
min browser
pacseek
bar-protonmail
spotify-tui
render cli
posting (api tui)

lm studio

FROM archlinux:base-devel

# https://docs.github.com/en/actions/reference/dockerfile-support-for-github-actions#workdir,
# make a relative ./workdir to ease testing.
RUN mkdir -p "./workdir"

RUN <<EOF
    pacman -Syu --noconfirm --needed base-devel git rsync
EOF

COPY ["PKGBUILD", "docker-entrypoint-build-archlinux.bash", "bin-ensure-updated-source-to-build", "./workdir"]

ENTRYPOINT ["bash", "-c", "cd ./workdir ; bash docker-entrypoint-build-archlinux.bash"]

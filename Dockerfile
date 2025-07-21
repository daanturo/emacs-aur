FROM archlinux:base-devel

# https://docs.github.com/en/actions/reference/dockerfile-support-for-github-actions#workdir,
# github action will override WORKDIR, manually cd to instead

RUN mkdir -p "/build/"

RUN <<EOF
    pacman -Syu --noconfirm --needed base-devel git rsync
EOF

COPY ["PKGBUILD", "docker-entrypoint-build-archlinux.bash", "bin-ensure-updated-source-to-build", "/build/"]

ENTRYPOINT ["bash", "-c", "cd /build/ ; bash docker-entrypoint-build-archlinux.bash"]

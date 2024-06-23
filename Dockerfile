FROM --platform="linux/arm64" gcc:13.2.0-bookworm AS build

COPY . "/src"
WORKDIR "/src"
RUN make

FROM --platform="linux/arm64" scratch
ARG PROG_NAME="rand"

COPY --from=build /src/${PROG_NAME} /${PROG_NAME}
# COPY --from=build /lib/x86_64-linux-gnu/libc.so.6 /lib/x86_64-linux-gnu/
# COPY --from=build /lib64/ld-linux-x86-64.so.2 /lib64/
# COPY --from=build /lib/aarch64-linux-gnu/libc.so.6 /lib/aarch64-linux-gnu/libc.so.6

ENTRYPOINT [ "/rand" ]

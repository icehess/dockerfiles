FROM alpine:latest

RUN \
    addgroup -g 1000 -S devuser && \
    adduser -u 1000 -D -S -G devuser devuser

CMD ["tail", "-f", "/dev/null"]

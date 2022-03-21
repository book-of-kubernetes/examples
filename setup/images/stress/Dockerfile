FROM alpine

RUN apk --update add stress-ng && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*

ENTRYPOINT ["stress-ng"]
CMD ["--help"]


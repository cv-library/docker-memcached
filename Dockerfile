FROM alpine:3.7

RUN apk add --no-cache ca-certificates curl gcc libc-dev make

RUN curl -L https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz | tar xzf -

RUN cd libevent-2.1.8-stable                   \
 && ./configure --disable-shared --prefix=/usr \
 && make install

RUN curl http://www.memcached.org/files/memcached-1.5.7.tar.gz | tar xzf -

RUN cd memcached-1.5.7          \
 && LDFLAGS=-static ./configure \
 && make                        \
 && strip memcached

FROM scratch

COPY --from=0 memcached-1.5.7/memcached /

USER 1000

ENTRYPOINT ["/memcached"]

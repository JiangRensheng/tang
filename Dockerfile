FROM ubuntu/build:16.04 as builder

LABEL maintainer="golden finger@deepsecs.com"

WORKDIR /opt
RUN apt-get -y update \
  && apt-get install -yqq dh-autoreconf pkg-config git-core libz-dev libssl-dev \
  && git clone https://github.com/nodejs/http-parser.git  && cd http-parser \
  && make -j4 && make install && cd - \
  && git clone https://github.com/akheron/jansson && cd jansson \
  && aclocal && autoreconf -fis && automake --add-missing && ./configure && make -j4 && make install && cd - \
  && git clone --branch v10 https://github.com/latchset/jose.git && cd jose \ 
  && libtoolize --automake --copy --force && aclocal && automake --add-missing && autoreconf -fis \
  && ./configure && make -j4 && make install && cd - \
  && git clone https://github.com/latchset/tang.git && cd tang && autoreconf -if \
  && ./configure --prefix=/usr --libdir=/usr/lib64 && make -j4 && make install

FROM ubuntu:16.04
RUN apt-get -y update && apt-get install -y libssl1.0.0 && mkdir -p /opt/tang 

WORKDIR /opt/tang
COPY --from=builder /opt/http-parser/libhttp_parser.so.2.8.1 .
COPY --from=builder /opt/jansson/src/.libs/libjansson.so.4.11.0 .
COPY --from=builder /opt/jose/lib/.libs/libjose.so.0.0.0 .
COPY --from=builder /opt/jose/cmd/.libs/jose .
COPY --from=builder /opt/tang/src/tang-show-keys .
COPY --from=builder /opt/tang/src/tangd .
COPY --from=builder /opt/tang/src/tangd-* ./

RUN  ln -s libhttp_parser.so.2.8.1 libhttp_parser.so.2.8 \    
  && ln -s libhttp_parser.so.2.8.1 libhttp_parser.so \ 
  && ln -s libjansson.so.4.11.0 libjansson.so.4.11 \      
  && ln -s libjansson.so.4.11.0 libjansson.so \ 
  && ln -s libjose.so.0.0.0 libjose.so.0.0 \     
  && ln -s libjose.so.0.0.0 libjose.so \
  && ln -s libjose.so.0.0.0 libjose.so.0 \
  && ln -s libjansson.so.4.11.0 libjansson.so.4 \
  && mkdir -p /var/cache/tang /var/db/tang /var/log/tang 


COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]


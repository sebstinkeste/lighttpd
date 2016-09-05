FROM debian:jessie

RUN apt-get update && apt-get -y install nano wget htop gcc make

ENV SERVICE lighttpd
ENV LIGHTTPD_VERSION 1.4.41


RUN wget http://lighttpd.net/download/${SERVICE}-${LIGHTTPD_VERSION}.tar.gz && \
    tar -zxvf ${SERVICE}-${LIGHTTPD_VERSION}.tar.gz && \
    cd ${SERVICE}-${LIGHTTPD_VERSION} && \
    ./configure  \
           --without-pcre  \
           --without-zlib  \
           --without-bzip2 &&\
    make && \
    make install && \
    mkdir -p /etc/${SERVICE} && \
    groupadd ${SERVICE} && \
    useradd -g ${SERVICE} -d /var/www/html -s /sbin/nologin ${SERVICE} && \
    mkdir -p /var/log/${SERVICE} && \
    chown ${SERVICE}:${SERVICE} /var/log/${SERVICE}

COPY lighttpd.conf /etc/${SERVICE}/${SERVICE}.conf
RUN chown ${SERVICE}:root /etc/${SERVICE}/${SERVICE}.conf

COPY ${SERVICE} /etc/init.d/${SERVICE}
RUN chmod +x /etc/init.d/${SERVICE}
EXPOSE 80

#ENTRYPOINT ["lighttpd", "-D","-f","/etc/lighttpd/lighttpd.conf"]
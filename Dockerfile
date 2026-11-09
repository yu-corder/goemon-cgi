FROM httpd:2.4

RUN apt-get update && apt-get install -y --no-install-recommends \
        gcc make libc6-dev \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i \
    -e 's/^\([[:space:]]*\)#\(LoadModule cgid_module\)/\1\2/' \
    -e 's/^\([[:space:]]*\)#\(LoadModule cgi_module\)/\1\2/' \
    -e 's/^#ServerName.*/ServerName localhost/' \
    /usr/local/apache2/conf/httpd.conf

COPY goemon-src /app/goemon-src
RUN make -C /app/goemon-src clean all
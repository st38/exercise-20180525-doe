FROM ubuntu:xenial
MAINTAINER st38

ARG build_dir=/tmp/nginx

RUN mkdir ${build_dir} && \
    cd ${build_dir} && \
    apt-get update && \
    apt-get --yes install build-essential wget net-tools && \
    wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.42.tar.gz && \
    tar -zxf pcre-8.42.tar.gz && \
    cd pcre-8.42 && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    wget https://zlib.net/zlib-1.2.11.tar.gz && \
    tar -zxf zlib-1.2.11.tar.gz && \
    cd zlib-1.2.11 && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    wget https://www.openssl.org/source/openssl-1.0.2o.tar.gz && \
    tar -zxf openssl-1.0.2o.tar.gz && \
    cd openssl-1.0.2o && \
    ./config --prefix=/usr && \
    make && \
    make install && \
    cd .. && \
    wget https://luajit.org/download/LuaJIT-2.0.5.tar.gz && \
    tar -zxf LuaJIT-2.0.5.tar.gz && \
    cd LuaJIT-2.0.5 && \
    make && \
    make install && \
    cd .. && \
    wget https://github.com/simplresty/ngx_devel_kit/archive/v0.3.0.tar.gz && \
    mkdir ngx_devel_kit && \
    tar -zxf v0.3.0.tar.gz -C ngx_devel_kit --strip-components=1 && \
    wget https://github.com/openresty/lua-nginx-module/archive/v0.10.13.tar.gz && \
    mkdir ngx_lua && \
    tar -zxf v0.10.13.tar.gz -C ngx_lua --strip-components=1 && \
    wget https://nginx.org/download/nginx-1.13.12.tar.gz && \
    tar zxf nginx-1.13.12.tar.gz && \
    cd nginx-1.13.12 && \
    export LUAJIT_LIB=/usr/local/lib/lua && \
    export LUAJIT_INC=/usr/local/include/luajit-2.0 && \
    ./configure --prefix=/opt/nginx \
         --with-ld-opt="-Wl,-rpath,${LUAJIT_LIB}" \
         --add-module="${build_dir}"/ngx_devel_kit \
         --add-module="${build_dir}"/ngx_lua && \
    make -j2 && \
    make install && \
    cd ../.. && \
    ln -s /opt/nginx/sbin/nginx /usr/local/bin/nginx && \
    rm -rf "${build_dir}" && \
    ldconfig

RUN rm -f /opt/nginx/conf/nginx.conf.default
COPY nginx/index.html /opt/nginx/html/index.html
COPY nginx/nginx.conf /opt/nginx/conf/nginx.conf

CMD ["nginx", "-g", "daemon off;"]
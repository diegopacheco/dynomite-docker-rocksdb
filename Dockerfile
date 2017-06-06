FROM java:8-jdk
MAINTAINER Diego Pacheco - diego.pacheco.it@gmail.com

RUN apt-get update && apt-get install -y \
	autoconf \
	build-essential \
	dh-autoreconf \
	git \
	libssl-dev \
	libtool \
	python-software-properties \
	tcl8.5 \
	dos2unix \
	unzip

RUN mkdir /dynomite-0.5.8/ &&  cd /dynomite-0.5.8/ && git clone https://github.com/Netflix/dynomite.git
RUN cd /dynomite-0.5.8/dynomite/ && git checkout tags/v0.5.8-5_HgetallLocalRack

RUN mkdir /dynomite-0.5.9/ &&  cd /dynomite-0.5.9/ && git clone https://github.com/Netflix/dynomite.git
RUN cd /dynomite-0.5.9/dynomite/ && git checkout tags/v0.5.9-2_ProxyCloseFix

WORKDIR /
RUN git clone https://github.com/yinqiwen/ardb.git && cd /ardb/ &&  make

ADD start.sh /usr/local/dynomite/
RUN mkdir /dynomite/ && mkdir /dynomite/conf/
COPY rocksdb_cluster_1.yml /dynomite/conf/rocksdb_cluster_1.yml
COPY rocksdb_cluster_2.yml /dynomite/conf/rocksdb_cluster_2.yml
COPY rocksdb_cluster_3.yml /dynomite/conf/rocksdb_cluster_3.yml
COPY rocksdb_cluster_21.yml /dynomite/conf/rocksdb_cluster_21.yml
COPY rocksdb_cluster_22.yml /dynomite/conf/rocksdb_cluster_22.yml
COPY rocksdb_cluster_23.yml /dynomite/conf/rocksdb_cluster_23.yml

RUN chmod 777 /usr/local/dynomite/start.sh

WORKDIR /dynomite-0.5.8/dynomite/
RUN autoreconf -fvi \
		&& ./configure --enable-debug=log \
		&& CFLAGS="-ggdb3 -O0" ./configure --enable-debug=log \
		&& make \
		&& make install

WORKDIR /dynomite-0.5.9/dynomite/
RUN autoreconf -fvi \
		&& ./configure --enable-debug=log \
		&& CFLAGS="-ggdb3 -O0" ./configure --enable-debug=log \
		&& make \
		&& make install

EXPOSE 8101
EXPOSE 16379
EXPOSE 22222
EXPOSE 8102

CMD ["/usr/local/dynomite/start.sh"]

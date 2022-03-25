FROM postgres:12

RUN apt-get update \
	&& apt-get install -y --no-install-recommends ca-certificates wget build-essential libc++abi-dev git python libc++-dev glib2.0 libtinfo5 postgresql-server-dev-12=$PG_VERSION \
	&& git config --global user.name "Temporary User" && git config --global user.email "Temporarary.User@example.com" 

#build hll
ARG HLL_VERSION=v2.16

RUN git clone https://github.com/citusdata/postgresql-hll.git \
	&& cd postgresql-hll \
	&& git checkout tags/${HLL_VERSION} \
	&& make \
	&& make install \
	&& cd .. \
	&& rm -rf postgres-hll

# build plv8
ARG PLV8_VERSION=v3.0.0
RUN apt-get install -y --no-install-recommends ninja-build
RUN	git clone https://github.com/plv8/plv8.git \
	&& cd plv8 \
	&& git checkout tags/${PLV8_VERSION} \ 
	&& make \
	&& make install \
	&& cd / \
	&& rm -rf plv8 

# build postgis
RUN apt-get install -y --no-install-recommends tar gdal-bin libgdal-dev libgeos-3.9.0 libgeos++-dev proj-bin libproj-dev libxml2 libxml2-dev libjson-c5 libjson-c-dev libcunit1 libprotobuf-c1  libprotobuf-c-dev protobuf-c-compiler libprotoc-dev \
	&& rm -rf /var/lib/apt/lists/* 

ARG POSTGIS_VERSION=3.2.1
RUN wget https://download.osgeo.org/postgis/source/postgis-${POSTGIS_VERSION}.tar.gz \
	&& tar -xvzf postgis-${POSTGIS_VERSION}.tar.gz \
	&& rm postgis-${POSTGIS_VERSION}.tar.gz \
	&& cd postgis-${POSTGIS_VERSION} \
	&& ./configure \
	&& make \
	&& make install \
	&& cd .. \
	&& rm -rf postgis-${POSTGIS_VERSION}


# clean up	
RUN apt-get purge -y --auto-remove ca-certificates wget build-essential git python glib2.0 postgresql-server-dev-12 libgeos++-dev libxml2-dev libjson-c-dev libcunit1 libproj-dev libgdal-dev libc++abi-dev libprotobuf-c-dev libprotoc-dev ninja-build

RUN mkdir -p /docker-entrypoint-initdb.d
# enable plv8 by default
COPY ./initdb-plv8.sh /docker-entrypoint-initdb.d/plv8.sh

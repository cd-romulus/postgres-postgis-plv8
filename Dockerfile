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
RUN	git clone https://github.com/plv8/plv8.git \
	&& cd plv8 \
	&& git checkout tags/v2.3.14 \ 
	&& make \
	&& make install \
	&& cd / \
	&& rm -rf plv8 

# build postgis
RUN apt-get install -y --no-install-recommends tar gdal-bin libgdal-dev dans-gdal-scripts libgeos-3.7.1 libgeos++-dev proj-bin libproj-dev libxml2 libxml2-dev libjson-c3 libjson-c-dev libcunit1 \
	&& rm -rf /var/lib/apt/lists/* 
	
RUN wget https://download.osgeo.org/postgis/source/postgis-3.0.1.tar.gz \
	&& tar -xvzf postgis-3.0.1.tar.gz \
	&& rm postgis-3.0.1.tar.gz \
	&& cd postgis-3.0.1 \
	&& ./configure \
	&& make \
	&& make install \
	&& cd .. \
	&& rm -rf postgis-3.0.1


# clean up	
RUN apt-get purge -y --auto-remove ca-certificates wget build-essential git python glib2.0 postgresql-server-dev-12 libgeos++-dev libxml2-dev libjson-c-dev libcunit1 libproj-dev libgdal-dev libc++abi-dev

RUN mkdir -p /docker-entrypoint-initdb.d
# enable plv8 by default
COPY ./initdb-plv8.sh /docker-entrypoint-initdb.d/plv8.sh

# Dockerfile that builds a postgres image with postgis and plv8 extensions

Currently used versions are
- postgres: 12.2
- postgis: 3.0.1
- plv8: 2.3.14

plv8 will be enabled by default on each created database. The postgis features have to be [enabled manually](https://postgis.net/install/).

Referre to the [official postgres docker image](https://hub.docker.com/_/postgres) for documentation on how to use the image. 
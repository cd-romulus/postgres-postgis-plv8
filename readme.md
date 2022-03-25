# Dockerfile that builds a postgres image with postgis, plv8, hll extensions

Currently used versions are
- postgres: 12
- postgis: 3.2.1
- plv8: 3.0.0
- hll: 2.1.6

plv8 will be enabled by default on each created database. The postgis features have to be [enabled manually](https://postgis.net/install/).

Referre to the [official postgres docker image](https://hub.docker.com/_/postgres) for documentation on how to use the image. 
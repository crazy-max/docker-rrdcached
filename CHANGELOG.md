# Changelog

## 1.8.0-r0 (2023/07/30)

* RRDtool cached 1.8.0
* Alpine Linux 3.18

## 1.7.2-r5-r0 (2022/05/15)

* RRDtool cached 1.7.2-r5
* Alpine Linux 3.15

## 1.7.2-r4-r2 (2021/03/19)

* alpine-s6 3.14-2.2.0.3 (#30)
* Move to `docker/metadata-action`

## 1.7.2-r4-r1 (2021/03/18)

* Upstream Alpine update

## 1.7.2-r4-r0 (2021/02/17)

* RRDtool cached 1.7.2-r4
* `s6-overlay` 2.2.0.3
* Alpine Linux 3.13
* Fix daemon to listen on port 42217 (librenms/docker#124)
* Switch to buildx bake

## 1.7.2-r3-RC4 (2020/11/08)

* Switch to `s6-overlay` and log through `socklog-overlay`

## 1.7.2-r3-RC3 (2020/08/07)

* Set up healthcheck start period (#8)

## 1.7.2-r3-RC2 (2020/06/15)

* Alpine Linux 3.12

## 1.7.2-r3-RC1 (2020/04/04)

* RRDtool cached 1.7.2-r3
* Alpine Linux 3.11
* Switch to Open Container Specification labels as label-schema.org ones are deprecated

## 1.7.2-RC8 (2019/11/07)

* Bring back `PUID`/`PGID` vars

## 1.7.2-RC7 (2019/10/20)

* Fix `WRITE_JITTER`

## 1.7.2-RC6 (2019/10/17)

* Switch to GitHub Actions
* :warning: Stop publishing Docker image on Quay
* :warning: Run as non-root user
* Set timezone through tzdata

> :warning: **UPGRADE NOTES**
> As the Docker container now runs as a non-root user, you have to first stop the container and change permissions to volumes:
> ```
> docker compose stop
> chown -R 1000:1000 data/db data/journal
> docker compose pull
> docker compose up -d
> ```

## 1.7.2-RC5 (2019/09/14)

* Split db and journal volumes
* Add `PUID`/`PGID` vars

## 1.7.2-RC4 (2019/08/17)

* Fix journal issue

## 1.7.2-RC3 (2019/08/17)

* No need to chown `/data`
* Remove `PUID`/`PGID` vars

## 1.7.2-RC2 (2019/08/07)

* Add healthcheck

## 1.7.2-RC1 (2019/06/24)

* RRDtool cached 1.7.2
* Alpine Linux 3.10

## 1.7.0-RC2 (2019/01/31)

* Alpine Linux 3.9

## 1.7.0-RC1 (2018/12/03)

* Fix RRDtool cached version

## 20180706

* Initial version

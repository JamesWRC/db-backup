[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/IWPjnG?referralCode=AMYBrI)

https://railway.app/template/IWPjnG?referralCode=AMYBrI



# github.com/tiredofit/docker-db-backup

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-db-backup?style=flat-square)](https://github.com/tiredofit/docker-db-backup/releases/latest)
[![Build Status](https://img.shields.io/github/actions/workflow/status/tiredofit/docker-db-backup/main.yml?branch=main&style=flat-square)](https://github.com/tiredofit/docker-db-backup/actions)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/db-backup.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/db-backup/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/db-backup.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/db-backup/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

* * *
## About

This will build a container for backing up multiple types of DB Servers

Currently backs up CouchDB, InfluxDB, MySQL, MongoDB, Postgres, Redis servers.

* dump to local filesystem or backup to S3 Compatible services, and Azure.
* select database user and password
* backup all databases, single, or multiple databases
* backup all to seperate files or one singular file
* choose to have an MD5 or SHA1 sum after backup for verification
* delete old backups after specific amount of time
* choose compression type (none, gz, bz, xz, zstd)
* connect to any container running on the same system
* Script to perform restores
* Zabbix Monitoring capabilities
* select how often to run a dump
* select when to start the first dump, whether time of day or relative to container start time
* Execute script after backup for monitoring/alerting purposes

## Maintainer

- [Dave Conroy](https://github.com/tiredofit)

## Table of Contents

- [github.com/tiredofit/docker-db-backup](#githubcomtiredofitdocker-db-backup)
  - [About](#about)
  - [Maintainer](#maintainer)
  - [Table of Contents](#table-of-contents)
  - [Prerequisites and Assumptions](#prerequisites-and-assumptions)
  - [Installation](#installation)
    - [Build from Source](#build-from-source)
    - [Prebuilt Images](#prebuilt-images)
      - [Multi Architecture](#multi-architecture)
  - [Configuration](#configuration)
    - [Quick Start](#quick-start)
    - [Persistent Storage](#persistent-storage)
    - [Environment Variables](#environment-variables)
      - [Base Images used](#base-images-used)
      - [Container Options](#container-options)
    - [Database Specific Options](#database-specific-options)
      - [For Influx DB2:](#for-influx-db2)
    - [Scheduling Options](#scheduling-options)
    - [Backup Options](#backup-options)
      - [Backing Up to S3 Compatible Services](#backing-up-to-s3-compatible-services)
      - [Upload to a Azure storage account by `blobxfer`](#upload-to-a-azure-storage-account-by-blobxfer)

> **NOTE**: If you are using this with a docker-compose file along with a seperate SQL container, take care not to set the variables to backup immediately, more so have it delay execution for a minute, otherwise you will get a failed first backup.

## Prerequisites and Assumptions
*  You must have a working connection to one of the supported DB Servers and appropriate credentials

## Installation

### Build from Source
Clone this repository and build the image with `docker build <arguments> (imagename) .`

### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/db-backup)

Builds of the image are also available on the [Github Container Registry](https://github.com/tiredofit/docker-db-backup/pkgs/container/docker-db-backup)

```
docker pull ghcr.io/tiredofit/docker-db-backup:(imagetag)
```

The following image tags are available along with their tagged release based on what's written in the [Changelog](CHANGELOG.md):

| Alpine Base | Tag       |
| ----------- | --------- |
| latest      | `:latest` |

```bash
docker pull docker.io/tiredofdit/db-backup:(imagetag)
```
#### Multi Architecture
Images are built primarily for `amd64` architecture, and may also include builds for `arm/v7`, `arm64` and others. These variants are all unsupported. Consider [sponsoring](https://github.com/sponsors/tiredofit) my work so that I can work with various hardware. To see if this image supports multiple architecures, type `docker manifest (image):(tag)`

## Configuration

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.
* Make [networking ports](#networking) available for public access if necessary

### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.
| Directory              | Description                                                                         |
| ---------------------- | ----------------------------------------------------------------------------------- |
| `/backup`              | Backups                                                                             |
| `/assets/scripts/pre`  | *Optional* Put custom scripts in this directory to execute before backup operations |
| `/assets/scripts/post` | *Optional* Put custom scripts in this directory to execute after backup operations  |

### Environment Variables

#### Base Images used

This image relies on an [Alpine Linux](https://hub.docker.com/r/tiredofit/alpine) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`, `nano`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                  | Description                            |
| ------------------------------------------------------ | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-alpine/) | Customized Image based on Alpine Linux |

#### Container Options

| Parameter               | Description                                                                                                                      | Default         |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `BACKUP_LOCATION`       | Backup to `FILESYSTEM`, `blobxfer` or `S3` compatible services like S3, Minio, Wasabi                                            | `FILESYSTEM`    |
| `MODE`                  | `AUTO` mode to use internal scheduling routines or `MANUAL` to simply use this as manual backups only executed by your own means | `AUTO`          |
| `MANUAL_RUN_FOREVER`    | `TRUE` or `FALSE` if you wish to try to make the container exit after the backup                                                 | `TRUE`          |
| `TEMP_LOCATION`         | Perform Backups and Compression in this temporary directory                                                                      | `/tmp/backups/` |
| `DEBUG_MODE`            | If set to `true`, print copious shell script messages to the container log. Otherwise only basic messages are printed.           | `FALSE`         |
| `CREATE_LATEST_SYMLINK` | Create a symbolic link pointing to last backup in this format: `latest-(DB_TYPE)-(DB_NAME)-(DB_HOST)`                            | `TRUE`          |
| `PRE_SCRIPT`            | Fill this variable in with a command to execute pre backing up                                                                   |                 |
| `POST_SCRIPT`           | Fill this variable in with a command to execute post backing up                                                                  |                 |
| `SPLIT_DB`              | For each backup, create a new archive. `TRUE` or `FALSE` (MySQL and Postgresql Only)                                             | `TRUE`          |

### Database Specific Options
| Parameter          | Description                                                                                                                                                                          | Default | `_FILE` |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------- | ------- |
| `DB_AUTH`          | (Mongo Only - Optional) Authentication Database                                                                                                                                      |         |         |
| `DB_TYPE`          | Type of DB Server to backup `couch` `influx` `mysql` `pgsql` `mongo` `redis` `sqlite3`                                                                                               |         |         |
| `DB_HOST`          | Server Hostname e.g. `mariadb`. For `sqlite3`, full path to DB file e.g. `/backup/db.sqlite3`                                                                                        |         | x       |
| `DB_NAME`          | Schema Name e.g. `database` or `ALL` to backup all databases the user has access to. Backup multiple by seperating with commas eg `db1,db2`                                          |         | x       |
| `DB_NAME_EXCLUDE`  | If using `ALL` - use this as to exclude databases seperated via commas from being backed up                                                                                          |         | x       |
| `DB_USER`          | username for the database(s) - Can use `root` for MySQL                                                                                                                              |         | x       |
| `DB_PASS`          | (optional if DB doesn't require it) password for the database                                                                                                                        |         | x       |
| `DB_PORT`          | (optional) Set port to connect to DB_HOST. Defaults are provided                                                                                                                     | varies  | x       |
| `INFLUX_VERSION`   | What Version of Influx are you backing up from `1`.x or `2` series - AMD64 and ARM64 only for `2`                                                                                    |         |         |
| `MONGO_CUSTOM_URI` | If you wish to override the MongoDB Connection string enter it here e.g. `mongodb+srv://username:password@cluster.id.mongodb.net`                                                    |         | x       |
|                    | This environment variable will be parsed and populate the `DB_NAME` and `DB_HOST` variables to properly build your backup filenames. You can overrde them by making your own entries |         |         |

#### For Influx DB2:
Your Organization will be mapped to `DB_USER` and your root token will need to be mapped to `DB_PASS`. You may use `DB_NAME=ALL` to backup the entire set of databases. For `DB_HOST` use syntax of `http(s)://db-name`

### Scheduling Options
| Parameter                | Description                                                                                                                                                                                        | Default                      |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `DB_DUMP_FREQ`           | How often to do a dump, in minutes after the first backup. Defaults to 1440 minutes, or once per day.                                                                                              | `1440`                       |
| `DB_DUMP_BEGIN`          | What time to do the first dump. Defaults to immediate. Must be in one of two formats                                                                                                               |                              |
|                          | Absolute HHMM, e.g. `2330` or `0415`                                                                                                                                                               |                              |
|                          | Relative +MM, i.e. how many minutes after starting the container, e.g. `+0` (immediate), `+10` (in 10 minutes), or `+90` in an hour and a half                                                     |                              |
| `DB_DUMP_TARGET`         | Directory where the database dumps are kept.                                                                                                                                                       | `${DB_DUMP_TARGET}/archive/` |
| `DB_DUMP_TARGET_ARCHIVE` | Optional Directory where the database dumps archives are kept.                                                                                                                                     |                              |
| `DB_CLEANUP_TIME`        | Value in minutes to delete old backups (only fired when dump freqency fires). 1440 would delete anything above 1 day old. You don't need to set this variable if you want to hold onto everything. | `FALSE`                      |
| `DB_ARCHIVE_TIME`        | Value in minutes to move all files files older than (x) from `DB_DUMP_TARGET` to `DB_DUMP_TARGET_ARCHIVE` - which is useful when pairing against an external backup system.                        |                              |

- You may need to wrap your `DB_DUMP_BEGIN` value in quotes for it to properly parse. There have been reports of backups that start with a `0` get converted into a different format which will not allow the timer to start at the correct time.

### Backup Options
| Parameter                      | Description                                                                                                                  | Default                   | `_FILE` |
| ------------------------------ | ---------------------------------------------------------------------------------------------------------------------------- | ------------------------- | ------- |
| `COMPRESSION`                  | Use either Gzip `GZ`, Bzip2 `BZ`, XZip `XZ`, ZSTD `ZSTD` or none `NONE`                                                      | `ZSTD`                    |         |
| `COMPRESSION_LEVEL`            | Numberical value of what level of compression to use, most allow `1` to `9` except for `ZSTD` which allows for `1` to `19` - | `3`                       |         |
| `ENABLE_PARALLEL_COMPRESSION`  | Use multiple cores when compressing backups `TRUE` or `FALSE`                                                                | `TRUE`                    |         |
| `PARALLEL_COMPRESSION_THREADS` | Maximum amount of threads to use when compressing - Integer value e.g. `8`                                                   | `autodetected`            |         |
| `GZ_RSYNCABLE`                 | Use `--rsyncable` (gzip only) for faster rsync transfers and incremental backup deduplication. e.g. `TRUE`                   | `FALSE`                   |         |
| `ENABLE_CHECKSUM`              | Generate either a MD5 or SHA1 in Directory, `TRUE` or `FALSE`                                                                | `TRUE`                    |         |
| `CHECKSUM`                     | Either `MD5` or `SHA1`                                                                                                       | `MD5`                     |         |
| `EXTRA_OPTS`                   | If you need to pass extra arguments to the backup command, add them here e.g. `--extra-command`                              |                           |         |
| `MYSQL_MAX_ALLOWED_PACKET`     | Max allowed packet if backing up MySQL / MariaDB                                                                             | `512M`                    |         |
| `MYSQL_SINGLE_TRANSACTION`     | Backup in a single transaction with MySQL / MariaDB                                                                          | `TRUE`                    |         |
| `MYSQL_STORED_PROCEDURES`      | Backup stored procedures with MySQL / MariaDB                                                                                | `TRUE`                    |         |
| `MYSQL_ENABLE_TLS`             | Enable TLS functionality for MySQL client                                                                                    | `FALSE`                   |         |
| `MYSQL_TLS_VERIFY`             | (optional) If using TLS (by means of MYSQL_TLS_* variables) verify remote host                                               | `FALSE`                   |         |
| `MYSQL_TLS_VERSION`            | What TLS `v1.1` `v1.2` `v1.3` version to utilize                                                                             | `TLSv1.1,TLSv1.2,TLSv1.3` |         |
| `MYSQL_TLS_CA_FILE`            | Filename to load custom CA certificate for connecting via TLS                                                                | `/etc/ssl/cert.pem`       | x       |
| `MYSQL_TLS_CERT_FILE`          | Filename to load client certificate for connecting via TLS                                                                   |                           | x       |
| `MYSQL_TLS_KEY_FILE`           | Filename to load client key for connecting via TLS                                                                           |                           | x       |

- When using compression with MongoDB, only `GZ` compression is possible.

#### Backing Up to S3 Compatible Services

If `BACKUP_LOCATION` = `S3` then the following options are used.

| Parameter             | Description                                                                               | Default | `_FILE` |
| --------------------- | ----------------------------------------------------------------------------------------- | ------- | ------- |
| `S3_BUCKET`           | S3 Bucket name e.g. `mybucket`                                                            |         | x       |
| `S3_KEY_ID`           | S3 Key ID (Optional)                                                                      |         | x       |
| `S3_KEY_SECRET`       | S3 Key Secret (Optional)                                                                  |         | x       |
| `S3_PATH`             | S3 Pathname to save to (must NOT end in a trailing slash e.g. '`backup`')                 |         | x       |
| `S3_REGION`           | Define region in which bucket is defined. Example: `ap-northeast-2`                       |         | x       |
| `S3_HOST`             | Hostname (and port) of S3-compatible service, e.g. `minio:8080`. Defaults to AWS.         |         | x       |
| `S3_PROTOCOL`         | Protocol to connect to `S3_HOST`. Either `http` or `https`. Defaults to `https`.          | `https` | x       |
| `S3_EXTRA_OPTS`       | Add any extra options to the end of the `aws-cli` process execution                       |         | x       |
| `S3_CERT_CA_FILE`     | Map a volume and point to your custom CA Bundle for verification e.g. `/certs/bundle.pem` |         | x       |
| _*OR*_                |                                                                                           |         |         |
| `S3_CERT_SKIP_VERIFY` | Skip verifying self signed certificates when connecting                                   | `TRUE`  |         |

- When `S3_KEY_ID` and/or `S3_KEY_SECRET` is not set, will try to use IAM role assigned (if any) for uploading the backup files to S3 bucket.

#### Upload to a Azure storage account by `blobxfer`

Support to upload backup files with [blobxfer](https://github.com/Azure/blobxfer) to the Azure fileshare storage.

If `BACKUP_LOCATION` = `blobxfer` then the following options are used.

| Parameter                      | Description                                 | Default             | `_FILE` |
| ------------------------------ | ------------------------------------------- | ------------------- | ------- |
| `BLOBXFER_STORAGE_ACCOUNT`     | Microsoft Azure Cloud storage account name. |                     | x       |
| `BLOBXFER_STORAGE_ACCOUNT_KEY` | Microsoft Azure Cloud storage account key.  |                     | x       |
| `BLOBXFER_REMOTE_PATH`         | Remote Azure path                           | `/docker-db-backup` | x       |

> This service uploads files from backup targed directory `DB_DUMP_TARGET`.
> If the a cleanup configuration in `DB_CLEANUP_TIME` is defined, the remote directory on Azure storage will also be cleaned automatically.

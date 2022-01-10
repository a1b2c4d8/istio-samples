#!/bin/bash
#
# Copyright 2017 Istio Authors
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

set -o errexit

if [ "$#" -eq 0 ]; then
    echo Missing prefix and version parameters
    echo Usage: build-services.sh \<prefix\> \<version\>
    exit 1
fi

if [ "$#" -eq 1 ]; then
    echo Missing version parameter
    echo Usage: build-services.sh \<prefix\> \<version\>
    exit 1
fi

if [ "$#" -gt 2 ]; then
    echo Extra parameters provided
    echo Usage: build-services.sh \<prefix\> \<version\>
    exit 1
fi

PREFIX=$1
VERSION=$2
SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#pushd "$SCRIPTDIR/productpage"
#  docker build --pull -t "istio/examples-bookinfo-productpage-v1:${VERSION}" -t istio/examples-bookinfo-productpage-v1:latest .
#  #flooding
#  docker build --pull -t "istio/examples-bookinfo-productpage-v-flooding:${VERSION}" -t istio/examples-bookinfo-productpage-v-flooding:latest --build-arg flood_factor=100 .
#popd

#pushd "$SCRIPTDIR/details"
#  #plain build -- no calling external book service to fetch topics
#  docker build --pull -t "istio/examples-bookinfo-details-v1:${VERSION}" -t istio/examples-bookinfo-details-v1:latest --build-arg service_version=v1 .
#  #with calling external book service to fetch topic for the book
#  docker build --pull -t "istio/examples-bookinfo-details-v2:${VERSION}" -t istio/examples-bookinfo-details-v2:latest --build-arg service_version=v2 \
#	 --build-arg enable_external_book_service=true .
#popd

PLATFORMS=linux/amd64,linux/arm64/v8

pushd "$SCRIPTDIR/reviews"
  #build the java app.
  #docker run --rm -u root -v "$(pwd)":/home/gradle/project -w /home/gradle/project gradle:4.8.1 gradle clean build
  pushd reviews-application
    docker run --rm -v "$(pwd)":/usr/src/mymaven -w /usr/src/mymaven maven:3.8.4-openjdk-17 mvn clean package
  popd
  pushd reviews-tomcat
    # copy the war file
    rm -rf servers
    mkdir -p servers/apps
    cp ../reviews-application/target/reviews-application-1.0.war servers/apps/


    #plain build -- no ratings
    #docker build \
    docker buildx build --platform "$PLATFORMS" --push \
        -t "$PREFIX/examples-tomcat-bookinfo-reviews-v1:${VERSION}" \
        --build-arg service_version=v1 \
        .

    #with ratings black stars
    #docker build \
    docker buildx build --platform "$PLATFORMS" --push \
        -t "$PREFIX/examples-tomcat-bookinfo-reviews-v2:${VERSION}" \
        --build-arg service_version=v2 \
	      --build-arg enable_ratings=true \
	      .

    #with ratings red stars
    #docker build \
    docker buildx build --platform "$PLATFORMS" --push \
        -t "$PREFIX/examples-tomcat-bookinfo-reviews-v3:${VERSION}" \
        --build-arg service_version=v3 \
	      --build-arg enable_ratings=true \
	      --build-arg star_color=red \
	      .
  popd
popd

#pushd "$SCRIPTDIR/ratings"
#  docker build --pull -t "istio/examples-bookinfo-ratings-v1:${VERSION}" -t istio/examples-bookinfo-ratings-v1:latest --build-arg service_version=v1 .
#  docker build --pull -t "istio/examples-bookinfo-ratings-v2:${VERSION}" -t istio/examples-bookinfo-ratings-v2:latest --build-arg service_version=v2 .
#  docker build --pull -t "istio/examples-bookinfo-ratings-v-faulty:${VERSION}" -t istio/examples-bookinfo-ratings-v-faulty:latest --build-arg service_version=v-faulty .
#  docker build --pull -t "istio/examples-bookinfo-ratings-v-delayed:${VERSION}" -t istio/examples-bookinfo-ratings-v-delayed:latest --build-arg service_version=v-delayed .
#  docker build --pull -t "istio/examples-bookinfo-ratings-v-unavailable:${VERSION}" -t istio/examples-bookinfo-ratings-v-unavailable:latest --build-arg service_version=v-unavailable .
#  docker build --pull -t "istio/examples-bookinfo-ratings-v-unhealthy:${VERSION}" -t istio/examples-bookinfo-ratings-v-unhealthy:latest --build-arg service_version=v-unhealthy .
#popd

#pushd "$SCRIPTDIR/mysql"
#  docker build --pull -t "istio/examples-bookinfo-mysqldb:${VERSION}" -t istio/examples-bookinfo-mysqldb:latest .
#popd

#pushd "$SCRIPTDIR/mongodb"
#  docker build --pull -t "istio/examples-bookinfo-mongodb:${VERSION}" -t istio/examples-bookinfo-mongodb:latest .
#popd

#!/bin/bash
#
# Copyright 2018 Istio Authors
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

#if [ "$#" -ne 1 ]; then
#    echo Missing version parameter
#    echo Usage: build_push_update_images.sh \<version\>
#    exit 1
#fi

PREFIX=rsdkna58
VERSION=1.15.0

#Build docker images
src/build-services.sh "${PREFIX}" "${VERSION}"

##get all the new image names and tags
#for v in ${VERSION} lastest
#do
#  IMAGES+=$(docker images -f reference="$PREFIX/examples-tomcat-bookinfo-reviews-*:$v" --format "{{.Repository}}:$v")
#  IMAGES+=" "
#done
#
#for IMAGE in ${IMAGES} ; do
#  echo "$IMAGE"
done

#push images
#for IMAGE in ${IMAGES};
#do
#  echo "Pushing: ${IMAGE}"
#  docker push "${IMAGE}"
#done

#Update image references in the yaml files
#find . -name "*bookinfo*.yaml" -exec sed -i.bak "s/\\(soloio\\/examples-tomcat-bookinfo-.*\\):[[:digit:]]*\\.[[:digit:]]*\\.[[:digit:]]*/\\1:$VERSION/g" {} +

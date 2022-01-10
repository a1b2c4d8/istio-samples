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

FROM tomcat:10.0.14-jdk17-openjdk-bullseye

ADD ./servers/apps/reviews-application-1.0.war /usr/local/tomcat/webapps.dist/

RUN sed -i 's/8080/9080/g' /usr/local/tomcat/conf/server.xml

RUN ln -s /usr/local/tomcat/webapps.dist/reviews-application-1.0.war /usr/local/tomcat/webapps/ROOT.war

ARG service_version
ARG enable_ratings
ARG star_color
ENV SERVICE_VERSION ${service_version:-v1}
ENV ENABLE_RATINGS ${enable_ratings:-false}
ENV STAR_COLOR ${star_color:-black}

EXPOSE 9080

CMD ["catalina.sh", "run"]

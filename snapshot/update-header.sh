#!/usr/bin/env bash

# Copyright 2019 The KubeSphere Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

UPGRADE_DIR="/opt/upgrade"
UPGRADE_IMAGE="${UPGRADE_DIR}/image"
UPGRADE_BINARY="${UPGRADE_DIR}/binary"
UPGRADE_SCRIPT="${UPGRADE_SCRIPT}/script"

declare -A IMG_FILE_MAP
IMG_FILE_MAP=(
    ["gcr.azk8s.cn/google-containers/hyperkube:v1.15.5"]="hyperkube-v1.15.5.img" 
    ["gcr.azk8s.cn/google-containers/pause:3.1"]="pause-3.1.img"

    ["gcr.azk8s.cn/google_containers/coredns:1.3.1"]="coredns-1.3.1.img"
    ["calico/node:v3.8.4"]="calico-node-v3.8.4.img"
    ["calico/cni:v3.8.4"]="calico-cni-v3.8.4.img"
    ["calico/kube-controllers:v3.8.4"]="calico-kube-controllers-v3.8.4.img"
    ["calico/pod2daemon-flexvol:v3.8.4"]="calico-pod2daemon-flexvol-v3.8.4.img"
    ["quay.io/coreos/flannel:v0.11.0-amd64"]="flannel-v0.11.0-amd64.img"
    ["kubesphere/cloud-controller-manager:v1.4.2"]="cloud-controller-manager-v1.4.2.img"

    ["quay.io/k8scsi/csi-provisioner:v1.4.0"]="csi-provisioner-v1.4.0.img"
    ["quay.io/k8scsi/csi-attacher:v2.0.0"]="csi-attacher-v2.0.0.img"
    ["quay.io/k8scsi/csi-snapshotter:v1.2.2"]="csi-attacher-v2.0.0.img"
    ["quay.io/k8scsi/csi-resizer:v0.2.0"]="csi-resizer-v0.2.0.img"
    ["csiplugin/csi-qingcloud:v1.1.0"]="csi-qingcloud-v1.1.0.img"
    ["quay.io/k8scsi/csi-node-driver-registrar:v1.2.0"]="csi-node-driver-registrar-v1.2.0.img"

    ["gcr.azk8s.cn/kubernetes-helm/tiller:v2.12.3"]="tiller-v2.12.3.img"
    ["nginx:1.14-alpine"]="nginx-1.14-alpine.img"

    ["kubesphere/ks-console:v2.1.0"]="ks-console-v2.1.0.img"
    ["kubesphere/kubectl:v1.0.0"]="kubectl-v1.0.0.img"
    ["kubesphere/ks-account:v2.1.0"]="ks-account-v2.1.0.img"
    ["kubesphere/ks-devops"]="ks-devops-flyway-v2.1.0.img"
    ["kubesphere/ks-apigateway:v2.1.0"]="ks-apigateway-v2.1.0.img"
    ["kubesphere/ks-apiserver:v2.1.0"]="ks-apiserver-v2.1.0.img"
    ["kubesphere/ks-controller-manager:v2.1.0"]="ks-controller-manager-v2.1.0.img"
    ["kubesphere/docs.kubesphere.io:advanced-2.0.0"]="docs.kubesphere.io-advanced-2.0.0.img"
    ["kubesphere/cloud-controller-manager:v1.4.0"]="cloud-controller-manager-v1.4.0.img"
    ["kubesphere/ks-installer:v2.1.0"]="ks-installer-v2.1.0.img"

    ["quay.azk8s.cn/kubernetes-ingress-controller/nginx-ingress-controller:0.24.1"]="nginx-ingress-controller-0.24.1.img"
    ["mirrorgooglecontainers/defaultbackend-amd64:1.4"]="defaultbackend-amd64-1.4.img"
    ["gcr.azk8s.cn/google_containers/metrics-server-amd64:v0.3.1"]="metrics-server-amd64-v0.3.1.img"

    ["kubesphere/notification:v2.1.0"]="notification-v2.1.0.img"
    ["kubesphere/notification:flyway_v2.1.0"]="notification-flyway_v2.1.0.img"
    ["kubesphere/alerting-dbinit:v2.1.0"]="alerting-dbinit-v2.1.0.img"
    ["kubesphere/alerting:v2.1.0"]="alerting-v2.1.0.img"
    ["kubesphere/alert_adapter:v2.1.0"]="alert_adapter-v2.1.0.img"
    
    ["openpitrix/release-app:v0.4.2"]="release-app-v0.4.2.img"
    ["openpitrix/openpitrix:flyway-v0.4.5"]="openpitrix-flyway-v0.4.5.img"
    ["openpitrix/openpitrix:v0.4.5"]="openpitrix-v0.4.5.img"
    ["openpitrix/runtime-provider-kubernetes:v0.1.2"]="runtime-provider-kubernetes-v0.1.2.img"

    ["kubesphere/jenkins-uc:v2.1.0"]="jenkins-uc-v2.1.0.img"
    ["jenkins/jenkins:2.176.2"]="jenkins-2.176.2.img"
    ["jenkins/jnlp-slave:3.27-1"]="jnlp-slave-3.27-1.img"
    ["kubesphere/builder-base:v2.1.0"]="builder-base-v2.1.0.img"
    ["kubesphere/builder-nodejs:v2.1.0"]="builder-nodejs-v2.1.0.img"
    ["kubesphere/builder-maven:v2.1.0"]="builder-maven-v2.1.0.img"
    ["kubesphere/builder-go:v2.1.0"]="builder-go-v2.1.0.img"
    ["sonarqube:7.4-community"]="sonarqube-7.4-community.img"

    ["kubesphere/s2ioperator:v2.1.0"]="s2ioperator-v2.1.0.img"
    ["kubesphere/s2irun:v2.1.0"]="s2irun-v2.1.0.img"
    ["kubesphere/java-11-centos7:v2.1.0"]="java-11-centos7-v2.1.0.img"
    ["kubesphere/java-8-centos7:v2.1.0"]="java-8-centos7-v2.1.0.img"
    ["kubesphere/nodejs-8-centos7:v2.1.0"]="nodejs-8-centos7-v2.1.0.img"
    ["kubesphere/nodejs-6-centos7:v2.1.0"]="nodejs-6-centos7-v2.1.0.img"
    ["kubesphere/nodejs-4-centos7:v2.1.0"]="nodejs-4-centos7-v2.1.0.img"
    ["kubesphere/python-36-centos7:v2.1.0"]="python-36-centos7-v2.1.0.img"
    ["kubesphere/python-35-centos7:v2.1.0"]="python-35-centos7-v2.1.0.img"
    ["kubesphere/python-34-centos7:v2.1.0"]="python-34-centos7-v2.1.0.img"
    ["kubesphere/python-27-centos7:v2.1.0"]="python-27-centos7-v2.1.0.img"
    ["kubesphere/tomcat85-java8-centos7:v2.1.0"]="tomcat85-java8-centos7-v2.1.0.img"
    ["kubesphere/tomcat85-java8-runtime:v2.1.0"]="tomcat85-java8-runtime-v2.1.0.img"
    ["kubesphere/tomcat85-java11-runtime:v2.1.0"]="tomcat85-java11-runtime-v2.1.0.img"
    ["kubesphere/tomcat85-java11-centos7:v2.1.0"]="tomcat85-java11-centos7-v2.1.0.img"
    ["kubesphere/java-8-runtime:v2.1.0"]="java-8-runtime-v2.1.0.img"
    ["kubesphere/java-11-runtime:v2.1.0"]="java-11-runtime-v2.1.0.img"
    ["kubesphere/s2i-binary:v2.1.0"]="s2i-binary-v2.1.0.img"

    ["kubesphere/configmap-reload:v0.0.1"]="configmap-reload-v0.0.1.img"
    ["kubesphere/prometheus:v2.5.0"]="prometheus-v2.5.0.img"
    ["kubesphere/prometheus-config-reloader:v0.27.1"]="prometheus-config-reloader-v0.27.1.img"
    ["kubesphere/prometheus-operator:v0.27.1"]="prometheus-operator-v0.27.1.img"
    ["kubesphere/kube-rbac-proxy:v0.4.1"]="kube-rbac-proxy-v0.4.1.img"
    ["kubesphere/kube-state-metrics:v1.5.2"]="kube-state-metrics-v1.5.2.img"
    ["kubesphere/node-exporter:ks-v0.16.0"]="node-exporter-ks-v0.16.0.img"
    ["kubesphere/addon-resizer:1.8.4"]="addon-resizer-1.8.4.img"
    ["mirrorgooglecontainers/addon-resizer:1.8.3"]="addon-resizer-1.8.3.img"
    ["grafana/grafana:5.2.4"]="grafana:5.2.4.img"

    ["kubesphere/docker-elasticsearch-curator:5.5.4"]="docker-elasticsearch-curator-5.5.4.img"
    ["kubesphere/elasticsearch-oss:6.7.0-1"]="elasticsearch-oss-6.7.0-1.img"
    ["kubesphere/fluent-bit:v1.3.2-reload"]="fluent-bit-v1.3.2-reload.img"
    ["docker.elastic.co/kibana/kibana-oss:6.7.0"]="kibana-oss-6.7.0.img"
    ["dduportal/bats:0.4.0"]="bats-0.4.0.img"
    ["kubesphere/fluentbit-operator:v2.1.0"]="fluentbit-operator-v2.1.0.img"
    ["kubesphere/fluent-bit:v1.3.2-reload"]="fluent-bit-v1.3.2-reload.img"
    ["kubesphere/configmap-reload:v0.0.1"]="configmap-reload-v0.0.1.img"
    ["kubesphere/log-sidecar-injector:1.0"]="log-sidecar-injector-1.0.img"

    ["istio/kubectl:1.3.3"]="kubectl-1.3.3.img"
    ["istio/proxyv2:1.3.3"]="proxyv2-1.3.3.img"
    ["istio/citadel:1.3.3"]="citadel-1.3.3.img"
    ["istio/pilot:1.3.3"]="pilot-1.3.3.img"
    ["istio/mixer:1.3.3"]="mixer-1.3.3.img"
    ["istio/galley:1.3.3"]="galley-1.3.3.img"
    ["istio/proxy_init:1.3.3"]="proxy_init-1.3.3.img"
    ["istio/sidecar_injector:1.3.3"]="sidecar_injector-1.3.3.img"
    ["jaegertracing/jaeger-operator:1.13.1"]="jaeger-operator-1.13.1.img"
    ["jaegertracing/jaeger-agent:1.13"]="jaeger-agent-1.13.img"
    ["jaegertracing/jaeger-collector:1.13"]="jaeger-collector-1.13.img"
    ["jaegertracing/jaeger-query:1.13"]="jaeger-query-1.13.img"

    ["redis:5.0.5-alpine"]="redis-5.0.5-alpine.img"
    ["busybox:1.28.4"]="busybox-1.28.4.img"
    ["mysql:8.0.11"]="mysql-8.0.11.img"
    ["nginx:1.14-alpine"]="nginx-1.14-alpine.img"
    ["postgres:9.6.8"]="postgres-9.6.8.img"
    ["osixia/openldap:1.3.0"]="openldap-1.3.0.img"
    ["alpine:3.9"]="alpine-3.9.img"
    ["haproxy:2.0.4"]="haproxy-2.0.4.img"
    ["joosthofman/wget:1.0"]="wget-1.0.img"
    ["minio/minio:RELEASE.2019-08-07T01-59-21Z"]="minio-RELEASE.2019-08-07T01-59-21Z.img"
    ["minio/minio:RELEASE.2017-12-28T01-21-00Z"]="minio-RELEASE.2017-12-28T01-21-00Z.img"
    ["minio/mc:RELEASE.2019-08-07T23-14-43Z"]="mc-RELEASE.2019-08-07T23-14-43Z.img"
    ["minio/mc:RELEASE.2018-07-13T00-53-22Z"]="mc-RELEASE.2018-07-13T00-53-22Z.img"

    ["kubesphere/examples-bookinfo-productpage-v1:1.13.0"]="examples-bookinfo-productpage-v1-1.13.0.img"
    ["kubesphere/examples-bookinfo-reviews-v1:1.13.0"]="examples-bookinfo-reviews-v1-1.13.0.img"
    ["kubesphere/examples-bookinfo-reviews-v2:1.13.0"]="examples-bookinfo-reviews-v2-1.13.0.img"
    ["kubesphere/examples-bookinfo-reviews-v3:1.13.0"]="examples-bookinfo-reviews-v3-1.13.0.img"
    ["kubesphere/examples-bookinfo-details-v1:1.13.0"]="examples-bookinfo-details-v1-1.13.0.img"
    ["kubesphere/examples-bookinfo-ratings-v1:1.13.0"]="examples-bookinfo-ratings-v1-1.13.0.img"
    ["kubesphere/netshoot:v1.0"]="netshoot-v1.0.img"
    ["nginxdemos/hello:plain-text"]="hello-plain-text.img"
    ["mysql:8.0.11"]="mysql-8.0.11.img"
    ["wordpress:4.8-apache"]="wordpress-4.8-apache.img"
    ["mirrorgooglecontainers/hpa-example:latest"]="hpa-example-latest.img"
    ["java:openjdk-8-jre-alpine"]="java-openjdk-8-jre-alpine.img"
    ["fluent/fluentd:v1.4.2-2.0"]="fluentd-v1.4.2-2.0.img"
    ["perl:latest"]="perl-latest.img"
)
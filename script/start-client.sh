#!/usr/bin/env bash

# Copyright 2018 The KubeSphere Authors.
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


SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")
${K8S_HOME}/script/check-fs.sh
${K8S_HOME}/script/check-env.sh
source "${K8S_HOME}/script/common.sh"
export KUBECONFIG="/etc/kubernetes/admin.conf"
log "===start start client==="

if [ ! -d "/root/.kube" ]; then
    # for upgrade
    link_dir
    set_password
    touch ${CLIENT_INIT_LOCK}
fi

log  "copy kubeconfig from master1"
scp root@master1:${KUBECONFIG} /root/.kube/config
cp /root/.kube/config ${KUBECONFIG}

log  "Install KubeSphere"
if [ ! -f "${CLIENT_INIT_LOCK}" ]; then
    touch ${CLIENT_INIT_LOCK}
    log  "Install Cloud Controller Manager"
    install_cloud_controller_manager
    log  "Pre-check tiller"
    retry is_tiller_available
    if [ "${ENV_INSTALL_KUBESPHERE}" == "true" ]
    then
        log  "Install KubeSphere"
        install_kubesphere
    fi
    log  "Finish install KubeSphere"
    chmod 400 ${CLIENT_INIT_LOCK}
fi

# for cluster recovery
if [ "${ENV_INSTALL_KUBESPHERE}" == "true" ]
then
    log "install kubesphere resource"
    retry kubectl get nodes --kubeconfig ${KUBECONFIG}
    retry kubectl apply -f /opt/kubernetes/k8s/kubesphere/ks-console/ks-console-svc.yaml
fi

log  "===end start client==="
exit 0
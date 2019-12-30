SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"
UPGRADE_DIR="/root"
UPGRADE_BINARY="${UPGRADE_DIR}/binary"
UPGRADE_SCRIPT="${UPGRADE_DIR}/kubernetes"

# copy binary (kubelet, kubeadm, kubectl)
retry systemctl stop kubelet
retry cp ${UPGRADE_BINARY}/kubelet /usr/bin/kubelet
retry cp ${UPGRADE_BINARY}/kubectl /usr/bin/kubectl
retry cp ${UPGRADE_BINARY}/kubeadm /usr/bin/kubeadm

# copy scripts
mv /opt/kubernetes /opt/old-kubernetes
cp -r ${UPGRADE_SCRIPT} /opt

# copy confd template files
rm -rf ${PERMIT_RELOAD_LOCK}
rm -rf /etc/confd/conf.d/k8s/*
rm -rf /etc/confd/templates/k8s/*
cp -r ${UPGRADE_DIR}/kubernetes/confd/conf.d /etc/confd/
cp -r ${UPGRADE_DIR}/kubernetes/confd/templates /etc/confd/
systemctl restart confd
/opt/qingcloud/app-agent/bin/confd -onetime
touch ${PERMIT_RELOAD_LOCK}
chmod 400 ${PERMIT_RELOAD_LOCK}

# delete sts and ds
kubectl delete sts csi-qingcloud-controller -n kube-system --kubeconfig ${KUBECONFIG}
kubectl delete ds csi-qingcloud-node -n kube-system --kubeconfig ${KUBECONFIG}
# upgrade csi plugin
retry kubectl apply -f /opt/kubernetes/k8s/addons/qingcloud-csi/csi-release-v1.1.0.yaml  --kubeconfig ${KUBECONFIG}
# update storage class
kubectl delete -f /opt/kubernetes/k8s/addons/qingcloud-csi/csi-sc.yaml  --kubeconfig ${KUBECONFIG}
kubectl create -f /opt/kubernetes/k8s/addons/qingcloud-csi/csi-sc.yaml  --kubeconfig ${KUBECONFIG}
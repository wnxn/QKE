package phase

import (
	"github.com/QingCloudAppcenter/QKE/cmd/qkeadm/app/cmd/phase/workflow"
	"k8s.io/klog"
)

// NewKubeletStartPhase creates a kubeadm workflow phase that start kubelet on a node.
func NewGetPackagePhase() workflow.Phase {
	return workflow.Phase{
		Name: "get-package",
		Short: "Download packages from Internet",
		Long: "Download packages from Internet for qkeadm init",
		Run: runGetPackagePhase,
	}
}

func runGetPackagePhase(c workflow.RunData) error{
	klog.Info("[get-package] Downloading packages")
	return nil
}
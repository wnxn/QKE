package phase

import (
	"github.com/QingCloudAppcenter/QKE/cmd/qkeadm/app/cmd/options"
	"github.com/QingCloudAppcenter/QKE/cmd/qkeadm/app/cmd/phase/workflow"
	"k8s.io/klog"
)

func NewPreflightPhase() workflow.Phase{
	return workflow.Phase{
		Name: "preflight",
		Short: "Run pre-flight checks",
		Long: "Run pre-flight checks for qkeadm init.",
		Run: runPreflight,
		InheritFlags: []string{
			options.IgnorePreflightErrors,
		},
	}
}

func runPreflight(c workflow.RunData) error{
	klog.Info("[preflight] Running pre-flight checks")
	return nil
}
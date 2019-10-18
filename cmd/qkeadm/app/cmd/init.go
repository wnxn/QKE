package cmd

import (
	"github.com/QingCloudAppcenter/QKE/cmd/qkeadm/app/cmd/phase/init"
	"github.com/QingCloudAppcenter/QKE/cmd/qkeadm/app/cmd/phase/workflow"
	"github.com/spf13/cobra"
	"io"
	"k8s.io/apimachinery/pkg/util/sets"
	"k8s.io/klog"
)

var _ phase.InitData = &initData{}

type initData struct{
	dryRun                  bool
	dryRunDir               string
	outputWriter            io.Writer
	ignorePreflightErrors   sets.String
}

func NewCmdInit(out io.Writer)*cobra.Command{
	initRunner := workflow.NewRunner()
	cmd := &cobra.Command{
		Use: "init",
		Short: "Run this command in order to set up QKE KVM image",
		RunE: func(cmd *cobra.Command, args []string)error {
			_, err := initRunner.InitData(args)
			if err != nil{
				return err
			}

			if err := initRunner.Run(args); err != nil {
				return err
			}

			klog.Info("qkeadm init")
			return nil
		},
		Args: cobra.NoArgs,
	}
	// initialize the workflow runner with the list of phases
	initRunner.AppendPhase(phase.NewPreflightPhase())
	initRunner.AppendPhase(phase.NewGetPackagePhase())

	initRunner.BindToCommand(cmd)
	return cmd
}

// DryRun returns the DryRun flag.
func (d *initData)DryRun()bool{
	return d.dryRun
}

// IgnorePreflightErrors returns the IgnorePreflightErrors flag.
func (d *initData) IgnorePreflightErrors() sets.String {
	return d.ignorePreflightErrors
}
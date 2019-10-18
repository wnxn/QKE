package cmd

import (
	"encoding/json"
	"fmt"
	"github.com/QingCloudAppcenter/QKE/pkg/common"
	"github.com/pkg/errors"
	"github.com/spf13/cobra"
	"io"
	"k8s.io/klog"
	"sigs.k8s.io/yaml"
)

// NewCmdVersion provides the version information of kubeadm.
func NewCmdVersion(out io.Writer) *cobra.Command {
	cmd := &cobra.Command{
		Use:   "version",
		Short: "Print the version of qkeadm",
		RunE: func(cmd *cobra.Command, args []string) error {
			return RunVersion(out, cmd)
		},
	}
	cmd.Flags().StringP("output", "o", "", "Output format; available options are 'yaml', 'json' and 'short'")
	return cmd
}

// RunVersion provides the version information of qkeadm in format depending on arguments
// specified in cobra.Command.
func RunVersion(out io.Writer, cmd *cobra.Command) error {
	klog.V(1).Infoln("[version] retrieving version info")
	ver := common.Get()

	const flag = "output"
	of, err := cmd.Flags().GetString(flag)
	if err != nil {
		return errors.Wrapf(err, "error accessing flag %s for command %s", flag, cmd.Name())
	}
	switch of {
	case "":
		fmt.Fprintf(out, "qkeadm version: %#v\n", ver)
	case "short":
		fmt.Fprintf(out, "%s\n", ver.QKEVersion)
	case "yaml":
		y, err := yaml.Marshal(&ver)
		if err != nil {
			return err
		}
		fmt.Fprintln(out, string(y))
	case "json":
		y, err := json.MarshalIndent(&ver, "", "  ")
		if err != nil {
			return err
		}
		fmt.Fprintln(out, string(y))
	default:
		return errors.Errorf("invalid output format: %s", of)
	}

	return nil
}

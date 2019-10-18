package cmd

import (
	"github.com/spf13/cobra"
	"io"
	"github.com/QingCloudAppcenter/QKE/cmd/qkeadm/app/util"
)

func NewQkeadmCommand(in io.Reader, out, err io.Writer) *cobra.Command{
	var rootfsPath string

	cmds:=&cobra.Command{
		Use: "qkeadm",
		Short: "qkeadm: easily make a QKE KVM image",
		PersistentPreRunE: func(cmd *cobra.Command, args []string) error {
			if rootfsPath != "" {
				if err := util.Chroot(rootfsPath); err != nil {
					return err
				}
			}
			return nil
		},
	}

	cmds.ResetFlags()
	cmds.AddCommand(NewCmdInit(out))
	cmds.AddCommand(NewCmdReset(out))
	cmds.AddCommand(NewCmdVersion(out))
	return cmds
}
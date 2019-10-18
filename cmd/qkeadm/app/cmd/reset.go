package cmd

import (
"github.com/spf13/cobra"
"io"
)

func NewCmdReset(out io.Writer)*cobra.Command{
	cmd := &cobra.Command{
		Use: "reset",
		Short: "Run this command in order to clean up QKE KVM image",
		RunE: func(cmd *cobra.Command, args []string)error{
			return nil
		},
	}
	return cmd
}

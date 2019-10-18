package phase

import (
	"k8s.io/apimachinery/pkg/util/sets"
)

// InitData is the interface to use for init phases.
// The "initData" type from "cmd/init.go" must satisfy this interface.
type InitData interface {
	DryRun() bool
	IgnorePreflightErrors() sets.String
}

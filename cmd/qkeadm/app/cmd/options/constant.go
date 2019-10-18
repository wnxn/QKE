package options

const(
	// DryRun flag instruct kubeadm to don't apply any changes; just output what would be done.
	DryRun = "dry-run"

	// IgnorePreflightErrors sets the path a list of checks whose errors will be shown as warnings. Example: 'IsPrivilegedUser,Swap'. Value 'all' ignores errors from all checks.
	IgnorePreflightErrors = "ignore-preflight-errors"
)
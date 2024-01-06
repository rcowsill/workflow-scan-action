# workflow-scan-action
[![ShellCheck](https://github.com/rcowsill/workflow-scan-action/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/rcowsill/workflow-scan-action/actions/workflows/shellcheck.yml)
[![Workflow CodeQL Scan](https://github.com/rcowsill/workflow-scan-action/actions/workflows/codeql-scan.yml/badge.svg)](https://github.com/rcowsill/workflow-scan-action/actions/workflows/codeql-scan.yml)

## Description

This action makes it easy to scan GitHub Actions workflow files with CodeQL. It's mainly intended for repos that aren't already using CodeQL on their source code.

The [Github Security Lab](https://securitylab.github.com/) created [two CodeQL queries](https://github.com/github/codeql/tree/main/javascript/ql/src/experimental/Security/CWE-094) for use on GitHub Actions workflows, but there are no detailed instructions on how to use them. There don't appear to be any public examples of these queries being used in a workflow either.

`workflow-scan-action` configures CodeQL to scan files in `.github/workflows` with the actions security queries. It includes the stub .js file required by CodeQL to perform a workflow scan. The scan itself is done by the official [GitHub codeql-action](https://github.com/github/codeql-action/).

To set it up, simply add a new workflow to your repo based on the template shown in the [usage](#usage) section.

## License

This project is released under the [MIT License](LICENSE).

The underlying CodeQL CLI, used in this action, is licensed under the [GitHub CodeQL Terms and Conditions](https://securitylab.github.com/tools/codeql/license). As such, this action may be used on open source projects hosted on GitHub, and on private repositories that are owned by an organisation with GitHub Advanced Security enabled.

## Usage
To scan your workflow files with CodeQL you can use the following workflow as a template:

```yaml
name: "Workflow CodeQL Scan"

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  schedule:
    # POSIX cron syntax for a weekly scan
    - cron: '30 1 * * 0'

permissions:
  # Required for all workflows
  security-events: write

  # Only required for workflows in private repositories
  actions: read
  contents: read

jobs:
  workflow-scan:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
        with:
          persist-credentials: false

      - name: Perform CodeQL Analysis
        uses: rcowsill/workflow-scan-action@v2
```

## Options

### `extra-queries` (default: "")
> 
> Comma-separated list of additional queries to run, eg:
> 
> ```yaml
> uses: rcowsill/workflow-scan-action@v2
> with:
>   extra-queries: "./my-local-query.ql,my-org/my-repo/my-remote-suite.qls@main"
> ```
> 
> **Local queries** start with `./`. They are looked up relative to `$GITHUB_WORKSPACE` and cannot be outside that directory (ie with `..` paths or symlinks)
> 
> **Remote queries** are of the form `{owner}/{repo}/{query-path}@{ref}`. They cause a checkout of `{owner}/{repo}` at the specified ref, and use the query at the given path

### `use-default-queries` (default: true)
> 
> Whether to use the default workflow-security-suite queries. Only useful in combination with `extra-queries` above

### `upload` (default: true)
> 
> Whether to upload the SARIF file to Code Scanning

### `data-dir-name` (default: "workflow-scan-action-data")
> 
> Name of the directory which will hold data needed by the action, eg:
> 
> ```yaml
> uses: rcowsill/workflow-scan-action@v2
> with:
>   data-dir-name: ".hidden-wsa-data"
> ```
> 
> This option lets you override the directory name if the default isn't suitable for some reason. The action makes a directory with this name inside `$GITHUB_WORKSPACE`, and copies in the data files needed for the scan. This directory must **not** already exist when the action runs.

## Notes 

The [template workflow](#usage) above uses a branch name to specify which version of the action to use. You may prefer to specify the full hash of a commit you've audited, or to fork the repo and reference your own copy. This choice is a tradeoff between the convenience of automatic patch updates and supply chain integrity. For more information, see: https://securitylab.github.com/research/github-actions-building-blocks#referencing-actions

This action will fail if used on a private repo that is owned by an organisation without GitHub Advanced Security enabled. This is a limitation of the underlying [GitHub codeql-action](https://github.com/github/codeql-action/)

## Further Reading

These articles give more detail on the issues that the actions security queries are designed to detect:

* [Keeping your GitHub Actions and workflows secure: Part 1](https://securitylab.github.com/research/github-actions-preventing-pwn-requests/)
* [Keeping your GitHub Actions and workflows secure: Part 2](https://securitylab.github.com/research/github-actions-untrusted-input/)

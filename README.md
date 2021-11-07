# workflow-scan-action
[![ShellCheck](https://github.com/rcowsill/workflow-scan-action/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/rcowsill/workflow-scan-action/actions/workflows/shellcheck.yml)
[![Workflow CodeQL Scan](https://github.com/rcowsill/workflow-scan-action/actions/workflows/codeql-scan.yml/badge.svg)](https://github.com/rcowsill/workflow-scan-action/actions/workflows/codeql-scan.yml)

## Description

This action makes it easy to scan GitHub Actions workflow files with CodeQL. It's mainly intended for repos that aren't already using CodeQL on their source code.

The [Github Security Lab](https://securitylab.github.com/) created [two CodeQL queries](https://github.com/github/codeql/tree/main/javascript/ql/src/experimental/Security/CWE-094) for use on GitHub Actions workflows, but didn't provide detailed instructions on how to use them. There don't appear to be any public projects using these queries to validate their workflow files.

`workflow-scan-action` configures CodeQL to scan files in `.github/workflows` with the actions security queries. It includes the stub .js file required by CodeQL to perform a workflow scan. The scan itself is done by the official [GitHub codeql-action](https://github.com/github/codeql-action/).

To set it up, simply add a new workflow to your repo based on the template shown in the [usage](#usage) section.

## License

This project is released under the [MIT License](LICENSE).

The underlying CodeQL CLI, used in this action, is licensed under the [GitHub CodeQL Terms and Conditions](https://securitylab.github.com/tools/codeql/license). As such, this action may be used on open source projects hosted on GitHub, and on  private repositories that are owned by an organisation with GitHub Advanced Security enabled.

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

jobs:
  workflow-scan:
    runs-on: ubuntu-latest

    permissions:
      # Required for all workflows
      security-events: write

      # Only required for workflows in private repositories
      actions: read
      contents: read

    steps:
      - name: Checkout repository
        uses: actions/checkout@v2
        with:
          persist-credentials: false

      - name: Perform CodeQL Analysis
        uses: rcowsill/workflow-scan-action@v1
        with:
          # Optional comma-separated list of extra queries/suites to run
          # extra-queries: ./local-query.ql,./local-suite.qls
```

## Further Reading

These articles give more detail on the issues that the actions security queries are designed to detect:

* [Keeping your GitHub Actions and workflows secure: Part 1](https://securitylab.github.com/research/github-actions-preventing-pwn-requests/)
* [Keeping your GitHub Actions and workflows secure: Part 2](https://securitylab.github.com/research/github-actions-untrusted-input/)

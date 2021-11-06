# workflow-scan-action

## Description

This action makes it easy to scan GitHub Actions workflow files with CodeQL. It's mainly intended for repos that aren't already using CodeQL on their source code.

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

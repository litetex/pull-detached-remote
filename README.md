# pull-detached-remote
Action for [PullDetachedRemote](https://github.com/litetex/PullDetachedRemote)

``UNDER DEVELOPMENT``

Example usage:

```YAML
name: Pull detached upstream automatically from https://github.com/<owner>/<repo>

on:
  schedule:
    # Run every hour
    - cron: '0 * * * *'
  
jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      # Checkout this repo
      - uses: actions/checkout@v2
      # Fetch the history and unshallow the checked out repo so that it can be used
      - name: Fetch all history for all tags and branches
        run: git fetch --prune --unshallow
      # Pull the detached remote and do the magic
      - name: Pull Detached Remote
        uses: litetex/pull-detached-remote@vdev
        with:
          upstreamrepo: https://github.com/<owner>/<repo>
          upstreambranch: an-update
        env:
          # NOTE: This is a Personal Access Token, ${{ secrets.GITHUB_TOKEN }} has not enough permissions :(
          GITHUB_TOKEN: ${{ secrets.GH_PAT }}
```

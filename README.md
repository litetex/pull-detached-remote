# <img width="26" height="26" src="logo.png" /> pull-detached-remote
[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-pull--detached--remote-blue.svg?colorA=1b1e21&colorB=0265de&style=flat&longCache=true&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAM6wAADOsB5dZE0gAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAERSURBVCiRhZG/SsMxFEZPfsVJ61jbxaF0cRQRcRJ9hlYn30IHN/+9iquDCOIsblIrOjqKgy5aKoJQj4O3EEtbPwhJbr6Te28CmdSKeqzeqr0YbfVIrTBKakvtOl5dtTkK+v4HfA9PEyBFCY9AGVgCBLaBp1jPAyfAJ/AAdIEG0dNAiyP7+K1qIfMdonZic6+WJoBJvQlvuwDqcXadUuqPA1NKAlexbRTAIMvMOCjTbMwl1LtI/6KWJ5Q6rT6Ht1MA58AX8Apcqqt5r2qhrgAXQC3CZ6i1+KMd9TRu3MvA3aH/fFPnBodb6oe6HM8+lYHrGdRXW8M9bMZtPXUji69lmf5Cmamq7quNLFZXD9Rq7v0Bpc1o/tp0fisAAAAASUVORK5CYII=)](https://github.com/marketplace/actions/pull-detached-remote)

Creates a branch with updates from a detached (not actively set) upstream of a repo and a corresponding PullRequest

If you don't understand the quick summary read the following:

## Why?
This action was mainly created for the following use-case:

You have a GitHub repo that is not directly linked via an [upstream-remote](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/configuring-a-remote-for-a-fork)
This can be achieved by
* [duplicating](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/duplicating-a-repository) a repo or
* [forking](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/about-forks) a repo and [removing it's upstream remote](https://stackoverflow.com/questions/29326767/unfork-a-github-fork-without-deleting/41486339)

Now you wan't to update this repo from it's "upstream" (which is not actively set / detached). <br/>
You [can do that manually](https://gist.github.com/CristinaSolana/1885435), but after some time (especially when there are more often commits on the "upstream"), you definetly wan't to do that automated.

An here this action comes into spotlight.

It automatically updates your "detached upstream":<br/>
Firstly it checks if there are new commits on the upstream.<br/>
When there are new ones, it creates a new branch and a pull request.
<br/>
<br/>
The action is based on [PullDetachedRemote](https://github.com/litetex/PullDetachedRemote)

## Usage
A simple worfklow example:
```YAML
name: Pull detached upstream automatically from https://github.com/<owner>/<repo>

on:
  # Possibility to run it manually
  workflow_dispatch:
  # Automated
  schedule:
    # Run this every day at 02:22 UTC
    - cron: '22 2 * * *'
  
  
jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      # Checkout the current repo
      - uses: actions/checkout@v2
      # Fetch the history and unshallow the repo so that it can be used
      - name: Fetch all history for all tags and branches
        run: git fetch --prune --unshallow
      # Pull the detached remote and do the magic
      - name: Pull Detached Remote
        uses: litetex/pull-detached-remote@<VERSIONTAG>
        with:
          upstreamrepo: https://github.com/<owner>/<repo>
          upstreambranch: <branchname>
        env:
          GITHUB_PAT: ${{ secrets.GH_PAT }}
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Inputs
→ see also [Configuration.cs](https://github.com/litetex/PullDetachedRemote/blob/develop/PullDetachedRemote/Config/Configuration.cs)
### Parameters
→ see [action.yml](action.yml)
### Environment-Variables
<table>
  <tr>
    <th>Variable</th>
    <th>State</th>
    <th>Description</th>
    <th>Notes</th>
  </tr>
  
  <tr>
    <td>GITHUB_PAT</td>
    <td>Required</td>
    <td>
      A personal access token, that is used for git modifications of the targeted repo
    </td>
    <td>
      This is the fallback if no GITHUB_TOKEN is set<br/>
      <br/>
      Add it to the <a href="https://help.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets#creating-encrypted-secrets-for-a-repository">secrets</a><br/>
      <br/>
      <a href="https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line">GitHub Documentation</a>
    </td>
  </tr>
  
  <tr>
    <td>GITHUB_TOKEN</td>
    <td>Recommended</td>
    <td>
      A token automatically created by GitHub for workflows on the current repo
    </td>
    <td>
      If not set, the owner of the GITHUB_PAT will be the author of the pull request<br/>
      <br/>
      <a href="https://help.github.com/en/actions/configuring-and-managing-workflows/authenticating-with-the-github_token#about-the-github_token-secret">GitHub Documentation</a>
    </td>
  </tr>
  
  <tr>
    <td>DETACHED_CREDS_PRINCIPAL</td>
    <td>Optional</td>
    <td>
      Principal/Username (if you have a token, use it here and leave password blank)
    </td>
    <td rowspan=2>
      Only required if a repository outside of GitHub has to be authenticated<br/>
      <br/>
      Only used if:<br/>
      <ul>
        <li>upstreamcredmode=AUTO (default)<br/>the upstream-repo is not hosted on GitHub and DETACHED_CREDS_PRINCIPAL is set
        </li>
        <li>upstreamcredmode=CUSTOM</li>
      </ul>
    </td>
  </tr>

  <tr>
    <td>DETACHED_CREDS_PW</td>
    <td>Optional</td>
    <td>
      Password
    </td>
  </tr>
  
  <tr><td colspan=4></td></tr>
  
  <tr>
    <td>NO_PR_STATUS</td>
    <td>Optional</td>
    <td>Disables the status message in the pull request</td>
    <td>Valid values: <code>1</code> or <code>true</code></td>
  </tr>
  
  <tr>
    <td>NO_CREDITS</td>
    <td>Optional</td>
    <td>Disables the credits in the pull request</td>
    <td>Valid values: <code>1</code> or <code>true</code></td>
  </tr>
</table>

## Demos
Here you can find a demo implementations:
* [avesflower](https://github.com/BaseMC/avesflower/blob/develop/.github/workflows/upstream_update.yml)

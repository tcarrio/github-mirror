# GitHub Mirror

This is an example repository of how you can integrate git mirroring into the SourceHut build pipelines. Git is essentially built with this functionality, you simply need write access to the target repository. Here we will use an SSH token to push the latest master branch to a GitHub repository.

This solution is meant to tie in easily with the build tools provided by SourceHut, but another means of doing this could be an OAuth app you have given write access to your repositories. The build tooling itself may be useful for propogating the initial event to a third-party server with the access to push code to your repository. That flow is not covered here, but if I care to do an example app for that functionality in the future, I'll make a point to update this repo with a reference to it.

**Note:** this will work for any Git project, it isn't specific to GitHub, I'm just doing a demo of it using GitHub as the target.

## Getting Started

1. Generate an SSH token and add it to your GitHub account
2. Generate a file secret on https://builds.sr.ht/secrets to load at `~/git_ssh_token`
3. Update your `.builds.yml` pipeline with the following:
  - Include the secret reference under the `secrets`
  - Include this repository under the `sources`
  - Include the `build` stage of the example pipeline in your pipeline
  - Include the target repository as the environment variable `GIT_TARGET_URL`

## What's happening

Repositories listed under `sources` are cloned to the current working directory, so you will have directories per repo that you can reference using `./repo-name`. This repository includes a simple shell script that will use your SSH token at `~/git_ssh_token` to push your current branch to the target git repository's branch. Simple stuff.

**Warning:** This forces the push, taking into consideration that the target should be a downstream mirror, it will overwrite the state there should it have a diverged git history from your SourceHut repo.
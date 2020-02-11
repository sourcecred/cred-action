# SourceCred Cred Action

**under development**

This repository provides a GitHub action for generating a "cred instance"
for your repository.  This means that you can add a `.github/workflow/generate-cred.yml`
to your repository, and the static files will be generated into "docs"
(which you can deploy on GitHub pages) and you can add other customizations
(weights, projects file, etc.) via the GitHub actions variables.

Importantly, this is designed to expose a GitHub actions interface that can
remain consistent even if/when the underlying structure of the code changes (which
seems likely). See the [examples](examples) are provided here to get you started,
or continue reading for a basic example.

## Usage

This is under development, and currently hosted at vsoch (future will be at
sourcecred organization).

```
uses: vsoch/cred-action@master
with:
  weights: weights.json
  project: '@sourcecred'
  project-file: projects/combined.json
  branch-against: master
```

In the above, automated set to false will open a pull request against master (branch-against).
You can also set automated to true to push directly to a branch:

```
uses: vsoch/cred-action@master
with:
  weights: weights.json
  project: '@sourcecred'
  project-file: projects/combined.json
  automated: true
  branch-against: master
```

The project id is given to the scores function, and should correspond with any project
ids referenced in the weights or projects configuration files.

## Development

### Design

I've chosen to use [GitHub Actions](https://help.github.com/en/actions) to provide an easy
way for a SourceCred community to define a workflow in `.github/workflows` that uses the
action to generate a SourceCred interface. Since there are many issues with installing
dependencies, the strategy I chose is to use a pre-built container. By referencing 
[sourcecred/sourcecred:dev](https://hub.docker.com/r/sourcecred/sourcecred/tags) 
we can be relatively sure that the build is using the latest on master.
As SourceCred moves toward more official releases, releases of the action can
follow suit. 

I chose to start by taking the simplest approach possible - instead of creating
another set of logic to do the build, we use the already existing [build_static_site.sh](https://github.com/sourcecred/sourcecred/blob/master/scripts/build_static_site.sh). While this was considered "hacky" I like the idea of
having a consistent build script packaged with the container, or at least
some eventual "bin" or equivalent folder that can be used inside the container
without a hitch.

The repository that the action is running for is bound at [/github/workspace](https://help.github.com/en/actions/reference/virtual-environments-for-github-hosted-runners#docker-container-filesystem), so we can create a simple entrypoint
that references content there, and the user can assume that paths to files provided are relative.

### Idea for Development

The sourcecred repository has an official [docker-entrypoint.sh](https://github.com/sourcecred/sourcecred/blob/master/scripts/docker-entrypoint.sh)
that can handle running yarn commands (to build, dev, or otherwise interact with sourcecred.js). What
would make sense is to modify the [build_static_site.sh](https://github.com/sourcecred/sourcecred/blob/master/scripts/build_static_site.sh)
script to (instead of calling yarn directly) to use this same entrypoint. If 
the entrypoint can be updated so that sourcecred has it's own client that can
be used for both, this is even better.

### Local Testing

If you want to interactively test the action, first build the Docker container:

```bash
$ docker build -t cred-action .
```

Then interactively shell inside. We will clone a repository with a project file
to what would be the github workspace at `/github/workspace`

```bash
$ docker run -it --entrypoint /bin/bash cred-action
$ mkdir -p /github/workspace
$ git clone https://github.com/sourcecred/cred /github/workspace
```

Note that this folder is automatically bound to the host runner on GitHub actions,
meaning that the repository where the action is deployed is bound there.
We can now mimic the entrypoint, which is `/bin/bash entrypoint.sh`.
First we will change so that the GitHub repository that we cloned (that would
be bound as a volume) is in the present working directory:

```bash
cd /github/workspace
# ls
README.md		  docs	    scores.json     update.sh
distributionHistory.json  projects  transfers.json  weights.json
```

Now we will set environment variables that would have come from
the action - we ask the user to set relative paths for weights,
a project file, or other assets. If we don't specify a target, it's set
to be docs/ in the present working directory (created if it doesn't exist).

```bash
export SC_PROJECT=projects/combined.json
export SC_WEIGHTS=weights.json
```


### Icon

The style of the icon is selected from the [Feathers](https://feathericons.com/) set.
This icon (and color) appears in the GitHub marketplace where the action can be found.
The style and color are set in the [action.yml](action.yml) as follows:

```

```

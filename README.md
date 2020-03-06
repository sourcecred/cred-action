# SourceCred Cred Action

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
sourcecred organization). The suggested best practice is to use a project file,
which should define the users, plugins, and plugin details (e.g., repositories) 
to run sourcecred on. This is the `project-file` variable. 
Within the file, you'll also have defined a project id, something like this:

```json
    "id": "@sourcecred",
```

And this is the `project` id. Both are shown below in entirety, and required
for the action to run.

```yaml
uses: vsoch/cred-action@master
with:
  weights: weights.json
  project: '@sourcecred'
  project-file: projects/combined.json
  branch-against: master
```

In the above, automated set to false will open a pull request against master (branch-against).
You can also set automated to true to push directly to a branch:

```yaml
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

I chose to start by taking the simplest approach possible - I modified the 
[build_static_site.sh](https://github.com/sourcecred/sourcecred/blob/master/scripts/build_static_site.sh)
to be optimized for a container (we don't need to worry so much about temporary files or cleaning up)
and integrated these scripts into a GitHub action. The action is defined by the [action.yml](action.yml)
file (meaning it could be shared on the GitHub marketplace) and the user simply needs to
reference it in a workflow (see [examples](examples)) to use it.

The repository that the action is running for is bound at [/github/workspace](https://help.github.com/en/actions/reference/virtual-environments-for-github-hosted-runners#docker-container-filesystem), so we can create a simple entrypoint
that references content there, and the user can assume that paths to files provided are relative.

### Icon

The style of the icon is selected from the [Feathers](https://feathericons.com/) set.
This icon (and color) appears in the GitHub marketplace where the action can be found.
The style and color are set in the [action.yml](action.yml) as follows:

```yaml
branding:
  icon: 'sliders'
  color: 'blue'
```

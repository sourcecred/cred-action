#!/bin/bash
set -eu
set -o pipefail
out=${1:-/dev/stdout}

printf "# Secrets
GITHUB_TOKEN=${GITHUB_TOKEN:+***}
SOURCECRED_GITHUB_TOKEN=${GITHUB_TOKEN:+***}
SOURCECRED_DISCORD_TOKEN=${SOURCECRED_DISCORD_TOKEN:+***}

# GitHub default parameters
GITHUB_ACTOR=${GITHUB_ACTOR:-Should not be empty!}
GITHUB_REPOSITORY=${GITHUB_REPOSITORY:-Should not be empty!}

# Action input parameters
INPUT_TARGET=docs
INPUT_WEIGHTS=.github/weights.json
INPUT_PROJECT=@sourcecred
INPUT_PROJECT_FILE=.github/github.json
INPUT_SCORES_JSON=scores.json
INPUT_AUTOMATED=true
INPUT_BRANCH_AGAINST=master
INPUT_TEST_RUN=true

# SourceCred known parameters
SOURCECRED_DIRECTORY=/data
SOURCECRED_INITIATIVES_DIRECTORY=

# Action output parameters
UPDATE_BRANCH=
" > $out

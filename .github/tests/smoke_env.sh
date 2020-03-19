#!/bin/bash
# Shows important env vars in a predictable order.
set -eu
set -o pipefail
out=${1:-/dev/stdout}

function show {
	for var in "$@"; do
		printf "${var}=${!var:-}\n"
	done
}

function show_secret {
	for var in "$@"; do
		printf "${var}=${!var:+***}\n"
	done
}

# Start with a clean file.
printf "" > $out

printf "# Secrets\n" >> $out
show_secret \
	GITHUB_TOKEN \
	SOURCECRED_GITHUB_TOKEN \
	SOURCECRED_DISCORD_TOKEN \
	>> $out

printf "\n# GitHub default parameters\n" >> $out
show \
	GITHUB_ACTOR \
	GITHUB_REPOSITORY \
	>> $out

printf "\n# Action input parameters\n" >> $out
show \
	INPUT_TARGET \
	INPUT_WEIGHTS \
	INPUT_PROJECT \
	INPUT_PROJECT_FILE \
	INPUT_SCORES_JSON \
	INPUT_AUTOMATED \
	INPUT_BRANCH_AGAINST \
	INPUT_TEST_RUN \
	>> $out

printf "\n# SourceCred known parameters\n" >> $out
show \
	SOURCECRED_DIRECTORY \
	SOURCECRED_INITIATIVES_DIRECTORY \
	>> $out

printf "\n# Action output parameters\n" >> $out
show \
	UPDATE_BRANCH \
	>> $out

FROM sourcecred/sourcecred:dev
# docker build -t cred-action .
# jq should be added to base container so we don't need to install here
RUN apt-get update && apt-get install -y jq
COPY ./scripts/entrypoint.sh /entrypoint.sh
COPY ./scripts/pull_request.sh /pull_request.sh
COPY ./scripts/build_static_site.sh /build_static_site.sh
ENTRYPOINT ["/bin/bash"]
CMD ["/entrypoint.sh"]

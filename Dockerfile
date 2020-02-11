FROM sourcecred/sourcecred:dev
# docker build -t cred-action .
COPY ./scripts/entrypoint.sh /entrypoint.sh
COPY ./scripts/pull_request.sh /pull_request.sh
COPY ./scripts/automated.sh /automated.sh
ENTRYPOINT ["/bin/bash"]
CMD ["/entrypoint.sh"]

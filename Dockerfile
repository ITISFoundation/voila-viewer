FROM itisfoundation/jupyter-math:2.0.9 as main
LABEL maintainer="iavarone"
USER root

COPY --chown=$NB_UID:$NB_GID requirements.txt ${NOTEBOOK_BASE_DIR}/requirements.txt
RUN .venv/bin/pip --no-cache install pip-tools && \
  .venv/bin/pip --no-cache install -r ${NOTEBOOK_BASE_DIR}/requirements.txt

# Copying boot scripts
COPY --chown=$NB_UID:$NB_GID docker /docker

# Copying source code
COPY --chown=$NB_UID:$NB_GID src /src

EXPOSE 8888

ENTRYPOINT [ "/bin/bash", "/docker/entrypoint.bash" ]
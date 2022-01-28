# Container image that runs your code
FROM wolframresearch/wolframengine:13.0.0

COPY ["src", "/src/"]

USER root
RUN chmod +x /src/main.sh
USER wolframengine

ENTRYPOINT ["/src/main.sh"]
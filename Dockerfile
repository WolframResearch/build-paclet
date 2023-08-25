# Container image that runs your code
FROM wolframresearch/wolframengine:latest

COPY ["src", "/src/"]

USER root
RUN chmod +x /src/main.sh

ENTRYPOINT ["/src/main.sh"]
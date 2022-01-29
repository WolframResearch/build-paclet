# Container image that runs your code
FROM wolframresearch/wolframengine:13.0.0
COPY ["src", "/github/src/"]
RUN chmod +x /github/src/main.sh
ENTRYPOINT ["/github/src/main.sh"]
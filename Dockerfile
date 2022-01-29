# Container image that runs your code
FROM wolframresearch/wolframengine:13.0.0
COPY ["src", "/src/"]
RUN chmod +x /src/main.sh
ENTRYPOINT ["/src/main.sh"]
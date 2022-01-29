# Container image that runs your code
FROM wolframresearch/wolframengine:13.0.0
COPY ["src", "/src/"]
ENTRYPOINT ["bash /src/main.sh"]
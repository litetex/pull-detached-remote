FROM mcr.microsoft.com/dotnet/core/runtime:3.1

RUN wget "https://litetex/PullDetachedRemote/releases/download/0.0.1/PullDetachedRemote"

ENTRYPOINT ["PullDetachedRemote"]

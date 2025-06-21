FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    ca-certificates \
    libicu66 \
    libssl1.1 \
    && rm -rf /var/lib/apt/lists/*

# Install .NET using the official method instead of snap
RUN wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh \
    && chmod +x dotnet-install.sh \
    && ./dotnet-install.sh --channel 5.0 \
    && rm dotnet-install.sh

ENV PATH="/root/.dotnet:${PATH}"
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1

WORKDIR /app

RUN wget https://github.com/LunaMultiplayer/LunaMultiplayer/releases/download/0.29.0/LunaMultiplayer-Server-Release.zip \
    && unzip LunaMultiplayer-Server-Release.zip \
    && rm LunaMultiplayer-Server-Release.zip

CMD ["dotnet", "./LMPServer/Server.dll"]
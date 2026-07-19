FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# タグ0.29.2でなく保守ブランチRelease/0_29_2を使う:
# 公式リリースバイナリ相当の受信スレッド保護(d17cbc5)等のサーバ側hardeningを含み、
# バージョン文字列は0.29.2のままクライアントと互換。
RUN git clone --depth 1 --branch Release/0_29_2 https://github.com/LunaMultiplayer/LunaMultiplayer.git /src

WORKDIR /src

# 0.29.2のサーバ→クライアントvessel送信は NumBytes に「文字数」を入れており、
# 日本語（マルチバイト）を含む機体はUTF-8バイト数との差分だけ末尾が切り詰められて届く。
# 切断位置が悪い機体はクライアントで FormatException となり永遠に読み込めない。
# NumBytes をバイト数に直す1行修正（他の送信経路は元からData.Lengthで正しい）。
RUN sed -i 's/protoMsg\.NumBytes = vesselData\.Length;/protoMsg.NumBytes = protoMsg.Data.Length;/' Server/Message/VesselMsgReader.cs \
    && grep -q 'protoMsg.NumBytes = protoMsg.Data.Length;' Server/Message/VesselMsgReader.cs

RUN dotnet publish Server/Server.csproj -c Release -o /app/LMPServer

FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    wget \
    ca-certificates \
    libicu66 \
    libssl1.1 \
    && rm -rf /var/lib/apt/lists/*

# Install .NET using the official method instead of snap
RUN wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh \
    && chmod +x dotnet-install.sh \
    && ./dotnet-install.sh --channel 6.0 --runtime dotnet \
    && rm dotnet-install.sh

ENV PATH="/root/.dotnet:${PATH}"
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1

WORKDIR /app

COPY --from=build /app/LMPServer ./LMPServer

CMD ["dotnet", "./LMPServer/Server.dll"]

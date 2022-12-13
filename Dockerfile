FROM mcr.microsoft.com/dotnet/sdk:7.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["Personal/Personal.csproj", "Personal/"]
RUN dotnet restore "Personal/Personal.csproj" -f
COPY . .
WORKDIR "/src/Personal"
RUN dotnet build "Personal.csproj" -c Debug -o /app/build -f

FROM build as publish
RUN dotnet publish "Personal.csproj" -c Debug -o /app/publish -f

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
COPY --from=publish "Personal.csproj" .

ENTRYPOINT [ "dotnet", "Personal.dll" ]

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["Personal/Personal.csproj", "Personal/"]
RUN dotnet restore "Personal/Personal.csproj"
COPY . .
WORKDIR "/src/Personal"
RUN dotnet build "Personal.csproj" -c Release -o /app/build

FROM build as publish
RUN dotnet publish "Personal.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

ENTRYPOINT [ "dotnet", "Personal.dll" ]

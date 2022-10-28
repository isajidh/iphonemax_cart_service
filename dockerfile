FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app

ENV ASPNETCORE_URLS=http://+:5005

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-dotnet-configure-containers
# RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
# USER appuser
USER root

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["Ecom.Cart.Service.csproj", "./"]
RUN dotnet restore "Ecom.Cart.Service.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "Ecom.Cart.Service.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Ecom.Cart.Service.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
#Disabled to test in the app in the producttion environment
# ENTRYPOINT ["dotnet", "Ecom.Cart.Service.dll"]
EXPOSE 5005
EXPOSE 5004

LABEL org.opencontainers.image.source="https://github.com/isajidh/iphonemax_cart_service"
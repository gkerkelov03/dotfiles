podman run -d \
  --name mssql \
  -e "ACCEPT_EULA=Y" \
  -e "MSSQL_SA_PASSWORD=P@ssw0rd123" \
  -p 1433:1433 \
  mcr.microsoft.com/mssql/server:2022-latest

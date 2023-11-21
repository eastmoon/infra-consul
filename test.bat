@echo off
setlocal
setlocal enabledelayedexpansion

@rem list consul cluster
docker exec consul-center_infra-consul consul members

@rem call api
echo ^> Call services catalog
curl http://localhost:8500/v1/catalog/services
echo.
echo ^> Call services catalog
curl http://localhost:8500/v1/catalog/nodes
echo.

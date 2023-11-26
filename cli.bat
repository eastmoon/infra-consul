@rem
@rem Copyright 2020 the original author jacky.eastmoon
@rem All commad module need 3 method :
@rem [command]        : Command script
@rem [command]-args   : Command script options setting function
@rem [command]-help   : Command description
@rem Basically, CLI will not use "--options" to execute function, "--help, -h" is an exception.
@rem But, if need exception, it will need to thinking is common or individual, and need to change BREADCRUMB variable in [command]-args function.
@rem NOTE, batch call [command]-args it could call correct one or call [command] and "-args" is parameter.
@rem

@rem ------------------- batch setting -------------------
@rem setting batch file
@rem ref : https://www.tutorialspoint.com/batch_script/batch_script_if_else_statement.htm
@rem ref : https://poychang.github.io/note-batch/

@echo off
setlocal
setlocal enabledelayedexpansion

@rem ------------------- declare CLI file variable -------------------
@rem retrieve project name
@rem Ref : https://www.robvanderwoude.com/ntfor.php
@rem Directory = %~dp0
@rem Object Name With Quotations=%0
@rem Object Name Without Quotes=%~0
@rem Bat File Drive = %~d0
@rem Full File Name = %~n0%~x0
@rem File Name Without Extension = %~n0
@rem File Extension = %~x0

set CLI_DIRECTORY=%~dp0
set CLI_FILE=%~n0%~x0
set CLI_FILENAME=%~n0
set CLI_FILEEXTENSION=%~x0

@rem ------------------- declare CLI variable -------------------

set BREADCRUMB=cli
set COMMAND=
set COMMAND_BC_AGRS=
set COMMAND_AC_AGRS=

@rem ------------------- declare variable -------------------

for %%a in ("%cd%") do (
    set PROJECT_NAME=%%~na
)
set PROJECT_ENV=dev
set CONF_FILE_PATH=%CLI_DIRECTORY%\conf\docker\.env

@rem ------------------- execute script -------------------

call :main %*
goto end

@rem ------------------- declare function -------------------

:main
    set COMMAND=
    set COMMAND_BC_AGRS=
    set COMMAND_AC_AGRS=
    call :argv-parser %*
    call :main-args-parser %COMMAND_BC_AGRS%
    IF defined COMMAND (
        set BREADCRUMB=%BREADCRUMB%-%COMMAND%
        findstr /bi /c:":!BREADCRUMB!" %CLI_FILE% >nul 2>&1
        IF errorlevel 1 (
            goto cli-help
        ) else (
            call :main %COMMAND_AC_AGRS%
        )
    ) else (
        call :%BREADCRUMB%
    )
    goto end

:main-args-parser
    for /f "tokens=1*" %%p in ("%*") do (
        for /f "tokens=1,2 delims==" %%i in ("%%p") do (
            call :%BREADCRUMB%-args %%i %%j
            call :common-args %%i %%j
        )
        call :main-args-parser %%q
    )
    goto end

:common-args
    set COMMON_ARGS_KEY=%1
    set COMMON_ARGS_VALUE=%2
    if "%COMMON_ARGS_KEY%"=="-h" (set BREADCRUMB=%BREADCRUMB%-help)
    if "%COMMON_ARGS_KEY%"=="--help" (set BREADCRUMB=%BREADCRUMB%-help)
    goto end

:argv-parser
    for /f "tokens=1*" %%p in ("%*") do (
        IF NOT defined COMMAND (
            echo %%p | findstr /r "\-" >nul 2>&1
            if errorlevel 1 (
                set COMMAND=%%p
            ) else (
                set COMMAND_BC_AGRS=!COMMAND_BC_AGRS! %%p
            )
        ) else (
            set COMMAND_AC_AGRS=!COMMAND_AC_AGRS! %%p
        )
        call :argv-parser %%q
    )
    goto end

@rem ------------------- Main method -------------------

:cli
    goto cli-help

:cli-args
    set COMMON_ARGS_KEY=%1
    set COMMON_ARGS_VALUE=%2
    if "%COMMON_ARGS_KEY%"=="--prod" (set PROJECT_ENV=prod)
    goto end

:cli-help
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo If not input any command, at default will show HELP
    echo.
    echo Options:
    echo      --help, -h        Show more information with CLI.
    echo      --prod            Setting project environment with "prod", default is "dev"
    echo.
    echo Command:
    echo      up                Startup Server.
    echo      down              Close down Server.
    echo      into              Into docker container by docker exec.
    echo      logs              Show docker container logs.
    echo      dev               Startup single container.
    echo      secure            Generate secure inforamtion in cache.
    echo.
    echo Run 'cli [COMMAND] --help' for more information on a command.
    goto end

@rem ------------------- Common Command method -------------------

:cli-up-docker-prepare
    echo ^> Build docker compose environment file
    @rem Create .env for compose
    echo Current Environment %PROJECT_ENV%
    echo PROJECT_NAME=%PROJECT_NAME% > %CONF_FILE_PATH%

    @rem Setting ocelot project and cache directory
    set TARGET_DIR=%CLI_DIRECTORY%\cache
    IF NOT EXIST %TARGET_DIR% (
        mkdir %TARGET_DIR%
    )
    echo CACHE_DIR=%TARGET_DIR% >> %CONF_FILE_PATH%

    set TARGET_DIR=%CLI_DIRECTORY%\app
    echo APP_DIR=%TARGET_DIR% >> %CONF_FILE_PATH%

    set TARGET_DIR=%CLI_DIRECTORY%\src
    echo SRC_DIR=%TARGET_DIR% >> %CONF_FILE_PATH%
    goto end

@rem ------------------- Command "up" method -------------------

:cli-up
    echo ^> Startup and into container for develop html
    @rem setting container infomation
    call :cli-up-docker-prepare

    @rem execute container
    echo ^> Startup docker container instance
    docker-compose -f .\conf\docker\docker-compose.yml --env-file %CONF_FILE_PATH% up -d

    goto end

:cli-up-args
    goto end

:cli-up-help
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo Startup Server
    echo.
    echo Options:
    echo      --help, -h        Show more information with UP Command.
    goto end

@rem ------------------- Command "down" method -------------------

:cli-down
    echo ^> Server close down
    @rem execute container
    echo ^> Startup docker container instance
    docker-compose -f .\conf\docker\docker-compose.yml --env-file %CONF_FILE_PATH% down
    goto end

:cli-down-args
    goto end

:cli-down-help
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo Close down Server
    echo.
    echo Options:
    echo      --help, -h        Show more information with UP Command.
    goto end

@rem ------------------- Command "into" method -------------------

:cli-into
    @rem Into docker container by docker exec
    if defined INTO_CONTAINER (
        docker exec -ti -w /consul consul-%INTO_CONTAINER%_%PROJECT_NAME% sh
    ) else (
        echo choose target container with options.
    )
    goto end

:cli-into-args
    set COMMON_ARGS_KEY=%1
    set COMMON_ARGS_VALUE=%2
    set INTO_CONTAINER=%COMMON_ARGS_KEY:--=%
    goto end

:cli-into-help
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo Into docker container by docker exec.
    echo.
    echo Options:
    echo      --help, -h        Show more information with UP Command.
    goto end

@rem ------------------- Command "logs" method -------------------

:cli-logs
    @rem Into docker container by docker exec
    if defined INTO_CONTAINER (
        docker logs -f consul-%INTO_CONTAINER%_%PROJECT_NAME%
    ) else (
        echo choose target container with options.
    )
    goto end

:cli-logs-args
    set COMMON_ARGS_KEY=%1
    set COMMON_ARGS_VALUE=%2
    set INTO_CONTAINER=%COMMON_ARGS_KEY:--=%
    goto end

:cli-logs-help
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo Show docker container logs.
    echo.
    echo Options:
    echo      --help, -h        Show more information with UP Command.
    goto end

@rem ------------------- Command "secure" method -------------------

:cli-secure
    docker rm -f secure-consul-%PROJECT_NAME%
    docker run -ti --rm ^
        -v %CLI_DIRECTORY%\src\secure:/app ^
        -v %CLI_DIRECTORY%\cache:/app/cache ^
        -w /app ^
        --user consul ^
        --name secure-consul-%PROJECT_NAME% ^
        hashicorp/consul sh gen.sh
    goto end

:cli-secure-args
    goto end

:cli-secure-help
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo Generate secure inforamtion in cache
    echo.
    echo Options:
    echo      --help, -h        Show more information with UP Command.
    goto end

@rem ------------------- Command "dev" method -------------------

:cli-dev
    echo ^> Startup and into container for develop css
    @rem create cache
    IF NOT EXIST cache (
        mkdir cache
    )

    @rem execute container
    docker rm -f dev-consul-%PROJECT_NAME%
    docker run -d --rm ^
        -e CONSUL_BIND_INTERFACE=eth0 ^
        -p 8500:8500 ^
        -p 8600:8600 ^
        --name dev-consul-%PROJECT_NAME% ^
        hashicorp/consul

    goto end

:cli-dev-args
    goto end

:cli-dev-help
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo Startup single container
    echo.
    echo Options:
    echo      --help, -h        Show more information with UP Command.
    goto end

@rem ------------------- End method-------------------

:end
    endlocal

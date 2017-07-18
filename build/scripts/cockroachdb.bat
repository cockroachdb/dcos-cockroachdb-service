@if "%DEBUG%" == "" @echo off
@rem ##########################################################################
@rem
@rem  cockroachdb startup script for Windows
@rem
@rem ##########################################################################

@rem Set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" setlocal

set DIRNAME=%~dp0
if "%DIRNAME%" == "" set DIRNAME=.
set APP_BASE_NAME=%~n0
set APP_HOME=%DIRNAME%..

@rem Add default JVM options here. You can also use JAVA_OPTS and COCKROACHDB_OPTS to pass JVM options to this script.
set DEFAULT_JVM_OPTS=

@rem Find java.exe
if defined JAVA_HOME goto findJavaFromJavaHome

set JAVA_EXE=java.exe
%JAVA_EXE% -version >NUL 2>&1
if "%ERRORLEVEL%" == "0" goto init

echo.
echo ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.
echo.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.

goto fail

:findJavaFromJavaHome
set JAVA_HOME=%JAVA_HOME:"=%
set JAVA_EXE=%JAVA_HOME%/bin/java.exe

if exist "%JAVA_EXE%" goto init

echo.
echo ERROR: JAVA_HOME is set to an invalid directory: %JAVA_HOME%
echo.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.

goto fail

:init
@rem Get command-line arguments, handling Windows variants

if not "%OS%" == "Windows_NT" goto win9xME_args

:win9xME_args
@rem Slurp the command line arguments.
set CMD_LINE_ARGS=
set _SKIP=2

:win9xME_args_slurp
if "x%~1" == "x" goto execute

set CMD_LINE_ARGS=%*

:execute
@rem Setup the command line

set CLASSPATH=%APP_HOME%\lib\cockroachdb.jar;%APP_HOME%\lib\mesos-1.3.0-reservation-refinement.jar;%APP_HOME%\lib\scheduler-0.20.0-SNAPSHOT.jar;%APP_HOME%\lib\executor-0.20.0-SNAPSHOT.jar;%APP_HOME%\lib\common-0.20.0-SNAPSHOT.jar;%APP_HOME%\lib\jackson-datatype-guava-2.6.3.jar;%APP_HOME%\lib\jackson-datatype-jdk8-2.6.3.jar;%APP_HOME%\lib\jackson-datatype-jsr310-2.6.3.jar;%APP_HOME%\lib\jackson-dataformat-yaml-2.6.3.jar;%APP_HOME%\lib\jackson-databind-2.6.3.jar;%APP_HOME%\lib\jackson-datatype-protobuf-0.9.3.jar;%APP_HOME%\lib\annotations-3.0.1u2.jar;%APP_HOME%\lib\commons-collections-3.2.2.jar;%APP_HOME%\lib\commons-io-2.4.jar;%APP_HOME%\lib\antlr4-runtime-4.5.1-1.jar;%APP_HOME%\lib\javax.ws.rs-api-2.0.1.jar;%APP_HOME%\lib\curator-framework-2.9.1.jar;%APP_HOME%\lib\curator-recipes-2.9.1.jar;%APP_HOME%\lib\curator-test-2.9.1.jar;%APP_HOME%\lib\httpclient-4.5.2.jar;%APP_HOME%\lib\fluent-hc-4.5.2.jar;%APP_HOME%\lib\commons-lang3-3.4.jar;%APP_HOME%\lib\protobuf-java-format-1.4.jar;%APP_HOME%\lib\json-20160212.jar;%APP_HOME%\lib\guice-3.0.jar;%APP_HOME%\lib\guice-assistedinject-3.0.jar;%APP_HOME%\lib\diffutils-1.3.0.jar;%APP_HOME%\lib\jersey-container-jetty-http-2.23.2.jar;%APP_HOME%\lib\jersey-media-json-jackson-2.23.2.jar;%APP_HOME%\lib\jetty-servlet-9.2.3.v20140905.jar;%APP_HOME%\lib\compiler-0.9.2.jar;%APP_HOME%\lib\hibernate-validator-5.3.2.Final.jar;%APP_HOME%\lib\javax.el-api-2.2.4.jar;%APP_HOME%\lib\javax.el-2.2.4.jar;%APP_HOME%\lib\mesos-http-adapter-0.4.1.jar;%APP_HOME%\lib\slf4j-api-1.7.25.jar;%APP_HOME%\lib\log4j-core-2.8.1.jar;%APP_HOME%\lib\log4j-slf4j-impl-2.8.1.jar;%APP_HOME%\lib\commons-codec-1.10.jar;%APP_HOME%\lib\jackson-core-2.6.3.jar;%APP_HOME%\lib\snakeyaml-1.15.jar;%APP_HOME%\lib\jackson-annotations-2.6.0.jar;%APP_HOME%\lib\curator-client-2.9.1.jar;%APP_HOME%\lib\zookeeper-3.4.6.jar;%APP_HOME%\lib\commons-math-2.2.jar;%APP_HOME%\lib\httpcore-4.4.4.jar;%APP_HOME%\lib\commons-logging-1.2.jar;%APP_HOME%\lib\javax.inject-1.jar;%APP_HOME%\lib\aopalliance-1.0.jar;%APP_HOME%\lib\cglib-2.2.1-v20090111.jar;%APP_HOME%\lib\javax.inject-2.5.0-b05.jar;%APP_HOME%\lib\jetty-server-9.2.14.v20151106.jar;%APP_HOME%\lib\jetty-util-9.2.14.v20151106.jar;%APP_HOME%\lib\jetty-continuation-9.2.14.v20151106.jar;%APP_HOME%\lib\jersey-common-2.23.2.jar;%APP_HOME%\lib\jersey-server-2.23.2.jar;%APP_HOME%\lib\jersey-entity-filtering-2.23.2.jar;%APP_HOME%\lib\jackson-jaxrs-base-2.5.4.jar;%APP_HOME%\lib\jackson-jaxrs-json-provider-2.5.4.jar;%APP_HOME%\lib\jetty-security-9.2.3.v20140905.jar;%APP_HOME%\lib\validation-api-1.1.0.Final.jar;%APP_HOME%\lib\jboss-logging-3.3.0.Final.jar;%APP_HOME%\lib\classmate-1.3.1.jar;%APP_HOME%\lib\edu-umd-cs-findbugs-annotations-1.3.2-201002241900.nbm;%APP_HOME%\lib\log4j-over-slf4j-1.7.10.jar;%APP_HOME%\lib\jcl-over-slf4j-1.7.10.jar;%APP_HOME%\lib\google-http-client-1.20.0.jar;%APP_HOME%\lib\log4j-api-2.8.1.jar;%APP_HOME%\lib\log4j-1.2.16.jar;%APP_HOME%\lib\jline-0.9.94.jar;%APP_HOME%\lib\netty-3.7.0.Final.jar;%APP_HOME%\lib\asm-3.1.jar;%APP_HOME%\lib\javax.servlet-api-3.1.0.jar;%APP_HOME%\lib\jetty-http-9.2.14.v20151106.jar;%APP_HOME%\lib\jetty-io-9.2.14.v20151106.jar;%APP_HOME%\lib\javax.annotation-api-1.2.jar;%APP_HOME%\lib\jersey-guava-2.23.2.jar;%APP_HOME%\lib\hk2-api-2.5.0-b05.jar;%APP_HOME%\lib\hk2-locator-2.5.0-b05.jar;%APP_HOME%\lib\osgi-resource-locator-1.0.1.jar;%APP_HOME%\lib\jersey-client-2.23.2.jar;%APP_HOME%\lib\jersey-media-jaxb-2.23.2.jar;%APP_HOME%\lib\jackson-module-jaxb-annotations-2.5.4.jar;%APP_HOME%\lib\annotations-1.3.2.jar;%APP_HOME%\lib\hk2-utils-2.5.0-b05.jar;%APP_HOME%\lib\aopalliance-repackaged-2.5.0-b05.jar;%APP_HOME%\lib\protobuf-java-3.3.1.jar;%APP_HOME%\lib\guava-18.0.jar;%APP_HOME%\lib\jcip-annotations-1.0.jar;%APP_HOME%\lib\javassist-3.20.0-GA.jar;%APP_HOME%\lib\jsr305-3.0.1.jar

@rem Execute cockroachdb
"%JAVA_EXE%" %DEFAULT_JVM_OPTS% %JAVA_OPTS% %COCKROACHDB_OPTS%  -classpath "%CLASSPATH%" com.mesosphere.sdk.cockroachdb.scheduler.Main %CMD_LINE_ARGS%

:end
@rem End local scope for the variables with windows NT shell
if "%ERRORLEVEL%"=="0" goto mainEnd

:fail
rem Set variable COCKROACHDB_EXIT_CONSOLE if you need the _script_ return code instead of
rem the _cmd.exe /c_ return code!
if  not "" == "%COCKROACHDB_EXIT_CONSOLE%" exit 1
exit /b 1

:mainEnd
if "%OS%"=="Windows_NT" endlocal

:omega

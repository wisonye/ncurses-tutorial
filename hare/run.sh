#!/bin/sh

OS_TYPE=`uname -s`
echo ">>> [ RUN ]"
echo ">>> OS_TYPE: ${OS_TYPE}"

SRC_FILE=$@
echo ">>> SRC_FILE: ${SRC_FILE}"
if [ -z "${SRC_FILE}" ]; then
    echo ">>>"
    echo ">>> Usage: ./run.sh source_file"
    echo ">>>"
    echo ">>> Example: ./run.sh src/window_border_example.ha"
    echo ">>>"
    exit 0
fi

BUILD_TYPE="Debug"
RELEASE_FLAG=""
if [ -z "${RELEASE_BUILD}" ]; then
    BUILD_TYPE="Debug"
    echo ">>> BUILD_TYPE: ${BUILD_TYPE}"
else
    BUILD_TYPE="Release"
    RELEASE_FLAG="-R"
    echo ">>> BUILD_TYPE: ${BUILD_TYPE}"
    echo ">>> RELEASE_FLAG: ${RELEASE_FLAG}"
fi

STDLIB_PATH=`hare version -v | grep stdlib | awk '{print $1}'`
HARE_PATH="./src:${STDLIB_PATH}"
echo ">>> HAREPATH: ${HARE_PATH}"
#
# Log level
#
# def LOG_DISABLED: size    = 0;
# def LOG_ERROR_LEVEL: size = 1;
# def LOG_WARN_LEVEL: size  = 2;
# def LOG_INFO_LEVEL: size  = 3;
# def LOG_DEBUG_LEVEL: size = 4;
LOGGER_LEVEL=4

if [ "${BUILD_TYPE}" = "Release" ]; then
    COMMAND="HAREPATH=${HARE_PATH} hare run ${RELEASE_FLAG} -lncursesw"
    COMMAND="${COMMAND} -D utils::logger::LOG_ENABLE=true"
    COMMAND="${COMMAND} -D utils::logger::LOG_LEVEL=${LOGGER_LEVEL}"
    COMMAND="${COMMAND} ${SRC_FILE}"
    echo ">>> COMMAND: ${COMMAND}"
    eval "${COMMAND}"
else
    COMMAND="HAREPATH=${HARE_PATH} hare run -lncursesw"
    COMMAND="${COMMAND} -D utils::logger::LOG_ENABLE=true"
    COMMAND="${COMMAND} -D utils::logger::LOG_LEVEL=${LOGGER_LEVEL}"
    COMMAND="${COMMAND} ${SRC_FILE}"
    echo ">>> COMMAND: ${COMMAND}"
    eval "${COMMAND}"
fi

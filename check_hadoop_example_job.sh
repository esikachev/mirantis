#!/bin/bash -x

HADOOP_USER=""
HADOOP_EXAMPLES_PATH=""

DATA_DIRECTORY=/tmp/hadoop-example-job-test
TEXT="Whose woods these are I think I know.
      His house is in the village though;
      He will not see me stopping here
      To watch his woods fill up with snow.

      My little horse must think it queer
      To stop without a farmhouse near
      Between the woods and frozen lake
      The darkest evening of the year.

      He gives his harness bells a shake
      To ask if there is some mistake.
      The only other sound’s the sweep
      Of easy wind and downy flake.

      The woods are lovely, dark and deep,
      But I have promises to keep,
      And miles to go before I sleep,
      And miles to go before I sleep."
WORD=woods
EXPECTED_WORD_COUNT=4

# Names of input file and output directory that Hadoop will use for example job
INPUT_FILE_NAME=input-file-$RANDOM
OUTPUT_DIRECTORY_NAME=output-directory-$RANDOM

create_data_directory() {
    if ! [ -d ${DATA_DIRECTORY} ]
    then
        mkdir ${DATA_DIRECTORY}
        chmod -R 777 ${DATA_DIRECTORY}
    fi
}

compare_word_counts() {
    if [ "${1}" = "${2}" ]
    then
        echo "Expected and actual counts of words are equal."
    else
        echo "Expected and actual counts of words are NOT equal! ${1} != ${2}" && exit 1
    fi
}

check_hadoop_example_job() {
    create_data_directory
    echo ${TEXT} > ${DATA_DIRECTORY}/${INPUT_FILE_NAME}

    if [ "$(echo ${HADOOP_EXAMPLES_PATH} | grep -io spark)" ]
    then
        cd ${HADOOP_EXAMPLES_PATH}
        word_count=`./bin/run-example JavaWordCount ${DATA_DIRECTORY}/${INPUT_FILE_NAME} | grep ${WORD} | awk '{print \$2}'`
    else
        sudo -u ${HADOOP_USER} bash -lc "hadoop dfs -copyFromLocal ${DATA_DIRECTORY}/${INPUT_FILE_NAME} /"
        sudo -u ${HADOOP_USER} bash -lc "hadoop jar ${HADOOP_EXAMPLES_PATH} wordcount /${INPUT_FILE_NAME} /${OUTPUT_DIRECTORY_NAME}"
        sudo -u ${HADOOP_USER} bash -lc "hadoop dfs -copyToLocal /${OUTPUT_DIRECTORY_NAME} ${DATA_DIRECTORY}/${OUTPUT_DIRECTORY_NAME}"
        word_count=`cat ${DATA_DIRECTORY}/${OUTPUT_DIRECTORY_NAME}/part-r-00000 | grep ${WORD} | awk '{print \$2}'`
    fi

    compare_word_counts ${EXPECTED_WORD_COUNT} ${word_count}
}

check_hadoop_example_job

# Import Agave runtime extensions
. _lib/extend-runtime.sh

# Allow CONTAINER_IMAGE over-ride via local file
if [ -z "${CONTAINER_IMAGE}" ]
then
    if [ -f "./_lib/CONTAINER_IMAGE" ]; then
        CONTAINER_IMAGE=$(cat ./_lib/CONTAINER_IMAGE)
    fi
    if [ -z "${CONTAINER_IMAGE}" ]; then
        echo "CONTAINER_IMAGE was not set via the app or CONTAINER_IMAGE file"
        CONTAINER_IMAGE="sd2e/base:ubuntu17"
    fi
fi

# Usage: container_exec IMAGE COMMAND OPTIONS
#   Example: docker run centos:7 uname -a
#            container_exec centos:7 uname -a

export LC_ALL=C
COMMAND=" msconvert "
PARAMS=" "

if [ -n "${raw_file}" ];
then
	PARAMS="${PARAMS} ${raw_file} "

elif [ -n "${raw_directory}" ];
then
	find ${raw_directory} -type f > filelist.txt
	PARAMS="${PARAMS} -f filelist.txt "

else
	echo "Error: must specify either an input file or input directory"
	return 1
fi


if [ -n "${out_file}" ];
then
	PARAMS="${PARAMS} ${out_file} "

elif [ -n "${out_directory}" ];
then
	PARAMS="${PARAMS} -o ${out_directory} "
	mkdir -p ${out_directory}

else
	echo "Error: must specify either an output file or output directory"
	return 1
fi

if [ -n "${format}" ];
then
	PARAMS="${PARAMS} ${format} "
else
	PARAMS="${PARAMS} --mzML "
fi

#mkdir -p ./output/
container_exec ${CONTAINER_IMAGE} ${COMMAND} ${PARAMS}

#! /bin/sh

# $1 is expected to have xsb ececutable + command line options
PYTHON=$1
FILE=$2

DIR=`pwd`
BASEDIR=`basename $DIR`

echo "--------------------------------------------------------------------"
echo "Testing $BASEDIR/$FILE"
#echo "$EMU"     # debug check: verify that options have been passed to xsb

$PYTHON $FILE

FILEBASE="${FILE%.*}"    

echo "filebase is $FILEBASE"

# print out differences.
if test -f ${FILEBASE}_new; then
	rm -f ${FILEBASE}_new
fi
    
sort temp > ${FILEBASE}_new
sort ${FILEBASE}_old > temp

#-----------------------
# print out differences.
#-----------------------
status=0
diff -w ${FILEBASE}_new temp || status=1
if test "$status" = 0 ; then 
	echo "$BASEDIR/$FILE tested"
	rm -f ${FILEBASE}_new
else
	echo "$BASEDIR/$FILE differ!!!"
	diff -w ${FILEBASE}_old temp
fi

rm -f temp

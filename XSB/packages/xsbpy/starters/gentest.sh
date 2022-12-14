#! /bin/sh

# slightly different than the one in xsbtests -- in order to support
# xp_rdflib tests.

# $1 is expected to have xsb ececutable + command line options
EMU=$1
FILE=$2
CMD=$3
OLD_FILE=$4

DIR=`pwd`
BASEDIR=`basename $DIR`

echo "--------------------------------------------------------------------"
echo "Testing $BASEDIR/$FILE"
#echo "$EMU"     # debug check: verify that options have been passed to xsb

$EMU << EOF
[$FILE].
%tell(temp).
$CMD
%told.
EOF

# print out differences.
if test -f ${FILE}_new; then
	rm -f ${FILE}_new
fi
    
sort temp > ${FILE}_new
sort ${OLD_FILE}_old > temp

#-----------------------
# print out differences.
#-----------------------
status=0
diff -w ${FILE}_new temp || status=1
if test "$status" = 0 ; then 
	echo "$BASEDIR/$FILE tested"
	rm -f ${FILE}_new
else
	echo "$BASEDIR/$FILE differ!!!"
	diff -w ${FILE}_new temp
fi

rm -f temp

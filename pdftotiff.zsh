#!/usr/bin/zsh

if (( $# != 2 ));
then
	print "$0 input_file.pdf output_dir"
	exit -1;
fi

startdir=$(pwd)
tempdir=$(mktemp -d)
mutool draw -o "$tempdir/%d.pbm" -r300 $1
pushd $tempdir
print "moved to temporary directory $(pwd)"
for pbm in $(ls *.pbm|sort -n);
do
	tiff_name="$pbm.tif"
	all_tiffs=($all_tiffs $tiff_name)
	print "converting $pbm to $tiff_name"
	ppm2tiff -c g4 -R 300 "$pbm" "$tiff_name";
done

mkdir "$2"
cp -v $tempdir/*.tif "$2"
rm -r $tempdir

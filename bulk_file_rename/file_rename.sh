target_dir=${1:?"ERROR: ENTER A DIRECTORY PATH"}

for d in $target_dir; do
	i=0;
	if ! [ "$d" == "${d}/file_rename.sh" ]
	then
		for f in ${d}/*; do 
			((i+=1));
			mv "$f" $d/$i.jpg
		done; 
		echo $i; 
		i=0;
	fi
done

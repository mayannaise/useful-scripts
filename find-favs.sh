#!/bin/bash -eu

mount_dir=~/iphone
dest_dir=~/Pictures/print
favs_file=favs.csv
db_file="$mount_dir/PhotoData/Photos.sqlite"

# connect to iPhone
mkdir -p "$mount_dir"
mkdir -p "$dest_dir"
ifuse "$mount_dir"

# find which photos have been marked as favourite
sqlite3 "$db_file" "select ZFILENAME,ZUUID from ZASSET where ZFAVORITE==1" > "$favs_file"
echo "Found $(wc -l < $favs_file) favourite photos"

# now find those photos on the phone and copy them off
while IFS="|" read -r filename uuid
do
	echo "Searching for $filename"
	find "$mount_dir/DCIM" -type f -name "$filename" -exec cp "{}" "$dest_dir" \;
done < "$favs_file"

# unmount iphone and tidy up
fusermount -u "$mount_dir"
rmdir "$mount_dir"
rm "$favs_file"

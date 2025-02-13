#!/bin/bash

cd /media/sda/bsmkhtml/

OUT="/media/sda/html/bestshitsarchive"

echo "" > out.html
cat pre.html >> out.html
echo "copied pre to file"

rm -v $OUT/files/*

IFS="@"

# author, songname, genre, release time, link
data="$(sort -n -t"," -k4 data.csv | tr '\n' '@')"
index=0
for l in $data; do
	((index++))
	echo "reaidng $index"

	l_author="$(echo $l | cut -d ',' -f1)"
	l_songname="$(echo $l | cut -d ',' -f2)"
	l_genre="$(echo $l | cut -d ',' -f3)"
	l_time="$(echo $l | cut -d ',' -f4)"
	l_time="$(date --date=@$l_time '+%d/%m/%y')"
	l_link="$(echo $l | cut -d "," -f5)"

	echo "writing data entry"
	echo '		<tr>' >> out.html
	echo '			<td id="title">'"$l_author" - "$l_songname"'</td>' >> out.html
	echo '			<td>'"$l_genre"'</td>' >> out.html
	echo '			<td>'"$l_time"'</td>' >> out.html
	echo '			<td><audio controls src="./files/'"$l_link"'"></audio></td>' >> out.html
	echo '		</tr>' >> out.html
	# worst thing ive ever done

done
echo "done writing data"

cat post.html >> out.html
echo "copied post to file"

cp out.html "$OUT/index.html"
cp -v ./files/* "$OUT/files/"

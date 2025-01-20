#!/bin/bash

IFS="@"
OUT="/media/sda/html/bestshitsarchive"

echo "" > out.html
cat pre.html >> out.html
echo "copied pre to file"

# author, songname, genre, release time, link
data="$(sort -n -t"," -k4 data.csv | tr '\n' '@')"
index=0
for l in $data; do
	((index++))
	echo "reaidng $index"

	l_author="$(echo $l | cut -d ',' -f1 | tr -d "\"")"
	l_songname="$(echo $l | cut -d ',' -f2 | tr -d "\"")"
	l_genre="$(echo $l | cut -d ',' -f3 | tr -d "\"")"
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
cp ./files/* "$OUT/files/"

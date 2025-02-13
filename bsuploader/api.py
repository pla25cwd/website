from flask import Flask, request 
from flask_cors import CORS
import json
import subprocess
import base64
import time
from calendar import timegm
from bskeyfile import key

DATA_FILE = "/media/sda/bsmkhtml/data.csv"
AUDIO_DIRECTORY = "/media/sda/bsmkhtml/files"
MKHTML = "/media/sda/bsmkhtml/bsmkhtml.sh"

app = Flask(__name__)
CORS(app)

@app.route("/bsupload", methods=["POST"])
def upload():
	data = json.loads(request.data)

	# data """"verification""""
	if len(data) != 6:
		return "", 400

	key_set = {"key","author","title","genre","date","file"}
	if not key_set.issubset(data.keys()):
		return "", 400

	for i in data.values():
		if type(i) is not str:
			return "", 400

	if data["key"] != key:
		return "", 400

	print(data)

	data["author"] = data["author"].replace(',', '')
	data["title"] = data["title"].replace(',', '')

	# time to unixtime
	time_struct = time.gmtime()
	time_split = data["date"].split('-')
	unixtime = timegm((int(time_split[0]), int(time_split[1]), int(time_split[2]), time_struct.tm_hour, time_struct.tm_min, time_struct.tm_sec, time_struct.tm_wday, time_struct.tm_yday, time_struct.tm_isdst))

	# file
	file_bytes = base64.b64decode(data["file"])
	with open(f'{AUDIO_DIRECTORY}/{unixtime}.mp3', 'wb+') as f:
		f.write(file_bytes)
		f.close()

	with open(DATA_FILE, "a") as f:
		line = f'{data["author"]},{data["title"]},{data["genre"]},{unixtime},{unixtime}.mp3'
		f.write(line + "\n")
		f.close()

	time.sleep(1)
	subprocess.run(MKHTML)
	print(f'finished uploading {data["author"]} - {data["title"]}')

	return ""


const form = document.getElementById("form");
const URL = "https://x-im.li/bsupload"


async function sendRequest() {
	const formData = new FormData(form);
  const file_bytes = await formData.get("file").bytes()
  const file_b64 = file_bytes.toBase64()

	const response = await fetch(URL, {
		method: 'POST',
		mode: 'cors',
		credentials: 'omit',
		body: JSON.stringify({ "key": formData.get("key"), "author": formData.get("author"), "title": formData.get("title"), "genre": formData.get("genre"), "date": formData.get("date"), "file": file_b64})
	})
		.catch((error) => {
			return;
		});
};

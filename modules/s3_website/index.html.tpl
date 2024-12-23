<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Image Gallery</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
        }

        .gallery {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
        }

        .gallery img {
            margin: 10px;
            max-width: 200px;
            max-height: 200px;
        }
    </style>
</head>

<body>
    <h1>Image Gallery</h1>
    <div class="gallery" id="gallery"></div>

    <script>
        const bucketName = '${bucket_name}';
        console.log('Bucket Name:', bucketName);
        const region = 'us-west-2';
        const gallery = document.getElementById('gallery');

        async function listImages() {
            const response = await fetch('https://' + bucketName + '.s3.' + region + '.amazonaws.com?list-type=2');
            const text = await response.text();
            const parser = new DOMParser();
            const xml = parser.parseFromString(text, 'application/xml');
            const keys = xml.getElementsByTagName('Key');

            for (let i = 0; i < keys.length; i++) {
                const key = keys[i].textContent;
                if (key.match(/\.(jpeg|jpg|gif|png)$/)) {
                    const img = document.createElement('img');
                    img.src = 'https://' + bucketName + '.s3.' + region + '.amazonaws.com/' + key;
                    gallery.appendChild(img);
                }
            }
        }

        listImages();
    </script>
</body>

</html>
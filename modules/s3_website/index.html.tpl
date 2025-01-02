
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
    <script src="https://sdk.amazonaws.com/js/aws-sdk-2.283.1.min.js"></script>
</head>

<body>
    <h1>Image Gallery</h1>
    <div class="gallery" id="gallery"></div>

    <script>
        const bucketName = '${bucket_name}';
        const region = 'us-west-2';
        const accessKeyId = '${aws_access_key_id}';
        const secretAccessKey = '${aws_secret_access_key}';
        console.log('Bucket Name:', bucketName);
        const gallery = document.getElementById('gallery');

        AWS.config.update({
            accessKeyId: accessKeyId,
            secretAccessKey: secretAccessKey,
            region: region
        });

        const s3 = new AWS.S3({
            apiVersion: '2006-03-01',
            params: { Bucket: bucketName }
        });

        async function listImages() {
            const params = {
                Bucket: bucketName
            };

            s3.listObjectsV2(params, function(err, data) {
                if (err) {
                    console.log(err, err.stack);
                } else {
                    const keys = data.Contents.map(item => item.Key);
                    keys.forEach(async key => {
                        if (key.match(/\.(jpeg|jpg|gif|png|PNG)$/)) {
                            const getObjectParams = {
                                Bucket: bucketName,
                                Key: key
                            };
                            const objectData = await s3.getObject(getObjectParams).promise();
                            const base64Data = btoa(
                                new Uint8Array(objectData.Body)
                                    .reduce((data, byte) => data + String.fromCharCode(byte), '')
                            );
                            const img = document.createElement('img');
                            img.src = 'data:' + objectData.ContentType + ';base64,' + base64Data;
                            gallery.appendChild(img);
                        }
                    });
                }
            });
        }

        listImages();
    </script>
</body>

</html>
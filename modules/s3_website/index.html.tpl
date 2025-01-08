<!DOCTYPE html>
<html>
<head>
  <title>Secure Static Website</title>
  
  <!-- AWS Amplify Library (Latest Version) -->
  <script src="https://cdn.jsdelivr.net/npm/aws-amplify@4.3.35/dist/aws-amplify.min.js"></script>

  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f4f4;
      margin: 0;
      padding: 0;
    }
    #login-form, #content {
      max-width: 400px;
      margin: 100px auto;
      padding: 30px;
      background: #fff;
      border-radius: 8px;
      box-shadow: 0 2px 5px rgba(0,0,0,0.3);
    }
    h1, h2 {
      text-align: center;
      color: #333;
    }
    input[type="text"], input[type="password"] {
      width: 100%;
      padding: 12px 20px;
      margin: 8px 0;
      display: inline-block;
      border: 1px solid #ccc;
      border-radius: 4px;
      box-sizing: border-box;
    }
    button {
      width: 100%;
      background-color: #28a745;
      color: white;
      padding: 14px 20px;
      margin: 8px 0;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 16px;
    }
    button:hover {
      background-color: #218838;
    }
    .gallery img {
      max-width: 100px;
      margin: 10px;
      border: 2px solid #ccc;
      border-radius: 4px;
    }
    #signout-button {
      background-color: #dc3545;
    }
    #signout-button:hover {
      background-color: #c82333;
    }
  </style>

  <script>
  // window.LOG_LEVEL='DEBUG'
    const { Amplify } = window['aws_amplify'];
     

      // Configure Amplify
      Amplify.configure({
        Auth: {
          region: 'us-west-2', // REQUIRED - Amazon Cognito Region
          userPoolId: '${user_pool_id}',
          userPoolWebClientId: '${user_pool_web_client_id}',
          identityPoolId: '${identity_pool_id}', // REQUIRED - Amazon Cognito Identity Pool ID
          mandatorySignIn: true, // OPTIONAL - Ensures user authentication before accessing AWS resources
        },
        Storage: {
          AWSS3: {
            bucket: '${bucket_name}', // REQUIRED - Amazon S3 bucket name
            region: 'us-west-2', // REQUIRED - Amazon S3 region
          }
        }
      });
     document.addEventListener("DOMContentLoaded", async function() {    
      checkLogin();
    });

    // Sign In Function
    async function signIn() {
      const username = document.getElementById('username').value.trim();
      const password = document.getElementById('password').value.trim();

      if (!username || !password) {
        alert('Please enter both username and password.');
        return;
      }

      try {
        const user = await Amplify.Auth.signIn(username, password);
         if (user.challengeName === 'NEW_PASSWORD_REQUIRED') {
          const newPassword = prompt('Please enter a new password:');
          await Amplify.Auth.completeNewPassword(user, newPassword, {});
        }
        const session = await Amplify.Auth.currentSession();
        const idToken = session.getIdToken().getJwtToken();

        // Store the token and reload the page
        localStorage.setItem('idToken', idToken);
        window.location.reload();
      } catch (error) {
        console.error('Error signing in', error);
        alert('Error signing in: ' + error.message);
      }
    }

    // Sign Out Function
    async function signOut() {
      try {
        await Amplify.Auth.signOut();
        localStorage.removeItem('idToken');
        window.location.reload();
      } catch (error) {
        console.error('Error signing out', error);
        alert('Error signing out: ' + error.message);
      }
    }

    // Check Login Status
    function checkLogin() {
      const token = localStorage.getItem('idToken');
      if (!token) {
        document.getElementById('login-form').style.display = 'block';
        document.getElementById('content').style.display = 'none';
      } else {
        document.getElementById('login-form').style.display = 'none';
        document.getElementById('content').style.display = 'block';
        listImages(token);
      }
    }

    // List Images from S3 using Amplify Storage
    async function listImages(token) {
      const gallery = document.getElementById('gallery');
      gallery.innerHTML = ''; // Clear existing images

      try {
        const images = await Amplify.Storage.list('',{level:'public'}); // Lists all items in the bucket

        // Filter image files based on extension
        const imageFiles = images.filter(item => /\.(jpeg|jpg|gif|png)$/i.test(item.key));

        if (imageFiles.length === 0) {
          gallery.innerHTML = '<p>No images found.</p>';
          return;
        }

        // Fetch each image's URL and display it
        for (const image of imageFiles) {
          try {
            const imageURL = await Amplify.Storage.get(image.key, { level: 'public' });
            const img = document.createElement('img');
            img.src = imageURL;
            img.alt = image.key;
            gallery.appendChild(img);
          } catch (error) {
            console.error('Error fetching image' +image.key +':', error);
          }
        }
      } catch (error) {
        console.error('Error listing images:', error);
        gallery.innerHTML = '<p>Error loading images.</p>';
      }
    }
  </script>
</head>

<body>
  <!-- Login Form -->
  <div id="login-form" style="display:none;">
    <h2>Login</h2>
    <input type="text" id="username" placeholder="Username" required />
    <input type="password" id="password" placeholder="Password" required />
    <button onclick="signIn()">Sign In</button>
  </div>

  <!-- Main Content -->
  <div id="content" style="display:none;">
    <h2 id="welcome">Welcome to the Secure Static Website</h2>
    <button id="signout-button" onclick="signOut()">Sign Out</button>
    <h3>Image Gallery</h3>
    <div class="gallery" id="gallery"></div>
  </div>
</body>
</html>
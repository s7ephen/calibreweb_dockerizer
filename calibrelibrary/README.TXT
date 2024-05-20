There should be two files in this directory:
1. prepare.sh
2. use.sh

PREPARE.SH
===========
Prepare.sh is used ONLY when building the Library.
prepare.sh is intended to be run on the computer "building" the docker
container. It will take the path of your Calibre Library as an argument:
Usually: ~/"Calibre Library"/

run: ./prepare.sh -c <CalibreLibrary dir> -e yes (or no) 

Example: ./prepare.sh -c "/home/s7/Calibre Library" -e yes

it will tar that directory, compress it to ./CalibreLibrary.tar.gz
it will then encrypt that compressed file, prompting you first for the password.
you should manually delete the .tar and .tar.gzip files, leaving only CalibreLibrary.tar.gz.enc

Your container is now ready to build.

Run docker build -t whatever_you_want_this_image_named .
This will build the container copying your encrypted library into the container
during the build process (as well as installing the webapp and webserver that will
serve you your Library).

After the container has built it is ready to run or be shared.
(If you encrypted your Library it can be shared easier "in public").

========
USE.SH
========
USE.sh is used from WITHIN the container and prepares your bundled Library for use by the embedded-webapp. It "prepares" by decrypting/decompressing.

When you are ready to use the container, execute the container as the image's instructions indicate it shoudl be run,
making sure to add options to run it interactively dropping to a shell.
(docker run -it <your_image_name> bash)
USE.SH along with PREPARE.SH and CalibreLibrary.tar.gz.enc will be in /books/
within the container.

Run: ./use.sh
This will prompt you for the decryption password, decrypt CalibreLibrary.tar.gz.enc
it will then decompress the resulting CalibreLibrary.tar.gz
and then untar the resulting CalibreLibrary.tar
This should leave you with your Library residing in /books/"Calibre Library".
Your library should now be usable via the webinterface started automatically 
by this container. 

Your decrypted Library should now be browsable/readable via a browser on your
Host OS by accessing http://localhost:8083 assuming you used the instructions for running this
container and didnt change the port number.

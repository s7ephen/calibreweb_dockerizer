#!/bin/bash
# decrypt and decompress an ebook library and get it prepared for use by
# the ebook-library-webapp in the container  
#
while getopts f:e: flag
    do
        case "$flag" in
            e) encr=${OPTARG};;
            f) libr=${OPTARG};;
        \?) echo "Usage: [-f the_calibre_library.tar.gz] [-e encrypted?]" >&2
                exit 1;;
        :) echo "Missing Option, Usage: [-f the_calibre_library.tar.gz] [-e encrypted?]" >&2
                exit 1;;
        *) echo "Incorrect Option Usage: [-f the_calibre_library.tar.gz] [-e encrypted?]" >&2
                exit 1;;
        esac
    done

if [ ! "$libr" ] || [ ! "$encr" ]; then
    echo -ne "Usage: [-c CalibreLibrary.tar.gz] [-e encrypted?]"
    echo -ne "\n\n\t Example: -f ./CalibreLibrary.tar.gz.enc -e yes\n"
    echo -ne "\n\t -f <filename>: path to the Calibre Library"
    echo -ne "\n\t -e <yes>||<no>: Whether the library bundle is encrypted (yes/no)\n"
    exit 1
fi
if [ $encr == "yes" ] || [ $encr == "Yes" ] || [ $encr == "y" ]; then # this should be a "case" but i hate
                                                                      # shellscripting more than i have to.
                                                                      # they're retarded. 
    libr_sans_ext=${libr%.*} #strips the .enc portion
    printf "\n[+] You said the bundle was encrypted, so.."
    printf "\n\t\t Decrypting '""$libr""' to '""$libr_sans_ext""' ."
    openssl enc -aes-256-cbc -d -in $libr -out $libr_sans_ext 
    printf "\n[+] Decompressing '""$libr_sans_ext""' to /books/CalibreLibrary/."
    mkdir /books/CalibreLibrary/
    tar xvfz $libr_sans_ext -C /books/CalibreLibrary/
    printf "\n[+] Deleteing '""$libr_sans_ext""' to save space in the container."
    rm $libr_sans_ext
    printf "\n[+] ...Assuming no errors, your library should be ready."
    printf "\n[+] browse to http://localhost:8083 to continue"
    printf "\n"
fi
if [ $encr == "no" ] || [ $encr == "No" ] || [ $encr == "n" ]; then # this should be a "case" but i hate
                                                                      # shellscripting more than i have to.
                                                                      # retarded. 
    printf "\n[+] You said the bundle wasn't encrypted."
    printf "\n[+] Decompressing '""$libr""' to /books/CalibreLibrary/."
    mkdir /books/CalibreLibrary/
    tar xvfz $libr -C /books/CalibreLibrary/
    printf "\n[+] ...Assuming no errors, your library should be ready."
    printf "\n[+] browse to http://localhost:8083 to continue"
fi

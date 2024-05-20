#!/bin/bash
# prepare the calibre library for transport in the container.

while getopts c:e: flag
    do
        case "$flag" in
            e) encr=${OPTARG};;
            c) calilib=${OPTARG};;
        \?) echo "Usage: [-c calibre library dir] [-e encrypt?]" >&2
                exit 1;;
        :) echo "Missing Option, Usage: [-c calibre library dir] [-e encrypt?]" >&2
                exit 1;;
        *) echo "Incorrect Option Usage:: [-c calibre library dir] [-e encrypt?]" >&2
                exit 1;;
        esac
    done

if [ ! "$calilib" ] || [ ! "$encr" ]; then
    echo -ne "Usage: [-c Calibre Library Dir] [-e encrypt?]\n\t Example: -c "
    echo '"/home/s7/Calibre Library"'" -e yes"
    echo -ne "\n\n(Note: if path has spaces use \"\"s and DONT escape spaces)\n"
    exit 1
fi

# Bash shellscript handling of whitespaces in paths is really hacky.
# if you remove the quotes from "$calilib" below, everything breaks.
# An important note about the hackyness of shellscript string-handling
# and "escape characters". 
printf "\n[+] Tarballing dir: '""$calilib"
echo -ne "' to CalibreLibrary.tar ...\n"
tar cvf ./CalibreLibrary.tar -C "$calilib" . && printf "\n[+] Tarball ./CalibreLibrary.tar created. Beginning Compression\n"
printf "\n[+] Compressing ./CalibreLibrary.tar --> ./CalibreLibrary.tar.gz"
gzip ./CalibreLibrary.tar
if [ $encr == "yes" ] || [ $encr == "Yes" ] || [ $encr == "y" ]; then
    printf "\n[+] Encrypting the tarball ..."
    openssl enc -aes-256-cbc -in ./CalibreLibrary.tar.gz -out ./CalibreLibrary.tar.gz.enc 
    printf "\n[+] Removing calibreLibrary.tar.gz (leaving only the encrypted version) to save space in your image."
    rm CalibreLibrary.tar.gz
fi

printf "\n[+] ...Assuming everything ran without errors, you should be ready.\n"

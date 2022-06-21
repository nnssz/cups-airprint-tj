#!/bin/bash
#!/bin/sh
#set -e
#set -x

cd /root/
tar  -xzvf "./uld-hp_V1.00.39.12_00.15.tar.gz"

#line 12 is space + enter ;line 13 is enter
echo "
 y
 

" | /root/uld/install.sh

exit 0

#! /bin/bash
rsync -av --delete --rsh=ssh --exclude-from="tz-rsync-exclude" \
    * www.cesnet.cz:/home/httpd/private/html/doc/tr/Techrep

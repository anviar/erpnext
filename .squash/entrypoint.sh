#!/bin/bash

if [[ ! -d ~/frappe-bench/sites/${SQUASH_DOMAIN} ]]
then
    mkdir ~/frappe-bench/sites/${SQUASH_DOMAIN}
    j2 /tmp/site_config.j2 >~/frappe-bench/sites/${SQUASH_DOMAIN}/site_config.json
fi

bench --site ${SQUASH_DOMAIN} reinstall --yes && \
bench --site ${SQUASH_DOMAIN} install-app erpnext && \
bench start
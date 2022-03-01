#!/usr/bin/env bash
OPTION="$1"; shift

if [[ $OPTION == '--delete' ]]; then
    for i in 'master' 'worker1' 'worker2'; do multipass delete "${i}" --purge; done
else
    for i in 'master' 'worker1' 'worker2'; do multipass stop "${i}"; done
fi

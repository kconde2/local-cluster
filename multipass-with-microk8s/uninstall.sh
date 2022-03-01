#!/usr/bin/env bash

# for i in 'master' 'worker1' 'worker2'; do multipass delete "${i}" --purge; done
for i in 'master' 'worker1' 'worker2'; do multipass stop "${i}"; done

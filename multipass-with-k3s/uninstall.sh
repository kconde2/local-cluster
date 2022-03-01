#!/usr/bin/env bash

for i in 'node1' 'node2' 'node3'; do multipass delete "${i}" --purge; done

#!/bin/bash

kubectl apply -f mysql.deployment.yaml
kubectl apply -f mysql.pv.yaml
kubectl apply -f mysql.service.yaml
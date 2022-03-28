

kubectl patch pv pvc-name -p '{"metadata":{"finalizers":null}}'
kubectl delete pv pvc-name

NAMESPACES=($(kubectl get ns | tail -n +2 | awk '{print $1}'))

for ns in "${NAMESPACES[@]}"
do
  kubectl get pods --namespace $ns --field-selector status.phase=Failed | tail -n +2 | awk '{print $1}' | while read line;
do kubectl delete pods $line --namespace $ns; done
done

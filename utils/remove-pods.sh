PODS_PATTERN=$1
NAMESPACES=($(kubectl get ns | tail -n +2 | awk '{print $1}'))

for ns in "${NAMESPACES[@]}"
do
  kubectl get pods --namespace $ns | grep $PODS_PATTERN | awk '{print $1}' | while read line;
do kubectl delete pods $line --namespace $ns; done
done

PODS_PATTERN=$1
NAMESPACE=$2

kubectl get pods --namespace $NAMESPACE | grep $PODS_PATTERN | awk '{print $1}' | while read line; do kubectl delete pods $line --namespace $NAMESPACE; done

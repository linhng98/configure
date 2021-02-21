ZONE=asia-southeast2-a
COMMAND="'sysctl fs.inotify.max_user_watches=1048576'"

gcloud compute instances list | grep gke | awk '{print $1}' | while read line; do gcloud compute ssh --zone=$ZONE $line --command $COMMAND; done


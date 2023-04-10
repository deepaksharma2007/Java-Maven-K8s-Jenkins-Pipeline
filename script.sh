#!/bin/bash 

deploy=sudo kubectl get deploy | awk 'NR==2 {print $1}'
BUILD_TAG="$1"
if [ "$deploy" = "myjavapp" ] ;
then 
        echo "deployment exists"
else 
         sudo wget https://raw.githubusercontent.com/deepaksharma2007/Java-Maven-K8s-Jenkins-Pipeline/master/deploy.yml
         sudo kubectl apply -f deploy.yml --prune --selector BUILD_TAG=${BUILD_TAG}
fi

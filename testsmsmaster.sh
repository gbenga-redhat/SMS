#!/bin/bash

# script to prepare daily hit data for a demo
# TODO: make this generic

get () {
  curl -k $1/sms/v2/$2?user_key=$3
}

getLoop() {
  echo "--> performing GET for $2"
  for counter in {1..3}
  do
    get $1 $counter $2
    echo "";
     ((counter++))
  done
}

delete () {
  curl -k -X DELETE $1/sms/v2/$2?user_key=$3
}

deleteLoop() {
  echo "--> performing DELETE for $2"
  for counter in {1..3}
  do
    delete $1 $counter $2
    echo "";
     ((counter++))
  done
}

put() {
  curl -k -X PUT -H "Content-Type: application/json" -d '{"id":3,"createdTimeStamp":"447500887763","timeStamp":"1521636642088","text":"Some random SMS Character text 3"}' $1/sms/v2/$2?user_key=$3
}

putLoop() {
  echo "--> performing PUT for $2"
  for counter in {1..3}
  do
    put $1 $counter $2
    echo "";
     ((counter++))
  done
}


post() {
  curl -k -X POST -H "Content-Type: application/json" -d '{"id":3,"createdTimeStamp":"447500887763","timeStamp":"1521636642088","text":"Some random SMS Character text 3"}' $1/sms/v2?user_key=$2
}

postLoop() {
  echo "--> performing POST for $2"
  for counter in {1..5}
  do
    post $1 $2
    echo "";
     ((counter++))
  done
}

testpods() {

echo "-->checking to see if Pod is running and liveness/readiness probe is 1/1"

oc get pods | grep Running | grep 1/1
while ! [ $? == 0 ] 
do
   oc get pods | grep Running | grep 1/1
done
echo "--booted"

}

echo "-->Logging into openshift"

oc login https://master.rhsademo.net -u $1 -p $2
! [ $? == 0 ] && echo "FAILED" && exit 1

echo "-->Bringing up apicast pod"
oc project 3scale-apicast

oc scale dc apicast --replicas=1

echo "-->Waiting for apicast to boot"
testpods
# apicast has a liveness/readiness probe but going to wait a bit more
sleep 15


echo "--> Attempt a GET before SMS is up to force a 5XX call"
getLoop https://sms-3scale-apicast.apps.rhsademo.net:443  20cd0d18260b1b480d7421da1d307aa0

echo "-->Bringing up sms pod"
oc project sms

oc scale dc sms --replicas=1 

echo "-->Waiting for sms to boot"
testpods
# need a liveness/readiness proble but don't have one..going to wait a bit more
sleep 30


echo "--> Healthcheck testing 3scale API gateway/backend"
curl -k "https://sms-3scale-apicast.apps.rhsademo.net:443/?user_key=20cd0d18260b1b480d7421da1d307aa0"
curl -k "https://sms-3scale-apicast.apps.rhsademo.net:443/?user_key=e5a57ccc1c411dada4a2717faaf18b7a"
curl -k "https://sms-3scale-apicast.apps.rhsademo.net:443/?user_key=aec48ab3714b2c18e4dc320ce9e98ea5"

echo "--> begin actual testing 3scale API gateway/backend"
getLoop https://sms-3scale-apicast.apps.rhsademo.net:443  20cd0d18260b1b480d7421da1d307aa0
getLoop https://sms-3scale-apicast.apps.rhsademo.net:443  e5a57ccc1c411dada4a2717faaf18b7a
getLoop https://sms-3scale-apicast.apps.rhsademo.net:443  aec48ab3714b2c18e4dc320ce9e98ea5

putLoop https://sms-3scale-apicast.apps.rhsademo.net:443  20cd0d18260b1b480d7421da1d307aa0
putLoop https://sms-3scale-apicast.apps.rhsademo.net:443  e5a57ccc1c411dada4a2717faaf18b7a
putLoop https://sms-3scale-apicast.apps.rhsademo.net:443  aec48ab3714b2c18e4dc320ce9e98ea5

postLoop https://sms-3scale-apicast.apps.rhsademo.net:443  20cd0d18260b1b480d7421da1d307aa0
postLoop https://sms-3scale-apicast.apps.rhsademo.net:443  e5a57ccc1c411dada4a2717faaf18b7a
postLoop https://sms-3scale-apicast.apps.rhsademo.net:443  aec48ab3714b2c18e4dc320ce9e98ea5

deleteLoop https://sms-3scale-apicast.apps.rhsademo.net:443  20cd0d18260b1b480d7421da1d307aa0
deleteLoop https://sms-3scale-apicast.apps.rhsademo.net:443  e5a57ccc1c411dada4a2717faaf18b7a
deleteLoop https://sms-3scale-apicast.apps.rhsademo.net:443  aec48ab3714b2c18e4dc320ce9e98ea5

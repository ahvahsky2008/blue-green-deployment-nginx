#!/usr/bin/env bash

set -e

source init.sh


echo 'Build the new image'
cd app
docker build . -t app:new
cd ..


state='blue'
new_state='green'
new_upstream=${green_upstream}


echo 'Check the current state'
blue_is_not_run=$(docker ps | grep blue-green-deployment-nginx-blue- | awk '{print $1}')
if [ "$blue_is_not_run" == "" ]
then
    echo 'blue не запущен'
    state='green'
    new_state='blue'
    new_upstream=${blue_upstream}
else
    echo 'blue запущен'
fi


echo "Create the app:${new_state} image"
docker tag app:new app:${new_state}

echo "Update the ${new_state} container"
docker-compose up -d ${new_state}


echo "Тут нужно проверить дополнительно запустился ли полноценно сервис или нет. Я добавил просто паузу."
sleep 10s

echo 'Check the new app for 200 code'
status=$(docker-compose run --rm nginx curl -XGET ${new_upstream} -o /dev/null -Isw '%{http_code}')
if [[ ${status} != '200' ]]
then
    echo "NOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOo"
    echo "Bad HTTP response in the ${new_state} app: ${status}"
    ./reset.sh ${key_value_store} ${state}
    exit 1
fi

./activate.sh ${new_state} ${state} ${new_upstream} ${key_value_store}

echo "Set the ${new_state} image as ${state}"
docker tag app:${new_state} app:${state}

echo 'Set the old image as previous'
docker tag app:latest app:previous

echo 'Set the new image as latest'
docker tag app:new app:latest

echo "Stop the ${state} container"
docker-compose stop ${state}

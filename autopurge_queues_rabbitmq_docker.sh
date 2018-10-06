#!/bin/bash

# this script assumes:
#   RabbitMQ is running as docker container
#   only vhost "/" is used
#   environment variables are set
#     RABBIT_USER (admin user)
#     RABBIT_PASS (password of the admin user)

rabbitmq_container_name="docker_raspi2stack_docker-rabbitmq_1"
vhost="/"

for queue in $(docker exec $rabbitmq_container_name rabbitmqadmin --host=rabbitmq --port=80 --vhost=$vhost --username=$RABBIT_USER --password=$RABBIT_PASS list queues name | grep paho | column -s "|" -t | awk '{$1=$1;print}'); do
  queue=$(echo $queue | xargs)
  docker exec rabbitmq_container_name --host=rabbitmq --port=80 --vhost=$vhost --username=$RABBIT_USER --password=$RABBIT_PASS purge queue name=$queue
done

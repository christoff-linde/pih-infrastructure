# pih-infrastructure

All PIH-related infrastructure configurations and setups

## RabbitMQ Setup

After successfully starting all containers using `docker compose up -d`, make sure to enable the required plugins as follows:

```
docker exec rabbitmq rabbitmq-plugins enable rabbitmq_mqtt
docker exec pih-rabbitmq rabbitmqctl enable_feature_flag all
```

This will enable the `mqtt` plugin (required to receive/accept MQTT messages), as well as ensuring that the relevant feature flags are enabled to cater for the new functionality.

**NOTE**: This is all still done manually. One day, it will be configured on startup.

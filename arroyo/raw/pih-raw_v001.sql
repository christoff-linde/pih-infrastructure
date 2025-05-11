-- pih-raw_v001

-- CREATE MQTT DATA SOURCE
CREATE TABLE sensor_data_mqtt (
    device_id STRING,
    temperature DOUBLE,
    humidity DOUBLE,
    topic STRING METADATA FROM 'topic'
) WITH (
    connector = 'mqtt',
    url = 'mqtt://host.docker.internal:1883',
    type = 'source',
    format = 'json',
    topic = 'pih'
);

-- OUTPUT TO WEB
SELECT * FROM sensor_data_mqtt;

-- CREATE SINK TO MINIO BUCKET
CREATE TABLE s3_sink (
    device_id STRING,
    temperature DOUBLE,
    humidity DOUBLE,
    topic STRING,
    ingest_datetime TIMESTAMP
) WITH (
    connector = 'filesystem',
    type = 'sink',
    path = 's3::http://minio:9000/warehouse/pih/raw',
    format = 'parquet',
    rollover_seconds = 300, -- 300 seconds = 5 minutes
    time_partition_pattern = '%Y-%m-%d',
    "storage.aws_region" = 'us-east-1',
    "storage.aws_access_key_id" = 'admin',
    "storage.aws_secret_access_key" = 'password',
    "shuffle_by_partition.enabled" = 'true',
    "filename.strategy" = 'uuid'
);

-- WRITE TO S3_SINK
INSERT INTO s3_sink SELECT
    *,
    CAST(current_timestamp(1) AS timestamp) AS ingest_datetime
FROM
    sensor_data_mqtt;

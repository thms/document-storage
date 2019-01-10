web:    bin/puma config.ru -p 3000
db: postgres -D /usr/local/var/postgres
zookeeper: /Users/thomasboltze/Servers/confluent-3.0.0/bin/zookeeper-server-start /Users/thomasboltze/Servers/confluent-3.0.0/etc/kafka/zookeeper.properties
kafka: sleep 15; /Users/thomasboltze/Servers/confluent-3.0.0/bin/kafka-server-start /Users/thomasboltze/Servers/confluent-3.0.0/etc/kafka/server.properties
schema-registry: sleep 30; /Users/thomasboltze/Servers/confluent-3.0.0/bin/schema-registry-start /Users/thomasboltze/Servers/confluent-3.0.0/etc/schema-registry/schema-registry.properties
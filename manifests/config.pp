# == Class kafka::config($zookeeper_hosts = [''])
# 
class kafka::config(
	$zookeeper_hosts                = ["127.0.0.1:2181"],
	$zookeeper_connectiontimeout_ms = 1000000) 
	$kafka_log_file                 = "/var/log/kafka/kafka.log",
	$producer_type                  = "async",
	$producer_batch_size            = 200)
{
	file { "/etc/kafka/log4j.properties":
		content => template("kafka/log4j.properties.erb"),
	}

	file { "/etc/kafka/producer.properties.erb":
		content => template("kafka/producer.properties.erb"),
	}

	file { "/etc/kafka/consumer.properties.erb":
		content => template("kafka/consumer.properties.erb"),
	}
}
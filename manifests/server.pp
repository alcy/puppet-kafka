# == Class kafka::server
# 
class kafka::server(
	$broker_id                              = undef,
	$port                                   = 9092,
	$num_threads                            = 8,
	$log_dir                                = "/tmp/kafka-logs",
	$num_partitions                         = 1,
	log_flush_interval                      = 10000,
	log_default_flush_interval_ms           = 1000, 
	log_default_flush_scheduler_interval_ms = 1000,
	log_retention_hours                     = 168, # 1 week
	log_retention_size                      = -1,
	log_file_size                           = 536870912,
	log_cleanup_interval_mins               = 1) 
{
	# Infer the broker_id from numbers in the hostname
	# if is not manually passed in.
	if (!$broker_id) {
		$broker_id = inline_template("<%= hostname.gsub(/[^\d]/, '').to_i %>")
	}

	# define local variables from kafka::config class for use in ERb template.
	$zookeeper_hosts                = $kafka::config::zookeeper_hosts
	$zookeeper_connectiontimeout_ms = $kafka::config::zookeeper_connectiontimeout_ms

	file { "/etc/kafka/server.properties":
		content => template("kafka/server.properties.erb"),
		require => Class["kafka::config"],
	}

	service { "kafka":
		ensure     => running,
		require    => [Package["kafka"], File["/etc/kafka/server.properties"]]
		hasrestart => true,
		hasstatus  => true,
	}
}
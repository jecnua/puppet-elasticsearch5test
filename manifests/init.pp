#
class elasticsearch5 {

  $node_data = true
  $node_master = true
  $node_name = 'es-01'
  $config_hash = {
    'action.destructive_requires_name' => true,
    'cluster.name' => 'es5.local',
    'discovery.zen.minimum_master_nodes' => '1',
    'http.compression' => true,
    'indices.queries.cache.size' => '30%',
    'network.host' => '0.0.0.0',
    'node.data' => $node_data,
    'node.ingest' => true,
    'node.master' => $node_master,
    'node.name' => $node_name,
    'path.data' => '/usr/share/elasticsearch/data',
    'thread_pool.bulk.queue_size' => '300',
    'transport.bind_host' => '0.0.0.0',
    'xpack.graph.enabled' => false,
    'xpack.monitoring.enabled' => true,
    'xpack.security.enabled' => false,
    'xpack.watcher.enabled' => false,
  }

  package { 'apt-transport-https':
    ensure => installed,
  }->
  class { 'elasticsearch':
    # package_pin => true,
    version           => '5.5.1',
    java_install      => true,
    manage_repo       => true,
    repo_version      => '5.x',
    restart_on_change => true, # Without this installing plugins later does nothing
    jvm_options       => [
      '-Xms1g',
      '-Xmx1g'
    ] # This finishes in /etc/elasticsearch/jvm.options
  }->
  elasticsearch::instance { $node_name:
    config        => $config_hash,
    # init_defaults => { }, # Init defaults hash
    # datadir       => [ ], # Data directory
  }

  # Added plugins
  elasticsearch::plugin { 'discovery-ec2':
    instances => $node_name
  }->
  elasticsearch::plugin { 'repository-s3':
    instances => $node_name
  }->
  elasticsearch::plugin { 'x-pack':
    instances => $node_name
  }->
  elasticsearch::plugin { 'elasticsearch-prometheus-exporter':
    instances => $node_name,
    url       => 'https://github.com/vvanholl/elasticsearch-prometheus-exporter/releases/download/5.2.1.0/elasticsearch-prometheus-exporter-5.2.1.0.zip',
  }
}

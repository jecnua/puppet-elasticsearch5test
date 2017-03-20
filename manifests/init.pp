#
class elasticsearch5 {

  $node_data = true
  $node_master = true
  $node_name = 'es-01'
  $xms = '2g'
  $xmx = '2g'
  $config_hash = {
    'action.destructive_requires_name' => true,
    'cluster.name' => 'es5p-test',
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
    # version           => '5.2.1',
    java_install      => true,
    manage_repo       => true,
    repo_version      => '5.x',
    restart_on_change => true, # Without this installing plugins later does nothing
    jvm_options       => [
      "-Xms${xms}",
      "-Xmx${xmx}",
    ] # This finishes in /etc/elasticsearch/jvm.options
  }->
  elasticsearch::instance { $node_name:
    config        => $config_hash,
    # init_defaults => { }, # Init defaults hash
    # datadir       => [ ], # Data directory
  }->
  file { '/etc/elasticsearch/es-01/es_java.policy':
    ensure => file,
    mode   => '0644',
    owner  => 'elasticsearch',
    group  => 'elasticsearch',
    source => 'puppet:///modules/elasticsearch5/es_java.policy',
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
  elasticsearch::plugin { 'prometheus-exporter': #This must be the name of the direcotory
    instances => $node_name,
    url       => 'https://github.com/vvanholl/elasticsearch-prometheus-exporter/releases/download/5.2.2.0/elasticsearch-prometheus-exporter-5.2.2.0.zip',
  }
}

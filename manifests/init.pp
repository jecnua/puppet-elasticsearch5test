#
class elasticsearch5 {

  package { 'apt-transport-https':
    ensure => installed,
  }->
  class { 'elasticsearch':
    java_install => true,
    manage_repo  => true,
    repo_version => '5.x',
  }->
  elasticsearch::instance { 'es-01': }

}

# == Class grafana::config
#
# This class is called from grafana
#
class grafana::ldap {
  case $::grafana::install_method {
    'docker': {
      if $::grafana::container_cfg {
        $ldap = $::grafana::ldap

        file {  "$::grafana::cfg_folder/ldap.toml":
          ensure  => present,
          owner   => $::grafana::user,
          content => template('grafana/ldap.toml.erb'),
        }
      }
    }
    'package': {
      $ldap       = $::grafana::ldap
      $attributes = $::grafana::attributes
      $adming     = $::grafana::adming
      $writeg     = $::grafana::writeg
      $viewg      = $::grafana::viewg

      file {  "$::grafana::cfg_folder/ldap.toml":
        ensure  => present,
        owner   => $::grafana::user,
        content => template('grafana/ldap.toml.erb'),
        notify  => Service['grafana-server']
      }
    }
    'archive': {
      $ldap = $::grafana::ldap

      file { "${::grafana::install_dir}/conf/ldap.toml":
        ensure  => present,
        content => template('grafana/ldap.toml.erb'),
      }
    }
    default: {
      fail("Installation method ${::grafana::install_method} not supported")
    }
  }
}

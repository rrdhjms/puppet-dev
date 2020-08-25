# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include role::kubernetes::controller
class role::kubernetes::controller {
  include profile::base
  include profile::server
  include profile::kubernetes::controller
}

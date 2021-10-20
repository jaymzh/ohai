# frozen_string_literal: true
#
# Author:: Serdar Sutay (<serdar@chef.io>)
# Copyright:: Copyright (c) Chef Software Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module Ohai
  module Mixin
    module NetworkHelper
      FAMILIES = {
        "inet" => "default",
        "inet6" => "default_inet6",
      }.freeze

      def hex_to_dec_netmask(netmask)
        # example 'ffff0000' -> '255.255.0.0'
        dec = netmask[0..1].to_i(16).to_s(10)
        [2, 4, 6].each { |n| dec = dec + "." + netmask[n..n + 1].to_i(16).to_s(10) }
        dec
      end

      # This does a forward and reverse lookup on the hostname to return what should be
      # the FQDN for the host determined by name lookup (generally DNS)
      #
      def canonicalize_hostname(hostname)
        Addrinfo.getaddrinfo(hostname, nil).first.getnameinfo.first
      end

      def canonicalize_hostname_with_retries(hostname)
        retries = 3
        begin
          canonicalize_hostname(hostname)
        rescue
          retries -= 1
          retry if retries > 0
          hostname
        end
      end
    end
  end
end

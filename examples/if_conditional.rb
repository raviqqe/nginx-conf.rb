#!/usr/bin/env ruby

require 'nginx-conf'


conf = nginx_conf do
  events do
  end

  http do
    server do
      listen 443, :ssl
      server_name :localhost

      location '/' do
        set '$realm', '"Restricted"'

        if_ '$uri ~ /git-uploadpack$' do
          set '$realm', :off
        end

        auth_basic '$realm'

        root 'html'
        index 'index.html', 'index.htm'
      end
    end
  end
end

puts conf

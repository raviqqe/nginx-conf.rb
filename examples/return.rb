#!/usr/bin/env ruby

require 'nginx-conf'


conf = nginx_conf do
  events do
  end

  http do
    server do
      listen 80
      return_ 301, 'https://$host$request_uri'
    end
  end
end

puts conf

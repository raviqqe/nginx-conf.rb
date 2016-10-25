#!/usr/bin/env ruby

require 'nginx-conf'

file = nginx_conf do
  load_module '/usr/lib/nginx/some_module.so'
  load_module '/usr/lib/nginx/another_module.so'

  http do
    server do
      listen 80

      set '$x', 123
      set '$y', 456

      if_ '(some bool)' do
        foo
      end

      if_ '(another bool)' do
        foo
      end
    end

    server do
      listen 443, :ssl

      location '/' do
        fastcgi_param :REMOTE_USER, '$remote_user'
        fastcgi_param :SOME_ENV, 'some_value'
      end
    end
  end
end

puts file

require 'block-is-hash'

require_relative 'compiler'



def nginx_conf &block
  repeats = %i(server load_module fastcgi_param)
  Compiler.new(repeats).compile block_is_hash(repeats, &block)
end

require 'block-is-hash'

require_relative 'compiler'



def nginx_conf &block
  repeats = %i(server load_module fastcgi_param set if_)

  hash = block_is_hash repeats, &block
  replace_if = lambda { |o| replace_elem :if_, :if, o }
  replace_if.call hash
  replace_if.call repeats
  Compiler.new(repeats).compile hash
end


def replace_elem origin, subst, object
  replace = lambda { |o| replace_elem origin, subst, o }

  case object
  when Hash
    new_pairs = {}

    object.each do |key, value|
      case origin
      when key
        object.delete key
        new_pairs[subst] = value
      when value
        object[key] = subst
      else
        replace.call value
      end
    end

    object.merge! new_pairs
  when Array
    object.each_with_index do |value, key|
      if value == origin
        object[key] = subst
      else
        replace.call value
      end
    end
  end
end

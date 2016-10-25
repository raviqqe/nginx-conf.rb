class Compiler
  @@spaces = ' ' * 4

  def initialize repeats
    @repeats = repeats
  end

  def compile hash
    @indents = 0
    compile_hash_without_brackets hash
  end

  def compile_elem object
    case object
    when Hash
      compile_hash object
    when Array
      object.map{ |o| compile_elem(o) }.join(' ')
    when -> (o) { o.respond_to? :to_s }
      object.to_s
    else
      raise "The object doesn't respond to to_s method.: #{o}"
    end
  end

  def compile_hash hash
    s = "{\n"
    @indents += 1
    s += compile_hash_without_brackets hash
    @indents -= 1
    s + indent('}')
  end

  def compile_hash_without_brackets hash
    hash.map do |key, values|
      if @repeats.include? key
        values.map do |values_per_item|
          compile_hash_item key, values_per_item
        end.join
      else
        compile_hash_item key, values
      end
    end.join
  end

  def compile_hash_item key, values
    values = [values] if not values.is_a? Array
    values[0] = "(#{values[0]})" if key == :if

    values_str = compile_elem(values)
    indent(key.to_s + (values_str != '' ? ' ' + values_str : '') \
           + (values[-1].is_a?(Hash) ? "" : ";")) + "\n"
  end

  def indent line
    @@spaces * @indents + line
  end
end

require "json"

class Flattenator::Hash
  attr_reader *%i(
    flattened
    source
  )

  def initialize(source, include_unflattened: true)
    raise ArgumentError.new("Source object does not respond to each_pair") unless source.respond_to?(:each_pair)

    @source = source
    @flattened = {}
    @include_unflattened = !!include_unflattened

    source.each_pair do |key, value|
      flatten(key: key, value: value, destination: @flattened)
    end
  end

  def include_unflattened?
    @include_unflattened
  end

  private def flatten(key:, value:, destination:, prefix: nil)
    fullkey = [prefix, key].compact.join("_").tr("-", "_")

    case value
    when Hash
      destination[fullkey] = JSON.dump(value) if include_unflattened?
      value.each do |k, v|
        flatten(key: k, value: v, destination: destination, prefix: fullkey)
      end
    when Array
      destination[fullkey] = JSON.dump(value) if include_unflattened?
      value.each_with_index do |item, i|
        destination["#{fullkey}_#{i}"] = item
      end
    else
      destination[fullkey] = value
    end
  end
end

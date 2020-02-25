class Flattenator::Hash
  attr_reader :flattened, :source

  def initialize(source)
    raise ArgumentError.new("Source object does not respond to each_pair") unless source.respond_to?(:each_pair)

    @source = source
    @flattened = {}
    source.each_pair do |key, value|
      flatten(key: key, value: value, destination: @flattened)
    end
  end


  private def flatten(key:, value:, destination:, prefix: nil)
    fullkey = [prefix, key].compact.join("_").tr("-", "_")

    case value
    when Hash
      # destination[fullkey] = value.inspect
      value.each do |k, v|
        flatten(key: k, value: v, destination: destination, prefix: fullkey)
      end
    when Array
      # destination[fullkey] = value.join(",")
      value.each_with_index do |item, i|
        destination["#{fullkey}_#{i}"] = item
      end
    else
      destination[fullkey] = value
    end
  end
end

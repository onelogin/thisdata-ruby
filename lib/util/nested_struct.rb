# Public: turns JSON into a deeply nested OpenStruct. Will find Hashes
# with Hashes and within Arrays.
class NestedStruct < OpenStruct
  def initialize(json=Hash.new)
    @table = {}

    json.each do |key, value|
      @table[key.to_sym] =  if value.is_a? Hash
                              self.class.new(value)
                            elsif value.is_a? Array
                              # Turn all the jsons in the array into DeepStructs
                              value.collect do |i|
                                i.is_a?(Hash) ? self.class.new(i) : i
                              end
                            else
                              value
                            end

      new_ostruct_member(key)
    end
  end

  def as_json(*args)
    json = super
    json["table"]
  end
end
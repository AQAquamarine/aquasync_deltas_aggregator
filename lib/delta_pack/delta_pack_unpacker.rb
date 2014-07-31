# Has a responsibility to unpack a DeltaPack hash.
# @author kaiinui
class DeltaPackUnpacker
  # id [String] UUID
  attr_accessor :id
  # deltas [Array] An array of deltas.
  attr_accessor :deltas

  def initialize
    self.deltas = {}
  end

  # unpacks a DeltaPack. You can extract data from #id, #deltas
  # @param delta_pack [Hash] A DeltaPack
  # @return [DeltaPackUnpacker]
  def unpack(delta_pack)
    self.id = delta_pack["_id"].downcase
    delta_pack.each do |key, value|
      next if key == "_id"
      deltas[key] = value
    end
    self
  end
end
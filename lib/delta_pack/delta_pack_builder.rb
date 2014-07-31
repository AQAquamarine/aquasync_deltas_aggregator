require 'simple_uuid'
require 'json'

# Has a responsibility to build a DeltaPack hash.
# @author kaiinui
# @example
#   builder = DeltaPackBuilder.new
#   builder.push_documents(Book.all)
#   builder.push_documents(Author.all)
#   builder.delta_pack
# @note Please implement #_name and #to_h to Models. (DeltaPackBuilder requirements.)
class DeltaPackBuilder
  # delta_pack [Hash]
  attr_accessor :delta_pack

  def initialize
    self.delta_pack = {}
    self.delta_pack["_id"] = uuid
    self.delta_pack["latestUST"] = 0
  end

  # pushes a document into a DeltaPack.
  # @param document [Aquasync::Base] a resource which inherits Aquasync::Base
  def push(document)
    name = document._name
    initialize_array(name)
    self.delta_pack[name].push document.to_h
    update_ust(document)
  end

  # pushes documents into a DeltaPack.
  # @param documents [Array] resources which inherits Aquasync::Base
  def push_documents(documents)
    documents.each {|d| push(d)}
  end

  # updates latestUST
  # @param document [Aquasync::Base]
  def update_ust(document)
    if document.ust > latest_ust
      self.delta_pack["latestUST"] = document.ust
    end
  end

  # returns latestUST of current DeltaPack
  # @return [Integer]
  def latest_ust
    self.delta_pack["latestUST"]
  end

  # returns built DeltaPack represented in JSON
  # @return [String] JSON string
  def json
    delta_pack.to_json
  end

  # returns built DeltaPack represented in pretty printed JSON
  # @return [String] pretty printed JSON
  def pretty_json
    JSON.pretty_generate(delta_pack)
  end

  private

  # @param [String] name model name
  def initialize_array(name)
    self.delta_pack[name] = [] unless self.delta_pack[name]
  end

  # @return [String] UUIDv1
  def uuid
    SimpleUUID::UUID.new.to_guid
  end
end
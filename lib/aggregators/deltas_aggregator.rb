require_relative '../delta_pack/delta_pack_builder'

# Has responsibility to
# 1. Commit a DeltaPack to registered models.
# 2. Pack a DeltaPack from registered models.
# @author kaiinui
# @example Initialization
#   aggregator = DeltasAggregator.new
#   aggregator.regist_model_manager(Book, Author)
# @example Obtain a DeltaPack from registered models.
#   aggregator.pack_deltas(ust)
# @example Commit a DeltaPack to registered models.
#   aggregator.commit_delta_pack(delta_pack)
# @example Add begin_of_association_chain options
#   aggregator.pack_deltas(ust, begin_of_association_chain: current_user)
# @example Add append_attributes options
#   aggregator.pack_deltas(ust, append_attributes: {all: {user_id: "some_id"}})
# @note Please implement #aq_deltas and #aq_commit_deltas to models. (DeltasAggregator requirement.)
class DeltasAggregator
  attr_accessor :model_managers

  def initialize
    self.model_managers = {}
  end

  # Adds target models to aggregate.
  # @param klass [Aquasync::Base]
  # @return [NilClass]
  def add_model_manager(*klasses)
    klasses.each do |klass|
      name = klass.name
      model_managers[name] = klass
    end
  end

  # Returns registered model manager from name.
  # @param [String] name
  # @return [Aquasync::Base]
  def model_manager_class(name)
    model_managers[name]
  end

  # Unpacks a DeltaPack and delegates #aq_commit_deltas to registered model managers.
  # @param [Hash] A DeltaPack (https://github.com/AQAquamarine/aquasync-protocol/blob/master/deltapack.md)
  # @return [NilClass]
  def commit_delta_pack(delta_pack, opts = {})
    unpacked_deltas = DeltaPackUnpacker.new.unpack(delta_pack).deltas
    unpacked_deltas.each do |model_name, deltas|
      manager = model_manager_class(model_name)
      manager.aq_commit_deltas deltas, opts
    end
  end

  # Packs deltas collected from registered model managers via #aq_deltas to DeltaPack.
  # @param [Integer] from_ust latestUST
  # @return [Hash] A DeltaPack (https://github.com/AQAquamarine/aquasync-protocol/blob/master/deltapack.md)
  def pack_deltas(from_ust, opts = {})
    builder = DeltaPackBuilder.new
    model_managers.each do |model_name, model_manager|
      builder.push_documents model_manager.aq_deltas(from_ust, opts)
    end
    builder.delta_pack
  end

  # @deprecated
  def regist_model_manager(*klasses)
    warn "DEPRECATED"
    add_model_manager(*klasses)
  end
end
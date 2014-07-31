require_relative '../spec_helper'

describe DeltasAggregator do
  before(:context) do
    DatabaseCleaner.clean
    valid_hoge.save
    valid_hoge.save
    valid_huga.save
  end

  let(:aggregator) {
    aggregator = DeltasAggregator.new
    aggregator.regist_model_manager(Hoge, Huga)
    aggregator
  }

  describe "#pack_deltas" do
    context "when older latestUST is given" do
      let(:delta_pack) { aggregator.pack_deltas(1000000000) }

      it { expect(delta_pack).to include "_id" }
      it { expect(delta_pack["Hoge"].size).to eq 2 }
      it { expect(delta_pack["Huga"].size).to eq 1 }
    end

    context "when same latestUST is given" do
      let(:delta_pack) { aggregator.pack_deltas(1934567789) }

      it { expect(delta_pack).to include "_id" }
      it { expect(delta_pack["Hoge"].try(:size) || 0).to eq 0 }
    end

    context "when newer latestUST is given" do
      let(:delta_pack) { aggregator.pack_deltas(2000000000) }

      it { expect(delta_pack).to include "_id" }
      it { expect(delta_pack["Hoge"].try(:size) || 0).to eq 0 }
      it { expect(delta_pack["Huga"].try(:size) || 0).to eq 0 }
    end
  end

  describe "#commit_delta_pack" do
    context "when existed gid is given" do
      context "when older localTimestamp is given" do
        before(:each) do
          aggregator.commit_delta_pack(older_ust_delta_pack)
        end

        it("should not update the record") { expect(Hoge.find_by(gid: "550e8400-e29b-41d4-a716-446655440000").hoge).to eq "before" }
      end

      context "when newer localTimestamp is given" do
        before(:each) do
          aggregator.commit_delta_pack(newer_ust_delta_pack)
        end

        it("should update the record") { expect(Hoge.find_by(gid: "550e8400-e29b-41d4-a716-446655440000").hoge).to eq "after" }
        it("should update localTimestamp") { expect(Hoge.find_by(gid: "550e8400-e29b-41d4-a716-446655440000").localTimestamp).to eq 2034567789 }
      end
    end

    context "when unknown gid is given" do
      before(:each) do
        aggregator.commit_delta_pack(new_gid_delta_pack)
      end

      it("should save new record") { expect(Hoge.find_by(gid: "aaaaaaaa-e29b-41d4-a716-446655440000").hoge).to eq "new" }
    end
  end
end
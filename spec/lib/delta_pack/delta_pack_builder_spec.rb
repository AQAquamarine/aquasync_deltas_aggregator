require_relative '../spec_helper'

describe DeltaPackBuilder do
  before(:context) {
    DatabaseCleaner.clean

    valid_hoge.save
    valid_hoge.save
    valid_hoge.save
    valid_huga.save
  }

  let(:builder) { DeltaPackBuilder.new }

  describe "#push" do
    before(:each) do
      builder.push_documents Hoge.all
      builder.push_documents Huga.all
    end
    let(:hoge) { valid_hoge }
    let(:huga) { valid_huga }
    let(:ust) { huga.ust }

    it { expect(builder.delta_pack).to include "_id" }
    it { expect(builder.delta_pack).to include "latestUST" }
    it { expect(builder.delta_pack).to include "Hoge" }
    it { expect(builder.delta_pack).to include "Huga" }
    it { expect(builder.delta_pack["Hoge"].size).to eq 3 }
    it { expect(builder.delta_pack["Huga"].size).to eq 1 }
  end

  context '#uuid' do
    it("returns UUID") { expect(builder.send(:uuid)).not_to eq nil }
  end
end
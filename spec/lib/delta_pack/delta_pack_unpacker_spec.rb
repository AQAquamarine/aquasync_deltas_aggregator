require_relative '../spec_helper'

describe DeltaPackUnpacker do
  let(:unpacker) { DeltaPackUnpacker.new }
  let(:delta_pack) {
    {
        "_id" => "550E8400-E29B-41D4-A716-446655dd0000",
        "Book" => [
            {
                "id" => "1",
                "title" => "The Little Prince"
            },
            {
                "id" => "2",
                "title" => "The Little Prince"
            }
        ],
        "Author" => [
            {
                "id" => "1",
                "name" => "Some Author"
            }
        ]
    }
  }

  context "#unpack" do
    let(:unpacked_delta) { unpacker.unpack(delta_pack).deltas }
    it("downcase UUID") { expect(unpacker.unpack(delta_pack).id).to eq "550e8400-e29b-41d4-a716-446655dd0000" }
    it { expect(unpacked_delta).to include "Book" }
    it { expect(unpacked_delta).to include "Author" }
    it { expect(unpacked_delta["Book"].size).to eq 2 }
    it { expect(unpacked_delta["Author"].size).to eq 1 }
  end
end
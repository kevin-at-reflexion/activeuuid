require 'spec_helper'

describe UUIDTools::UUID do
  let(:input) { 'e4618518-cb9f-11e1-aa7c-14dae903e06a' }
  let(:uuid) { described_class.parse input }

  describe '#as_json' do
    subject { uuid.as_json }
    it { is_expected.to eq input }
  end

  describe '#to_param' do
    subject { uuid.as_json }
    it { is_expected.to eq input }
  end

  describe '#quoted_id' do
    subject { uuid.quoted_id }
    it { is_expected.to eq "x'e4618518cb9f11e1aa7c14dae903e06a'" }
  end

  describe '.serialize' do
    subject { described_class }
    let(:raw) { uuid.raw }
    let(:hex) { uuid.hexdigest }
    let(:zero) { UUIDTools::UUID.new(0,0,0,0,0,[0,0,0,0,0,0]) }
    let(:lazy) { LazyUUID.new(raw) }

    specify { expect(subject.serialize(input)).to eq uuid }
    specify { expect(subject.serialize(uuid)).to eq uuid }
    specify { expect(subject.serialize(lazy)).to eq uuid }
    specify { expect(subject.serialize(hex)).to eq uuid }
    specify { expect(subject.serialize(raw)).to eq uuid }
    specify { expect(subject.serialize('')).to eq zero }
    specify { expect(subject.serialize(5)).to be_nil }
    specify { expect(subject.serialize(nil)).to be_nil }
  end
end

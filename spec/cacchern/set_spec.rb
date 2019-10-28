# frozen_string_literal: true

require 'cacchern'
require 'redis'
require_relative 'caches/read_set'
require_relative 'caches/read_member'
require_relative 'caches/simple_set'

RSpec.describe Cacchern::Set do
  describe '.value_class' do
    context 'when set contain_class' do
      it { expect(ReadSet.value_class).to eq(ReadMember) }
    end

    context 'when do not set contain_class' do
      it { expect(SimpleSet.value_class).to eq(Cacchern::Member) }
    end
  end

  describe '#initialize' do
    let(:set_instance) { ReadSet.new('base') }

    it { expect(set_instance.key).to eq 'read_set:base' }
  end

  describe '#all' do
    let(:set_value) { 100 }

    let(:set_instance) { ReadSet.new('base') }

    before do
      Redis.current.sadd set_instance.key, set_value
      Redis.current.sadd set_instance.key, 101
    end

    it { expect(set_instance.all.first).to be_a_kind_of(ReadMember) }
    it { expect(set_instance.all.first.value.to_i).to eq set_value }
    it { expect(set_instance.all.count).to eq 2 }
  end

  describe '#add' do
    let(:set_value) { 100 }

    let(:set_instance) { ReadSet.new('base') }

    it { expect(set_instance.add(ReadMember.new(set_value))).to be_truthy }
    it { expect(set_instance.add(value: set_value)).to be_falsey }
    it { expect(set_instance.add(ReadMember.new('hoge'))).to be_falsey }

    it do
      values = Redis.current.smembers set_instance.key
      expect(values).to be_empty
    end

    it do
      set_instance.add(ReadMember.new(set_value))
      values = Redis.current.smembers set_instance.key
      expect(values.first.to_i).to eq set_value
    end

    it do
      set_instance.add(ReadMember.new('hoge'))
      values = Redis.current.smembers set_instance.key
      expect(values).to be_empty
    end
  end

  describe '#remove' do
    let(:set_instance) { ReadSet.new('base') }

    context 'when remove by key' do
      before do
        set_instance.add(ReadMember.new(100))
        set_instance.add(ReadMember.new(200))
      end

      it do
        expect { set_instance.remove(ReadMember.new(100)) }.to change { set_instance.all.count }.from(2).to(1)
      end
    end
  end

  describe '#remove_all' do
    let(:set_instance) { ReadSet.new('base') }

    before do
      set_instance.add(ReadMember.new(100))
      set_instance.add(ReadMember.new(200))
      set_instance.add(ReadMember.new(300))
    end

    it do
      expect { set_instance.remove_all }.to change { set_instance.all.count }.from(3).to(0)
    end
  end
end

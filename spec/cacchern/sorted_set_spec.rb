# frozen_string_literal: true

require 'cacchern'
require 'redis'
require_relative 'caches/score_sorted_set'
require_relative 'caches/score_value'
require_relative 'caches/simple_sorted_set'

RSpec.describe Cacchern::SortedSet do
  describe '.value_class' do
    context 'when set contain_class' do
      it { expect(ScoreSortedSet.value_class).to eq(ScoreValue) }
    end

    context 'when do not set contain_class' do
      it { expect(SimpleSortedSet.value_class).to eq(Cacchern::SortableMember) }
    end
  end

  describe '#initialize' do
    let(:sorted_set_instance) { ScoreSortedSet.new('base') }

    it { expect(sorted_set_instance.key).to eq 'score_sorted_set:base' }
  end

  describe '#get' do
    let(:set_key) { 1 }
    let(:set_value) { 100 }

    let(:sorted_set_instance) { ScoreSortedSet.new('base') }

    before { Redis.current.zadd sorted_set_instance.key, set_value, set_key }

    it { expect(sorted_set_instance.get(set_key)).to be_a_kind_of(ScoreValue) }
    it { expect(sorted_set_instance.get(set_key).key).to eq set_key }
    it { expect(sorted_set_instance.get(set_key).value).to eq set_value }
  end

  describe '#add' do
    let(:set_key) { 1 }
    let(:set_value) { 100 }

    let(:sorted_set_instance) { ScoreSortedSet.new('base') }

    it { expect(sorted_set_instance.add(ScoreValue.new(set_key, set_value))).to be_truthy }
    it { expect(sorted_set_instance.add(key: set_key, value: set_value)).to be_falsey }

    it do
      value = Redis.current.zscore sorted_set_instance.key, set_key
      expect(value).to be_nil
    end

    it do
      sorted_set_instance.add(ScoreValue.new(set_key, set_value))
      value = Redis.current.zscore sorted_set_instance.key, set_key
      expect(value).to eq set_value
    end
  end

  describe '#where_by_score' do
    let(:sorted_set_instance) { ScoreSortedSet.new('base') }
    let(:value1) { ScoreValue.new(1, 100) }
    let(:value2) { ScoreValue.new(2, 200) }

    before do
      sorted_set_instance.add(value1)
      sorted_set_instance.add(value2)
    end

    it { expect(sorted_set_instance.where_by_score.count).to eq 2 }
    it { expect(sorted_set_instance.order(:asc)).to all(be_a(ScoreValue)) }
  end

  describe '#order' do
    let(:sorted_set_instance) { ScoreSortedSet.new('base') }
    let(:value1) { ScoreValue.new(1, 100) }
    let(:value2) { ScoreValue.new(2, 200) }

    before do
      sorted_set_instance.add(value1)
      sorted_set_instance.add(value2)
    end

    it { expect(sorted_set_instance.order(:asc).count).to eq 2 }
    it { expect(sorted_set_instance.order(:asc)).to all(be_a(ScoreValue)) }

    it do
      expect(sorted_set_instance.order(:asc).first.key).to eq value1.key.to_s
      expect(sorted_set_instance.order(:asc).last.key).to eq value2.key.to_s
    end

    it do
      expect(sorted_set_instance.order(:desc).first.key).to eq value2.key.to_s
      expect(sorted_set_instance.order(:desc).last.key).to eq value1.key.to_s
    end
  end
end

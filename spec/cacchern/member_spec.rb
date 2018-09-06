# frozen_string_literal: true

require 'cacchern'
require 'redis'
require_relative 'caches/read_member'

RSpec.describe Cacchern::Member do
  describe '#initialize' do
    context 'when value is not integer' do
      it { expect(ReadMember.new(value: 'aaaaa')).to be_invalid }
    end
  end
end
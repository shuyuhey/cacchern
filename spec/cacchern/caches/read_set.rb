# frozen_string_literal: true

require_relative 'read_member'

class ReadSet < Cacchern::Set
  contain_class ReadMember
end

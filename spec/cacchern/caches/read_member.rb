class ReadMember < Cacchern::Member
  validates :value, presence: true, numericality: { only_integer: true }
end
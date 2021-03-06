class User < ApplicationRecord
  authenticates_with_sorcery!
  
  validates :name, presence: true, length: { maximum: 255 }
  validates :staff_no, presence: true, uniqueness: true	
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :trip, length: { maximum: 255 }
  validates :party_type, length: { maximum: 255 }
  
  has_many :shifts
  has_many :having_skills
  has_many :skills, through: :having_skills
  has_many :shift_dicisions
  has_many :parties, through: :shift_dicisions
  
  def have(skill)
    self.having_skills.find_or_create_by(skill_id: skill.id)
  end
  
  def unhave(skill)
    have = self.haves.find_by(skill_id: skill.id)
    have.destroy if have
  end
  
  def have?(skill)
    self.having_skills.include?(skill)
  end
  
  def work(party)
    self.shift_dicisions.find_or_create_by(party_id: party.id)
  end
  
  def unwork(party)
    work = self.works.find_by(party_id: party.id)
    work.destroy if work
  end
  
  def work?(party)
    self.shift_dicisions.include?(party)
  end
  
end

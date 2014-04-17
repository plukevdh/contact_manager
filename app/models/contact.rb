class Contact < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true

  scope :alphabetical, -> { order(:last_name, :first_name) }

  def full_name
    [first_name, last_name].join(" ")
  end

  def full_name=(name)
    self.first_name, self.last_name = name.split(" ", 2)
  end
end

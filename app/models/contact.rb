class Contact < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true, allow_blank: false
  validates :postcode, length: { is: 5 }, allow_nil: true

  scope :alphabetical, -> { order(:last_name, :first_name) }

  VALID_ADDRESS_KEYS = [
    :street,
    :state,
    :city,
    :postcode
  ]

  alias_attribute :zip, :postcode

  def full_name
    [first_name, last_name].join(" ")
  end
  alias_method :name, :full_name

  def full_name=(name)
    self.first_name, self.last_name = name.split(" ", 2)
  end
  alias_method :name=, :full_name=

  def address=(address_hash)
    VALID_ADDRESS_KEYS.each do |key|
      send "#{key}=", address_hash[key]
    end
  end

  def as_json(options={})
    super options.merge(methods: [:full_name], except: [:first_name, :last_name])
  end
end

class Customer < ApplicationRecord
  validates :full_name, :email, :identification_code, presence: true
  validates :email, uniqueness: true

  def self.create_or_update_from_bunny(payload)
    customer = find_or_initialize_by(email: payload['email'])

    customer.assign_attributes(
      email: payload['email'],
      full_name: payload['full_name'],
      identification_code: payload['identification_code']
    )

    customer.save!
  end
end

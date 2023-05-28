# frozen_string_literal: true

class BunnyConsumer
  VALID_MODELS = {
    'customer' => 'Customer'
  }

  class << self
    def call!(properties, payload)
      # return false unless VALID_MODELS.include?(properties[:type])

      Customer.create_or_update_from_bunny(JSON.parse(payload))
    end

    private

    def model_klass(type)
      VALID_MODELS[type].constantize
    end
  end
end

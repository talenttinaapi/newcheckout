module PriceCalculator
    module Models
      class PriceAndTime
        include ActiveModel::Model
        include Virtus.model
  
        attribute :price, Money
        attribute :time_hours, Integer
        attribute :variables_used, Hash
        attribute :timing_formulas_used, Hash
        attribute :calculated_incidence_rate, Float
        attribute :incidence_rate, Float
        attribute :formulas_to_be_exposed, Array
  
        validates :price, presence: true, numericality: {greater_than: 0}
        validates :time_hours, presence: true, numericality: {only_integer: true, greater_than: 0}
        validates :timing_formulas_used, presence: true
        validates :incidence_rate, presence: true
      end
    end
  end
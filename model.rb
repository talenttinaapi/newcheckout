module PriceCalculator
    module PricingSchemes
      class FlatRate < PriceCalculator::PricingSchemes::Base
        # Required Variables
        pricing_variables :additional_respondent_batch_cost_high_ir,
          :additional_respondent_batch_cost_low_ir,
          :flat_product_price_high_ir,
          :flat_product_price_low_ir,
          :number_of_surveys,
          :panel_size,
          :sample_cost,
          :is_sequential,
          :incidence_rate,
          :respondent_count_boundary
  
        # Variables that can be nil
        optional_pricing_variables :partner_sample_fee,
          :product_partner_share,
          :incidence_rate_price_no_markup,
          :ir_boundary_price_override
  
        # Methods defined in the scheme that are returned for use in the calculator
        custom_variables :partner_share,
          :product_sample_cost,
          :quantifiable,
          :quantity_ordered,
          :total_respondent_count,
          :unit_price
  
        # All AddOns
        define_addon :custom_survey_questions, PriceCalculator::PricingSchemes::Addons::CustomSurveyQuestions
        define_addon :eye_square, PriceCalculator::PricingSchemes::Addons::Eyesquare
        define_addon :lumen, PriceCalculator::PricingSchemes::Addons::Lumen
        define_addon :optional_measures, PriceCalculator::PricingSchemes::Addons::OptionalMeasures
        define_addon :post_screening_custom_questions, PriceCalculator::PricingSchemes::Addons::PostScreeningCustomQuestions
        define_addon :zappi_eyesquare, PriceCalculator::PricingSchemes::Addons::ZappiEyesquare
  
        define_multi_line_addon :optional_measures_module, PriceCalculator::PricingSchemes::Addons::OptionalMeasuresModule
  
        IR_THRESHOLD = 0.5
        IR_PRICE_MARKUP = 1.3
        ADDITIONAL_RESPONDENT_BATCH_SIZE = 100
  
        def component_count
          is_sequential ? 1 : number_of_surveys
        end
  
        def charge_high_ir_rate?
          case ir_boundary_price_override
          when "charge_high_ir_rate"
            true
          when "charge_low_ir_rate"
            false
          else
            incidence_rate >= IR_THRESHOLD
          end
        end
  
        def base_price
          charge_high_ir_rate? ? flat_product_price_high_ir : flat_product_price_low_ir
        end
  
        def partner_revenue
          (product_price - calculated_partner_sample_fee * panel_size) * partner_share
        end
  
        def calculated_partner_sample_fee
          (incidence_rate_price_no_markup.present? && incidence_rate_price_no_markup * IR_PRICE_MARKUP) || partner_sample_fee || zero_money
        end
  
        def partner_share
          product_partner_share.to_f
        end
  
        def product_price
          base_price + additional_sample_price
        end
  
        def product_sample_cost
          sample_cost
        end
  
        def quantifiable
          !is_sequential
        end
  
        def quantity_ordered
          component_count
        end
  
        def respondent_cost_per_batch
          charge_high_ir_rate? ? additional_respondent_batch_cost_high_ir : additional_respondent_batch_cost_low_ir
        end
  
        def additional_respondent_batches
          # Get the difference between the panel size and the optimal panel size
          # If the panel size is less than the optimal panel size, then the difference is 0
          delta = [0, panel_size - respondent_count_boundary].max
          # Get difference in batches of hundreds and round up e.g. 1-100 = 1, 101-200 = 2
          (delta.to_f / ADDITIONAL_RESPONDENT_BATCH_SIZE).ceil
        end
  
        def sample_price
          calculated_partner_sample_fee * panel_size
        end
  
        def additional_sample_price
          additional_respondent_batches * respondent_cost_per_batch
        end
  
        def total
          zappi_revenue + partner_revenue
        end
  
        def total_respondent_count
          component_count * panel_size
        end
  
        def unit_price
          product_price
        end
  
        def zappi_revenue
          product_price - partner_revenue
        end
  
        def zero_money
          Money.new(0.0, currency)
        end
      end
    end
  end
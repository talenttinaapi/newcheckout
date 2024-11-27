require 'minitest/autorun'
require_relative 'model'

class FlatRateTest < Minitest::Test
    def setup
        @flat_rate = PriceCalculator::PricingSchemes::FlatRate.new(
            additional_respondent_batch_cost_high_ir: 10,
            additional_respondent_batch_cost_low_ir: 5,
            flat_product_price_high_ir: 100,
            flat_product_price_low_ir: 50,
            number_of_surveys: 3,
            panel_size: 200,
            sample_cost: 20,
            is_sequential: false,
            incidence_rate: 0.6,
            respondent_count_boundary: 150,
            partner_sample_fee: 15,
            product_partner_share: 0.2,
            incidence_rate_price_no_markup: nil,
            ir_boundary_price_override: nil
        )
    end

    def test_component_count
        assert_equal 3, @flat_rate.component_count
    end

    def test_charge_high_ir_rate
        assert @flat_rate.charge_high_ir_rate?
    end

    def test_base_price
        assert_equal 100, @flat_rate.base_price
    end

    def test_partner_revenue
        assert_equal 14, @flat_rate.partner_revenue
    end

    def test_calculated_partner_sample_fee
        assert_equal 15, @flat_rate.calculated_partner_sample_fee
    end

    def test_partner_share
        assert_equal 0.2, @flat_rate.partner_share
    end

    def test_product_price
        assert_equal 150, @flat_rate.product_price
    end

    def test_product_sample_cost
        assert_equal 20, @flat_rate.product_sample_cost
    end

    def test_quantifiable
        assert @flat_rate.quantifiable
    end

    def test_quantity_ordered
        assert_equal 3, @flat_rate.quantity_ordered
    end

    def test_respondent_cost_per_batch
        assert_equal 10, @flat_rate.respondent_cost_per_batch
    end

    def test_additional_respondent_batches
        assert_equal 1, @flat_rate.additional_respondent_batches
    end

    def test_sample_price
        assert_equal 3000, @flat_rate.sample_price
    end

    def test_additional_sample_price
        assert_equal 10, @flat_rate.additional_sample_price
    end

    def test_total
        assert_equal 136, @flat_rate.total
    end

    def test_total_respondent_count
        assert_equal 600, @flat_rate.total_respondent_count
    end

    def test_unit_price
        assert_equal 150, @flat_rate.unit_price
    end

    def test_zappi_revenue
        assert_equal 136, @flat_rate.zappi_revenue
    end

    def test_zero_money
        assert_equal Money.new(0.0, @flat_rate.currency), @flat_rate.zero_money
    end
end
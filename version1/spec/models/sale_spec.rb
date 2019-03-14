require 'spec_helper'

describe Sale do
  describe '.after_create' do
    it 'should call SaleNotification.broadcast with the new sale' do
      SaleNotification.should_receive(:broadcast) do |a_sale|
        expect(a_sale.id).to eq Sale.last.id
      end

      user = create(:user_with_current_assignation)

      create(:sale, user: user)
    end
  end
end

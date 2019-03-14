require 'spec_helper'

describe SaleNotification do
  describe '.broadcast' do
    let(:mail) { double('Mail').as_null_object }

    context 'with users subscribed to email notification' do
      it 'should deliver email to those users' do
        users = create_list(:user, 5, email_notification: true)
        sale = create(:sale)

        mail.should_receive(:deliver)

        SaleMailer.should_receive(:new_sale)
          .with(sale, users.map(&:email))
          .and_return(mail)

        SaleNotification.broadcast(sale)
      end
    end

    context 'without user subscribed to email notification' do
      it 'should not deliver any email' do
        sale = create(:sale)

        mail.should_not_receive(:deliver)

        SaleMailer.should_not_receive(:new_sale)

        SaleNotification.broadcast(sale)
      end
    end
  end
end

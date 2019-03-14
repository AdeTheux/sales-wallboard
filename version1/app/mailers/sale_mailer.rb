class SaleMailer < ActionMailer::Base
  default from: "no-reply@emea-sentry.com"
  include ApplicationHelper
  helper :application

  def new_sale(sale, users)
    @sale = sale
    @stats = SaleStatistic.new
    @user_stats = UserSaleStatistic.new(sale.user)

    mail(to: users,
         subject: "Sentry Deal - MMR #{currency(sale.mrr)} - #{sale.user.username} - #{sale.company}")
  end
end

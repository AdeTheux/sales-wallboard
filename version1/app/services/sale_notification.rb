module SaleNotification
  def self.broadcast(sale)
    users = User.subscribed_to_email_notifications

    SaleMailer.new_sale(sale, users.map(&:email)).deliver if users.any?
  end
end

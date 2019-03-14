class Sale < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  attr_accessible :arr, :date, :company

  after_create {|sale| SaleNotification.broadcast(sale) }

  def mrr
    arr/12.0
  end
end

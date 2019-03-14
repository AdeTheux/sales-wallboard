module ApplicationHelper

  include ActionView::Helpers::NumberHelper

  def currency(value)
    number_to_currency value, :precision => 2
  end

  def percentage(args = {})
    total = args.fetch(:total).to_f
    done = args.fetch(:done).to_f

    number_to_percentage(done / total * 100, precision: 0)
  end
end

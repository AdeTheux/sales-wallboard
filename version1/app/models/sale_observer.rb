require 'notifications'


class SaleObserver < ActiveRecord::Observer

  include ApplicationHelper

  def after_create(sale)
    # Send a notification no matter what.
    message = "#{sale.user.name} just scored a #{currency(sale.mrr)} MRR deal!<br>Client name: #{sale.company}"
    if (200..500).include? sale.mrr
      Notifications.send(message, {:big => true, :sound => Notifications::SOUNDS[:blip]})
    elsif sale.mrr > 500
      Notifications.send(message, {:big => true, :sound => Notifications::SOUNDS[:trumpet]})
    else
      Notifications.send(message, {:big => true})
    end

    # Gather sales and forget the last one.
    today = Date.today
    first_day = Date.civil(today.year, today.month, 1)
    last_day = Date.civil(today.year, today.month, -1)

    quarter = Quarter.where(current: true).first
    total_qarr = Sale.where(['date between ? and ?', quarter.begin_date, quarter.end_date]).sum(:arr).to_f
    total_marr = sale.user.sales.where(['date between ? and ?', first_day, last_day]).sum(:arr).to_f

    # Grab the targets
    q_target = quarter.target
    m_target = sale.user.current_assignation.month_target

    # Compute delta
    q_delta = q_target - total_qarr
    m_delta = m_target - total_marr

    # If we have reached the goal, for the first time, trigger notifications.
    if m_delta <= 0  && m_delta.abs < sale.arr
      message = "#{sale.user.name} just hit his monthly target!"
      Notifications.send(message, {:big => true, :sound => Notifications::SOUNDS[:lmfao]})
    end

    if q_delta <= 0 && q_delta.abs < sale.arr
      message = "Quarter target hit!"
      Notifications.send(message, {:big => true, :sound => Notifications::SOUNDS[:siren]})
    end

  end

end

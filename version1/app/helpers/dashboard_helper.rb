module DashboardHelper

  def cap_hundred(x)
    if x > 100
      100
    else
      x
    end
  end

  def bar(type, value)
    render :partial => 'dashboard/bar', :locals => {:type => type, :value => value}
  end

end

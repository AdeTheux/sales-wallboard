class StaticController < ApplicationController
  def index
  end

  def sales
    @wallboards = Iframe.where(department: 'sales')
  end

  def presales
    @wallboards = Iframe.where(department: 'presales')
  end
end

class HomeController < ApplicationController
  before_action :authorize_user!
  def index
  end

  def about
  end
end

class Admin::DashboardController < ApplicationController
  def index
    @total_users = User.count
    @total_income = Booking.confirmed.joins(:service).sum(:price_cents) / 100.0
    @users_by_role = User.group(:role).count
  end
end

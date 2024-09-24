class Admin::InquiriesController < Admin::BaseController
  before_action :authenticate_admin!

  def index
    @inquiries = Inquiry.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @inquiry = Inquiry.find(params[:id])
  end
end

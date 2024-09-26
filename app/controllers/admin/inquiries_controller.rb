class Admin::InquiriesController < Admin::BaseController
  before_action :authenticate_admin!

  def index
    if params[:search].present?
      @inquiries = Inquiry.where("title LIKE ?", "%#{params[:search]}%")
                          .order(created_at: :desc)
                          .page(params[:page])
                          .per(10)
    else
      @inquiries = Inquiry.order(created_at: :desc)
                          .page(params[:page])
                          .per(10)
    end
  end

  def show
    @inquiry = Inquiry.find(params[:id])
  end
end

class PagesController < ApplicationController
  def about
  end

  def privacy_policy
    # プライバシーポリシーのページに関連するコードをここに記述
  end

  def terms_of_service
    # 利用規約のページに関するコードをここに記載
  end

  def contact
    @inquiry = Inquiry.new

    if request.post?
      @inquiry = Inquiry.new(inquiry_params)
      if @inquiry.save
        redirect_to root_path
      else
        render :contact
      end
    end
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:title, :category, :content)
  end

end

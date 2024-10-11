module UsersHelper
  def profile_image_for(user)
    if user.guest_user?
      # ゲストユーザーには静的画像を使用
      asset_path('no_image_photo.jpg')
    elsif user.profile_image.attached?
      # 通常のユーザーには Active Storage を使用して画像を表示
      rails_blob_path(user.profile_image, only_path: true)
    else
      # 通常のユーザーで画像が設定されていない場合、静的画像を使用
      asset_path('no_image_photo.jpg')
    end
  end
end

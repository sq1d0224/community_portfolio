# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  # ユーザー登録のカスタマイズ
  # ユーザーが新規登録した際に呼び出されるメソッド
  # Deviseが提供する標準の動作を上書きしています
  def create
    # Deviseのサインアップパラメータ（例: email, password）を使って新規ユーザーオブジェクトを作成
    build_resource(sign_up_params)

    # 新規ユーザーオブジェクトを保存（データベースに挿入）
    resource.save

    # ブロックが与えられていれば、そのブロックを呼び出す
    # 例えば、外部の処理が必要な場合に使われる
    yield resource if block_given?

    # ユーザーが正しく保存されたかどうかをチェック
    if resource.persisted?
      # ユーザーがすぐにログイン可能な状態か（メール確認などが不要か）をチェック
      if resource.active_for_authentication?
        # ログイン成功時のメッセージをセット
        set_flash_message! :notice, :signed_up
        
        # ユーザーをサインインさせ、セッションに保存
        sign_up(resource_name, resource)
        
        # 登録後のリダイレクト先を指定
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        # ユーザーは作成されたが、アカウントがまだアクティブでない場合（例: メール確認が必要）
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        
        # セッションに保存されているデータを破棄（ユーザーが未アクティブのため）
        expire_data_after_sign_in!
        
        # 非アクティブな状態でも、特定のリダイレクト先に送る
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      # ユーザーが保存されなかった場合、パスワードフィールドをリセットし、フォームにエラーメッセージを表示
      clean_up_passwords resource
      
      # パスワードの最小文字数（Deviseの設定に基づく）を設定
      set_minimum_password_length
      
      # ユーザーが登録に失敗した場合、サインアップフォームにリダイレクト
      render :new
    end
  end

  protected

  # サインアップ後のリダイレクト先をカスタマイズ
  def after_sign_up_path_for(resource)
    if guest_user?(resource)
      # ゲストユーザーの場合、サインイン画面にリダイレクト
      new_user_session_path
    else
      # 通常のユーザーはプロフィールページにリダイレクト
      user_path(resource)
    end
  end

  # 非アクティブサインアップ時のリダイレクト先をカスタマイズ
  def after_inactive_sign_up_path_for(resource)
    if guest_user?(resource)
      # ゲストユーザーの場合、サインイン画面にリダイレクト
      new_user_session_path
    else
      # 非アクティブユーザーもプロフィールページにリダイレクト
      user_path(resource)
    end
  end

  # ゲストユーザーかどうかを判定するメソッド
  def guest_user?(user)
    user.email == 'guest@example.com' # ゲストユーザーの判定条件（例: メールアドレスで判定）
  end
end

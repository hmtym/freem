class UsersController < ApplicationController
  before_action :authorize, except: [:sign_up, :sign_up_process, :sign_in, :sign_in_process]
  before_action :redirect_to_top_if_signed_in, only: [:sign_up, :sign_in]
  
  def profiles
    @user = current_user
    @products = Product.where(user_id: @user.id)
  end
  
  def edit
      @user = current_user
  end
  
  def update
  end
  
  
  
  def sign_in
    @user = User.new
  end
  
  def sign_in_process
    password_md5 = User.generate_password(user_params[:password])
    user = User.find_by(email: user_params[:email], password: password_md5)
    if user
      user_sign_in(user)
      redirect_to top_path and return
    else
      # flash[:danger] = "サインインに失敗しました。"
    end
  end
  
  def sign_up
    @user = User.new
  end
  
  def sign_up_process
    user = User.new(user_params)
    if user.save
      user_sign_in(user)
      redirect_to profiles_path and return
    else
      flash[:danger] = "入力に不備があります。"
      redirect_to sign_up_path and return
    end
  end
  
  def sign_out
    user_sign_out
    redirect_to sign_in_path and return
  end
  
  def user_sign_out
    session.delete(:user_id)
    @current_user = nil
  end
  
  def likes
  end
  
  def profiles_edit
  end
  
  def total
    @product = Product.all.order("id desc")
  end
  
  def like
    @product = Product.find(params[:id])
    if ProductLike.exists?(producr_id: @product.id, user_id: current_user.id)
      # いいねを削除
      ProductLike.find_by(producr_id: @product.id, user_id: current_user.id).destroy
    else
      # いいねを登録
      ProductLike.create(producr_id: @product.id, user_id: current_user.id)
    end
    redirect_to top_path and return
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  def product_params
    params.require(:product).permit(:name, :description, :price, :category_id).merge(user_id: current_user.id)
  end
end

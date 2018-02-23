class UsersController < ApplicationController
  before_action :authorize, except: [:sign_up, :sign_up_process, :sign_in, :sign_in_process]
  before_action :redirect_to_top_if_signed_in, only: [:sign_up, :sign_in]
  
  def profiles
    @user = current_user
    @product = Product.where(user_id: @user.id)
  end
  
  def edit
      @user = current_user
  end
  
  def update
    @user = current_user
    upload_file = params[:user][:image]
    if upload_file.present?
      upload_file_name = upload_file.original_filename
      output_dir = Rails.root.join('public', 'users')
      output_path = output_dir + upload_file_name
      File.open(output_path, 'w+b') do |f|
        f.write(upload_file.read)
      end
      @user.image =  upload_file.original_filename
    end
    if user_params[:password].length > 0
      @user.update(user_params)
    else
      @user.update(update_params)
    end
    p current_user.errors.full_messages
    # データベースに更新
    redirect_to top_path and return
  end
  
  
  
  def sign_in
    @user = User.new
    render layout: "application_search"
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
    render layout: "application_search"
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
    @user = current_user
    
    @products = Product.where(id: Userlike.where(user_id: @user.id).pluck(:product_id))
  end
  
  def total
    @product = Product.all
    if params[:word].present?
      @product = @product.where("name like ?", "%#{params[:word]}%")
    end
    
    if params[:category_id].present?
      if params[:category_id] == "5"
        @product = @product.all
      else
        @product = @product.where(category_id: params[:category_id])
      end
    end
    
    if params[:min_price].present?
      @product = @product.where("price >= ?", params[:min_price].to_i)
    end
    
    if params[:max_price].present?
      @product = @product.where("price <= ?", params[:max_price].to_i)
    end
    
    if params[:arrangement] == "created_at"
      if params[:order] == "asc"
        @product = @product.order("created_at asc")
      elsif params[:order] == "desc"
        @product = @product.order("created_at desc")
      end
     elsif params[:arrangement] =- "price" 
      if params[:order] == "asc"
        @product = @product.order("price asc")
      elsif params[:order] == "desc"
        @product = @product.order("price desc")
      end
    end
    render layout: "application_search"
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile)
  end
  
  def product_params
    params.require(:product).permit(:name, :description, :price, :category_id).merge(user_id: current_user.id)
  end
  
  def update_params
    params.require(:user).permit(:name, :email, :profile)
  end
end

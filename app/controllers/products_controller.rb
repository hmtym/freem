class ProductsController < ApplicationController
    before_action :authorize
    def products
        if params[:word].present?
            @product = Product.where("description like ?", "%#{params[:word]}%").order("id desc")
        else
            @product = Product.all.order("id desc")
        end
    end
  
    def show
        @product = Product.new
    end
  
    def edit
        @user = current_user
        @product = Product.new(product_params)
    end
    
    def update
        
    end
    
    def new
       @product = Product.new
    end
    
    def create
        @product = Product.new(product_params)
        # upload_file = params[:product][:upload_file]
        upload_file = params[:product][:image1]
    
        if upload_file.blank?
            flash[:danger] = "出品には画像が必須です。"
            redirect_to new_path and return
        else
            upload_file_name = upload_file.original_filename
            output_dir = Rails.root.join('public', 'images')
            output_path = output_dir + upload_file_name
            File.open(output_path, 'w+b') do |f|
                f.write(upload_file.read)
            end
        end
        
        @product.new(image1: upload_file_name)
        if @product.save
            redirect_to :products
            flash[:success] = "出品しました。"
        else
            redirect_to :products_new
            flash[:danger] = "出品に失敗しました。"
        end
    end
    
    def destroy
        @product= Product.find(params[:id])
        if @product.destroy
            redirect_to top_path
            flash[:success] = "投稿を削除しました。"
        else
            redirect_to top_path
            flash[:danger] = "削除に失敗しました。"
        end 
    end
    
    
    private
    def product_params
        params.require(:product).permit(:name, :description, :price,  :image1, :image2, :image3).merge(user_id: current_user.id)
        # :category_id,
    end
end

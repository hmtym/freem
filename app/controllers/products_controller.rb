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
        @product = Product.find(params[:id])
        @category = Category.find(@product.category_id)
    end
  
    def edit
        @user = current_user
        @product = Product.find(params[:id])
        @category = Category.all
    end
    
    def update
        upload_file = params[:product][:image1]
        if upload_file.present?
            upload_file_name = upload_file.original_filename
            output_dir = Rails.root.join('public', 'images')
            output_path = output_dir + upload_file_name
            File.open(output_path, 'w+b') do |f|
                f.write(upload_file.read)
            end
            current_user.update(product_params.merge({image: upload_file.original_filename}))
        else
            current_user.update(product_params)
        end
   
    redirect_to top_path and return
    end
    
    def new
       @product = Product.new
       @category = Category.all
    end
    
    def create
        @product = Product.new(product_params)
        @product.status = 0
        # upload_file = params[:product][:upload_file]
        upload_file1 = params[:product][:image1]
        file_name = image_edit(upload_file1)
        if file_name.nil?
            flash[:danger] = "出品には画像が必須です。"
            redirect_to new_path and return
        end
        @product.image1 = file_name
        
        upload_file2 = params[:product][:image2]
        file_name = image_edit(upload_file2)
        @product.image2 = file_name if file_name.present?
        
        upload_file3 = params[:product][:image3]
        file_name = image_edit(upload_file3)
        @product.image3 = file_name if file_name.present?
        
        
        
        # if upload_file.blank?
        #     flash[:danger] = "出品には画像が必須です。"
        #     redirect_to new_path and return
        # else
        #     upload_file_name = upload_file.original_filename
        #     output_dir = Rails.root.join('public', 'images')
        #     output_path = output_dir + upload_file_name
        #     puts output_dir
        #     puts upload_file_name
        #     File.open(output_path, 'w+b') do |f|
        #         f.write(upload_file.read)
        #     end
        #     @product[:image1] = upload_file_name
        # end
        
        # @product = Product.new(image1: upload_file_name)
        if @product.save
            redirect_to :products
            flash[:success] = "出品しました。"
        else
            redirect_to :new
            flash[:danger] = "出品に失敗しました。"
        end
    end
    
    def destroy
        @product= Product.find(params[:id])
        # @product= Product.find(current_user.id)
        if @product.destroy
            redirect_to top_path
            flash[:success] = "投稿を削除しました。"
        else
            redirect_to top_path
            flash[:danger] = "削除に失敗しました。"
        end 
    end
    
    def like
        @product = Product.find(params[:id])
        if Userlike.exists?(product_id: @product.id, user_id: current_user.id)
          Userlike.find_by(product_id: @product.id, user_id: current_user.id).destroy
        else
          Userlike.create(product_id: @product.id, user_id: current_user.id)
        end
        redirect_to total_path and return
    end
    
    private
    def product_params
        params.require(:product).permit(:name, :description, :price, :category_id, :status, :image1, :image2, :image3).merge(user_id: current_user.id)
    end
    
    def image_edit(upload_file)
        if upload_file.blank?
            return nil
        else
            upload_file_name = upload_file.original_filename
            output_dir = Rails.root.join('public', 'images')
            output_path = output_dir + upload_file_name
            puts output_dir
            puts upload_file_name
            File.open(output_path, 'w+b') do |f|
                f.write(upload_file.read)
            end
            return upload_file_name
        end
    end
end

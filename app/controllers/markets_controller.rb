class MarketsController < ApplicationController
    def item
        @product = Product.find(params[:id])
        @category = Category.find(@product.category_id)
        render layout: "application_search"
    end
    
    def payment
        @product = Product.find(params[:id])
        render layout: "application_search"
    end
    
    def purchase
        @product = Product.find(params[:id])
        # @product.status = 1
        @product.update(status: 1)
        redirect_to total_path and return
    end
    
    private
    def product_params
        params.require(:product).permit(:name, :description, :price,  :image1, :image2, :image3).merge(user_id: current_user.id)
        # :category_id,
    end
end

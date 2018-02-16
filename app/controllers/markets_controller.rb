class MarketsController < ApplicationController
    def item
        @product = Product.new(product_params)
    end
    
    def payment
        
    end
    
    private
    def product_params
        params.require(:product).permit(:name, :description, :price,  :image1, :image2, :image3).merge(user_id: current_user.id)
        # :category_id,
    end
end

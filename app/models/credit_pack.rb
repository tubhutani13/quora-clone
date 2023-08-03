class CreditPack < ApplicationRecord
    validates :price, :credits, presence:true , numericality: true
end

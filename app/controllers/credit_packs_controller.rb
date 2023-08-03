class CreditPacksController < ApplicationController
    def index
        @packs = CreditPack.all
    end
end

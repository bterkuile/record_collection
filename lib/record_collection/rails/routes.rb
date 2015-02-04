module ActionDispatch::Routing
  class Mapper
    # Add two collection routes to the normal resources definition.
    # This call behaves exactly as the normal resources :... call, 
    # but adds:
    #   collection do
    #     get :collection_edit
    #     post :collection_update
    #   end
    def collection_resources(*resources, &blk)
      collection_blk = Proc.new do
        collection do
          get :collection_edit
          match :collection_update, via: [:post, :patch, :put]
        end
        blk.call if blk
      end
      resources(*resources, &collection_blk)
    end
  end
end

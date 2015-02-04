module ActionDispatch::Routing
  class Mapper
    # Add two collection routes to the normal resources definition.
    # This call behaves exactly as the normal resources :... call, 
    # but adds:
    #   collection do
    #     get :batch_edit
    #     post :batch_update
    #   end
    def batch_resources(*resources, &blk)
      batch_blk = Proc.new do
        collection do
          get :batch_edit
          match :batch_update, via: [:post, :patch, :put]
        end
        blk.call if blk
      end
      resources(*resources, &batch_blk)
    end
  end
end

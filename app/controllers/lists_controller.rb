class ListsController < ApplicationController
  before_action :authorize_request
  
  def index
    @lists = List.all
      
    render json: @lists.as_json(except: %i[created_at updated_at photo_path], :include => [:movies]), status: :ok 
  end
end

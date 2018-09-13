class CatsController < ApplicationController
  def index
    user_id = current_user.id 
    if params[:user_id]
    if current_user.cats.length > 0 
      @cats = current_user.cats

    end  
  else 
  @cats = Cat.all

end
render :index

  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.owner_id = current_user.id
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit  
    cat_query = current_user.cats.find_by(id: params[:id])
    if cat_query
      @cat = cat_query
      render :edit
    else 
      flash[:errors] = ['You cant edit a cat you dont own']
      redirect_to cats_url
    end
  end

  def update
    cat_query = current_user.cats.find_by(id: params[:id])
    if cat_query
      @cat = cat_query
      if @cat.update_attributes(cat_params)
        redirect_to cat_url(@cat)
      else
        flash.now[:errors] = @cat.errors.full_messages
        render :edit
      end
    else 
      flash[:errors] = ['You cant edit a cat you dont own']
      redirect_to cats_url
    end
  end

  private

  def cat_params
    params.require(:cat).permit(:age, :birth_date, :color, :description, :name, :sex)
  end
end

class CategoriesController < ApplicationController

  def index
    @tree = Category.tree

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tree }
    end
  end


  def show
    @category = Category.by_alias params[:alias]
    if @category.nil?
      raise ActionController::RoutingError.new('Not fount')
    end

    @children = @category.children

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @category }
    end
  end


  def new
    @category = Category.new
    @parent = Category.by_alias params[:alias]

    if params[:alias] && @parent.nil?
      raise ActionController::RoutingError.new('Not fount')
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @category }
    end
  end


  def create
    @category = Category.new
    @parent = Category.by_alias params[:alias]

    if params[:alias] && @parent.nil?
      raise ActionController::RoutingError.new('Not fount')
    end

    @category.title = params[:category][:title]
    @category.alias = params[:category][:alias]
    @category.text = params[:category][:text]
    @category.parent = @parent || Category.new

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category.url, notice: 'Category was successfully created.' }
        format.json { render json: @category, status: :created, location: @category }
      else
        format.html { render action: 'new' }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end


  def edit
    @category = Category.by_alias params[:alias]
    if @category.nil?
      raise ActionController::RoutingError.new('Not fount')
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @category }
    end
  end


  def update
    @category = Category.by_alias params[:alias]
    if @category.nil?
      raise ActionController::RoutingError.new('Not fount')
    end

    @category.title = params[:category][:title]
    @category.alias = params[:category][:alias]
    @category.text = params[:category][:text]

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category.url, notice: 'Category was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @category = Category.by_alias params[:alias]
    if @category.nil?
      raise ActionController::RoutingError.new('Not fount')
    end

    parent_url = @category.parent_url
    @category.destroy_tree

    respond_to do |format|
      format.html { redirect_to parent_url }
      format.json { head :ok }
    end
  end

end

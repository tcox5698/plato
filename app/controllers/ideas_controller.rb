class IdeasController < ApplicationController
  before_action :set_idea, only: [:show, :edit, :update, :destroy]

  access_control :debug => true do
    allow :owner, :of => :idea, :to => [:show, :edit, :update, :destroy]
    allow logged_in, :to => [:index, :new, :create]
  end

# GET /ideas
# GET /ideas.json
  def index
    @ideas = current_user.ideas
  end

# GET /ideas/1
# GET /ideas/1.json
  def show
  end

# GET /ideas/new
  def new
    @idea = Idea.new passion_rating: 1, skill_rating: 1, profit_rating: 1
  end

# GET /ideas/1/edit
  def edit
  end

# POST /ideas
# POST /ideas.json
  def create
    @idea = Idea.new(idea_params)

    respond_to do |format|
      if @idea.save
        current_user.has_role! :owner, @idea
        format.html { redirect_to @idea, notice: 'Idea was successfully created.' }
        format.json { render :show, status: :created, location: @idea }
      else
        format.html { render :new }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

# PATCH/PUT /ideas/1
# PATCH/PUT /ideas/1.json
  def update
    respond_to do |format|
      if @idea.update(idea_params)
        format.html { redirect_to @idea, notice: 'Idea was successfully updated.' }
        format.json { render :show, status: :ok, location: @idea }
      else
        format.html { render :edit }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

# DELETE /ideas/1
# DELETE /ideas/1.json
  def destroy
    @idea.destroy
    respond_to do |format|
      format.html { redirect_to ideas_url, notice: 'Idea was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
# Use callbacks to share common setup or constraints between actions.
  def set_idea
    @idea = Idea.find(params[:id])
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def idea_params
    params.require(:idea).permit(:name, :description, :profit_rating, :skill_rating, :passion_rating)
  end

end

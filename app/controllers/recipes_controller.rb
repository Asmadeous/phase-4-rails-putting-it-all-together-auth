class RecipesController < ApplicationController
    before_action :authorize
  
    def index
      recipes = Recipe.includes(:user)
      render json: recipes, include: { user: { only: [:username, :image_url, :bio] } }
    end
  
    def create
      recipe = active_user.recipes.create(recipe_params)
      if recipe.valid?
        render json: recipe, status: :created
      else
        render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    private
  
    def active_user
      User.find(session[:user_id])
    end
  
    def recipe_params
      params.permit(:title, :instructions, :minutes_to_complete)
    end
  
    def authorize
      return render json: { errors: ["Not authorized"] }, status: :unauthorized unless session.include? :user_id
    end
  end
  
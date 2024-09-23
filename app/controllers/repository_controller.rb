class RepositoryController < ApplicationController
  def index 
    if params[:user_name].present?
      page = params[:page] || 1
      @repositories = GithubApi.get_all_repositories(params[:user_name], page)
      if @repositories[:error]
        render json: {error: @repositories[:error]}, status: :unprocessable_entity
      else
        render json: @repositories
      end
    else
      render json: {error: "user_name parameter is required"}, status: :bad_request
    end
  end

  def show
    if params[:user_name] && params[:repo_name]
      page = params[:page] || 1
      @repository  = GithubApi.get_repository(params[:user_name], params[:repo_name], page.to_i)
      if @repository[:error]
        render json: {error: @repository[:error]}, status: :unprocessable_entity
      else
        @repository[:current_page] = page.to_i
        render json: @repository
      end
    else
      render json: {error: "username and repository name are required e.g repository/{owner name}/{repository name}"}, status: :bad_request
    end
  end

end

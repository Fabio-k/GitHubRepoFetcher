class RepositoryController < ApplicationController
  SHOW_PARAMETER_ERROR_MESSAGE = "username and repository name are required e.g repository/{owner name}/{repository name}"

  def index 
    unless params[:user_name].present?
      render json: {error: "user_name parameter is required"}, status: :bad_request 
      return
    end

    page = params[:page] || 1
    @repositories = GithubApi.get_all_repositories(params[:user_name], page.to_i)

    if @repositories[:error]
      render json: {error: @repositories[:error]}, status: :unprocessable_entity 
      return 
    end

    render json: @repositories
  
  end


  def show
    unless params[:user_name] && params[:repo_name]
      render json: {error: SHOW_PARAMETER_ERROR_MESSAGE}, status: :bad_request
      return
    end

    page = params[:page] || 1
    @repository  = GithubApi.get_repository(params[:user_name], params[:repo_name], page.to_i)

    if @repository[:error]
      render json: {error: @repository[:error]}, status: :unprocessable_entity 
      return
    end
  
    @repository[:current_page] = page.to_i
    render json: @repository
  end

end

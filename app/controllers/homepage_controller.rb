class HomepageController < ApplicationController
  def index
    @response = GithubApi.get_all_repositories
  end

  def show
    @repository = GithubApi.get_repository(params[:name])
  end
end

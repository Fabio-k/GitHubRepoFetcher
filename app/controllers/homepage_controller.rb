class HomepageController < ApplicationController
  def index
    @response = GithubApi.fetch_repositories
    puts @response.is_a?(Array)
    puts @response
  end
end

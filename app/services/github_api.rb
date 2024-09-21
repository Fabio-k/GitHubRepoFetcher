require 'net/http'

class GithubApi
  USER_NAME = "fabio-k"
  def self.fetch_repositories
    Rails.cache.fetch('github_repos',expires_in: 20.minutes) do
      url = URI("https://api.github.com/users/#{USER_NAME}/repos")
      res = Net::HTTP.get_response(url)
      if res.is_a?(Net::HTTPSuccess)
        format_json_repository(res.body)
      else
        handle_api_error(res.body)
      end
    end
  rescue StandardError => e
    Rails.logger.error("Failed to fetch repositories: #{e.message}")
    []
  end

  def self.fetch_commits(url)
    Rails.cache.fetch("github_commits_#{url}", expires_in: 20.minutes) do
      commits_url = URI(url)
      res = Net::HTTP.get(commits_url)
      commits = JSON.parse(res)
      commits.map do |commit|
        Commit.new(
          message: commit['commit']['message'],
          author: commit['commit']['author']['name']
        )
      end
    end
  rescue StandardError => e
    Rails.logger.error("Failed to fetch repositories: #{e.message}")  
    []
  end


  def self.format_json_repository(json_string)
    repositories = JSON.parse(json_string)
    repositories.map do |repo|
      Repository.new(
        name: repo['name'],
        forks_count: repo['forks_count'],
        stars_count: repo['stargazers_count'],
        description: repo['description'],
        commits: fetch_commits(repo['commits_url'].gsub('{/sha}', ''))
      )
    end
  end

  def self.handle_api_error(response)
    error_message = JSON.parse(response)
    [{error: error_message['message']}]
  end

end
require 'net/http'

class GithubApi
  USER_NAME = "fabio-k"
  def self.get_all_repositories
    Rails.cache.fetch('github_repos',expires_in: 30.minutes) do
      res = fetch_repository_data("https://api.github.com/users/#{USER_NAME}/repos")
      process_repository_data(res)
    end
  rescue StandardError => e
    Rails.logger.error("Failed to fetch repositories: #{e.message}")
    []
  end

  def self.get_repository(name)
    res = fetch_repository_data("https://api.github.com/repos/#{USER_NAME}/#{name}")
    if res.is_a?(Net::HTTPSuccess)
      repository = JSON.parse(res.body)
      repo = Repository.new(
        name: repository['name'],
        forks_count:  repository['forks_count'],
        stars_count: repository['stargazers_count'],
        description: repository['description'],
        commits: fetch_commits( repository['commits_url'].gsub('{/sha}', ''))
      )

      repo
    else
      handle_api_error(res.body)
    end
  end

  def self.fetch_repository_data(repo_url)
    url = URI(repo_url)
    res = Net::HTTP.get_response(url)

    res
  end

  def self.process_repository_data(response)
    if response.is_a?(Net::HTTPSuccess)
      repositories = JSON.parse(response.body)
      repositories.map do |repo|
        format_data_to_repository(repo)
      end
    else
      handle_api_error(response.body)
    end
  end

  def self.format_data_to_repository(hash_repo)
    repo = Repository.new(
        name: hash_repo['name'],
        forks_count:  hash_repo['forks_count'],
        stars_count: hash_repo['stargazers_count'],
        description:  hash_repo['description'],
      )

    repo 
  end
  

  def self.fetch_commits(url)
      commits_url = URI(url)
      res = Net::HTTP.get(commits_url)
      commits = JSON.parse(res)
      commits.map do |commit|
        Commit.new(
          message: commit['commit']['message'],
          author: commit['commit']['author']['name']
        )
    end
  rescue StandardError => e
    Rails.logger.error("Failed to fetch repositories: #{e.message}")  
    []
  end

  def self.handle_api_error(response)
    error_message = JSON.parse(response)
    [{error: error_message['message']}]
  end

end
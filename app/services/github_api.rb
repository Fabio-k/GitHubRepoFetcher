require 'net/http'

class GithubApi
  def self.get_all_repositories(name, page)
    Rails.cache.fetch("github_repos_#{name}",expires_in: 30.minutes) do
      res = fetch_repository_data("https://api.github.com/users/#{name}/repos?page=#{page}")
      return handle_api_error(res.body) unless res.is_a?(Net::HTTPSuccess)

      last_page = get_last_page(res)
      repositories = process_repository_data(res)
      
      {user: name, current_page: page, last_page: last_page,  repositories: repositories}
    
    end
  rescue StandardError => e
    Rails.logger.error("Failed to fetch repositories: #{e.message}")
    {error: e.message}
  end

  def self.get_repository(user, name, page)
    res = fetch_repository_data("https://api.github.com/repos/#{user}/#{name}")
    return handle_api_error(res.body) unless res.is_a?(Net::HTTPSuccess)

    repository = JSON.parse(res.body)
    commits_response = fetch_commits( repository['commits_url'].gsub('{/sha}', ''), page)
    repo = format_data_to_repository(repository)
    repo.commits = commits_response[:commits]

    {repository: repo, current_page: page, last_page: commits_response[:last_page]}
  end

  private 

  def self.fetch_repository_data(repo_url)
    url = URI(repo_url)
    res = Net::HTTP.get_response(url)

    res
  end

  def self.handle_api_error(response)
    error_message = JSON.parse(response)
    {error: error_message['message']}
  end
  
  def self.process_repository_data(response)
    repositories = JSON.parse(response.body)
    repositories.map do |repo|
      format_data_to_repository(repo)
    end
  end

  def self.format_data_to_repository(hash_repo)
    repo = Repository.new(
        name: hash_repo['name'],
        forks_count:  hash_repo['forks_count'],
        stars_count: hash_repo['stargazers_count'],
        description:  hash_repo['description'] || "",
        url: hash_repo['html_url']
      )

    repo 
  end
  

  def self.fetch_commits(url, commit_page)
      page = commit_page != 1 ? "?page=#{commit_page}" : ""
      commits_url = URI("#{url}#{page}")
      
      res = Net::HTTP.get_response(commits_url)
      last_commit_page = get_last_page(res)
      commits = JSON.parse(res.body)

      commits.map! do |commit|
        Commit.new(
          message: commit['commit']['message'],
          author: commit['commit']['author']['name']
        )
      end

    {commits: commits, last_page: last_commit_page}

  rescue StandardError => e
    Rails.logger.error("Failed to fetch Commits: #{e.message}")  
    []
  end

  def self.get_last_page(response)
    if response['link']
      return response['link'].split(",")[1].split("?")[1].gsub(/\D/, "").to_i
    end
    ""
  end

  

end
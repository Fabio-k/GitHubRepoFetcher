class Repository
  include ActiveModel::Model

  attr_accessor :name, :forks_count, :stars_count, :description, :commits
end
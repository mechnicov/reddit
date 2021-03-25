namespace :parse do
  subreddit = ENV['subreddit']
  url = ENV['url']

  desc 'Get subreddit info'
  task subreddit_info: :environment do
    next unless subreddit.present?

    RedditParser.new.get_subreddit_info(subreddit)
  end

  desc 'Parse posts in given subreddit'
  task posts: :environment do
    next unless subreddit.present?

    [
      "https://old.reddit.com/r/#{subreddit}/",
      "https://old.reddit.com/r/#{subreddit}/top/?sort=top&t=month",
      "https://old.reddit.com/r/#{subreddit}/top/?sort=top&t=all",
      "https://old.reddit.com/r/#{subreddit}/new/"
    ].each do |url|
      RedditParser.new.start_parsing(url: url)
    rescue
      next
    end
  end

  desc 'Parse new posts in given subreddit'
  task new_posts: :environment do
    next unless subreddit.present?

    RedditParser.new.start_parsing(url: "https://old.reddit.com/r/#{subreddit}/new/")
  end

  desc 'Parse starting from given list url'
  task url: :environment do
    next unless url.present?

    RedditParser.new.start_parsing(url: url)
  end
end

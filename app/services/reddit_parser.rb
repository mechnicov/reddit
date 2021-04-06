require 'open-uri'

class RedditParser
  BASE_REDDIT_URL = 'https://www.reddit.com'.freeze
  BASE_OLD_REDDIT_URL = 'https://old.reddit.com'.freeze
  MINIMAL_SYMBOLS_QTY = 2_000.freeze

  def initialize
    @browser = Watir::Browser.new(:chrome, headless: true)
  end

  def start_parsing(url:)
    browser.goto(url)

    subreddit = get_current_subreddit

    loop do
      sleep rand(1..2.5)

      browser.links(class: 'title', href: /r\/#{subreddit}\/comments/).each do |link|
        0.step(10_000, rand(5..20)) do |v|
          browser.execute_script "window.scrollTo(0, #{v})"
          sleep 0.00001
        end

        sleep rand(1..2.5)
        browser.execute_script "window.scrollTo(0, -10000)"

        link.click(:control)

        browser.window(url: link.href).use

        sleep rand(1..2.5)
        parse_post
        browser.execute_script "window.scrollTo(0, 200)"
        sleep 2

        browser.window.close
      end

      logger.info "#{browser.url} has parsed"

      browser.link(text: 'next ›').click rescue return
    rescue => error
      logger.error browser.url
      logger.error error
    end
  end

  def get_subreddit_info(subreddit)
    browser.goto("#{BASE_OLD_REDDIT_URL}/r/#{subreddit}")
    scroll_down_up

    subreddit = Subreddit.find_or_create_by(name: subreddit)

    doc = Nokogiri::HTML(browser.html)

    subscribers_count = doc.at('.subscribers span').text.delete('^0-9').to_i
    founded_at = Time.parse(doc.at('.age time')[:datetime])

    subreddit.update!(subscribers_count: subscribers_count, founded_at: founded_at)
  end

  def assign_subreddits_to_posts
    Post.where(subreddit: nil).find_each do |post|
      browser.goto(post.short_url)

      scroll_down_up

      post.update!(subreddit: Subreddit.find_by(name: get_current_subreddit))
    end
  end

  private

  attr_reader :browser

  def parse_post
    author_link = browser.div(id: 'siteTable').a(class: 'author')
    author_link.fire_event('onmouseover') if author_link.present?

    sleep 2

    doc = Nokogiri::HTML(browser.html)

    body = doc.at('div.content .expando div.md')&.text
    data_node = doc.at('#siteTable .thing')

    return if body&.size.to_i < MINIMAL_SYMBOLS_QTY
    return if data_node['data-promoted'] == 'true'

    author = nil

    # Author attributes
    if author_link.present?
      author_reddit_id = data_node['data-author-fullname']

      author_karma_nodes = doc.at('.author-tooltip__karma-details')&.children || []
      comment_karma = author_karma_nodes.find { |el| el.text.match?(/comment/i) }&.at('strong')&.text.to_i
      post_karma = author_karma_nodes.find { |el| el.text.match?(/post/i) }&.at('strong')&.text.to_i

      name = author_link&.text

      registered_at =
        Date.parse(
          doc.at('.author-tooltip__cakeday div div').text.delete_prefix('Joined ')
        ) rescue nil

      if registered_at.present?
        author = Author.find_or_create_by(reddit_id: author_reddit_id)
        author.update(
          comment_karma: comment_karma,
          post_karma: post_karma,
          name: name,
          registered_at: registered_at
        )
      end
    end

    # Post attributes
    title = doc.at('div.content .entry a.title').text

    score = data_node['data-score'].to_i
    url = data_node['data-url']
    post_reddit_id = data_node['data-fullname']
    comments_count = data_node['data-comments-count'].to_i

    info_node = doc.at('.linkinfo')
    short_url = info_node.at('#shortlink-text')['value']
    posted_at = Time.parse(info_node.at('.date time')['datetime'])
    upvoted = info_node.xpath('//div[@class="score"]/text()').to_s.delete('^0-9').to_i

    post = Post.find_or_create_by(reddit_id: post_reddit_id)

    subreddit = Subreddit.find_by(name: get_current_subreddit)

    post.update(
      title: title,
      body: body,
      url: url,
      comments_count: comments_count,
      posted_at: posted_at,
      score: score,
      upvoted: upvoted,
      short_url: short_url,
      author: author,
      subreddit: subreddit
    )
  end

  def logger
    @logger ||= Logger.new(Rails.root.join('log', 'reddit.log'))
  end

  def scroll_down_up
    0.step(10_000, rand(5..20)) do |v|
      browser.execute_script "window.scrollTo(0, #{v})"
      sleep 0.00001
    end

    sleep rand(1..4)

    browser.execute_script "window.scrollTo(0, -10000)"
  end

  def scroll_down
    browser.execute_script "window.scrollTo(0, 200)"
    sleep 2
  end

  def get_current_subreddit
    browser.form(id: 'search').attributes[:action].split('reddit.com/r/').last.chomp('/search')
  end
end

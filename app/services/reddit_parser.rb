require 'open-uri'

class RedditParser
  BASE_REDDIT_URL = 'https://old.reddit.com'.freeze

  def initialize
    @browser = Watir::Browser.new(:chrome, headless: true)
  end

  def start_parsing(subreddit: nil, url: nil)
    url = "#{BASE_REDDIT_URL}/r/#{subreddit}/top/?sort=top&t=all" if subreddit.present?
    browser.goto(url)

    subreddit ||= browser.element(tag_name: 'meta', property: 'og:title').attributes[:content].split(' r/').last

    loop do
      sleep rand(1..4)

      browser.links(class: 'title', href: /r\/#{subreddit}\/comments/).each do |link|
        0.step(10_000, rand(5..20)) do |v|
          browser.execute_script "window.scrollTo(0, #{v})"
          sleep 0.00001
        end

        sleep rand(1..4)
        browser.execute_script "window.scrollTo(0, -10000)"

        link.click(:control)

        browser.window(url: link.href).use

        sleep rand(1..4)
        parse_post
        browser.execute_script "window.scrollTo(0, 200)"
        sleep 2

        browser.window.close
      end

      logger.info "#{browser.url} has parsed"

      browser.link(text: 'next ›').click
    rescue => error
      logger.error browser.url
      logger.error error
    end
  end

  private

  attr_reader :browser

  def parse_post
    author_link = browser.div(id: 'siteTable').a(class: 'author')
    author_link.fire_event('onmouseover') if author_link.present?

    sleep 2

    doc = Nokogiri::HTML(browser.html)

    body = doc.at('.expando div.md').text
    data_node = doc.at('#siteTable .thing')

    return if body.size < 2000
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
        author.update!(
          comment_karma: comment_karma,
          post_karma: post_karma,
          name: name,
          registered_at: registered_at
        )
      end
    end

    # Post attributes
    title = doc.at('.entry a.title').text

    score = data_node['data-score'].to_i
    url = data_node['data-url']
    post_reddit_id = data_node['data-fullname']
    comments_count = data_node['data-comments-count'].to_i

    info_node = doc.at('.linkinfo')
    short_url = info_node.at('#shortlink-text')['value']
    posted_at = Time.parse(info_node.at('.date time')['datetime'])
    upvoted = info_node.xpath('//div[@class="score"]/text()').to_s.delete('^0-9').to_i

    post = Post.find_or_create_by(reddit_id: post_reddit_id)

    post.update!(
      title: title,
      body: body,
      url: url,
      comments_count: comments_count,
      posted_at: posted_at,
      score: score,
      upvoted: upvoted,
      short_url: short_url,
      author: author
    )
  end

  def logger
    @logger ||= Logger.new(Rails.root.join('log', 'reddit.log'))
  end
end

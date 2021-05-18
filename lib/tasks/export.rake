namespace :export do
  desc 'Export all records to CSV'
  task csv: :environment do
    pattern = ENV['pattern']

    exported =
      if pattern.present?
        [
          subreddits = Subreddit.where('name ~* ?', pattern),
          posts = Post.where(subreddit: subreddits),
          Author.where(posts: posts)
        ]
      else
        Dir[Rails.root.join('app', 'models', '*.rb')].each do |file|
          require file
        end

        ActiveRecord::Base.
          descendants.
          reject { |klass| klass == ApplicationRecord }
      end

    exported.each do |export|
      klass = export.try(:klass) || export

      filename = Rails.root.join('export', "#{klass.name.tableize}.csv")

      File.write(filename, Export.to_csv(export))

      puts "#{klass} records were exported to #{filename}"
    end
  end
end

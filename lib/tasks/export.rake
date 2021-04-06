namespace :export do
  desc 'Export all records to CSV'
  task csv: :environment do
    Dir[Rails.root.join('app', 'models', '*.rb')].each do |file|
      require file
    end

    ActiveRecord::Base.
      descendants.
      reject { |klass| klass == ApplicationRecord }.
      each do |model|
        filename = Rails.root.join('export', "#{model.name.tableize}.csv")

        File.write(filename, Export.to_csv(model))

        puts "#{model} records were exported to #{filename}"
      end
  end
end

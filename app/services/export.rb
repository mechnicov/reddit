require 'csv'

module Export
  extend self

  def to_csv(model, clean: true)
    attributes = model.attribute_names

    CSV.generate(headers: true) do |csv|
      csv << attributes

      model.find_each do |record|
        if clean && record.is_a?(Post)
          record = ContentCleaner.clean(record, :body)
          next if record.blank?
        end

        csv << attributes.map { |atr| record.send(atr) }
      end
    end
  end
end

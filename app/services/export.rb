require 'csv'

module Export
  extend self

  def to_csv(model)
    attributes = model.attribute_names

    CSV.generate(headers: true) do |csv|
      csv << attributes

      model.find_each do |record|
        csv << attributes.map { |atr| record.send(atr) }
      end
    end
  end
end

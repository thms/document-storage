# Enable batch processing on models that use uuid as primary key
ActiveRecord::Batches.module_eval do
  def find_each_uuid(options = {})
    if block_given?
      find_in_batches_uuid(options) do |records|
        records.each { |record| yield record }
      end
    else
      enum_for :find_each_uuid, options do
        options[:start] ? where(table[:created_at].gteq(options[:start])).size : size
      end
    end
  end

  def find_in_batches_uuid(options = {})
    options.assert_valid_keys(:start, :batch_size)

    relation = self
    start = options[:start]
    batch_size = options[:batch_size] || 1000

    unless block_given?
      return to_enum(:find_in_batches_uuid, options) do
        total = start ? where(relation.table[:created_at].gteq(start)).size : size
        (total - 1).div(batch_size) + 1
      end
    end

    if logger && (arel.orders.present? || arel.taken.present?)
      logger.warn("Scoped order and limit are ignored, it's forced to be batch order and batch size")
    end

    relation = relation.reorder(batch_order_uuid).limit(batch_size)
    records = start ? relation.where(relation.table[:created_at].gteq(start)).to_a : relation.to_a

    while records.any?
      records_size = records.size
      key_offset = records.last.created_at
      raise 'Primary key not included in the custom select clause' unless key_offset

      yield records

      break if records_size < batch_size

      records = relation.where(relation.table[:created_at].gt(key_offset)).to_a
    end
  end

  private

  def batch_order_uuid
    "#{quoted_table_name}.created_at ASC"
  end
end

ActiveRecord::Querying.module_eval do
  delegate :find_each_uuid, to: :all
  delegate :find_in_batches_uuid, to: :all
end

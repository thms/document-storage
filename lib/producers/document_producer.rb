# Production producer for documents
require 'kafka'
require 'avro_turf/messaging'
class Producers::DocumentProducer
  
  attr_accessor :producer
  attr_accessor :kafka
  attr_accessor :config
  attr_accessor :class_logger
  attr_accessor :avro
  
  def initialize
    @config = YAML::load_file('config/kafka.yml')[Rails.env]
    @clogger =  Logger.new("#{Rails.root}/log/document.log")
    @kafka = Kafka.new(:seed_brokers => @config['kafka_connection'], logger: @clogger)
    # Use this for local schema without schema registry:
    # @avro = AvroTurf.new(schemas_path: "app/schemas/")
    # With schema registry, we need both the path to local and the url of the registry, so Avro can upload:
    @avro = AvroTurf::Messaging.new(registry_url: @config['schema_registry_connection'], schemas_path: "app/schemas/")
    @producer = @kafka.producer
  end
  
  # Publish one or more documents, including versions
  # In case the model has just been deleted, publish a message with the key but a nil value.
  def produce(documents)
    return if Rails.env == 'staging'
    documents.each do |document|
      begin
        metadata = {
          :published_at => Time.now.iso8601, 
          :published_by => 'document-storage',
          :country => document.country_code,
          :id => SecureRandom.uuid,
          :tracking_id => SecureRandom.uuid
        }
        if document.destroyed?
          @producer.produce(nil, :topic => 'document', :key => document.id.to_s)
        else
          message = {:metadata => metadata, :payload => document.as_json(:include => :versions)}.deep_stringify_keys.encode_timestamps
          @producer.produce(@avro.encode(message, :schema_name => 'document'), :topic => 'document', :key => document.id.to_s)
        end
      rescue Exception => e
        @clogger.info("Failed #{e.inspect}")
      end
    end
    begin
      @producer.deliver_messages
    rescue Exception => e
      @clogger.info("Failed #{e.inspect}")
    end
  end
  
  def produce_entire_history
    Document.find_in_batches_uuid do |documents|
      produce(documents)
    end
  end
  
end



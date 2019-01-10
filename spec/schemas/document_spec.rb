require 'rails_helper'
require 'avro_turf/messaging'

RSpec.describe Document do
  
  fixtures :all
  
  it "should be able to serialize a document" do
    #avro = AvroTurf.new(schemas_path: "app/schemas/")
    avro = AvroTurf::Messaging.new(registry_url: 'http://localhost:8081', schemas_path: "app/schemas/")
    document = Document.first
    metadata = {
      :published_at => Time.now.iso8601, 
      :published_by => 'document-storage',
      :country => document.country_code,
      :id => SecureRandom.uuid,
      :tracking_id => SecureRandom.uuid
    }
    # Issue for avro encoding is that as_json leaves the timestamps as time objects, but Avro::Messaging encoder does not handle that
    # So we need to replace them with strings encoded as iso8601 ()
    message = {:metadata => metadata, :payload => document.as_json(:include => :versions)}.deep_stringify_keys.encode_timestamps
    encoded_message = avro.encode(message, :schema_name => 'document')    
    expect(encoded_message.class).to eq(String)
  end
end


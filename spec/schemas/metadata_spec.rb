require 'rails_helper'

RSpec.describe 'Metadata' do
  
  fixtures :all
  
  it "should be able to serialize a metadata" do
    avro = AvroTurf.new(schemas_path: "app/schemas/")
    metadata = {
      :published_at => Time.now, 
      :published_by => 'document-storage',
      :country => 'DE',
      :id => SecureRandom.uuid,
      :tracking_id => SecureRandom.uuid
    }
    encoded_metadata = avro.encode(metadata, :schema_name => 'metadata')    
    expect(encoded_metadata.class).to eq(String)
  end
end

require 'rails_helper'

RSpec.describe Version do
  
  fixtures :all
  
  it "should be able to serialize a version" do
    avro = AvroTurf.new(schemas_path: "app/schemas/")
    version = Version.first
    metadata = {
      :published_at => Time.now, 
      :published_by => 'document-storage',
      :country => version.document.country_code,
      :id => SecureRandom.uuid,
      :tracking_id => SecureRandom.uuid
    }
    encoded_version = avro.encode({:metadata => metadata, :payload => version.as_json}, :schema_name => 'version')    
    expect(encoded_version.class).to eq(String)
  end
end

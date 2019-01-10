require 'rails_helper'
include ActionDispatch::TestProcess
RSpec.describe DocumentFactory do
  
  it "should create new document with version and assign random uuid" do
    document = DocumentFactory.create(
      :subject_id => '110118bc-316e-11e6-b8e2-c715121d5b6f',
      :subject_type => 'Loan',
      :category => 'tax_return',
      :year => 2015,
      :country_code => 'de',
      :owner => 'mike@example.com',
      :versions => [
        :version => Time.now,
        :reason => 'owner upload',
        :file_file_name => 'tax-return-2012.pdf',
        :file => fixture_file_upload("tax-return-2012.pdf", 'application/pdf', true)
      ]
    )
    expect(document).to be_persisted
    expect(document.versions.count).to eq(1)
    expect(document.versions.first.file_file_name).to eq('tax-return-2012.pdf')
  end
  
  it "should create new document with version and assign the provided uuid" do
    document = DocumentFactory.create(
      :id => '20000000-0000-0000-0000-000000000001',
      :subject_id => '110118bc-316e-11e6-b8e2-c715121d5b6f',
      :subject_type => 'Loan',
      :category => 'tax_return',
      :year => 2015,
      :country_code => 'de',
      :owner => 'mike@example.com',
      :versions => [
        :version => Time.now,
        :reason => 'owner upload',
        :file_file_name => 'tax-return-2012.pdf',
        :file => fixture_file_upload("tax-return-2012.pdf", 'application/pdf', true)
      ]
    )
    expect(document).to be_persisted
    expect(document.id).to eq('20000000-0000-0000-0000-000000000001')
  end
  
end
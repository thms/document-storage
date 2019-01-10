require 'rails_helper'

RSpec.describe Document, :type => :model do
  
  it 'should publish kafka event on commit' do
    allow_any_instance_of(Producers::DocumentProducer).to receive(:produce).and_return(nil)
    expect_any_instance_of(Producers::DocumentProducer).to receive(:produce)
    document = Document.last
    document.category = 'changed_category'
    document.save
  end

  it 'should not publish kafka event on commit if disabled' do
    allow(Producers::DocumentProducer).to receive(:new)
    expect(Producers::DocumentProducer).not_to receive(:new)
    Document.disable_kafka_publishing
    document = Document.last
    document.category = 'changed_category'
    document.save
  end
  
end

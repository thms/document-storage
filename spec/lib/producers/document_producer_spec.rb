require 'rails_helper'

RSpec.describe Producers::DocumentProducer do
  
  describe 'Document Producer' do
    it 'should read kafka connection from config' do
      producer = Producers::DocumentProducer.new
      expect(producer.config['kafka_connection']).to eq(['kafka://localhost:9092'])
    end

    it 'should publish message to kafka' do
      producer = Producers::DocumentProducer.new
      document = Document.first
      result = producer.produce([document])
      expect(result).to be nil
    end
    
    it 'should publish message with nil payload to kafka for deleted documents' do
      producer = Producers::DocumentProducer.new
      document = Document.last
      document.destroy
      result = producer.produce([document])
      expect(result).to be nil
    end
    
    it 'should be able to produce the entire history to Kafka' do
      producer = Producers::DocumentProducer.new
      expect do
        producer.produce_entire_history
      end.not_to raise_error
    end
  end
end

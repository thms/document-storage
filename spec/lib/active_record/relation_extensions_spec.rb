require 'rails_helper'

RSpec.describe ActiveRecord::Relation do
  fixtures :all
  
  describe "UUID Extension for batched finders" do
    it "should find all records in batches" do
      records = Document.find_each_uuid
      expect(records.size).to eq(Document.count)
    end
  
    it "should find all records in batches skipping 1" do
      records = Document.find_each_uuid(:start => Document.all.limit(2).last.created_at)
      expect(records.class).to eq(Enumerator)
      expect(records.size).to eq(Document.count - 1)
    end
  
    it "should yield each record" do
      ids = []
      Document.all.find_each_uuid do |document|
        ids << document.id
      end
      expect(ids).to eq(Document.ids)
    end
    
    it "should find all records in batches skipping 1" do
      ids = []
      Document.find_each_uuid(:start => Document.all.limit(2).last.created_at) do |document|
        ids << document.id
      end
      expect(ids).to eq(Document.ids - [Document.first.id])
    end
    
    it "should honour the batch size argument" do
      number_of_batches = 0
      Document.find_in_batches_uuid(:batch_size => 2) do |documents|
        expect(documents.size).to eq(2)
        number_of_batches += 1
      end
      expect(number_of_batches).to eq(2)
    end
    
    it "should return enumerator for find in batches" do 
      enumerator = Document.all.find_in_batches_uuid
      expect(enumerator.size).to eq(1)
    end
    
  end
  
  
end

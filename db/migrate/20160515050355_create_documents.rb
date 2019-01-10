class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents, :id => :uuid do |t|
      t.string    :country_code, :null => false, :default => 'DE'
      t.uuid      :subject_id, :null => false, :default => '110118bc-316e-11e6-b8e2-c715121d5b6f'
      t.string    :subject_type, :null => false, :default => 'Loan'
      t.string    :category
      t.integer   :year
      t.string    :owner, :null => false, :default => 'system'
      t.timestamps
    end
  end
end

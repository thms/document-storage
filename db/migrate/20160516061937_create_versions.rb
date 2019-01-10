class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions, :id => :uuid do |t|
      t.uuid :document_id
      t.attachment :file
      t.string    :file_fingerprint
      t.string :uploaded_by, :null => false, :default => 'system'
      t.string :reason, :null => false, :default => 'inital version'
      t.datetime :version
      t.timestamps
    end
  end
end

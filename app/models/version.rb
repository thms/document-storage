class Version < ApplicationRecord

  belongs_to :document
  has_attached_file :file
  validates_attachment_content_type :file, :content_type => ['application/xml', 'text/xml', 'application/pdf', 'application/octet-stream']
  
  default_scope { order(:created_at) }
  
end

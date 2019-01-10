# Purpose: create document and version when document gets frst created

class DocumentFactory
  
  # Creates a new document and first version from the parameter hash (and file content)
  def self.create(params)
    document = Document.create(
      :id => params[:id],
      :subject_id => params[:subject_id],
      :subject_type => params[:subject_type],
      :category => params[:category],
      :year => params[:year] || nil,
      :country_code => params[:country_code],
      :owner => params[:owner],
    )
    document.versions = params[:versions].map{|version_attributes| Version.create(version_attributes)}
    document
  end
end

class Api::V1::VersionsController < ApplicationController
  
  skip_before_action :verify_authenticity_token
  
  # Allow uplod of new version for existing document
  # POST /documents/1/versions
  def create
    version_attributes = params.require(:version).permit(:id, :file, :file_file_name, :version, :uploaded_by, :reason)
    @document = Document.find(params[:document_id])
    @document.versions << Version.create(version_attributes)
    render :json => @document, :include => [:versions]
  end
  
  # Stream the content of a specific version to the requestor
  # Responds with the mime type of the stored subject, so the user just needs to provide the ID
  # GET /documents/1/versions/3
  def show
    @document = Document.find(params[:document_id])
    @version = @document.versions.find(params[:id])
    content = Paperclip.io_adapters.for(@version.file).read
    headers["Content-Type"] = @version.file_content_type
    send_data(content, :filename => @version.file_file_name, :type => @version.file_content_type)
  end
end
 
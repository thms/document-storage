# The documents controller only provides meta data about documents and versions
# The contents of the document are provided by the versions controller.
class Api::V1::DocumentsController < ApplicationController
  
  skip_before_action :verify_authenticity_token
  
  # GET /documents?country=de&subject_type=Loan&subject_id=123
  # Returns list of documents for given subject
  def index
    @documents = Document.all
    [:country_code, :subject_type, :subject_id, :category, :year].each do |key|
      @documents = @documents.where(key => params[key]) unless params[key].nil?
    end
    render :json => @documents, :include => [:versions]
  end
  
  # GET /documents/1(.json)
  # Returns metadata including links to file in storage backend
  def show
    @document = Document.where(:id => params[:id])
    render :json => @document, :include => [:versions]
  end
  
  def create
    document_attributes = params.require(:document).permit(:id, :subject_id, :subject_type, :country_code, :owner, :category, :year, :versions => [:file, :file_file_name, :uploaded_by, :version, :reason])
    @document = DocumentFactory.create(document_attributes)
    render :json => @document, :include => [:versions]
  end
  
  def update
    document_attributes = params.require(:document).permit(:category, :year)
    @document = Document.find(params[:id])
    @document.update_attributes(document_attributes)
    render :json => @document, :include => [:versions]
  end
end
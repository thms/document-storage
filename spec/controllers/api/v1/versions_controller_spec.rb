require 'rails_helper'
RSpec.describe Api::V1::VersionsController, type: :controller do
  fixtures :all
  
  describe "GET show" do
    it "should return 401 if the auth token is missing" do
      get :show, params: {document_id: '00000000-0000-0000-0000-000000000001', id: '00000000-0000-0000-0000-000000000001'}, format: :json
      expect(response.status).to eq(401)
    end

    it "should return 401 if the auth token is wrong" do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials("wrong-token")
      get :show, params: {document_id: '00000000-0000-0000-0000-000000000001', id: '00000000-0000-0000-0000-000000000001'}, format: :json
      expect(response.status).to eq(401)
    end
    
    it "should return the JSON document if the file exists" do
      # Stub the reading of the file:
      allow_any_instance_of(Paperclip::Attachment).to receive(:path).and_return(Rails.root.join('spec/fixtures/tax-return-2012.pdf'))
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials("MJagrTYj2dCVTetpyFSyamuRPC2X9xNy")
      get :show, params: {document_id: '00000000-0000-0000-0000-000000000001', id: '00000000-0000-0000-0000-000000000001'}, format: :json
      expect(response.status).to eq(200)
    end
  end
  
  
  describe "POST" do
    it "should create a new version if the parameters are complete" do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials("MJagrTYj2dCVTetpyFSyamuRPC2X9xNy")
      expect {
        post :create, params: {
          document_id: '00000000-0000-0000-0000-000000000001',
          version: {
            uploaded_by: 'minnie@example.com',
            version: Time.now,
            reason: 'inital upload',
            file_file_name: 'tax-return-2012.pdf',
            file: fixture_file_upload('tax-return-2012.pdf', 'application/pdf')
          }
        }
      }.to change{Version.count}.by(1)
      expect(assigns(:document)).to be_persisted
    end
  end
end
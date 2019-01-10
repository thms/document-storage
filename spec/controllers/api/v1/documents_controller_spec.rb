require 'rails_helper'
RSpec.describe Api::V1::DocumentsController, type: :controller do
  
  describe "GET show" do
    it "should return 401 if the auth token is missing" do
      get :show, params: {id: '00000000-0000-0000-0000-000000000001'}, format: :json
      expect(response.status).to eq(401)
    end

    it "should return 401 if the auth token is wrong" do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials("wrong-token")
      get :show, params: {id: '00000000-0000-0000-0000-000000000001'}, format: :json
      expect(response.status).to eq(401)
    end
    
    it "should return the JSON document if the file exists" do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials("MJagrTYj2dCVTetpyFSyamuRPC2X9xNy")
      get :show, params: {id: '00000000-0000-0000-0000-000000000001'}, format: :json
      expect(response.status).to eq(200)
    end
  end
  
  describe "GET index" do
    it "should return 401 if the auth token is missing" do
      get :index, params: {id: '00000000-0000-0000-0000-000000000001'}, format: :json
      expect(response.status).to eq(401)
    end

    it "should return 401 if the auth token is wrong" do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials("wrong-token")
      get :index, format: :json
      expect(response.status).to eq(401)
    end
    
    it "should return 200 if the auth token is correct" do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials("MJagrTYj2dCVTetpyFSyamuRPC2X9xNy")
      get :index, format: :json
      expect(response.status).to eq(200)
    end
    
    it "should return array of documents for loan" do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials("MJagrTYj2dCVTetpyFSyamuRPC2X9xNy")
      get :index, params: {country_code: 'de', subject_type: 'Loan', subject_id: '00000000-0000-0000-0000-000000000005'}, format: :json
      expect(assigns(:documents).count).to eq(2)
    end
  end
  
  describe "POST" do
    it "should create a new document if the parameters are complete" do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials("MJagrTYj2dCVTetpyFSyamuRPC2X9xNy")
      expect {
        post :create, params: {
          document: {
            id: '10000000-0000-0000-0000-000000000001',
            subject_id: '00000000-0000-0000-0000-000000000005',
            subject_type: 'Loan',
            country_code: 'DE',
            owner: 'mike@example.com',
            category: 'tax_return',
            year: 2012,
            versions: [
              uploaded_by: 'minnie@example.com',
              version: Time.now,
              reason: 'inital upload',
              file_file_name: 'tax-return-2012.pdf',
              file: fixture_file_upload('tax-return-2012.pdf', 'application/pdf')
            ]
          }
        }
      }.to change{Document.count + Version.count}.by(2)
      expect(assigns(:document)).to be_persisted
    end
  end
  
  describe "PUT" do
    it "should allow updating of category" do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials("MJagrTYj2dCVTetpyFSyamuRPC2X9xNy")
      expect {
        put :update, params: {
          id: '00000000-0000-0000-0000-000000000001',
          document: {
            category: 'balance_sheet',
          }
        }
      }.to change{Document.find('00000000-0000-0000-0000-000000000001').category}.from('tax_return').to('balance_sheet')
    end

    it "should allow updating of year" do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials("MJagrTYj2dCVTetpyFSyamuRPC2X9xNy")
      expect {
        put :update, params: {
          id: '00000000-0000-0000-0000-000000000001',
          document: {
            year: 2013,
          }
        }
      }.to change{Document.find('00000000-0000-0000-0000-000000000001').year}.from(2015).to(2013)
    end
    
    it "should not allow updating owner" do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials("MJagrTYj2dCVTetpyFSyamuRPC2X9xNy")
      expect {
        put :update, params: {
          id: '00000000-0000-0000-0000-000000000001',
          document: {
            owner: 'minnie@example.com',
          }
        }
      }.not_to change{Document.find('00000000-0000-0000-0000-000000000001').owner}
      expect(response.status).to eq(200)
    end
  end
  
  
end
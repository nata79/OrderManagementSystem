require 'spec_helper'

describe '/api/v1/oauth/token', :api do
  let(:user) { create :user, password: '111111', password_confirmation: '111111' }  

  context 'password flow authorized app' do
    let(:application) { create :application, credentials_flow: true }

    it 'returns a 200 if credentials are valid' do
      post oauth_token_path,
        client_id: application.uid, 
        client_secret: application.secret, 
        grant_type: 'password',
        username: user.email,
        password: '111111'

      last_response.status.should eq 200
    end

    it 'returns a 401 if the credentials are wrong' do
      post oauth_token_path,
        client_id: application.uid, 
        client_secret: application.secret, 
        grant_type: 'password',
        username: user.email,
        password: '222222'

      last_response.status.should eq 401
    end
  end

  it 'returns a 401 if the app is not allowed to use the password flow' do
    application = create :application, credentials_flow: false
    
    post oauth_token_path,
      client_id: application.uid, 
      client_secret: application.secret, 
      grant_type: 'password',
      username: user.email,
      password: '111111'

    last_response.status.should eq 401
  end
end
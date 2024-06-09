require 'byebug'
require 'rails_helper'

RSpec.describe BlogsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:blog) { FactoryBot.create(:blog, user_id: user.id) }
  let(:valid_attributes) { { title: 'Test Title', content: 'Test Content' } }
  let(:invalid_attributes) { { title: '', content: '' } }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a success response' do
      blog
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: blog.to_param }
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit, params: { id: blog.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      before do
        allow_any_instance_of(BlogsController).to receive(:fetch_random_image_from_unsplash)
      end

      it 'creates a new Blog' do
        expect {
          post :create, params: { blog: valid_attributes }
        }.to change(Blog, :count).by(1)
      end

      it 'redirects to the index' do
        post :create, params: { blog: valid_attributes }
        expect(response).to redirect_to(blogs_path)
      end
    end

    context 'with invalid params' do
      it 'returns a success response (to display the new template)' do
        post :create, params: { blog: invalid_attributes }
        expect(response).to have_http_status(302)

      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      before do
        allow_any_instance_of(BlogsController).to receive(:fetch_random_image_from_unsplash)
      end

      it 'updates the requested blog' do
        patch :update, params: { id: blog.to_param, blog: valid_attributes }
        blog.reload
        expect(blog.title).to eq('Test Title')
        expect(blog.content).to eq('Test Content')
      end

      it 'redirects to the blog' do
        patch :update, params: { id: blog.to_param, blog: valid_attributes }
        expect(response).to redirect_to(blog)
      end
    end

    context 'with invalid params' do
      it 'returns a success response (to display the edit template)' do
        patch :update, params: { id: blog.to_param, blog: invalid_attributes }
        expect(response).to have_http_status(302)

      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested blog' do
      blog
      expect {
        delete :destroy, params: { id: blog.to_param }
      }.to change(Blog, :count).by(-1)
    end

    it 'redirects to the blogs list' do
      delete :destroy, params: { id: blog.to_param }
      expect(response).to redirect_to(blogs_path)
    end
  end

  describe '#fetch_random_image_from_unsplash' do
    it 'calls the Unsplash API and updates the blog image_url' do
      expect(Unsplash::Photo).to receive(:search).with('Test Title').and_return([OpenStruct.new(urls: { 'regular' => 'http://example.com/image.jpg' })])
      controller.instance_variable_set(:@blog, blog)
      controller.send(:fetch_random_image_from_unsplash, 'Test Title')
      blog.reload
      expect(blog.image_url).to eq('http://example.com/image.jpg')
    end
  end
end

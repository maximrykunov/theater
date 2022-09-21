# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Shows', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /index' do
    let!(:show) { create :show }

    it 'return list of shows' do
      get '/api/v1/shows', headers: headers

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq 1
    end
  end

  describe 'POST /create' do
    subject { post '/api/v1/shows', params: { show: show_params }, headers: headers }

    context 'invalid params' do
      let(:show_params) { { start_date: '01/01/2022', finish_date: '01/01/2022' } }

      it 'return 422 status' do
        subject

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq 'Unable to create show. Error(s): Name can\'t be blank'
      end
    end

    context 'valid params' do
      let(:show_params) { FactoryBot.attributes_for(:show) }

      it 'return 201 status' do
        subject

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:created)
      end

      it 'increases count by 1' do
        expect { subject }.to change { Show.count }.by(1)
      end
    end
  end

  describe 'DELETE /destroy' do
    subject { delete "/api/v1/shows/#{id}", headers: headers }

    context 'invalid id' do
      let(:id) { 0 }

      it 'return 404 status' do
        subject

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'exsisting id' do
      let!(:show) { create :show }
      let(:id) { show.id }

      it 'return 200 status' do
        subject

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq 'Show deleted'
      end

      it 'decreases count by 1' do
        expect { subject }.to change { Show.count }.by(-1)
      end
    end
  end
end

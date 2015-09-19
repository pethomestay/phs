require 'rails_helper'

RSpec.describe ImageSyncer do
  let(:image_params) do
    {id: '1234', scope: 'avatar'}
  end
  let(:resource_params) do
    {id: '1234', type: 'pet'}
  end
  let(:subject) { ImageSyncer.new(image_params, resource_params) }

  describe '#initialize' do
    it 'sets image params' do
      expect(subject.image_params).to eq(image_params.to_options)
    end

    it 'sets resource params' do
      expect(subject.resource_params).to eq(resource_params.to_options)
    end

    it 'sets errors array' do
      expect(subject.errors).to eq([])
    end
  end

  describe '#sync' do
    context 'with malformed resource params' do
      it 'returns nil and complains' do
        subject = ImageSyncer.new(image_params, resource_params.merge(type: 'child'))
        expect(subject.sync).to be_nil
        expect(subject.errors).to include('Unrecognised resource type: Child')
      end
    end

    context 'with no matching resource' do
      it 'returns nil and complains' do
        expect(subject.sync).to be_nil
        expect(subject.errors).to include('Unrecognised resource ID: 1234')
      end
    end

    context 'with a matching resource' do
      let!(:resource) { create(resource_params[:type].to_sym, id: resource_params[:id]) }

      context 'with a pre-existing image' do
        it 'returns the attachinary file' do
          image = double(:image)
          allow(Attachinary::File).to receive(:where).and_return([image])
          expect(subject.sync).to eq(image)
        end
      end

      context 'with no matching remote image'  do
        it 'returns nil and complains' do
          allow(Cloudinary::Api).to receive(:resources_by_ids).and_return({resources: []})
          expect(subject.sync).to be_nil
          expect(subject.errors).to include('Unrecognised image ID: 1234')
        end
      end

      context 'with a matching remote image' do
        it 'returns the newly created attachinary file' do
          payload = {
            resources: [{
              public_id: 'dirlekvxoelk4hngowcj',
              format: 'jpg',
              version: 1442630203,
              resource_type: 'image',
              type: 'upload',
              created_at: '2015-09-19T02:36:43Z',
              bytes: 1480936,
              width: 2448,
              height: 2448,
              backup: true,
              url: 'http://res.cloudinary.com/hxnfgf9c2/image/upload/v1442630203/dirlekvxoelk4hngowcj.jpg',
              secure_url: 'https://res.cloudinary.com/hxnfgf9c2/image/upload/v1442630203/dirlekvxoelk4hngowcj.jpg'
            }]
          }
          allow(Cloudinary::Api).to receive(:resources_by_ids).and_return(payload)
          expect{ @file = subject.sync }.to change(Attachinary::File, :count).by(1)
          expect(@file.public_id).to eq('dirlekvxoelk4hngowcj')
          expect(@file.attachinariable_id).to eq(1234)
        end
      end
    end
  end
end

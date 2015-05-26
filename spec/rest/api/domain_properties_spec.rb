require 'spec_helper'
require_relative '../../support/some_domain'

describe 'RestApiClient' do

  describe 'RestModel' do
    context 'instance methods' do
      subject(:instance_methods) { SomeDomain.instance_methods }

      it { expect(instance_methods).to include(:perform_get) }
      it { expect(instance_methods).to include(:perform_post) }
      it { expect(instance_methods).to include(:perform_delete) }
      it { expect(instance_methods).to include(:perform_put) }
      it { expect(instance_methods).to include(:save) }
      it { expect(instance_methods).to include(:delete) }
      it { expect(instance_methods).to include(:update) }

      it 'should use the correct path to make requests' do
        some_domain_instance = SomeDomain.new({:id => 1})
        expect(some_domain_instance).to receive(:perform_delete).with('some_domain/1')
        expect(some_domain_instance.path).to eq 'some_domain'
        some_domain_instance.delete
      end
    end

    context 'class methods' do
      subject(:class_methods) { SomeDomain.methods }

      it { expect(class_methods).to include(:list) }
      it { expect(class_methods).to include(:perform_get) }
      it { expect(class_methods).to include(:find) }
      it { expect(class_methods).to include(:get) }

      it 'should use the correct path' do
        expect(SomeDomain).to receive(:perform_get).with('some_domain')
        expect(SomeDomain.path).to eq 'some_domain'
        SomeDomain.list
      end
    end

    context 'instance properties' do
      subject(:domain) { SomeDomain.new }

      it { expect(domain.id).to be_nil }
      it { expect(domain.created_at).to be_nil }
      it { expect(domain.updated_at).to be_nil }
    end

  end
end

require 'rails_helper'

describe Utils::GroupFilter, type: :model do
  describe '#filter' do
    context 'with empty mapfile' do
      before do
        stub_const('Utils::GroupFilter::MAP_FILE_PATH', File.join(MOCK_DIR, 'mapfiles', 'mapfile_empty.yml'))
      end

      let(:groups) { { 'group1' => %w[role1 role7] } }
      let(:filtered) { described_class.new.run!(groups) }

      it 'wont change groups' do
        expect(filtered).to eq(groups)
      end
    end

    context 'without mapfile' do
      before do
        stub_const('Utils::GroupFilter::MAP_FILE_PATH', nil)
      end

      let(:groups) { { 'group1' => %w[role1 role7] } }
      let(:filtered) { described_class.new.run!(groups) }

      it 'wont change groups' do
        expect(filtered).to eq(groups)
      end
    end

    context 'with mapfile#1' do
      before do
        stub_const('Utils::GroupFilter::MAP_FILE_PATH', File.join(MOCK_DIR, 'mapfiles', 'mapfile1.yml'))
      end

      let(:groups) { { 'group1' => %w[role1 role7] } }
      let(:filtered) { described_class.new.run!(groups) }

      it 'wont filter out everything' do
        expect(filtered['group1'].length).to eq(1)
      end

      it 'will filter out role7' do
        expect(filtered['group1'].first).to eq('role1')
      end
    end
  end
end

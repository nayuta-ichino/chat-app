require 'rails_helper'

RSpec.describe Room, type: :model do
  describe '#create' do
    before do
      @room = FactoryBot.build(:room)
    end

    it 'nameの値が存在すれば保存が可能' do
      expect(@room).to be_valid
    end

    it 'nameが空であれば保存不可' do
      @room.name = ""
      @room.valid?
      expect(@room.errors.full_messages).to include("Name can't be blank")
    end

  end
end

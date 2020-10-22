require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#create' do
    before do
      @user = FactoryBot.build(:user)
    end

    it "nameとemail、passwordとpassword_confirmaionが存在すれば登録できること" do
      expect(@user).to be_valid
    end

    it "nameが空だと登録ができないこと" do
      @user.name = ""
      @user.valid?
      expect(@user.errors.full_messages).to include("Name can't be blank")
    end

    it "emailが空では登録できないこと" do
      @user.email = ""
      @user.valid?
      expect(@user.errors.full_messages).to include("Email can't be blank")
    end
    
    it 'passwordが空だと登録ができないこと' do
      @user.password = ""
      @user.valid?
      expect(@user.errors.full_messages).to include("Password can't be blank", "Password confirmation doesn't match Password")
    end
    
    it "passwordが6文字以上であれば登録が可能" do
      @user.password = "aaaaaa"
      @user.password_confirmation = "aaaaaa"
      expect(@user).to be_valid
    end
    
    it "passwordが5文字以下ならば登録は不可能" do
      @user.password = "aaaaa"
      @user.password_confirmation = "aaaaa"
      @user.valid?
      expect(@user.errors.full_messages).to include("Password is too short (minimum is 6 characters)")
    end
    
    it "passwordとpassword_confirmationが不一致では登録が不可能" do
      @user.password = "aaaaaa"
      @user.password_confirmation = "ssssss"
      @user.valid?
      expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end
    
    it "重複したemailが存在する時は登録ができない" do
      # @anoter_user = FactoryBot.build(:user)
      # @user.email = @anoter_user.email
      # @user.valid?
      # expect(@user.errors.full_messages).to include()
      
      @user.save
      anoter_user = FactoryBot.build(:user , email: @user.email)
      anoter_user.valid?
      expect(anoter_user.errors.full_messages).to include("Email has already been taken")
    end
  end
end

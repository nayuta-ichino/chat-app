require 'rails_helper'

RSpec.describe "Messages", type: :system do
  before do
    # 中間テーブルを作成して、usersテーブルとroomsテーブルのレコードを作成する
    @room_user = FactoryBot.create(:room_user)
  end

  context "投稿に失敗した時" do
    it '送る値がからのため、メッセージの送信に失敗する時' do
      # サインインする
      sign_in(@room_user.user)
      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)
      # DBに保存されていないことを確認する
      expect{
        click_on ("送信")
      }.to change { Message.count }.by(0)
      # もとのページに戻ってくること
      expect(current_path).to eq room_messages_path(@room_user.room)
    end
  end

  context '投稿に成功した時' do
    it 'テキストの投稿に成功すると、投稿一覧に遷移して、投稿した内容は表示されている' do
      
      # サインインする
      sign_in(@room_user.user)
      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)
      # 値をテキストフォームに入力する
      post = "テスト"
      fill_in 'message_content' , with: post
      # 送信した値がDBに保存されていることを確認する
      expect{
        click_on("送信")
      }.to change{Message.count}.by(1)  
      # 投稿一覧画面に遷移していることを確認する
      expect(current_path).to eq  room_messages_path(@room_user.room)
      # 送信した値がブラウザに表示されていることを確認する
      expect(page).to have_content(post)
    end

    it '画像の投稿に成功すると、投稿一覧に遷移して、投稿した画像が表示される' do
      # サインインする
      sign_in(@room_user.user)
      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')
      # 画像選択フォームに画像を添付する
      attach_file("message[image]" , image_path , make_visible: true)
      # 送信した値がDBに保存されていることを確認する
      expect{
        click_on ("送信")
      }.to change{Message.count}.by(1)
      # # 投稿一覧画面に遷移していることを確認する
      expect(current_path).to eq room_messages_path(@room_user.room)
      # # 送信した画像がブラウザに表示されていることを確認する
      expect(page).to have_selector("img")
    end

    it 'テキストと画像の投稿に成功すること' do
      # サインインする
      sign_in(@room_user.user)
      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')
      # 画像選択フォームに画像を添付する
      attach_file("message[image]" , image_path , make_visible: true)
      # 値をテキストフォームに入力する
      test = "てすと"
      fill_in 'message_content' , with: test
      # 送信した値がDBに保存されていることを確認する
      expect{
        click_on ("送信")
      }.to change{Message.count}.by(1)
      # 送信した値がブラウザに表示されていることを確認する
      expect(page).to have_content(test)
      # 送信した画像がブラウザに表示されていることを確認する
      expect(page).to have_selector("img")
    end
  end
end

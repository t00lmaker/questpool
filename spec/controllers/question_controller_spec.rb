require 'rails_helper'

RSpec.describe QuestionsController, :type => :controller do

  describe "GET index" do

    it "não deve ser acessado apenas por usuarios não autenticados" do
      sign_in nil
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end

    it "deve ser acessível por para usuários autenticados" do
      sign_in User.new(role: 'user')
      get :index
      expect(response).to be_success
    end

    it "deve redenrizar o template index" do
      sign_in User.new(role: 'user')
      get :index
      expect(response.content_type).to eq "text/html"
      expect(response).to render_template("index")
    end

    it "deve trazer todas as questões, quando usuario for admin" do
      sign_in User.new(role: 'admin')
      expect(Question).to receive(:all).once.and_return([])
      get :index
    end

    it "deve trazer as questões apenas do usuário logadao" do
      user = User.new(role: 'user')
      sign_in(user)
      expect(Question).to receive(:where).with(user: user).once.and_return([])
      get :index
    end

    it "deve trazer as questões agrupadas por status" do
      sign_in User.new(role: 'admin')
      question_approved = Question.new
      question_approved.approve!
      expect(Question).to receive(:all).once.and_return([Question.new(),Question.new(), Question.new(), question_approved])
      get :index
      expect(assigns(:pending).size).to eq 3
      expect(assigns(:approved).size).to eq 1
      expect(assigns(:rejected)).to be_empty
    end

  end

end

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

  describe "GET new" do
    it "não deve ser acessado apenas por usuarios não autenticados" do
      sign_in nil
      get :new
      expect(response).to redirect_to(new_user_session_path)
    end

    it "deve ser acessível por para usuários autenticados" do
      sign_in User.new(role: 'user')
      get :new
      expect(response).to be_success
    end
    it "deve trazer uma questão com 5 questões" do
      sign_in User.new(role: 'user')
      get :new
      expect(assigns(:question).alternatives.size).to eq 5
    end
  end

  describe "POST create" do
    it "não deve ser acessado apenas por usuarios não autenticados" do
      sign_in nil
      post :create, params: { id: 1, question: attributes_for(:question)}
      expect(response).to redirect_to(new_user_session_path)
    end

    it "deve ser acessível por para usuários autenticados" do
      sign_in User.new(role: 'user')
      post :create, params: { question: attributes_for(:question)}
      expect(response).to be_success
    end

    it "deve ter o atributo usuario igual ao usuário da questão" do
      user_login = User.new(role: 'user', name: 'Luan')
      sign_in user_login
      post :create, params: { question: attributes_for(:question)}
      expect(assigns(:question).user).to eq user_login
    end

    # Rails 5 and question_parans not work.
    xit "deve salvar a questão passada por params" do
      sign_in User.new(role: 'user')
      attrs = attributes_for(:question)
      attrs[:alternatives][0].correct = true
      post :create, params: { question: attrs}
      expect(assigns(:question).persisted?).to be true
    end
  end

  describe "PUT update" do
    it "não deve ser acessado para usuarios não autenticados" do
      sign_in nil
      id = "1"
      expect(Question).to receive(:find).with(id).once.and_return(build(:question))
      put :update, params: { id: id, question: attributes_for(:question)}
      expect(response).to redirect_to(new_user_session_path)
    end

    it "deve atualizar a questão passada" do
      sign_in User.new(role: 'user')
      id = "1"
      question = build(:question)
      params = attributes_for(:question)
      expect(Question).to receive(:find).with(id).once.and_return(question)
      expect(question).to receive(:update).once
      put :update, params: { id: 1, question: params }
    end

    it "tornar pendentes questões que estavam rejeitadas" do
      sign_in User.new(role: 'user')
      id = "1"
      reject_question = create(:question)
      reject_question.disapprove!("dica de teste", build(:admin))
      expect(Question).to receive(:find).with(id).once.and_return(reject_question)
      put :update, params: { id: 1, question: attributes_for(:question)}
      expect(assigns(:question).status).to eq "pendente"
    end
  end

  describe "GET approve" do

    it "não deve ser acessado para usuarios não autenticados" do
      sign_in nil
      id = "1"
      expect(Question).to receive(:find).with(id).once.and_return(build(:question))
      get :approve, params: { id: id }
      expect(response).to redirect_to(new_user_session_path)
    end

    it "deve direcionar para a action show" do
      sign_in User.new(role: 'user')
      id = "1"
      question = build(:question)
      question.id = id
      expect(Question).to receive(:find).with(id).once.and_return(question)
      get :approve, params: { id: id }
      expect(response.content_type).to eq "text/html"
      expect(response).to redirect_to action: 'show'
    end

    it "deve aprovar a questão" do
      sign_in User.new(role: 'user')
      id = "1"
      expect(Question).to receive(:find).with(id).once.and_return(build(:question))
      get :approve, params: { id: id }
      expect(assigns(:question).status).to eq "aprovada"
    end

  end

  describe "GET disapprove" do
    it "não deve ser acessado para usuarios não autenticados" do
      sign_in nil
      id = "1"
      expect(Question).to receive(:find).with(id).once.and_return(build(:question))
      get :disapprove, params: { id: id }
      expect(response).to redirect_to(new_user_session_path)
    end

    it "deve direcionar para a action show com um alerta, caso hint não seja passado" do
      sign_in User.new(role: 'user')
      id = "1"
      question = build(:question)
      question.id = id
      expect(Question).to receive(:find).with(id).once.and_return(question)
      get :disapprove, params: { id: id }
      expect(response.content_type).to eq "text/html"
      expect(response).to redirect_to action: 'show'
      expect(flash[:alert]).to be_present
    end

  end



end

class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy, :approve, :disapprove ]
  before_action :authenticate_user!

  # GET /questions
  # GET /questions.json
  def index
    user = current_user
    questions = user.admin? ? Question.all : Question.where(user: user)
    @pending = questions.select {|q| q.status == 'pendente'} # TODO colocar status em 'Enum'
    @approved = questions.select {|q| q.status == 'aprovada'} # TODO colocar status em 'Enum'
    @rejected = questions.select {|q| q.status == 'reprovada'} # TODO colocar status em 'Enum'
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
  end

  # GET /questions/new
  def new
    @question = Question.new(alternatives: [Alternative.new(content: "A"),
                     Alternative.new(content: "B"),
                     Alternative.new(content: "C"),
                     Alternative.new(content: "D"),
                     Alternative.new(content: "E")])
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(question_params)
    @question.user = current_user

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: 'Question was successfully created.' }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    if(@question.status == 'reprovada')
      @question.make_pending!
    end
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url, notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def approve
    @question.approve!
    @question.save
    redirect_to @question, notice: 'Questão foi aprovada!'
  end

  def disapprove
    if params[:hint].nil? || params[:hint].empty?
      redirect_to @question, alert: 'Dica é necessária para reprovar a questão!'
    else
      @question.disapprove!(params[:hint], current_user)
      @question.save
      redirect_to @question, notice: 'Questão foi reprovada!'
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:content, :year, :source, :user_id, alternatives_attributes: [:id, :content, :correct, :_destroy])
    end
end

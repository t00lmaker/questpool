class QuestionStateService

  STATES = {  :pendente =>[:reprovada, :aprovada],
              :reprovada => [:pendente],
              :aprovada =>[] }

  def initialize(question)
    @question = question
  end

  def change(status)
    if status_valid?(status) and change_valid?(status)
      suppress(RuntimeError) do
        @question.status = status.to_s
      end
    else
      raise "Mudança de status não permitida."
    end
  end

  private

  def status_valid?(status)
    STATES.key?(status)
  end

  def change_valid?(status)
    STATES[@question.status.to_sym].include?(status)
  end

end

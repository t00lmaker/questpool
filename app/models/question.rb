class Question < ApplicationRecord
  belongs_to :user
  has_many :alternatives, inverse_of: :question
  has_many :hints

  accepts_nested_attributes_for :alternatives, reject_if: proc { |attrs| attrs[:content].blank? }


  validates_presence_of :content, :year, :source
  validate :validate_num_alternativas, :validate_one_correct

  def approve!
    QuestionStateService.new(self).change(:aprovada)
  end

  def disapprove!(hint, user)
    raise "hint não pode ser nil ou vazia" if hint.nil? or hint.empty?
    self.hints.create(content: hint, user: user)
    QuestionStateService.new(self).change(:reprovada)
  end

  def make_pending!
    QuestionStateService.new(self).change(:pendente)
  end

  def status=(status)
    write_attribute :status, status
    raise "Alteração de valor feita, no entanto prefira os metodos approve!, disapprove! e make_pending!"
  end

  def validate_num_alternativas
    errors.add(:alternatives, "devem ser cinco") if alternatives.size != 5
  end

  def validate_one_correct
    errors.add(:alternatives, "devem ter uma marcada como correta") if alternatives.select{|a| a.correct}.size != 1
  end

end

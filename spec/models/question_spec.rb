require 'rails_helper'

RSpec.describe Question, :type => :model do
  subject {
   described_class.new(
        content: "Anything", source: "UFPI", year: 2012,
        user: User.new, hints: [],
        alternatives: [Alternative.new(content: "A", correct: true),
                         Alternative.new(content: "B"),
                         Alternative.new(content: "C"),
                         Alternative.new(content: "D"),
                         Alternative.new(content: "E")]
    )
  }
  it "é valida com os atributos content, source e year preenchidos" do
    expect(subject).to be_valid
  end

  it "não deve ser válida sem content" do
    subject.content = nil
    expect(subject).to_not be_valid
  end

  it "não deve ser válido sem source" do
    subject.source = nil
    expect(subject).to_not be_valid
  end

  it "não deve ser válido sem year" do
    subject.source = nil
    expect(subject).to_not be_valid
  end

  it "deve ter cinco alternativas" do
    subject.alternatives.size == 5
  end

  it "não deve ter mais que cinco alternativas" do
    subject.alternatives << Alternative.new
    expect(subject).to_not be_valid
  end

  it "não deve ter menos que cinco alternativas" do
    subject.alternatives.delete(subject.alternatives.last)
    expect(subject).to_not be_valid
  end

  it "deve ter pelo menos uma alternativa correta" do
    subject.alternatives.each {|a| a.correct = false}
    expect(subject).to_not be_valid
  end

  describe "status" do

    it "deve ter o valor padrão pendente" do
        expect(subject.status).to eq('pendente')
    end

    it "quando mudado utilizando o método de acesso do atributo status, deve advertir o responsável  " do
      expect { subject.status = 'pendente' }.to raise_error "Alteração de valor feita, no entanto prefira os metodos approve!, disapprove! e make_pending!"
    end

    it "deve ser mudado para aprovada usando o metodo approve!" do
      subject.approve!
      expect(subject.status).to eq('aprovada')
    end

    it "deve ser feita para reprovada usando o metodo disapprove!" do
      subject.save
      subject.disapprove!("short hint", nil)
      expect(subject.status).to eq('reprovada')
    end

    it "para reprovada deve adicionar um hint a questão" do
      subject.save
      subject.disapprove!("short hint", nil)
      expect(subject.status).to eq('reprovada')
      expect(subject.hints.size).to be 1
    end

    it "para reprovada deve adicionar um hint a questão que não deve ser nulo ou vazio" do
      expect{ subject.disapprove!(nil, nil) }.to raise_error "hint não pode ser nil ou vazia"
      expect{ subject.disapprove!("", nil) }.to raise_error "hint não pode ser nil ou vazia"
    end
    # demais validações de mudanças relacionadas a maquina de estados estão em services/question_state_service_spec.rb
  end

end

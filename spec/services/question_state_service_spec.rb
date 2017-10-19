require 'rails_helper'

RSpec.describe QuestionStateService, :type => :model do

  before(:example) do
    @question = Question.new
    @subject = described_class.new(@question)
  end

  it "não deve permitir status que não seja aprovada, pendente, reprovada" do
    expect{ @subject.change(:status_invalid) }.to raise_error "Mudança de status não permitida."
  end

  it "deve alterar os status da questão quando a mudança for permitida" do
    @subject.change(:reprovada)
    expect(@question.status).to eq("reprovada")
    @subject.change(:pendente)
    expect(@question.status).to eq("pendente")
    @subject.change(:aprovada)
    expect(@question.status).to eq("aprovada")
  end

  it "deve realizar a mudança de status de pendente para reprovada" do
    expect{ @subject.change(:reprovada) }.not_to raise_error
  end

  it "deve realizar a mudança de status de pendente para aprovada" do
    expect{ @subject.change(:aprovada) }.not_to raise_error
  end

  it "deve realizar a mudança de status de reprovada para pendente" do
    @subject.change(:reprovada)
    expect{ @subject.change(:pendente) }.not_to raise_error
  end

  it "não deve realizar a mudança de status de aprovada para qualquer outro" do
    @subject.change(:aprovada)
    expect{ @subject.change(:pendente) }.to raise_error "Mudança de status não permitida."
    expect{ @subject.change(:reprovada) }.to raise_error "Mudança de status não permitida."
  end

  it "não deve realizar a mudança de status de reprovada para aprovada" do
    @subject.change(:reprovada)
    expect{ @subject.change(:aprovada) }.to raise_error "Mudança de status não permitida."
  end

end

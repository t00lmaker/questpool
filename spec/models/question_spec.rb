require 'rails_helper'

RSpec.describe Question, :type => :model do
  subject {
   described_class.new(content: "Anything", user: User.new, alternatives: [Alternative.new, Alternative.new], hints: [])
  }
  it "é valida com todos os atributos preenchidos" do
    expect(subject).to be_valid
  end
end

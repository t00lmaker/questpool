# Factories use factory_bot_rails
# (https://github.com/thoughtbot/factory_bot_rails)

FactoryBot.define do
  factory :user, class: User do
    name "Luan"
    email "luanpontes2@gmail.com"
    role 'user'
    password '123456'
  end

  factory :admin, class: User do
    name "Luan"
    email "luanpontes1@gmail.com"
    role "admin"
    password '123456'
  end

  factory :alternative do
    content "aletrnativa"
  end

  factory :question do
    content "O enunciado de uma questão"
    source "UFPI"
    year "2012"
    association :user, factory: :user
    alternatives { build_list(:alternative, 5) }
    after(:build) do |q, evaluator|
      q.alternatives.first.correct = true
    end
  end


end

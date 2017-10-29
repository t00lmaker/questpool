

puts 'Criando usuário Administrador'

User.create!(name: 'Administrador', email: 'admin@mail.com', role: 'admin',	password: 'r00T8dm1n')

puts "Administrador criado com sucesso!"
puts "Credenciais de acesso"
puts " login: admin@mail.com"
puts " senha: r00T8dm1n"

#! /usr/bin/ruby
# encoding: utf-8

#Saber si el usuario es root
usuario = `whoami`
puts usuario

#Splitear lista de usuarios
lista = `cat userslist.txt`
usuarios = lista.split("/n")

if usuario.chop == "root"
	
	usuarios.each do |usu|
		campos = usu.split(":")
		nombre = campos[0]
		apellido = campos[1]
		email = campos[2]
		action = campos[3]
		
		if action == "delete"
			system ("deluser -f -r #{campos[0]}")
		end
		
		if action == "add"
			system ("adduser #{campos[0]}")
		end
		
		if email == ""
			puts "No se hace nada con el usuario #{campos[0]}"
		end
	end
	
end

if usuario.chop != "root"

	puts "Se necesita ser root para ejecutar este script"

end

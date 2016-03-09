#!/usr/bin/ruby
# encoding: utf-8

#Comprobar si el usuario es root
def comprobar_root

usuario=`whoami`
quiensoy=usuario.chop

if quiensoy=="root" then
	puts "Eres usuario root, todo correcto"
	puts " "
else
	puts "deber ser root para ejecutar este script"
	puts " "
	exit
end

end

#Listamos los usuarios y luego los eliminamos
def eliminar_usuarios
lista=`cat userslist.txt`
usuarios=lista.split("\n")
usuarios.each do |nombre|
system("userdel -f -r #{nombre}")
end
end

#Llamamos a ambas funciones
comprobar_root
eliminar_usuarios

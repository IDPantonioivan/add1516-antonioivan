#!/usr/bin/ruby
# encoding: utf-8

#Comprobar si el usuario es root

usuario=`whoami`

quiensoy=usuario.chop

if quiensoy=="root" then
puts "Eres usuario root, todo correcto"
puts "--------------------------------"
else
puts "deber ser root para ejecutar este script"
puts "----------------------------------------"
exit
end

lista=`cat software-list.txt`
software=lista.split("\n")

#Actualizar los repositorios
system("apt-get update")
puts "Se han actualizado los repositorios"

software.each do |lineas|
	datos=lineas.split(":")
	paquete=datos[0]
	accion=datos[1]
	instalado = system("dpkg -l #{paquete}|grep ii")

		
	if (accion == "remove" or accion == "r") and instalado==true
		
		system("apt-get remove --purge -y #{paquete}")
		puts "Se ha desinstalado: #{paquete}"
		
	elsif accion == "install" or accion =="i" and instalado==false
			
		system("apt-get install -y #{paquete}")
		puts "Se ha instalado: #{paquete}"
			
	end
	
end

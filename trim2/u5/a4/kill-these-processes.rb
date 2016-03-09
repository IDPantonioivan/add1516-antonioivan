#!/usr/bin/ruby
# encoding: utf-8

#Comprobar si el usuario es root
require "rainbow"
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

def listar_procesos

lista=`cat processes-black-list.txt`
procesos=lista.split("\n")

end


def comprobar_procesos(proceso, accion)

ejecutandose = system("ps -e| grep #{proceso} 1>/dev/null")
if (accion == "kill" or accion == "remove" or accion == "r") and ejecutandose==true
system("killall #{proceso} 1>/dev/null")
puts " "
puts Rainbow("Se ha detenido el proceso: #{proceso}").color(:red)
puts ""
elsif (accion == "notify" or accion =="n") and ejecutandose==true 
puts " "
puts Rainbow("NOTICE: #{proceso} en ejecución").color(:green)
puts " "
elsif (accion == "notify" or accion =="n") and ejecutandose==false 
puts ""
puts Rainbow("NOTICE: #{proceso} no se está ejecutando").color(:blue)
puts " "
end
end


comprobar_root
listar_procesos
system ("touch state.running 1>/dev/null")

procesamiento=listar_procesos

while File.exist? "state.running"  do
	procesamiento.each do |lineas|
	datos=lineas.split(":")
	proceso=datos[0]
	accion=datos[1]
	comprobar_procesos(proceso,accion)
	sleep(5)
end


end

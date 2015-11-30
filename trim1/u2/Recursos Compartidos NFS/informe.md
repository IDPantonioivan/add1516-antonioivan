NFS (Network File System)

NFS es una forma de crear recursos en red para compartir con sistemas heterogéneos.

#1. SO Windows
Para esta parte vamos a necesitar 2 máquinas:
* MV Windows 2008 Server (Enterprise) como nuestro servidor NFS.
    * Como nombre de esta máquina usar "primer-apellido-alumno+XX+WS".
    * IP estática 172.18.XX.22
    * Grupo de trabajo AULA108
* MV Windows (Enterprise) como nuestro cliente NFS.
    * Como nombre de esta máquina usar "primer-apellido-alumno+XX+WC".
    * IP estática 172.18.XX.12
    * Grupo de trabajo AULA108
    
> Donde XX es el número de PC de la máquina real de cada uno. 
Para averiguar XX se ejecuta en la máquina real, `ip a` o `ifconfig` o `if a s`, 
si muestra IP 172.16.8.30 entonces XX=30.

##1.1 Servidor NFS Windows

Instalación del servicio NFS en Windows 2008 Server
* Agregar rol `Servidor de Archivos`.
* Marcar `Servicio para NFS`.

![](./images/1.png)
![](./images/2.png)

Configurar el servidor NFS de la siguiente forma:

* Crear la carpeta `c:\export\public`. Picar en la carpeta `botón derecho 
propiedades -> Compartir NFS`, y configurarla para que sea accesible desde 
la red en modo lectura/escritura con NFS

![](./images/3.png)

* Crear la carpeta `c:\export\private`. Picar en la carpeta `botón derecho 
propiedades -> Compartir NFS`, y configurarla para que sea accesible desde la red 
sólo en modo sólo lectura.

![](./images/4.png)


* Ejecutamos el comando `showmount -e ip-del-servidor`, para comprobar los recursos compartidos.

![](./images/5.png)

##1.2 Cliente NFS

Las últimas versiones de Windows permiten trabajar con directorios de red NFS nativos de sistemas UNIX. 
En esta sección veremos como montar y desmontar estos directorios bajo un entorno de Windows 7 
Enterprise (Las versiones home y starter no tienen soporte para NFS).

**Instalar el soporte cliente NFS bajo Windows**
* En primer lugar vamos a instalar el componente cliente NFS para Windows. 
Para ello vamos a `Panel de Control -> Programas -> Activar o desactivar características de Windows`.

* Nos desplazamos por el menú hasta localizar Servicios para NFS y dentro de este, Cliente NFS. 
* Marcamos ambos y le damos a Aceptar.
* En unos instantes tendremos el soporte habilitado.

![](./images/6.png)

Iniciar el servicio cliente NFS.

* Para iniciar el servicio NFS en el cliente, abrimos una consola con permisos de Administrador.
* Ejecutamos el siguiente comando: `nfsadmin client start`

![](./images/7.png)

**Montando el recurso**

Ahora necesitamos montar el recurso remoto para poder trabajar con él.

* Esto no lo hacemos con Administrador, sino con nuestro usuario normal.
* Consultar desde el cliente los recursos que ofrece el servidor: `showmount -e ip-del-servidor`

![](./images/8.png)

* Montar recurso remoto: `mount –o anon,nolock,r,casesensitive \\ip-del-servidor\Nombre-recurso-NFS *`
* Comprobar en el cliente los recursos montados: `net use`
* Comprobar desde el cliente: `showmount -a ip-del-servidor`

![](./images/9.png)

* En el servidor ejecutamos el comando `showmount -e ip-del-servidor`, para comprobar los recursos compartidos.

![](./images/10.png)


> **EXPLICACIÓN DE LOS PARÁMETROS**
>
> * anon: Acceso anónimo al directorio de red.
> * nolock: Deshabilita el bloqueo. Esta opción puede mejorar el rendimiento si sólo necesita leer archivos.
> * r: Sólo lectura. Para montar en modo lectura/escritura no usaremos este parámetro.
> * casesensitive: Fuerza la búsqueda de archivos con distinción de mayúsculas y minúsculas (similar a los clientes de NFS basados en UNIX).


* Hemos decidido asignar la letra de unidad de forma automática, así que si no hay otras unidades de red 
en el sistema nos asignará la Z.

![](./images/unidad.png)

> Si hay problemas, comprobar que la configuración del cortafuegos del servidor permite accesos NFS.

> * Desde un cliente GNU/Linux hacemos `nmap IP-del-servidor -Pn`.
> * Debe aparecer abierto el puerto del servicio NFS

![](./images/nmap.png)

* Para desmontar la unidad simplemente escribimos en una consola: `umount z:`

![](./images/11.png)

* En el servidor ejecutamos el comando `showmount -e ip-del-servidor`, para comprobar los recursos compartidos.

![](./images/12.png)

#2. SO OpenSUSE

Vamos a necesitar 2 máquinas GNU/Linux:

- MV OpenSUSE, donde instalamos el servicio NFS (directorios compartidos por red):
1. Como nombre de esta máquina usar nfs-server-XX. Modificar el fichero /etc/hostname, para establecer el nombre de máquina, y el fichero /etc/hosts.
2. IP estática 172.18.XX.52
3. VirtualBox Red en Modo Puente
- MV OpenSUSE, donde instalaremos el cliente NFS.
1. Como nombre de esta máquina usar nfs-client-XX
2. IP estática 172.18.XX.62
3. VirtualBox Red en Modo Puente

Podemos configurar tambien el archivo hosts en /etc o en el Yast:

   172.18.XX.52 nfs-server-XX.apellido-alumno   nfs-server-XX
   172.18.XX.62 nfs-client-XX.apellido-alumno   nfs-client-XX

![](./imagenes/2.png)

##2.1 Servidor NFS


- Instalar servidor NFS por Yast.

![](./imagenes/2.1.png)
- Crear las siguientes carpetas/permisos:

1. /var/export/public, usuario y grupo propietario nobody:nogroup
2. /var/export/private, usuario y grupo propietario nobody:nogroup, permisos 770

![](./imagenes/2.1.1.1.png)

- Vamos configurar el servidor NFS de la siguiente forma:
1. La carpeta /var/export/public, será accesible desde toda la red en modo lectura/escritura.
2. La carpeta /var/export/private, sea accesible sólo desde la IP del cliente, sólo en modo lectura.
- Para ello usaremos o Yast o modificamos el fichero /etc/exports añadiendo las siguientes líneas:

![](./imagenes/2.1.1.png)

- Para iniciar y parar el servicio NFS, usaremos Yast o systemctl. Si al iniciar el servicio aparecen mensaje de error o advertencias, debemos resolverlas. Consultar los mensajes de error del servicio.

![](./imagenes/2.1.2.png)

- Para comprobarlo, showmount -e localhost. Muestra la lista de recursos exportados por el servidor NFS:

![](./imagenes/2.1.3.png)

##2.2 Cliente NFS

En esta parte, vamos a comprobar que las carpetas del servidor son accesibles desde el cliente.


Ping entre ambos para ver si todo va correcto:
![](./imagenes/2.2.png)

nmap ip-del-servidor -Pn

![](./imagenes/2.2.1.png)

showmount -e ip-del-servidor: Muestra la lista de recursos exportados por el servidor NFS.

![](./imagenes/2.2.2.png)

Ahora en el cliente vamos a montar y usar cada recurso compartido. Veamos ejemplo con public.

- Crear la carpeta /mnt/remoto/public

![](./imagenes/2.2.3.png)

- mount.nfs ip-del-servidor:/var/export/public /mnt/remoto/public montar el recurso

![](./imagenes/2.2.4.png)

- df -hT, y veremos que los recursos remotos están montados en nuestras carpetas locales.

![](./imagenes/2.2.5.png)

##2.3. Montaje automático

Para configurar acciones de montaje autoḿaticos cada vez que se inicie el equipo en OpenSUSE usamos Yast o bien modificamos la configuración del fichero /etc/fstab. Comprobarlo.


Añadimos la última línea en el fichero:
![](./imagenes/2.3.4.png)

#3. Preguntas

-  ¿Nuestro cliente GNU/Linux NFS puede acceder al servidor Windows NFS? Comprobarlo.
No nos ha dejado acceder pero si monta los recursos

![](./imagenes/wind1.png)
![](./imagenes/wind2.png)
![](./imagenes/wind3.png)

- ¿Nuestro cliente Windows NFS podría acceder al servidor GNU/Linux NFS? Comprobarlo.

![](./imagenes/pregunta2.png)

-  Fijarse en los valores de usuarios propietario y grupo propietario de los ficheros que se guardan en el servidor, cuando los creamos desde una conexión cliente NFS.

![](./imagenes/pregunta3.png)

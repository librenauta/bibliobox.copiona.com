---
layout: post
title: ¿Cómo hacer tu propia biblio.box?
tags:
  - cultura libre
  - bibliotecas libres
  - libros
  - biblioteca portátil
description: >
  Una bibliobox es una biblioteca portátil ambulante
 #hero: https://source.unsplash.com/collection/145103/
hero: /assets/img/biblio.box.jpg
overlay: red
published: true
---


¿Querés tener una biblioteca portátil para compartir libros? en la siguiente entrada se detalla como crear una bibliobox usando el código de [biblioteca-guerrilla](https://github.com/elKaZe/biblioteca-guerrilla) una raspberry pi y una celda de carga.
{: .lead}
> Una bibliobox es un dispositivo que crea una red [WLAN](https://en.wikipedia.org/wiki/Wireless_LAN) para poder conectarte y navegar un sitio estático que contiene una biblioteca digital.

Si bien el software puede utilizarce en varios dispositivos, esta instancia de biblioteca guerrilla será  montada en una raspberry pi.
 En esta documentación se detallará ese procedimimiento
*al estilo receta de cocina: ¿Qué necesitamos?

* [Raspberry PI 3 model B](https://www.raspberrypi.org/products/raspberry-pi-3-model-b/) [con placa de WiFi integrada]
* Monitor con hdmi para instalar [Rasbian](https://www.raspberrypi.org/downloads/raspbian)  a la Raspberry PI 3
* Tarjeta de memoria + 8gb (para OS y Libros)
* Computadora con Gnu/linux[^1] instalado.
* Calibre instalado  con una biblioteca y libros.

## El procedimiento se puede dividir en 3 etapas

* #1-Equipo [A] que generará el sitio estático con la biblioteca.
* #2-Equipo [B] que alojará la biblioteca virtual.
* #3-Copiar el sitio generado de [A] >>[B]



#1 Equipo que generará el sitio estático con la biblioteca.
---------------------------------------------------------------------
1. Instalar [[Calibre]](https://calibre-ebook.com) este será el lugar donde volcaremos los libros y los organizarémos por etiquetas, autoras, series.
2. Volcar libros en una biblioteca.
3. Editar metadata de los libros y asegurarnos que tienen todos portadas [tapas], en el buscador de calibre podemos poner: `cover:false` para filtrar los libros que no tengan una tapa, y podemos crearle una en `Modificar metadatos > Generar portada`

4. Clonar el repositorio de [[biblioteca-guerrilla]](https://github.com/elKaZe/biblioteca-guerrilla) `git clone https://github.com/elKaZe/biblioteca-guerrilla.git `
>Biblioteca-guerrilla es un script escrito en python que utiliza la base de datos de calibre y los libros de la biblioteca para crear un sitio estático. para ejecutar el script que esta en ./biblioteca-guerrilla/app/freeze.py son necesarias algunas herramientas:


* Instalar [[Python]](https://tutorial.djangogirls.org/es/python_installation/)
* Instalar pipenv `pip install pipenv --user`
* Instalar las dependencias parado en ./biblioteca-guerrilla `pipenv install` [1]
* Luego iniciar el entorno de trabajo para poder generar la biblioteca `pipenv shell`
* Ahora que tenemos el entorno de trabajo con las dependencias vamos a editar el archivo ./biblioteca-guerrilla/app/settings.py y reemplazar la ruta donde esta nuestra biblioteca calibre y su archivo metadata.db en FREEZER_DESTINATION podemos editar la ruta donde guardará el sitio estático con la página.  
~~~python
CONECTOR_OPCIONES = {
    "ruta": "ruta/a/la/bibliotecaDeCalibre/metadata.db"
    }
RUTA_BASE_LIBROS = "ruta/a/la/bibliotecaDeCalibre/"
FREEZER_DESTINATION = "/tmp/biblioteca-guerrilla/"
~~~
[1] Aquí cree el directorio `mkdir miaubox` y clone el repositorio allí dentro.
![683x741](https://bibliobox.copiona.com/assets/img/02.png "Large example image")
[2] Editando con nano el archivo settings.py
![683x741](https://bibliobox.copiona.com/assets/img/02.png "Large example image")
[3] Ejecutando pipenv shell
![683x741](https://bibliobox.copiona.com/assets/img/03.png "Large example image")
[4] Luego de editar y guardar settings.py podemos crear el sitio estático con `make generate-static-website` si no tenes `make` podes hacer `apt/pacman/dnf install make dependiendo de tu dsitribución Gnu/linux`

Ejecutando make generate-static-website
![683x741](https://bibliobox.copiona.com/assets/img/04.png "Large example image")
[5] Para ejecutar un servidor de pruebas ejecutamos `make start-test-server` y podemos acceder a el vía `http://localhost:5000/`

![683x741](https://bibliobox.copiona.com/assets/img/05.png "Large example image")

[6] Con esto tenemos el sitio en /tmp/biblioteca-guerrilla/ ahora lo siguiente es preparar el equipo donde se alojará el sitio estático!
![683x741](https://bibliobox.copiona.com/assets/img/06.png "Large example image")
* Luego de agregar varios libros podemos realizar nuevamente el paso 5 y copiar la nueva web actualizada de /tmp/biblioteca-guerrilla.
![683x741](https://bibliobox.copiona.com/assets/img/07.png "Large example image")

#2  Equipo que alojará la biblioteca.
-----------------------------------------
-Estos pasos recomiendo hacerlos con un monitor enchufado a la raspberrypi.
1. Instalación de OS en raspberry pi 3, en este [link](https://www.raspberrypi.org/downloads/raspbian) podrás descargar la imagen de raspbian, la distribución optimizada de debian para instalar en raspberry pi, luego de instalar `sudo apt-get update
sudo apt-get upgrade`
2. Cambio de contraseña de usuaria pi (por defecto). Con `sudo passwd` cambiamos la contraseña por defecto e introducimos 2 veces la nueva.
3. Instalación de nginx como servidor Web [Acá](https://howtoraspberrypi.com/install-nginx-raspbian-and-accelerate-your-raspberry-web-server/) hay una guía muy completa de como instalarlo y dejar el servicio funcionando (dejar el servicio significa que nginx el servidor web que instalaremos se iniciará cuando la raspberrypi inicie)
4. Como raspbian viene con apache vamos a pararlo con:
 `sudo /etc/init.d/apache2 stop`
Luego le decimos con [`systemd`](https://wiki.archlinux.org/index.php/systemd_(Espa%C3%B1ol)) que no este enabled como servicio:
`sudo systemctl disable apache2`
5. Instalamos nginx y php-fpm
`sudo apt install nginx php-fpm`

6. Comenzamos a Configurar el Acces Point (utilizaremos el hardware wifi para crear una red Wlan y actuar de router)
para esto necesitaremos hostapd: `sudo apt-get install dnsmasq hostapd`
7. Como no configuramos nada todavía vamos a desactivar temporalmente dnsmasq y hostapd                         
`sudo systemctl stop dnsmasq
sudo systemctl stop hostapd`
8. Luego reiniciamos la raspberrypi con `sudo reboot`

9. Estamos configurando una red inalámbrica para que actue como servidor, asique necesitaremos una ip estática asignada al puerto inalámbrico para luego  conectarnos a ella y que el dhcp nos asigne una ip como clientas.
Para configurar la ip estática editamos el siguiente archivo:                           
 `sudo nano /etc/dhcpcd.conf` (nano es el editor de texto que viene por defecto en raspbian)
alli podremos lo siguiente al final del archivo:
~~~bash
interface wlan0
    static ip_address=192.168.100.1/24
    nohook wpa_supplicant
~~~
static ip_address es la ip con la cual nos conectaremos via ssh luego                   
 `ssh pi@192.168.100.1`
10. Luego restarteamos el servicio dhcp `sudo service dhcpcd restart` y tendremos una ip estática en wlan0
11. El servicio DHCP es llamado por dnsmasq. por defecto el archivo dnsmasq.conf contiene mucha información y es mejor arrancar uno de cero, asque editamos el nombre con `sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig` y dejamos un backup del archivo de configuración
12. Luego iniciamos uno nuevo con `sudo nano /etc/dnsmasq.conf` y pegamos las siguentes lineas:                 
`interface=wlan0      # Use the require wireless interface - usually wlan0
  dhcp-range=192.168.100.2,192.168.100.24,255.255.255.0,24h`

13. Ahora editaremos el archivo de configuración de Hostapd, el software para crear el acces point en:
`sudo nano /etc/hostapd/hostapd.conf` en este archivo pondremos el nombre de la red inalámbrica y si queremos que tenga contraseña o no.

usar lo siguiente:
~~~bash
interface=wlan0
driver=nl80211
ssid=Biblio.box
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=biblioteca
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
~~~

* En ssid= poner el nombre de la red inalámbrica
* En wpa_passphrase= poner la constraseña si es que la queremos.
14. Ahora necesitamos que el sistema encuentre el archivo asi que en `sudo nano /etc/default/hostapd` buscamos #DAEMON_CONF y escribimos `DAEMON_CONF="/etc/hostapd/hostapd.conf"`

15. Iniciamos los servicios dnsmasq & hostapd
~~~bash
sudo systemctl start hostapd
sudo systemctl start dnsmasq
~~~
16. Antes de reiniciar vamos a chequear  tener el puerto 22 (SSH) abierto para poder comunicarnos via Wireless. Lo más fácil es utilizar el comando `sudo raspi-config` > 5 Interfacing Options > P2 SSH > Sí.

17. Luego parado en la máquina [A] y conectada a la red biblio.box  ubicamos la ruta donde creamos la biblioteca-guerrilla y enviamos esa carpeta al home/pi/ de la raspberrypi con el comando `scp`.
Escribimos -r para que copie los directorios y subdirectorios.
* El comando scp copia y envía por ssh lo que indiquemos, primero hay que indicar el directorio a copiar y luego la conexión via ssh al equipo de destino, seguido de la ubicación de la carpeta destino.
~~~bash
scp -r /tmp/biblioteca-guerrilla/ pi@192.168.100.1:/home/pi/
~~~
![screenshot de una terminal copiando los archivos](assets/img/08.png)

18. Luego en pi@192.168.100.1 dentro de /home/pi utilizamos el comando `mv` para mover los directorios del home a la carpeta host.
~~~bash
sudo mv -r /home/pi/biblioteca-guerrilla /var/www/html
~~~
19. Por último nos conectamos a la red vía movil o con una computadora y tecleamos en el navegador `192.168.100.1` e ingresamos a la biblioteca portátil. si ingresamos desde un celular, es necesario que desactivemos los datos móviles, ya que al ingresar la ip, el navegador intentará hacer una petición fuera de la red wlan0.

20. Por último, podemos conectar directamente la celda de carga con la raspberry-pi-3 y montar la red en cualquier sitio, independientemente de si hay corriente electrica o internet.

# ¡A por islas de bibliotecas portátiles!
![una bibliobox feliz :)](assets/img/09.jpg)

# Fuentes
1. [Setting up a Raspberry Pi as an access point in a standalone network (NAT)](https://www.raspberrypi.org/documentation/configuration/wireless/access-point.md)
2. [Install Nginx Raspbian, and accelerate your Raspberry web server](https://howtoraspberrypi.com/install-nginx-raspbian-and-accelerate-your-raspberry-web-server/)
3. [SSH-Raspbian](https://www.raspberrypi.org/forums/viewtopic.php?t=175143)

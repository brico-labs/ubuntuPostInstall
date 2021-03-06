---
title: Notas de post-instalación para Ubuntu Trusty
author:
- Sergio Alvariño <salvari@gmail.com>
tags: [BricoLabs]
date: diciembre-2015
lang: [es-ES]
abstract: |
Notas de post-instalación para Ubuntu LTS 14.04 Trusty Tahir
...

# Introducción {#intro}

Este documento es una descripción de las operaciones de post instalación
para Ubuntu 14.04 Trusty Tahir.

La instalación de Ubuntu se hizo en mi portátil, un ordenador Acer 5755G
con las siguientes características:

-   Core i5 2430M 2.4GHz

-   NVIDIA Geforce GT 540M

-   8Gb RAM

-   750Gb HD

La instalación de Ubuntu realizada es una instalación personalizada para
permitir editar la tabla de particiones. Las particiones en mi portátil
son muy simples 70Gb para / y el resto en una partición montada en
/store.

Ciertos directorios de trabajo (p.ej. /var) los convierto más tarde (a
mano) en symlinks a /store para que no ocupen espacio en la partición
root.

Lo mismo hago con ciertos directorios de mi home, por ejemplo el
directorio de música, el de imágenes, el de descargas y la biblioteca de
Calibre los tengo en /store con enlaces simbólicos a los mismos en home

Si no me equivoco, cuento todo lo que hice para dejar la instalación de
Ubuntu a mi gusto, aunque ya se sabe que esta tarea nunca acaba si te
gusta trastear.

Además de algunos detalles de configuración, la mayor parte del
documento trata de instalar programas, hay dos casos:

-   Programas que ya están en Ubuntu pero no están disponibles en la
    última versión.

    Para la mayor parte hay ppa (Personal Package Archive) disponibles,
    a veces incluso del equipo de desarrollo. Basta con añadir los ppa a
    nuestra lista de fuentes de software para instalarlos en Ubuntu.

-   Programas que no están disponibles en Ubuntu ni siquiera como ppa.

    Para instalar estos programas hay diversos métodos, más o menos
    complicados (e interesantes) para instalarlos.

Todo el documento está basado en la instalación que hago para mi
portátil. Eso significa que es un sistema para un solo usuario y por eso
cuando instalo un programa del segundo grupo, a veces simplemente lo
instalo en mi directorio `~/apps`.

El que quiera aplicar la instalación de estos programas en un ordenador
multiusuario tendrá que currarse una instalación en un directorio de
sistema (lo más lógico sería usar `/usr/local` creo yo)

En cualquier caso cuando instalemos programas que no están disponibles
en los orígenes de software para Ubuntu (oficiales o no) las únicas
operaciones adicionales que nos pueden hacer falta son

-   Añadir un lanzador al programa o hacer que el programa aparezca en
    el Dash

-   Hacer que la base de datos de paquetes sepa que hemos instalado el
    programa.

Del primer caso hay múltiples ejemplos en el documento, del segundo
tenemos el caso de TeX, que también incluimos en este documento.

Solución de problemas
=====================

Cursor parpadeante
------------------

Nada más terminar la instalación me apareció un problema bastante
molesto de parpadeo del cursor. Se soluciona fácilmente desactivando el
monitor secundario que creó la instalación.

System Settings::Displays: Desactivar el Unknow Monitor

Retardo en el click izquierdo del ratón.
----------------------------------------

Este problema apareció mucho más tarde despues de estar unos dias usando
la nueva distribución. No tengo ni idea de la causa y la solución la
encontré después de un par de horas navegando foros en la web.

Los síntomas eran bastante curiosos. Resumiendo: para que funcionara el
click izquierdo del ratón había que hacer: Pulsar Botón Izquierdo -
esperar (digamos que medio segundo al menos) - Soltar botón izquierdo

La solución pasa por desactivar la emulación de tres botones para el
ratón. Mi ratón es un Microsoft de dos botones mas rueda central.

Para identificar correctamente el ratón lo mejor es lanzar un terminal y
monitorizar el `syslog`:

    $ sudo tail -f /var/log/syslog
          

Ahora desconectamos el ratón y lo volvemos a conectar para ver el código
de producto

Veremos algo parecido a esto:

    Feb 22 15:23:33 rasalhague kernel: [ 8664.300394] usb 2-1.2: new low-speed USB device number 4 using ehci-pci
    Feb 22 15:23:33 rasalhague kernel: [ 8664.399363] usb 2-1.2: New USB device found, idVendor=045e, idProduct=00cb
    Feb 22 15:23:33 rasalhague kernel: [ 8664.399375] usb 2-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
    Feb 22 15:23:33 rasalhague kernel: [ 8664.399382] usb 2-1.2: Product: Microsoft Basic Optical Mouse v2.0
    Feb 22 15:23:33 rasalhague kernel: [ 8664.399387] usb 2-1.2: Manufacturer: Microsoft
    Feb 22 15:23:33 rasalhague kernel: [ 8664.403027] input: Microsoft  Microsoft Basic Optical Mouse v2.0  as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.0/input/input15
    Feb 22 15:23:33 rasalhague kernel: [ 8664.403406] hid-generic 0003:045E:00CB.0002: input,hidraw0: USB HID v1.11 Mouse [Microsoft  Microsoft Basic Optical Mouse v2.0 ] on usb-0000:00:1d.0-1.2/input0
    Feb 22 15:23:33 rasalhague mtp-probe: checking bus 2, device 4: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2"
    Feb 22 15:23:33 rasalhague mtp-probe: bus: 2, device: 4 was not an MTP device
          

La parte que nos interesa es la que dice que tenemos instalado un
"Microsoft Basic Optical Mouse v2.0 ", ojo, que en mi caso el nombre de
producto tiene un espacio al final y me llevó un rato darme cuenta.

Para ver la lista de dispositivos de entrada del servidor X también
podemos hacer:

    $ xinput --list
          

En mi caso veo que tengo el ratón con el identificador de producto que
ya mencionamos asociado al dispositivo 12, para ver las propiedades
puedo ejecutar cualquiera de los dos comandos siguientes:

    $ xinput --list-props "Microsoft  Microsoft Basic Optical Mouse v2.0 "
    $ xinput --list-props 17
          

Para dejar la emulación de tres botones desactivada editamos el fichero
`/usr/share/hal/fdi/policy/mouse-3button.fdi
      ` como sigue:

    $ sudo gedit /usr/share/hal/fdi/policy/mouse-3button.fdi
          

Y que contenga lo siguiente:

    <?xml version="1.0" encoding="UTF-8"?>

      <deviceinfo version="0.2">
        <device>
          <match key="info.product" string="Microsoft  Microsoft Basic Optical Mouse v2.0 ">
            <merge key="input.x11_options.Emulate3Buttons" type="string">false</merge>
          </match>
        </device>
      </deviceinfo>
          

Con esta modificación a mi se me resuelve el problema.

Soporte para la Nvidia Optimus
------------------------------

Si tienes la suerte (o la desgracia, según se mire) de tener una Nvidia
Optimus el soporte en linux (y en Ubuntu) ya esta muy avanzado.

Instalamos el paquete Bublebee:

    sudo add-apt-repository ppa:bumblebee/stable
    sudo apt-get update
    sudo apt-get install bumblebee bumblebee-nvidia virtualgl primus nvidia-331
          

Si ademas vamos a necesitar utilizar la nvidia con programas de 32 bits
(por ejemplo bajo wine):

    sudo apt-get install virtualgl-libs:i386
    primus-libs-ia32
          

Si algo no va bien habría que tocar los ficheros de configuración, el
propio programa de instalación nos da algunas pistas:

    DKMS: install completed.
    Setting up bumblebee (3.2.1-90~trustyppa1) ...
    Installing new version of config file /etc/modprobe.d/bumblebee.conf ...
    Selecting 01:00:0 as discrete nvidia card. If this is incorrect,
    edit the BusID line in /etc/bumblebee/xorg.conf.nouveau .
    bumblebeed start/running, process 26868
    Setting up primus-libs:amd64 (20131127-1~trustyppa1) ...
    Processing triggers for initramfs-tools (0.103ubuntu4.2) ...
    update-initramfs: Generating /boot/initrd.img-3.13.0-32-generic
    Setting up primus (20131127-1~trustyppa1) ...
    Setting up bumblebee-nvidia (3.2.1-90~trustyppa1) ...
    Selecting 01:00:0 as discrete nvidia card. If this is incorrect,
    edit the BusID line in /etc/bumblebee/xorg.conf.nvidia
    rmmod: ERROR: Module nouveau is in use
    bumblebeed stop/waiting
    bumblebeed start/running, process 32484
    Processing triggers for libc-bin (2.19-0ubuntu6) ...
          

Ajustes estéticos
=================

Activar espacios de trabajo
---------------------------

1.  En el Dash (<span class="keycombo">Super+A</span>) buscamos
    Appearance (Apariencia)

2.  En la pestaña Behavior activamos la opción de Workspaces

Modificar formato de fecha
--------------------------

Cambio el formato del reloj para poder ver el dia del mes y de la
semana. Con botón derecho del ratón sobre el reloj accedemos a Settings.

Cairo Dock
----------

Cuando Canonical decidió brindar una nueva experiencia de usuario,
adoptando Unity, superé el trauma instalando Cairo Dock.

Tengo que admitir que hoy en dia estoy bastante cómodo con Unity pero
"le he cogido cariño" al dock y lo mantengo en mi portátil aunque ya no
arranca por defecto al inicio.

    $ sudo add-apt-repository ppa:cairo-dock-team/ppa
    $ sudo add-apt-repository ppa:xubuntu-dev/xfce-4.10
    $ sudo apt-get install cairo-dock
          

Para todos los que necesiten tener un menú de aplicaciones pero no
quieran el Dock les recomiendo que prueben el appindicator Classic Menú.
Así que...

Instalación de Classic Menú
---------------------------

    $ sudo add-apt-repository ppa:diesch/testing
    $ sudo apt-get update
    $ sudo apt-get install classicmenu-indicator
          

Gestión de paquetes
===================

Instalación de Synaptic
-----------------------

Generalmente uso la línea de comandos o Aptitude para instalar pero
Synaptic también está muy bien, mucho mejor que el centro de software de
Ubuntu para la mayor parte de las tareas. Desde Synaptic podemos
visualizar facilmente los orígenes de software que tengamos configurados
para nuestro sistema

    $ sudo apt-get install synaptic
          

> **Important**
>
> Una vez configurado Synaptic es importantísimo entrar en las opciones
> y deshabilitar la opción de instalar los paquetes recomendados. En el
> menú Opciones en la opción Preferencias descativamos la opción
> Considerar paquetes recomendados como dependencias

Instalación de Aptitude
-----------------------

    $ sudo apt-get install aptitude
          

Una vez instalado Aptitude, lo configuro para que no instale los
paquetes recomendados, arrancamos con `sudo
      aptitude` y en el menú Options seleccionamos Dependency Handling y
desactivamos la opción Install Recommended Packages Automatically

Aptitude es un atavismo de mis tiempos Debianitas, cuando los hombres
eran hombres y usaban la linea de comandos para casi todo, yo era uno de
los timoratos que usaba un interfaz pseudo gráfico para la gestión de
paquetes. En cualquier caso tiene la ventaja de que también lo podemos
usar como sustituto de apt-get en la linea de comandos y una vez
configurado no nos va a instalar los paquetes recomendados.

Herramientas de configuración de sistema
========================================

Instalación de CCSM
-------------------

Esta aplicación nos permite configurar un montón de opciones de Compiz,
el gestor de ventanas de Ubuntu. (aunque yo, la verdad, lo mantengo con
los efectos al mínimo).

    $ sudo apt-get install compizconfig-settings-manager
    $ sudo apt-get install compiz-plugins-extra
          

Instalar Unity Tweak, Gnome Tweak y Ubuntu Tweak
------------------------------------------------

Nos dan más facilidades para configurar opciones de Unity y de Gnome.

    $ sudo add-apt-repository ppa:tualatrix/ppa
    $ sudo apt-get update
    $ sudo apt-get install ubuntu-tweak
    $ sudo apt-get install unity-tweak-tool gnome-tweak-tool
          

TLP
---

Para mantener un consumo de batería ajustado en el portátil. Yo antes
usaba Jupiter pero ya no existe.

    $ sudo add-apt-repository ppa:linrunner/tlp
    $ sudo apt-get update
    $ sudo apt-get install tlp tlp-rdw
    $ sudo tlp start
    $ sudo tlp stat
          

Utilidades y programas básicos
==============================

Herramientas de compresión
--------------------------

    $ sudo apt-get install p7zip-rar p7zip-full unace unrar zip unzip \
    sharutils rar uudeview mpack arj cabextract file-roller
          

Instalación de restricted extras
--------------------------------

    $ sudo apt-get install ubuntu-restricted-extras
          

Codecs
------

Me da la impresión de que todo esto lo han incluido en los restricted
extras, pero por si acaso ejecutamos:

    $ sudo apt-get install gstreamer0.10-plugins-ugly \
    gstreamer0.10-ffmpeg libxine1-ffmpeg gxine mencoder libdvdread4 \
    totem-mozilla icedax tagtool easytag id3tool lame \
    nautilus-script-audio-convert libmad0 mpg321
    $ sudo /usr/share/doc/libdvdread4/install-css.sh
          

Habilitar la opción de Abrir en Terminal en Nautilus
----------------------------------------------------

Si queremos tener la opción de abrir un terminal de comandos en el
directorio que estamos visitando con Nautilus.

    $  sudo apt-get install nautilus-open-terminal
          

Una vez hecho reiniciamos nautilus:

    $ nautilus -q
          

Applets de Ubuntu
-----------------

Algunos applets útiles (hay muchos más):

Primero un applet para el pronóstico meteorológico y otro para el
calendario.

    $ sudo add-apt-repository ppa:atareao/atareao
    $ sudo apt-get update
    $ sudo apt-get install my-weather-indicator
    $ sudo apt-get install calendar-indicator
          

Arrancamos los dos desde el Dash (Win+A).

Si eres usuario de Evernote no te pierdas everpad

    $ sudo add-apt-repository ppa:nvbn-rm/ppa
    $ sudo apt-get update
    $ sudo apt-get install everpad
          

Wallpapers variados con Variety

    $ sudo add-apt-repository ppa:peterlevi/ppa
    $ sudo apt-get update
    $ sudo apt-get install variety
          

Nixnote
-------

El cliente de Evernote para Linux:

    $ sudo add-apt-repository ppa:vincent-c/nevernote
    $ sudo apt-get update
    $ sudo apt-get install
          

Dropbox
-------

Si eres usuario de Dropbox, la instalación ahora se ha simplificado, el
paquete se encarga de descargar el último cliente de la página web de
Dropbox:

    $ sudo aptitude install dropbox  (se encarga de descargar el sw de la página web)
            

KeePassX
--------

Para almacenar todas nuestras contraseñas cifradas con clave fuerte.

    $ sudo aptitude install keepassx
          

Java
----

Necesitamos tener Java instalado para que posteriormente nos funcionen
varios programas y el plugin del navegador. Yo personalmente uso el
openjdk:

    $ sudo aptitude install icedtea-7-plugin openjdk-7-jre
          

Para desarrolladores hay que instalar también:

    $ sudo apt-get install openjdk-7-jdk
          

Deluge
------

Para descargar torrents

    $ sudo add-apt-repository ppa:deluge-team/ppa  !!!! falla lo he instalado a mano
    $ sudo apt-get update
    $ sudo apt-get install deluge
          

jDownloader
-----------

    $ sudo add-apt-repository ppa:jd-team/jdownloader
    $ sudo apt-get update
    $ sudo apt-get install jdownloader-installer
          

rsync
-----

grsync para tener un interfaz gráfico

    $ sudo aptitude install grsync
          

Calibre
-------

Hacemos un binary install desde linea de comandos:

    sudo -v && wget -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py \
    | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"
          

Se actualiza a menudo así que yo dejo un fichero `updCalibre` en mi
directorio `~/bin` con el siguiente contenido:

    #!/bin/bash
    $ sudo -v && wget -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py \
    | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"
          

GnuCash
-------

Instalado desde Ubuntu

    $ sudo aptitude install gnucash gnucash-docs
          

Seguridad y privacidad
======================

Ejecución de fixubuntu
----------------------

Información reciente disponible en <htpps://fixubuntu.com/>

Basicamente desactivamos las opciones que permiten al Dash buscar
on-line en sitios como Amazon, E-Bay o Ubuntu Shop.

Lo que yo hice fue copiar esto a un terminal y ejecutar

    V=`/usr/bin/lsb_release -rs`; \
    if [ $V \< 12.10 ]; then \
     echo "Good news! Your version of Ubuntu doesn't invade your privacy."; \
    else gsettings set com.canonical.Unity.Lenses remote-content-search none; \
    if [ $V \< 13.10 ]; \
    then sudo apt-get remove -y unity-lens-shopping; \
    else gsettings set com.canonical.Unity.Lenses disabled-scopes \
    "['more_suggestions-amazon.scope', 'more_suggestions-u1ms.scope', \
      'more_suggestions-populartracks.scope', 'music-musicstore.scope', \
      'more_suggestions-ebay.scope', 'more_suggestions-ubuntushop.scope', \
      'more_suggestions-skimlinks.scope']";\
    fi; \
    if ! grep -q productsearch.ubuntu.com /etc/hosts; \
    then echo -e "\n127.0.0.1 productsearch.ubuntu.com" \
     | sudo tee -a /etc/hosts >/dev/null;\
    fi; \
    echo "All done. Enjoy your privacy."; fi
          

Desactivado el reporte automático de errores
--------------------------------------------

Si te molesta que Ubuntu esté todo el tiempo pidiendo permiso para
enviar un informe.

Editamos el fichero `/etc/default/apport` y ponemos `enabled=0`

    $ sudo gedit /etc/default/apport
    $ sudo restart apport
          

Desactivación de remote login y guest login
-------------------------------------------

A mi no me hacen falta (no lo uso), además lo de permitir
simultaneamente las opciones de login remoto y login anónimo no parece
muy buena idea. Pero que conste que no lo he investigado en profundidad.

    $ echo allow-guest=false \
    | sudo tee -a /etc/lightdm/lightdm.conf.d/50-unity-greeter.conf
    $ echo greeter-show-remote-login=false \
    | sudo tee -a /etc/lightdm/lightdm.conf.d/50-unity-greeter.conf
          

TOR
---

Para utilizar la red TOR, que garantiza la navegación anónima,
descargamos el Bundle desde la página web del proyecto en el idioma
deseado: <https://www.torproject.org/projects/torbrowser.html.en>

Descomprimimos el fichero recibido en donde queramos instalar (en mi
caso `~/apps/`)

Para que me funcionase he tenido que editar el fichero
`~/apps/tor-browser/star-tor-browser` y añadir la linea

    export GTK_IM_MODULE=xim
          

Tenemos que instalarnos un lanzador para TOR, podemos hacerlo en Cairo o
integrarlo en el propio Ubuntu. En la siguiente sección describiremos
como hacerlo.

Firewall
--------

Configuración del cortafuegos.

    $ sudo apt-get install gufw
    $ gufw
          

> **Note**
>
> Completar esta sección con la configuración del cortafuegos
>
> Más información en
> <http://debianhelp.wordpress.com/2013/11/19/to-do-list-after-installing-ubuntu-13-10-aka-saucy-salamander-os-2/>

Instalando programas
====================

Creando lanzadores
------------------

Como comentamos en la introducción a la hora de instalar programas nos
vamos a encontrar con dos casos:

-   Programas integrados en los orígenes de software de Ubuntu (ya sean
    oficiales o no).

-   Programas no disponibles en paquetes para Ubuntu, o que decidimos
    instalar fuera de los orígenes de software para Ubuntu (por ejemplo
    para usar una versión más actualizada).

Para los programas en el segundo caso ya he comentado que yo suelo
instalar en `~/apps`. Ya he explicado que lo hago así en mi portátil por
que solo lo uso yo, si fuera un ordenador multiusuario lo propio sería
usar un directorio por debajo de /usr/local para cada aplicación.

Una vez instalado el programa podemos crear el lanzador en el dock Cairo
y/o integrarlo en los menús de Ubuntu.

La primera opción, añadir un lanzador al dock Cairo no tiene demasiada
ciencia, basta con explorar el menú que aparece con el botón derecho del
ratón, para ver como se hace. El Cairo nos permite crear separadores,
carpetas de lanzadores que actuan como submenus, etc. etc. Yo suelo
descargar un icono que esté bien para el programa (si es que no viene
incluido) y descargarlo en el directorio `~/apps/icons`, para que no
desmerezca el aspecto gráfico de Cairo.

La segunda opción se basa en que tanto Gnome, como Kde cumplen con el
menu estándar especificado por FreeDesktop. Eso implica que basta con
crear un fichero (con un formato xml específico) en el directorio
`/usr/share/applications` para que esté disponible para todos los
usuarios, o en el directorio `~/.local/share/applications` para que solo
le aparezca a nuestro usuario, lo lógico en nuestro portátil como solo
instalamos para nuestro usuario es usar esta última opción.

Hay multitud de herramientas para crear este fichero. Nosotros vamos a
usar gnome-panel.

            sudo apt-get install --no-install-recommends gnome-panel
          

Una vez instalado podemos crear nuestro lanzador (por ejemplo para el
programa TOR que acabamos de instalar, sin más que ejecutar:

            $ sudo gnome-desktop-item-edit ~/.local/share/applications/ \
            --create-new
          

Organizando el directorio `~/apps`
----------------------------------

Cuando instalamos programas en `~/apps` nos podemos ahorrar trabajo
organizándolo un poco.

Cuando actualizamos nuestros programas descargando nuevas versiones
puede que nos vayan apareciendo directorios nuevos, por ejemplo para el
IDE Arduino al descomprimir nos aparece el directorio:
`~/apps/arduino-1.0.5`. Si después instalamos la nueva versión beta para
Arduino Yun nos aparecerá un directorio diferente, en el momento de
escribir esto sería: `arduino-1.5.6-r2`. Si no cambiamos los nombres de
directorios tendremos que estar editando los lanzadores, de lo contrario
dificultamos el seguimiento de la versión instalada.

Nos puede quedar más organizado si:

-   Creamos el directorio `~/apps/arduino`

        $ mkdir ~/apps/arduino
                  

-   Descomprimimos las versiones que descargamos en este directorio.

-   Cremos un link `current` a la versión actual (también se puede hacer
    en modo gráfico desde tu gestor de ficheros favorito).

        $ cd ~/apps/arduino
        $ ln -s ./arduino-1.5.6-r2 current
                  

-   En este punto el directorio `~/apps/arduino` tendría esta pinta:

        $ tree -L 1 -d arduino
        arduino
        ├── arduino-1.0.5
        ├── arduino-1.5.6-r2
        └── current -> arduino-1.5.6-r2/
                  

Ahora podemos crear nuestros lanzadores asociándolos al path
`~/apps/arduino/current`. Cuando descarguemos nuevas versiones
actualizamos el link `current` y todos los lanzadores seguirán
funcionando.

Software de Google
==================

Instalación de Chrome
---------------------

Instalamos el navegador de Google

    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
    sudo apt-get update
    sudo apt-get install google-chrome-stable
          

Instalación de Chromium
-----------------------

También podemos instalar la versión libre de Chrome aunque Google está
limitando algunas funcionalidades.

    $ sudo apt-get install chromium
          

Instalación de Google-Earth
---------------------------

> **Note**
>
> Completar esta sección con la instalación del Google-Earth

Sonido
======

Gpodder
-------

Gestión de podcast

    $ sudo add-apt-repository ppa:thp/gpodder
    $ sudo apt-get update
    $ sudo apt-get install gpodder
          

Audacity
--------

    $ sudo add-apt-repository ppa:audacity-team/daily
    $ sudo aptitude update
    $ sudo aptitude install audacity lame libmp3lame0
          

Clementine
----------

    $ sudo apt-get install clementine
          

Banshee
-------

Tengo la colección de música ordenada por Banshee y me resisto a
abandonarlo.

    $ sudo add-apt-repository ppa:banshee-team/ppa
    $ sudo apt-get update
    $ sudo apt-get install banshee banshee-extension-soundmenu
          

Video
=====

Para ver y hacer videos

Algunos codecs (creo que están algunos repes pero bueno):

    $ sudo apt-get install vlc vlc-plugin-pulse
    $ sudo apt-get install mplayer smplayer gnome-mplayer

    $ sudo apt-get install libxine1-ffmpeg gxine mencoder mpeg2dec vorbis-tools \
      id3v2 mpg321 mpg123 libflac++6 ffmpeg totem-mozilla icedax tagtool easytag \
      id3tool lame nautilus-script-audio-convert libmad0 libjpeg-progs flac faac faad \
      sox ffmpeg2theora libmpeg2-4 uudeview flac libmpeg3-1 mpeg3-utils \
      mpegdemux liba52-0.7.4-dev libquicktime2

    $ sudo apt-get install gstreamer0.10-ffmpeg gstreamer0.10-fluendo-mp3 \
    gstreamer0.10-gnonlin gstreamer0.10-plugins-bad-multiverse gstreamer0.10-plugins-bad \
    gstreamer0.10-plugins-ugly totem-plugins-extra gstreamer-dbus-media-service \
    gstreamer-tools ubuntu-restricted-extras ttf-mscorefonts-installer
       

FFMPEG
------

Instalamos ffmpeg desde el ppa recomendado para esta versión de Ubuntu
(en versiones posteriores vuelve a estar disponible)

    sudo apt-add-repository ppa:mc3man/trusty-media
    sudo apt-get update
    sudo apt-get install ffmpeg
         

> **Warning**
>
> Sospecho que con este ppa activado ya no es conveniente hacer un
> upgrade del sistema. O en todo caso si se quiere hacer un upgrade será
> mejor purgar este ppa previamente.
>
> A mi me da igual por qué normalmente prefiero hacer un fresh-install,
> pero quedáis avisados.

Kdenlive
--------

Lo instalamos también desde el ppa recomendado en la página oficial de
la distribución:

    $ sudo add-apt-repository ppa:sunab/kdenlive-release
    $ sudo apt-get update
    $ sudo apt-get install kdenlive
         

Cinelerra
---------

Tras una larga ausencia, Cinelerra vuelve a estar disponible para Ubuntu
en un paquete con linkado estático.

Nos lo descargamos desde la página oficial de la aplicación y, como de
costumbre lo instalamos en el directorio `~/apps`

Hay que corregir el límite SHMMAX, editando (como root) el fichero
`/etc/sysctl.conf` añadiendo la línea:

    kernel.shmmax=2147483647
         

Y además activamos el cambio ejecutando:

    sudo sysctl -p
         

OpenShot
--------

El ppa de openshot developers sigue sin funcionar. Lo he instalado
directamente desde Ubuntu:

    $ sudo aptitude install openshot frei0r-plugins

         

Gráficos y dibujos
==================

Dia
---

Un clásico imprescindible:

    $ sudo aptitude install dia
          

Gimp
----

El software libre de manipulación de imágenes.

    $ sudo add-apt-repository ppa:otto-kesselgulasch/gimp
    $ sudo apt-get update
    $ sudo apt-get install gmic gimp-gmic
    $ sudo apt-get install gimp-data-extras
    $ sudo apt-get install gimp-plugin-registry
          

Instalamos también el GPS (Gimp Paint Studio). Para añadir más
funcionalidades de dibujo a Gimp. Descargamos el paquete con el GPS 2.0
desde aquí:

<http://www.ramonmiranda.com/2012/07/gps-20-disponible.html>

Y descomprimimos en nuestro directorio `~/.gimp-2.8`

Inkscape
--------

El programa libre de gráficos vectoriales. Instalado desde los orígenes
de software de Ubuntu.

    $ sudo apt-get install inkscape
          

> **Tip**
>
> Merece la pena probar Jessyink para presentaciones aunque ya es un
> poco antiguo, los resultados son muy resultones.

Krita
-----

Un programa de dibujo completísimo. No hay que dejarse engañar por los
menús minimalistas. Instalado desde los orígenes de software de Kubuntu.

    $ sudo add-apt-repository ppa:kubuntu-ppa/backports
    $ sudo apt-get install krita
          

MyPaint
-------

Un programa de dibujo artístico muy completo.

Instalamos desde ppa

    $ sudo add-apt-repository ppa:achadwick/mypaint-testing
    $ sudo apt-get update
    $ sudo apt-get install mypaint mypaint-data-extras
          

Alchemy
-------

Un programa para buscar inspiración a la hora de ponerse a dibujar.
Echad una mirada a la página web <http://al.chemy.org/gallery/> para
entender lo que digo.

Pues como siempre, descargamos, descomprimimos en `~/apps` y creamos el
lanzador a nuestro gusto.

Fotografía
==========

Rawtherapee
-----------

Programa para revelado digital de imágenes raw.

    $ sudo add-apt-repository ppa:dhor/myway
    $ sudo apt-get update
    $ sudo apt-get install rawtherapee
          

Darktable
---------

Programa para revelado digital de imágenes raw.

    $ sudo add-apt-repository ppa:pmjdebruijn/darktable-release-plus
    $ sudo apt-get update
    $ sudo apt-get install darktable
          

Luminance
---------

Para generar imagenes HDR

    $ sudo apt-get install luminance
          

Hugin
-----

Para generar imágenes panorámicas o HDR.

    $ sudo apt-get install hugin
          

Desarrollo software
===================

EMACS
-----

Si no eres de EMACS puedes pasar a la sección siguiente. Instalamos el
paquete emacs y a mayores instalamos la última versión emacs24

    $ sudo apt-get install emacs
    $ sudo apt-get install emacs24
          

La verdad es que sólo estoy usando el emacs24, tengo que comprobar si es
posible hacer una instalación más limpia.

Al margen de tener o no las dos versiones de Emacs instaladas, la última
versión tiene un problema con el Trusty, no parece llevarse nada bien
con el Ibus. A causa de ese problema no se pueden escribir por ejemplo:
"x\^2"

Para soslayar el problema hay varias soluciones (Ver
<http://www.emacswiki.org/emacs/DeadKeys>).

Lo mas facil es cambiar nuestor fichero `~/.emacs` de forma que incluya
la línea:

    (require 'iso-transl)
          

> **Important**
>
> Describir el fichero .emacs
>
> Auctex

### Instalación de yasnippets

Yasnippets es una utilidad para Emacs que uso bastante. Se puede
instalar desde Ubuntu pero no me gusta como se instala, es muy dificil
de configurar a tu gusto, así que la instalo fuera del sistema de
paquetes.

    $ mkdir ~/.emacs.d/plugins
    $ mkdir ~/.emacs.d/snippets
    $ cd ~/.emacs.d/plugins
    $ git clone -recursive https://github.com/capitaomorte/yasnippet
            

> **Note**
>
> COMPLETAR https://github.com/capitaomorte/yasnippet

### Instalación AucTex

> **Note**
>
> COMPLETAR

VIM
---

Si no eres de Emacs serás de Vi ¿no?. Instalamos VIM desde Ubuntu:

    $ sudo apt-get install gnome-vim
          

Git
---

Lo del git-cola es opcional.

    $ sudo add-apt-repository ppa:git-core/ppa
    $ sudo apt-get update
    $ sudo apt-get install git
    $ sudo apt-get install git-cola
          

Además hacemos la configuración inicial del git:

    $ git config --global user.name "Sergio Alvariño"
    $ git config --global user.email "salvari@gmail.com"
    $ git config --global core.editor emacs
    $ git config --global color.ui true
    $ git config --global credential.helper cache
    $ git config --global credential.helper 'cache --timeout=3600'

Adicionalmente instalamos también el
[bash-git-promt](https://github.com/magicmonty/bash-git-prompt) que
mola un montón.

Seguimos las instrucciones en la página así que:

~~~{bash}
cd ~
git clone https://github.com/magicmonty/bash-git-prompt.git .bash-git-prompt
~~~

Yo no lo quiero siempre activo así que en vez de hacer source desde el
fichero *.bashrc* sin más, lo que hago es preparar un alias, así que
en el fichero *~/.bashrc* o en el fichero *~/bash_aliases*, depende de donde guardes tus alias, añade:

~~~{bash}
alias gp='. ~/bash-git-prompt/gitprompt.sh'
~~~

Ahora si lo quiero activar basta con teclear **gp** en el terminal.

Mercurial
---------

Tortoise Hg no es imprescindible.

    $ sudo apt-get install mercurial
    $ sudo apt-get install tortoisehg tortoisehg-nautilus
          

Creado fichero \~/.hgrc con el contenido:

    [ui]
    username = Sergio Alvariño <salvari@gmail.com>
    editor = emacs

    [web]
    cacerts = /etc/ssl/certs/ca-certificates.crt
          

Bazaar
------

Bazaar viene instalado por defecto.

Subversion
----------

No lo uso para programar pero hay veces en que te bajas programas con el
cliente.

    $ sudo apt-get install subversion
          

D programming language
----------------------

Visitamos la página e instalamos el paquete para Debian/Ubuntu
(<http://dlang.org/download.html>).

### DUB

También conviene que nos instalemos el DUB
<http://code.dlang.org/download>, con este no hay que partirse la
cabeza, nos descargamos el "binary tarball" para linux 64 bits y lo
descomprimimos en `~/bin`

DUB será en breve el instalador oficial para el D. Conviene a empezar a
usarlo cuanto antes. Además tiene ventajas obvias a la hora de gestionar
las dependencias de nuestros programas.

### vibe.d

Instalamos dependencias

    $sudo apt-get install libevent-dev libssl-dev
            

### D completion daemon - DCD

Instalamos también este programa que nos va a permitir configurar varios
editores para la edición de código en D, de momento lo he probado solo
en emacs y va muy bien.

    $ git clone https://github.com/Hackerpilot/DCD
    $ cd DCD
    $ git submodule update --init
    $ ./build.sh
            

Una vez compilados copiamos el `dcd-server` y `dcd-client` a nuestro
path, por ejemplo a `~/bin`.

Para completar la instalación tenemos que crear el fichero
`~/.config/dcd/dcd.conf`. Cada linea del fichero es un directorio para
imports desde D, si has hecho la instalación como yo deberá tener estas
dos líneas:

    /usr/include/dmd/phobos
    /usr/include/dmd/druntime/import
            

Perl
----

Perl viene instalado por defecto (se usa para un montón de cosas en
linux)

En Debian, y consecuentemente en Ubuntu, hay versiones empaquetadas de
la mayor parte de los módulos de Perl, pero no estarán completamente
actualizadas. Como es más rápido instalar las versiones empaquetadas yo
suelo instalar las empaquetadas la primera vez, después uso las
herramientas internas de Perl para descargar desde CPAN las últimas
versiones cuando me interesa.

He instalado los siguientes módulos de Perl en sus versiones
empaquetadas para Debian/Ubuntu:

libmodern-perl-perl

:   Atajos para varios pragmas usados comunmente (ver
    <http://modernperlbooks.com/books/modern_perl/>

liblog-log4perl-perl

:   Logs para Perl

libtemplate-perl

:   Template toolkit para Perl

libmoose-perl

:   Extensión para facilitar OOP en Perl.

### Padre, un IDE para Perl

También me lo he instalado, aunque la verdad suelo usar Emacs para todo.

    $ sudo aptitude install Padre
            

Squirrel SQL Client
-------------------

Un cliente SQL muy versátil. Como va sobre Java me vale para el trabajo
(Windows) y para uso personal.

Descargamos el instalador de la última versión (en el momento de
escribir esto la 3.5.2) desde la página web
<http://squirrel-sql.sourceforge.net/#installation>. Le damos permisos
para ejecución y lo ejecutamos. El instalador ya se encarga de crear los
lanzadores correspondientes. Si queremos instalarlo para todos los
usuarios del sistema hay que ejecutarlo como root.

Yo lo uso sobre todo con MySQL, así que necesitamos descargarnos el
driver para el MySQL desde la página web de
MySQL<http://dev.mysql.com/downloads/connector/j/> y lo descomprimimos
(por ejemplo en `~/apps`)

Una vez descomprimido basta con informar al Squirrel SQL de la ruta al
conector. En el menú Windows escogemos View Drivers. Picamos dos veces
en el driver de MySQL y añadimos el jar que descargamos en el paso
anterior a la pestaña: Extra Class Path.

A partir de aquí ya podremos conectarnos a bases de datos MySQL.

R
-

Añadimos nuestro mirror preferido a la lista de repositorios (yo lo hago
desde synaptic)

    $ deb http://cran.es.r-project.org/bin/linux/ubuntu saucy/
          

Necesitamos añadir la clave gpg para validar los paquetes

    $ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
          

Instalamos por el método que mas nos guste el paquete r-recommended.

Para poder instalar paquetes R para todos los usuarios sin liarnos mucho
lo mejor es que nos hagamos miembros del grupo staff

    $ sudo gpasswd -a staff myuser
          

Mongodb
-------

Motor de bases de datos no relaccionales.

    $ sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
    $ echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse"\
    | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
    $ sudo aptitude update
    $ sudo aptitude install mongodb-org
          

Desarrollo Web
==============

Servidor LAMP
-------------

Un servidor LAMP (Linux, Apache, MySQL, PHP o Perl), como base para
empezar con desarrollo web. La manera más fácil de instalarlo en Debian
y derivados es instalar TASKSEL

> **Note**
>
> La verdad es que cada vez uso más nginx y que tengo muchas ganas de
> pasarme a MariaDB y dejar MySQL, de todas formas como Apache y MySQL
> es el estadar de facto...

    $ sudo aptitude install tasksel
    $ sudo tasksel
          

Una vez instalada la aplicación tasksel la invocamos e instalamos los
"combinados" que queramos, en este caso escogemos la opción "LAMP
Server"

En el momento en que instalamos la opción "LAMP Server" el ordenador
arrancará un servidor Apache (no tienes más que visitar
<http://localhost> para verlo en acción) si no queremos tenerlo siempre
corriendo en nuestro portatil tenemos que cambiar que programas
arrancamos por defecto. A mi no me preocupa demasiado tenerlo corriendo
pero si quereis configurar apache para que no arranque tenéis que mirar
los comandos runlevel (para saber en que runlevel estáis) y update-rc.d
(para actualizar los servicios que se arrancan o paran en cada runlevel.

En el caso de que queráis dejar el apache parado ahora mismo para
arrancarlo manualmente:

    $ sudo update-rc.d -f apache2 remove
          

A partir de aquí ya no arranca por defecto, hay que arrancarlo
manualmente usando apache2ctl o:

    $ sudo /etc/init.d/apache2 start
          

Para dejar otra vez el programa en sus runlevels por defecto:

    $ sudo update-rc.d apache2 defaults
          

> **Important**
>
> Cambia la password de root de mysql, no lo dejes sin password!!!!
>
> La configuración de Apache a cambiado, ahora el único directorio
> autorizado por defecto es `/var/www/html`

Concrete
--------

Como ya tenemos nuestro lamp server instalado...

    $ sudo aptitude install php5-gd
    $ sudo /etc/init.d/apache restart
          

Hay que asegurarse de que tenemos el modrewrite activado en Apache:

    $ sudo a2enmod rewrite
          

Descomprimimos el contenido del zip en `/var/www/html/concrete5`

Cambiamos el propietario de los ficheros instalados:

    $ sudo chmod -R www-data:www-data /var/www/html/concrete5
          

Y por último creamos la base de datos asociada, un usuario de la base de
datos y le damos permisos.

    $ sudo mysqladmin create concretedb
    $ sudo mysql -uroot -ppassword
    mysql> grant all privileges on concretedb.* to 'concrete'@'localhost' identified by 'aPassword';
    mysql> grant all privileges on concretedb.* to 'concrete'@'%' identified by 'aPassword';
    mysql> flush-privileges
          

Entramos con el navegador en <http://localhost/concrete5> y finalizamos
el proceso de instalación.

Media-wiki
----------

Descargamos el último paquete (en este momento 1.23.2) desde la página
web <https://www.mediawiki.org/wiki/MediaWiki>. Lo descomprimimos y
tenemos que dejarlo en un sitio accesible por apache, de momento lo dejo
en `/var/www/html/wiki`.

Es recomendable instalar:

    $ sudo aptitude install php-pear php5-dev
    $ sudo aptitude install libltdl-dev pkg-php-tools
    $ sudo aptitude install php-apc
    $ sudo aptitude install php5-intl
          

Hay otras cosas que es recomendable instalar como ImageMagick (que yo ya
tenía instalado).

Tenemos que crear la base de datos asociada al wiki, un usario de base
de datos y dar permisos a ese usuario.

    $ sudo mysqladmin create mediawikidb
    $ sudo mysql -uroot -ppassword
    mysql> grant all privileges on mediawikidb.* to 'mwikiuser'@'localhost' identified by 'aPassword';
    mysql> grant all privileges on mediawikidb.* to 'mwikiuser'@'%' identified by 'aPassword';
    mysql> flush-privileges
          

Durante la instalación:

-   Escogí el modo binario para la base de datos.

-   Escogí "Authorized edition only"

-   Creative commons attribution share alike

-   Es necesario configurar las opciones de correo de PHP, en principio
    lo instalo sin correo.

-   He habilitado todos los plugins

-   Habilitada la subida de ficheros

-   Deshabilitado instant commons

-   Habilitado el caché de PHP

### Extensiones adicionales

Puede que tengamos que instalar alguna de las siguientes extensiones:

-   DynamicPageList (MediaWiki)

-   DynamicPageList (Third Part)

También instalo en el portatil el paquete
libhtml-wikiconverter-mediawiki-perl

    $ sudo aptitude  install libhtml-wikiconverter-mediawiki-perl
            

Web2py
------

Un framework sencillo de usar, esta basado en Python.

Descargamos la última versión desde la página web de la aplicación
<http://www.web2py.com/init/default/download> (yo descargo la versión
para usuarios normales - source code)

Como de costumbre descomprimimos en nuestro directorio `~/apps`, y
tendremos el directorio `~/apps/web2py`

Django
------

En mi sistema tengo instalado Python.2.7 (no recuerdo haberlo instalado
debe venir incluido por defecto en Ubuntu). En su dia también instalé el
paquete python-pip. En caso de no tenerlos instalados:

    $ sudo aptitude install python python-pip
          

Instalamos virtualenv

    $ sudo pip install virtualenv
          

virtualenv es una aplicación genial para python que te permite crear
entornos diferentes para hacer instalaciones, incluso podrías tener
entornos con diferentes versiones de Python, se parece mucho a perlbrew.

Por último para probar Django parece conveniente usar también Pinax.
Pinax ya no es una aplicación, más bien es un conjunto de
configuraciones para Django que se pueden descargar desde Github:

    $ virtualenv mysiteenv
    $ source mysiteenv/bin/activate
    $ pip install Django==1.6.2
    $ django-admin.py startproject --template=https://github.com/pinax/pinax-project-account/zipball/master mysite
    $ cd mysite
    $ pip install -r requirements.txt
    $ python manage.py syncdb
    $ python manage.py runserver
          

Mosquitto
---------

Mosquitto es una implementación abierta del protocolo MQTT, la incluyo
por tener todo documentado pero, salvo que sepas que es MQTT y te
interese, no creo que la quieras instalar.

Para instalar Mosquitto seguimos las instrucciones en la propia web de
la aplicación:

    $ wget http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key
    $ sudo apt-key add mosquitto-repo.gpg.key
    $ rm mosquitto-repo.gpg.key
    $ cd /etc/apt/sources.list.d/
    $ sudo wget http://repo.mosquitto.org/debian/mosquitto-stable.list
    $ sudo apt-get update
    $ apt-cache search mosquitto
    $ sudo aptitude install mosquitto
          

WordPress
---------

Hay que tener el lamp server instalado y tb la php5-gd que mencionamos
en la instalación de Concrete.

Crear la base de datos:

    $ sudo mysqladmin create wordpressdb
    $ sudo mysql -uroot -ppassword
    mysql> grant all privileges on wordpressdb.* to 'wpuser'@'localhost' identified by 'aPassword';
    mysql> grant all privileges on wordpressdb.* to 'wpuser'@'%' identified by 'aPassword';
    mysql> flush-privileges
          

Descomprimimos el zip con la última versión del wp en
`/var/www/wordpress`

Configuramos Wordpress:

    $ cd /var/www/wordpress
    $ sudo cp wp-config-sample.php wp-config.php
    $ sudo chown -R www-data:www-data /var/www/wordpress
          

Editamos el fichero `wp-config.php` y ponemos el nombre de usuario y
contraseñas configurados para la base de datos.

Drupal
------

Instalamos el módulo de manejo de ficheros json para php:

     sudo apt-get-install php5-json
     sudo /etc/init.d/apache restart
          

Crear la database, el baile de siempre:

    $ sudo mysqladmin create drupaldb
    $ sudo mysql -uroot -ppassword
    mysql> grant all privileges on drupaldb.* to 'drupal'@'localhost' identified by 'password';
    mysql> grant all privileges on drupaldb.* to 'drupal'@'%' identified by 'password';
    mysql> flush privileges
          

Seguimos los pasos que nos recomiendan en la propia página de Drupal
(<http://drupal.org>), aunque teniendo en cuenta los consejos que nos
dan en Ubuntu (<https://help.ubuntu.com/community/Drupal>):

-   Descargamos el fichero con la versión de Drupal que queramos
    instalar (en el momento de escribir esto Drupal 7.28)

-   Extraemos el fichero descargado en algún directorio de trabajo, por
    ejemplo: `~/tmp`

-   Movemos los ficheros extraidos a la situación definitiva, en Ubuntu
    (y creo que en demás derivados de Debian), debería ser
    `/var/www/drupal`

        $ sudo mkdir /var/www/drupal
        $ sudo mv drupal-7.28/* drupal-7.28/.htaccess drupal-7.28/.gitignore /var/www/drupal
        $ sudo mkdir /var/www/drupal/sites/default/files
        $ sudo chown www-data:www-data /var/www/drupal/sites/default/files
                  

-   Creamos el fichero de configuración por defecto:

        $ sudo cp /var/www/drupal/sites/default/default.settings.php /var/www/drupal/sites/default/settings.php
        $ sudo chown www-data:www-data /var/www/drupal/sites/default/settings.php
                  

-   Nos descargamos los ficheros de traducción del nucleo de drupal para
    los idiomas que nos interesen. Tenemos que dejarlos en el directorio
    `/var/www/drupal/profiles/standard/translations/`. Podemos bajarlos
    desde aquí: <http://ftp.drupal.org/files/translations/7.x/drupal/>

-   Una vez hecho esto comenzamos el proceso de instalación visitando
    desde nuestro navegador la dirección:<http://localhost/drupal>

-   Escogemos la instalación standard

-   Podremos escoger uno de los lenguages disponibles, el inglés siempre
    está disponible y tendremos también un lenguage disponible por cada
    fichero de traducción descargado.

-   Pasamos los datos de acceso a la base de datos que creamos
    anteriormente.

-   Empezará la descarga e instalación automática de módulos, acto
    seguido hará la importación del fichero de traducciones (en mi pc
    este proceso es super-lento así que paciencia)

-   Por último le damos un nombre a nuestro sitio web y creamos un
    usuario administrador. Una vez hecho esto ya podremos ir a nuestro
    "nuevo sitio"

Plone
-----

Instalación de Plone

    sudo apt-get install python-setuptools python-dev build-essential libssl-dev libxml2-dev libxslt1-dev libbz2-dev
    // libjpeg62-dev -- conflicto con ros
    sudo apt-get install libreadline-dev wv poppler-utils
    sudo apt-get install libz-dev
    sudo ./install.sh standalone
    cd /usr/local/Plone/zinstance
    sudo ./bin/plonectl start
          

Hay que visitar el enlace <http://localhost:8080/>

Hay que apuntar la password de admin que nos da al final del proceso de
instalación.

Conviene cambiar la password de admin y al menos en mi caso cambiar el
puerto en el que Plone escucha.

Node.js
-------

Instalación

    $ sudo apt-get update
    $ sudo apt-get install build-essential libssl-dev
          

Comprobamos en la página de github cual es la versión más reciente y
descargamos.

La instalación por defecto nos deja el nvm instalado en el directorio
`~/.nvm`, además nos configura el `.profile` para que active el nvm.

    $ cd ~/tmp
    $ curl https://raw.githubusercontent.com/creationix/nvm/v0.14.0/install.sh | bash
          

Documentación
=============

TeX/LaTeX
---------

Tradicionalmente las versiones de TeX LaTeX en el el directorio de
Ubuntu (paquetes texlive) estaban muy desfasadas. Ultimamente el desfase
no es ya tan grande y si a lo mejor de vale con instalar desde Ubuntu.
Si no es asi, y quieres tener las versiones actualizadas hay que aplicar
la siguiente receta.

[ https://github.com/scottkosty/install-tl-ubuntu]( https://github.com/scottkosty/install-tl-ubuntu)

Finalmente instalamos el paquete auctex para editar TeX LaTeX desde
emacs sin problemas:

    $ sudo aptitude install auctex
          

Docbook 5
---------

Hay un resumen describiendo varias opciones en:
<https://help.ubuntu.com/community/DocBook>

Instalamos:

    $ sudo aptitude install docbook5-xml docbook-xsl-ns xsltproc fop xmlto libxml2-utils xmlstarlet
          

### Validación

    $ xmlstarlet val --err --xsd /usr/share/xml/docbook/schema/xsd/5.0/docbook.xsd src/ubuntuTrustyPostInstall.xml
            

### Salida a pdf

    $ xsltproc --stringparam paper.type A4  \
        --output out/ubuntuTrustyPostInstall.fo \
        --stringparam admon.graphics 1 \
        --stringparam admon.graphics.path /usr/share/xml/docbook/stylesheet/docbook-xsl-ns/images/ \
        --stringparam admon.graphics.extension .svg \
        /usr/share/xml/docbook/stylesheet/docbook-xsl-ns/fo/docbook.xsl \
        src/ubuntuTrustyPostInstall.xml

    $ fop -fo out/ubuntuTrustyPostInstall.fo -pdf out/ubuntuTrustyPostInstall.pdf
            

### Salida a html

    $ xsltproc --output out/ubuntuTrustyPostInstall.html \
        --stringparam admon.graphics 1 \
        --stringparam admon.graphics.path /usr/share/xml/docbook/stylesheet/docbook-xsl-ns/images/ \
        --stringparam admon.graphics.extension .svg \
        /usr/share/xml/docbook/stylesheet/docbook-xsl-ns/html/docbook.xsl \
        src/ubuntuTrustyPostInstall.xml
            

Scribus
-------

Instalamos desde ppa

    $ sudo add-apt-repository ppa:ubuntuhandbook1/ppa
    $ sudo apt-get update
    $ sudo apt-get install scribus scribus-template icc-profiles-free
          

Impressive
----------

Ideal para exponer presentaciones hechas con Beamer.

Instalamos las dependencias:

    $ sudo aptitude install python-pygame python-opengl python-imaging pdftk poppler-utils xdg-utils mplayer
          

Descargamos de la página web y descomprimimos en app como siempre.

Pandoc
------

Pandoc es una librería Haskell para traducir entre diferentes formatos
de markup. Con Pandoc puedes, por ejemplo, convertir los fuentes de este
documento (en docbook) a epub (entre otros muchos).

Lo he instalado usando el paquete debian bajado de la página de Github
del proyecto.

Sphinx
------

Sphinx es tambien un generador de documentación en y para Python.

Instalado desde Python Package Index con:

    $ sudo pip install sphinx
          

Editores para Markdown
----------------------

Algunos editores para usar Markdown y Pandoc.

### Pandoc Emacs mode

Lo he bajado de la página web
<http://joostkremers.github.io/pandoc-mode/>

Para dejarlo operativo he añadido las siguientes líneas a mi fichero
`.emacs`

              ;; (add-hook 'markdown-mode-hook 'pandoc-mode)
              (require 'pandoc-mode)
              (add-to-list 'auto-mode-alist '("\\.md\\'" . pandoc-mode))       
            

### Haroop

Instalado bajando el paquete para Ubuntu desde su página web
<http://pad.haroopress.com/>

### Qute

Un editor minimalista, muy interesante. Utiliza Pandoc para generar la
salida en distintos formatos.

Me he bajado el binario para Linux y lo he instalado como de costumbre
en mi directorio `~/apps`

Diseño
======

LibreCAD
--------

    $ sudo add-apt-repository ppa:librecad-dev/librecad-stable
    $ sudo apt-get install librecad librecad-data
          

FreeCAD
-------

    $ sudo add-apt-repository ppa:freecad-maintainers/freecad-stable
    $ sudo apt-get install freecad freecad-doc
          

OpenSCAD
--------

He intentado instalarlo desde el ppa recomendado pero falla para Trusty.
El comando sería el siguiente:

    $ sudo add-apt-repository ppa:chrysn/openscad
          

Como falla me he bajado el paquete binario desde la página oficial y lo
he instalado. Se instala en `/usr/local/`. Así que a la hora de hacer el
lanzador habrá que apuntar a `/usr/local/bin/openscad`

Wings
-----

Te puedes bajar el programa de la página web <http://www.wings3d.com/>,
pero el programa se instala donde le da la gana, concretamente en
`~/wings-x.x.x`

La alternativa sería compilar el programa pero hay que instalar el
lenguaje Erlang y varias librerias.

Electrónica
===========

Diversos programas.

Arduino IDE
-----------

Instalamos dependencias:

    $ sudo aptitude install gcc-avr avr-libc
          

También tendremos que dar privilegios a nuestro usuario para que pueda
acceder a los puertos usb, lo más sencillo es añadirlo al grupo dialout

    $ sudo usermod -a salvari -G dialout
          

Descargamos el programa desde la página web <http:/arduino.cc>

Descomprimimos el programa en el directorio `~/apps`

Ahora tenemos que crear un lanzador para el programa, podemos hacerlo
facilmente en el cairo, es bastante intuitivo.

O podemos currarnos un lanzador para Ubuntu. Ubuntu almacena los
lanzadores en ficheros xml en el directorio `/usr/share/applications`.
Nos podemos coger un fichero de los existentes y currarnos uno o podemos
instalar la antigua aplicación para crearlos y crear uno nuevo con los
siguientes comandos:

    $ sudo apt-get install --no-install-recommends gnome-panel
    $ sudo gnome-desktop-item-edit /usr/share/applications/ --create-new
          

Una vez creado el lanzador nos aparecerá en el Dash cuando busquemos
aplicaciones. Y también podemos arrastrarlo desde el dash al dock para
dejarlos permanentes.

Evidentemente también aparecerá en el menú global del Cairo o el applet
de Classic Menú si lo hemos instalado.

Pingüino IDE
------------

La instalación del IDE Pingüino ha cambiado totalmente, ahora ya hay
instalador para Debian y derivados.

Para usarlo basta con descargarse el instalador desde aquí:
<http://sourceforge.net/projects/pinguinoide/files/linux/installer.sh/download?use_mirror=freefr>

Después:

    $ sudo chmod +x installer.sh
    $ sudo ./installer.sh
          

El installer no se ocupa de instalar el fichero
`/etc/udev/rules.d/41-microchip.rules`, es necesario instalarlo a mano.
El contenido del fichero debe ser el siguiente:

    # sudo cp 41-microchip.rules /etc/udev/rules.d/
    # sudo usermod -a -G plugdev $USER
    #
    # Pinguino8 (PIC18F)
    ATTR{idVendor}=="04d8", ATTR{idProduct}=="feaa", MODE="0660",GROUP="plugdev"
    #
    # Pinguino32 (PIC32MX)
    ATTR{idVendor}=="04d8", ATTR{idProduct}=="003c", MODE="0660",GROUP="plugdev"
    #
    # Pickit 2
    ATTR{idVendor}=="04d8", ATTR{idProduct}=="0033", MODE="0660",GROUP="plugdev"
    #
    # Pickit 3
    ATTR{idVendor}=="04d8", ATTR{idProduct}=="900a", MODE="0660",GROUP="plugdev"
          

También tenemos que asegurarnos de que nuestro usuario de desarrollo
pertenezca al grupo plugdev.

    $ usermod -a -G plugdev $USER
          

> **Warning**
>
> Para instalar la última versión del IDE Pinguino es necesario instalar
> la última versión de la librería `libstdc++6`. Al menos es necesario
> ínstalar la versión 4.9. Para ello:
>
>     $ sudo add-apt-repository ppa:ubuntu-toolchain-r/test
>     $ sudo apt-get update
>     $ sudo apt-get install g++-4.9
>             
>
> Después de instalar esta versión se puede descargar el programa de
> instalación del IDE y ejecutarlo sin ningún error.

KiCAD
-----

Añadimos el ppa.

    $ sudo apt-add-repository ppa:js-reynaud/ppa-kicad
          

Geda
----

Lo he instalado directamente desde Ubuntu.

    $ sudo aptitude install geda pcb gerbv
          

Fritzing
--------

Fritzing

Astronomía
==========

Stellarium
----------

Excelente programa para explorar los cielos nocturnos, lo instalamos
directamente desde Ubuntu:

    $ sudo aptitude install stellarium
          

El programa es muy fácil de usar. Solo comentar que desde el menú
Options en la opción Tools se pueden descargar catalogos adicionales.

Where is M13?
-------------

Otra aplicación interesante de astronomía, se trata de un mapa
tridimensional de nuestra galaxia implementado en java.

El programa libre y gratuito se puede descargar desde aqui:
<http://www.thinkastronomy.com/M13/common/download.html>

La instalación también es muy sencilla, sencillamente lo descomprimimos
en nuestro directorio `~/apps`. Basta con dar permisos de ejecución al
fichero `WhereIsM13.jar` y ya lo podemos ejecutar desde el explorador de
ficheros con doble click o crearnos un lanzador para el programa de la
manera que más nos guste.

Digital Universe
----------------

Una aplicación que se basa en un visor de particulas en tres dimensiones
para implementar un mapa de nuestra galaxia y otro de nuestra galaxia y
sus alrededores.

El programa puede descargarse desde la web del Museo Americano de
Historia Natural:
<http://www.amnh.org/our-research/hayden-planetarium/digital-universe/download>.
Ojito que no es software libre. Es gratuito, pero si quereis usarlo para
otra cosa distinta del uso personal hay que leerse la licencia.

Para instalarlo, lo mismo que el anterior, los descomprimimos en nuestro
directorio `~/apps/` y veremos que en el directorio
`~/apps/Digital Universe`tendremos el manual de la aplicación, el manual
del visualizador de partículas en 3D, un par de scripts de ejemplos y
dos scripts para visualizar los datos astronomicos:

-   milkyway.sh

-   extragalactic.sh

Como de costumbre, podemos crearnos lanzadores para los programas que
nos interesen.

Virtual Moon
------------

Un excelente programa para explorar la Luna. Tiene un montón de texturas
e información disponible, hasta se pueden cargar los mapas de los
astrónomos clásicos (Casini, Hevelius...) Unos gráficos super chulos.

El único problemilla es que lo distribuyen como binario y nos piden que
instalemos como root. Como eso va contra mis principios os comento como
hacer la instalación con nuestro usuario en nuestro directorio habitual
`~/apps`

Descargamos el programa desde la dirección
<https://dl.dropboxusercontent.com/u/4192826/dumpNoAuth.sql.gz>

Cuando yo me instalé este programa (abril del 2014) me descargué la
versión 6.0, el upgrade a 6.1 y necesitamos también descargarnos al
menos un archivo de texturas (después se pueden añadir el resto pero
necesitamos uno al menos para comprobar que la instalación funciona)

Para la instalación propiamente dicha creamos un directorio `~/apps/vma`
(vma viene de Virtual Moon Atlas) y a continuación simplemente
descomprimimos los ficheros descargados en ese directorio:

1.  Descomprimimos el fichero con la release 6.0, dentro tendremos dos
    comprimidos (para 32 y 64 bits) escogemos el que convenga a nuestra
    arquitectura (64 bits salvo que tu pc sea a vapor) y descomprimimos
    en el directorio `~/apps/vma`

    Nos apareceran tres directorios `bin`, `lib` y `share`

2.  Descomprimimos el upgrade a 6.1 (habremos descargado el
    correspondiente a nuestra arquitectura, o sea el de 64bits en mi
    caso), en el mismo directorio `~/apps/vma`

3.  Descomprimimos todos los ficheros de texturas que descarguemos en el
    mismo directorio. Hay que descargar al menos uno para que funcione,
    y tenemos que instalar siempre de menor a mayor resolución.

4.  Por último, lo más importante, creamos un fichero
    `~/apps/vma/vmaStart.sh` con el siguiente contenido:

        #!/bin/bash
        export LD_LIBRARY_PATH="$HOME/apps/vma/lib"
        `$HOME/apps/vma/bin/cclun`
                  

Mapas
=====

MOBAC

QGis
----

Instalado desde el propio Ubuntu.

Añadimos los siguientes orígenes de software:

    deb     http://qgis.org/debian trusty main
    deb-src http://qgis.org/debian trusty main
          

Y procedemos a instalar:

    $ gpg --keyserver keyserver.ubuntu.com --recv DD45F6C3
    $ gpg --export --armor DD45F6C3 | sudo apt-key add -

    $ sudo apt-get update
    $ sudo apt-get install qgis python-qgis
    $ sudo apt-get install qgis-plugin-grass
          

Virtualización
==============

VirtualBox
----------

Instalación de virtual box

deb http://download.virtualbox.org/virtualbox/debian trusty contrib

    deb http://download.virtualbox.org/virtualbox/debian trusty contrib
    sudo apt-get update
    sudo apt-get install virtualbox-4.3
    wget http://download.virtualbox.org/virtualbox/4.3.10/Oracle_VM_VirtualBox_Extension_Pack-4.3.10-93012.vbox-extpack
    sudo adduser yourusername vboxusers
          

> **Important**
>
> He tenido que desinstalar VirtualBox por que los drivers me dejaban el
> Kernel tainted y me estaban dando fallos continuos de kernel panic.
> Pendiente de hacer más pruebas con el virtualbox de Ubuntu.

# Virtualización

## VMware

Descargamos VMware Workstation Player desde la página oficial de WMware.



## VirtualBox

Instalación de VirtualBox

Descargamos el paquete para Ubuntu 64bits desde la
[página wiki de VirtualBox](https://www.virtualbox.org/wiki/Linux_Downloads)
Mi usuario pertenece al grupo vboxuser desde el último intento de
instalar VirtualBox.


## Mininet: Un simulador de SDN


Mininet

Robótica: ROS
=============

    $ sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu trusty main" > /etc/apt/sources.list.d/ros-latest.list'
    $ wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O - | sudo apt-key add -
    $ sudo aptitude update
    $ sudo apt-get install ros-indigo-desktop-full
        

RepRap
======

Printrun
--------

     sudo apt-get install python python-serial python-wxgtk2.8 python-tk git
          

Preparamos un fichero para hacer la actualización del sw con el
siguiente contenido:

    #!/bin/bash
    BASEDIR="$HOME/apps/RepRap" # edit this is you don't want it installed in your home directory

    PRINTRUNDIR="$BASEDIR/Printrun" # Defines where the 'Printrun' directory is located. But of course
                                    # you can change this to say: "$HOME/Documents/Create/RepRap/Printrun".

    SKEINFORGEDIR="$PRINTRUNDIR/skeinforge" #Defines where the 'skeinforge' directory is located in the
                                    # 'Printrun' directory is located.

    SKEINFORGEBASEURL="http://fabmetheus.crsndoo.com/files/"
    SKEINFORGEFILENAME="50_reprap_python_beanshell.zip"

    cd $BASEDIR # Change directory to the executing users home directory.

    echo "Removing existing Printrun directory..." #Script being polite towards the user.
    rm -rf $PRINTRUNDIR # Removes the defined Printrun directory and _everything_ that resides
                        # in and beneath its directory tree.

    echo "Cloning Printrun..." # Script being polite towards the user.
    git clone https://github.com/kliment/Printrun.git # See also: http://help.github.com/linux-set-up-git/

    echo "Grabbing skeinforge..." # Script being polite towards the user.
    wget -P /tmp $SKEINFORGEBASEURL$SKEINFORGEFILENAME # Uses good ol' wget for downloading skeinforge.

    echo "Unzipping skeinforge into Printrun directory..." # Script being polite towards the user.
    unzip -d $SKEINFORGEDIR /tmp/$SKEINFORGEFILENAME # unzips the grabbed zip to ones defined skeinforge dir.

    echo "Symlinking skeinforge inside Printrun directory..." #Script being polite towards the user.
    ln -s $SKEINFORGEDIR/* $PRINTRUNDIR/ # Script makes a symbolic link.

    echo "Cleaning up temporary installation files..." #Script being polite towards the user.
    rm -rf /tmp/$SKEINFORGEFILENAME # Removes tmp files.
          

Una vez instalado en nuestro directorio podemos crear un lanzardor para
el Pronterface.

Para completar la instalación deberíamos asegurarnos de que todas las
dependencias del programa están instaladas:

    $ sudo pip install -r requirements.txt
          

> **Warning**
>
> Falla la instalacion de pycairo y cairosvg

Slic3r
------

Instalamos las dependencias

    $ sudo cpan App::cpanminus
    $ sudo apt-get install git build-essential libgtk2.0-dev libwxgtk2.8-dev libwx-perl libmodule-build-perl \
    libnet-dbus-perl libexpat1-dev
    $ sudo apt-get install libxmu-dev freeglut3-dev libwxgtk-media2.8-dev
    $ sudo aptitude install perlmagick
    $ sudo aptitude install libopengl-perl
    $ cd ~/apps/RepRap
    $ git clone https://github.com/alexrj/Slic3r.git
    $ cd Slic3r
    $ sudo perl Build.pl
    $ sudo perl Build.pl --gui
          

Como de costumbre podemos crear un lanzador.

# Juegos

## Spring

Añadido el ppa de Spring

~~~{bash}
sudo apt-add-repository ppa:spring
sudo aptitude update
sudo aptitude install spring
sudo aptitude install springlobby
~~~

Además de instalar el spring desde el ppa descargamos los binarios
desde la [wiki de spring](https://springrts.com/wiki/Download) y como
de costumbre lo instalamos en *~/apps*.

También he añadido el weblobby


# TODO

* Añadir la instalación de libreplan

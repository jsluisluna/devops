## Acerca del Proyecto

Este proyecto consiste en automatizar mediante Puppet la instalación de un servidor WordPress de ejemplo, incluyendo todas las herramientas necesarias (Apache, PHP, MySQL), utilizando como servidor destino una máquina virtual gestionada con la herramienta Vagrant, configurada para provisionar mediante Puppet.

A continuación, se describen brevemente las tecnologías usadas en la actividad:

### Vagrant:

Vagrant es una herramienta de virtualización y gestión de entornos de desarrollo. Permite crear y configurar fácilmente máquinas virtuales reproducibles y portátiles para desarrollar y probar aplicaciones. Vagrant simplifica el proceso de configuración del entorno de desarrollo al proporcionar una configuración en código, lo que facilita la colaboración y garantiza la consistencia entre los diferentes miembros del equipo.

### Puppet:

Puppet es una herramienta de gestión de configuración que automatiza el despliegue y la administración de software y sistemas. Permite definir y gestionar la configuración de los recursos de infraestructura, como servidores, redes y almacenamiento, de manera declarativa. Puppet utiliza un lenguaje de dominio específico (DSL) para describir el estado deseado del sistema, y luego se encarga de llevar el sistema a ese estado deseado y mantenerlo a lo largo del tiempo.

### WordPress:

WordPress es un sistema de gestión de contenido (CMS) ampliamente utilizado para crear y administrar sitios web. Proporciona una interfaz intuitiva y fácil de usar, lo que permite a los usuarios crear y publicar contenido sin necesidad de conocimientos de programación. WordPress ofrece una amplia variedad de temas y complementos que permiten personalizar la apariencia y funcionalidad del sitio web. Es conocido principalmente por ser utilizado en blogs, pero también es utilizado para construir sitios web comerciales, de noticias, de comercio electrónico, entre otros.

## Prerequisitos

Tener instalado Vagrant https://www.vagrantup.com para poder ejecutar el script principal.

## Instalación

Despues de clonar el proyecto en la carpeta raíz tenemos nuestro archivo Vagrantfile, el cual es el archivo que usa Vagrant para configurar y levantar nuestra máquina virtual, así como ejecutar el aprovisionamiento que hayamos configurado. 

Estando en la carpeta raiz del proyecto ejecutamos el siguiente comando de line de comando:

<code>vagrant up</code>

En nuestro caso hemos configurado una máquina virtual de Ubuntu focal64 y estamos exponiendo el puerto 8080 en donde se ejecutará nuestra instancia de WordPress, una vez terminado el aprovisionamiento de la máquina virtual podemos acceder a nuestra instancia de WordPress ingresando a localhost en un navegador de nuestro equipo guest.

<code>http://localhost:8080</code>

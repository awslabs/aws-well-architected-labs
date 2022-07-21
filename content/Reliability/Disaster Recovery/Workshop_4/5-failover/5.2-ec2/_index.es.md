+++
title = "Modifique la aplicación"
date =  2021-05-11T11:43:28-04:00
weight = 7
+++

Para conectar la aplicación a la base de datos Aurora recientemente promovida en la región us-west-1, debemos modificar la configuracion `Passive-Secondary` de la aplicación web.

### Conectándose a la aplicación

1.1 Oprima [EC2](https://us-west-1.console.aws.amazon.com/ec2/home?region=us-west-1#/) para navegar a la consola en la región **N. California (us-west-1)**.

1.2 Oprima el link **Instancias (En ejecución)**.

{{< img am-2-es.png >}}

1.3 Seleccione **UniShopAppV1EC2**, después oprima el botón **Conectar**.

{{< img am-3-es.png >}}

1.4 Oprima el link **Administrador de sesiones**, después oprima el botón **Conectar**.


1.5 Tras unos minutos, aparecerá un terminal.


1.6 Cambie el directorio actual a la carpeta home del usuario ec2-user.

```sh
sudo su ec2-user
cd /home/ec2-user/
```

1.7 Abra el archivo **unishoprun.sh** para editarlo con nano o vi.

```sh
sudo nano unishoprun.sh
```

**Tip:** Puede usar el comando vi ([Debian ManPage]((https://manpages.debian.org/buster/vim/vi.1.en.html))) o nano ([Debian ManPage](https://manpages.debian.org/stretch/nano/nano.1.en.html)) para editar el documento.

1.8 Elimine el contenido del archivo.  Posteriormente copie y pegue el siguiente contenido en el archivo **unishoprun.sh**.

```sh
#!/bin/bash
java -jar /home/ec2-user/UniShopAppV1-0.0.1-SNAPSHOT.jar &> /home/ec2-user/app.log &
```

1.9 Guarde las modificaciones (CTRL+O) y cierre el editor (CTRL+X).

1.10 Reinicie la instancia EC2 para que los cambios tengan efecto.

```sh
sudo reboot
```

#### Felicitaciones!  Su aplicación ha sido actualizada para usar la base de datos de Aurora que promovió!

{{< prev_next_button link_prev_url="../promote-aurora/" link_next_url="../../verify-failover/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}


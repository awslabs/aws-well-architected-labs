+++
title = "Modifique la aplicación"
date =  2021-05-11T11:43:28-04:00
weight = 5
+++

### EC2

1.1 Oprima [EC2](https://us-west-1.console.aws.amazon.com/ec2/home?region=us-west-1#/) para navegar a la consola en la región **N. California (us-west-1)**.

1.2 Oprima el link **Instancias (En ejecución)**.

{{< img BK-4-ES.png >}}

1.3 Seleccione la instancia **BackupAndRestoreSecondary**, después oprima el botón **Conectar**.

{{< img RS-44-ES.png >}}

1.4 Oprima el link **Administrador de sesiones**, después oprima el botón **Conectar**.

{{< img am-4-ES.png >}}

1.5 Poco tiempo después, se mostrará un terminal..

{{< img am-5.png >}}


1.6 Ahora, cree una conexion a la base de datos en la región secundaria **N. California (us-west-1)**. 
```sh
sudo su ec2-user
cd /home/ec2-user
```
Reemplace el endpoint **backupandrestore-secondary-region.xxxx.us-west-1.rds.amazonaws.com** que encuentra a continuación con el endpoint copiado de la [Sección de RDS](../rds/).

```sh
sudo mysql -u UniShopAppV1User -P 3306 -pUniShopAppV1Password -h backupandrestore-secondary-region.xxxx.us-west-1.rds.amazonaws.com
```

Escriba **show databases**.

```sh
MySQL [(none)]> show databases;
```

Debería ver lo siguiente

```sh 
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| unishop            |
+--------------------+
5 rows in set (0.02 sec)

```

Oprima **exit** para retornar a la terminal.

```sh
MySQL [(none)]> exit
```

1.7 Abra el archivo **unishopcfg.sh** para editarlo con nano o con vi.

```sh
sudo nano unishopcfg.sh
```

**Consejo:** Puede usar el comando vi ([Debian ManPage]((https://manpages.debian.org/buster/vim/vi.1.en.html))) o el comando nano ([Debian ManPage](https://manpages.debian.org/stretch/nano/nano.1.en.html)) para editar el documento.

1.8 Reemplace el endpoint **backupandrestore-secondary-region.xxxx.us-west-1.rds.amazonaws.com** con el endpoint que copió de la [Sección de RDS](../rds/).  Cambie el parámetro ***AWS_DEFAULT_REGION** a `us-west-1`.  Añada `-dr` al final de **UI_RANDOM_NAME**.

```sh
#!/bin/bash
export Database=backupandrestore-secondary-region.xxxx.us-west-1.rds.amazonaws.com
export DB_ENDPOINT=backupandrestore-secondary-region.xxxx.us-west-1.rds.amazonaws.com
export AWS_DEFAULT_REGION=us-west-1
export UI_RANDOM_NAME=backupandrestore-uibucket-xxxx-dr
```

Salga del editor guardando sus cambios.

1.9 Ahora, use el comando source, que lee y ejectua comandos del archivo unishopcfg.sh

```sh
source unishopcfg.sh
```

1.10 Ahora, copie los archivos de la aplicación a los buckets de S3. 

{{% notice note %}}
Si los buckets de S3 tuvieran información de la aplicación entonces sería necesaria agendar copias de seguridad recuerrentes para alcanzar el RPO objetivo. Esto podría lograrse con replicación entre region. Ya que nuestros buckets no contienen información, solo código, restauraremos el contenido de la instancia EC2.
{{% /notice %}}

```sh
sudo aws s3 cp /home/ec2-user/UniShopUI s3://$UI_RANDOM_NAME/ --recursive --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers
```

1.11 Reinicie la instancia EC2 para que los cambios surjan efecto.

```sh
sudo reboot
```

### Crear un archivo de configuración para la aplicación

2.1 Utilizando su editor preferido, cree un nuevo archivo llamado `config.json`. Establezca la propiedad **host** como el **Nombre IPv4 de DNS público de EC2** copiado de la [Sección de EC2](../ec2/).  Añada ('http://') y remueva cualquier backslash (`/`) si hay alguno presente.  Finalmente, establezca la propiedad **region** a `us-west-1`.

```json
{
    "host": "http://{{Reemplace con su Nombre IPv4 de DNS público de EC2 copiado de la sección de EC2}}",
    "region": "us-west-1"
}
```

Su archivo `config.json` final debe ser parecido a este ejemplo.

```json
{
    "host": "http://ec2-XXX-XXX-XXX-XXX.us-west-1.compute.amazonaws.com",
    "region": "us-west-1"
}
```

### S3

3.1 Oprima [S3](https://console.aws.amazon.com/s3/home?region=us-east-1#/) para navegar a la consola.

3.2 Oprima el link para **backupandrestore-uibucket-xxxx-dr**.

{{< img c-11-ES.png >}}

3.3 Oprima el botón **Cargar** button.

{{< img c-12-ES.png >}}

3.4 Oprima el botón **Añadir archivos** y especifique el archivo **config.json**.

{{< img c-13-ES.png >}}

3.5 En la sección **Sección de permisos**, Seleccione el botón **Especificar permisos de ACL individuales**.  Habilite la casilla de verificación **Lectura** que se encuentra al lado de **Todo el mundo (Acceso público)**.

{{< img c-14-ES.png >}}

3.6 Habilite la casilla de verificación **Comprendo los efectos que estos cambios tienen sobre los objectos especificados.** Oprima el botón **Cargar**.

{{< img c-15-ES.png >}}

Oprima el botón **Cerrar**.

3.7 Oprima el link **Propiedades**.  En la sección **Alojamiento de sitios web estáticos**, oprima el botón **Editar**.

{{< img c-17-ES.png >}}

{{< img c-18-ES.png >}}

3.8 En la sección **Alojamiento de sitios web estáticos** seleccioné el botón **Habilitar**.  Introduzca `index.html` como el **Documento de índice** e introduzca `error.html` como el **Documento de error**.

{{< img c-19-ES.png >}}

3.9 Oprima el botón **Guardar cambios**.

{{< img rs-45-ES.png >}}

3.10 En la sección **Alojamiento de sitios web estáticos**,  oprima el link **Endpoint de sitio web en el bucket** link.

{{< img rs-46-ES.png >}}
{{< img rs-45.png >}}

#### Felicitaciones !  Debería ver su aplicación "The Unicorn Shop" en la región **us-west-1**.

{{< prev_next_button link_prev_url="../rds/" link_next_url="../../cleanup/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}


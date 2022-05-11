+++
title = "EC2"
date =  2021-05-11T20:33:54-04:00
weight = 2
+++

### Crear una AMI (Amazon Machine Image)

Si nuestra instancia EC2 tuviera información de la aplicación, sería necesario agendar copias de seguridad recurrentes para alcanzar el RPO objetivo. [AWS Backup](https://aws.amazon.com/backup) provee esta funcionalidad a través de un tablero de control que simplifica el proceso de auditoría de copias de seguridad y actividades de restauración a través de servicios de AWS. Ya que nuestra instancia no contiene información, solo código, crearemos una copia de seguridad única. Los respaldos de seguridad recurrentes son necesarios para aplicaciones de producción cada vez que un cambio ocurre dentro de una instancia EC2.

1.1 Oprima [EC2](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#/) para navegar la consola en la región de **N. Virginia (us-east-1)**.

1.2 Oprima el link **Instancias (En ejecución)**.

{{< img BK-2-ES.png >}}

1.2 Seleccione **UniShopAppV1EC2BackupAndRestore**.  Oprima **Crear imagen** en la sección **Acciones -> Imagen y Plantillas**.

{{< img BK-3-ES.png >}}

1.3 Introduzca `BackupAndRestoreImage` como el **Nombre de la imagen**, después oprima el botón de **Crear Imagen**.

{{< img BK-4-ES.png >}}

{{< prev_next_button link_prev_url="../rds" link_next_url="../s3/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}

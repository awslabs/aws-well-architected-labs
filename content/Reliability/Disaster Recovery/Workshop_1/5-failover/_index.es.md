+++
title = "Failover a región secundaria"
date =  2021-05-11T11:43:28-04:00
weight = 5
+++

Cuando un evento de servicio regional afecta la aplicación Unicornio en la región primaria **N. Virginia (us-east-1)**, querremos activar sus recursos en la región secundaria **N. California (us-west-1)**.

Asumiremos que un evento de servicio regional ha ocurrida. Es esta sección, llevaremos a cabo una serie de tareas manuales para recuperar el funcionamiento de la aplicación en la región secundaria **N. California (us-west-1)**.  En un ambiente de producción, automatizariamos estos pasos utilizando una plantilla de AWS CloudFormation o herramientas de terceros.

Haremos lo siguiente:
- Iniciar una instancia EC2 a partir de una AMI (Amazon Machine Image)
- Restaurar la base de datos RDS a partir de una copia de seguridad
- Configurar la aplicación

### Simulando un evento de servicio regional

Simularemos un evento regional de servicio que afecte la página web estática alojada en S3 en la región  **N. Virginia (us-east-1)** correspondiente al portal de The Unicorn Shop.

1.1 Oprima [S3](https://console.aws.amazon.com/s3/home?region=us-east-1#/) para navegar a la consola.

1.2 Oprima el link **backupandrestore-primary-uibucket-xxxx**.

{{< img c-9-ES.png >}}

1.3 Oprima el link **Permisos**. En la sección **Bloquear acceso público (configuración del bucket)** oprima el botón **Editar**.

{{< img d-6-ES.png >}}

1.4 Habilite la casilla **Bloquear todo el acceso público**, después oprima el botón **Guardar cambios**.

{{< img d-7-ES.png >}}

1.5 Escriba `confirmar`, después oprima el botón **Confirmar**.

{{< img d-8-ES.png >}}

1.6 Oprima el link **Propiedades**.  

{{< img d-10-ES.png >}}

1.7 En la sección **Alojamiento de sitios web estáticos**.  Oprima el link **Punto de enlace de sitio web del bucket**.

{{< img d-11-ES.png >}}

1.8  Debería obtener un error tipo **403 Forbidden**.

{{< img f-7.png >}}

{{< prev_next_button link_prev_url="../verify-website/" link_next_url="./ec2/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}


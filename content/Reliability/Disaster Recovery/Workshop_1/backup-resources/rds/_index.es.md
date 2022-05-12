+++
title = "RDS"
date =  2021-05-11T20:33:54-04:00
weight = 1
+++

### Respalde la base de datos RDS

1.1 Oprima [AWS Backup](https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#/) para navegar a la consola en la región **N. Virginia (us-east-1)**.

1.2 Oprima el link **Recursos protegidos**, después oprima el botón **Crear copia de seguridad on-demand**.

{{< img BK-22-ES.png >}}

1.3 Seleccione **RDS** como el **Tipo de recurso**, después seleccione **unishopappv1dbbackupandrestore** como el **Nombre de la base de datos**. Oprima el botón **Crear copia de seguridad on-demand**.

{{< img BK-23-ES.png >}}

{{% notice warning %}}
Si ve este error, por favor **REPITA** los pasos 1.1 a 1.3 asegurandose de empezar por el paso 1.1. (Imagen en inglés)
{{% /notice %}}

{{< img BK-26.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../ec2/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}

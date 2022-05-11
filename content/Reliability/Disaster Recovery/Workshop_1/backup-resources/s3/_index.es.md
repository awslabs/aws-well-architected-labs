+++
title = "S3"
date =  2021-05-11T20:33:54-04:00
weight = 3
+++

### Crear el bucket S3 para la UI en la región secundaria N. California (us-west-1)

1.1 Oprima [S3](https://console.aws.amazon.com/s3/home?region=us-east-1#/) para navegar a la consola.

1.2 Copie el nombre del bucket para la UI que está en la región **N.Virginia (us-east-1)**.  Será similar a `backupandrestore-uibucket-xxxx`.

{{< img RS-48-ES.png >}}

1.3  Oprima el botón **Crear bucket**.

{{< img BK-29-ES.png >}}

1.4 Introduzca el nombre del bucket utilizando el **Bucket para la UI** que copió en el **Paso 1.2** y añada al final del nombre **“-dr”**. 

1.5  Selecccione **N. California (us-west-1)** como la **Region AWS**.

{{< img BK-30-ES.png >}}

1.6 En la sección **Propiedad de objetos** seleccione **ACLs habilitadas**.

{{< img BK-33-ES.png >}}

1.7 En la sección **Bloquear configuración de acceso publico para este bucket** ,  deshabilite **Bloquear *todo* acceso público** y todos sus hijos.  Habilite la casilla de verificación  **Reconozco que la configuración actual....**. 

{{< img BK-31-ES.png >}}

1.8 Oprima el botón **Crear Bucket** button.

{{< img BK-32-ES.png >}}

{{< prev_next_button link_prev_url="../ec2" link_next_url="../../copy-to-secondary/" button_next_text="Siguiente paso" button_prev_text="Paso anterior" />}}

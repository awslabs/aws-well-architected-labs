+++
title = "Acceso a S3"
date =  2021-05-11T11:43:28-04:00
weight = 1
+++

#### Permita acceso público a Amazon S3

Nuestra aplicación emplea alojamiento de sitios web estáticos en AWS Simple Storage Service (S3). Para hacer que la aplicación sea disponible para usuarios a través del internet, debemos deshabilitar la política de cuenta de AWS que bloquea el acceso público.

1.1 Oprima [S3](https://console.aws.amazon.com/s3/home?region=us-east-1#/) para navegar a la consola.

1.2 Oprima el link **Configuración de bloqueo de acceso público correspondiente a esta cuenta**.

{{< img pr-1-ES.png >}}

1.3 Si ve que **Bloquear *todo* el acceso público** está **Habilitado**, oprima el botón **Editar**.

{{< img pr-2-ES.png >}}

1.4 Deshabilite la casilla de verificación **Bloquear configuración de acceso público para esta cuenta** así como todos sus hijos. Oprima el botón **Guardar cambios**. 

{{< img pr-3-ES.png >}}

1.5 Escriba `confirmar` y oprima el botón **Confirmar**.

{{< img pr-4-ES.png >}}

{{< img pr-5-ES.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../1.1.2-primary-region/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}

+++
title = "Failover a secundaria"
date =  2021-05-11T11:43:28-04:00
weight = 4
+++

En el evento que un desastre afecte nuestra región primaria en **N. Virginia (us-east-1)**, querremos buscar habilitar nuestros recursos en la región secundaria  **N. California (us-west-1)**.

{{% notice info %}}
Tomaremos una serie de acciones **manuales** para failover nuestros recursos a nuestra región secundaria **N California (us-west-1)**.
En un ambiente de producción éstas acciones serian automatizadas como parte del proceso de failover.
{{% /notice %}}

#### Simulando un evento regional de servicio

Simularemos que un evento regional de servicio ha ocurrido y está afectando nuestro sitio web de Unishop en **N. Virginia (us-east-1)**. Ésto será logrado deshabilitando el acceso público a nuestro bucket de S3 que sirve nuestro sitio web, rindiendolo inaccesible.

1.1 Oprima [S3](https://console.aws.amazon.com/s3/home?region=us-east-1#/) para navegar a la consola.

1.2 Oprima el enlace **pilot-primary-uibucket-xxxx**.

{{< img f-1-ES.png >}}

1.3 Oprima el enlace **Permisos**. Oprima **Editar** en la sección **Bloquear acceso público (configuración del bucket)** .

{{< img f-2-ES.png >}}

1.4 Habilite el checkbox **Bloquear _todo_ el acceso público**, luego orpima **Guardar cambios**.

{{< img f-3-ES.png >}}

1.5 Escriba `confirmar` y luego oprima el botón **Confirmar**

{{< img d-8-ES.png >}}

1.6 Oprima el enlace **Propiedades**

{{< img f-4-ES.png >}}

1.7 Dentro de la página de propiedades, desplácese hacia abjao hasta encontrar la sección **Alojamiento de sitios web estáticos** y orpima el enlance **Alojamiento de sitios web estáticos**.

{{< img f-5-ES.png >}}

1.8 Debe recibir el error **403 Forbidden**.

{{< img d-9.png >}}

{{% notice note %}}
Si no recibe el error **403 Forbidden** puede ser debido a _caching_. Intente refrescar la página, utilizar otro browser o modo incognito para ver el error.
{{% /notice  %}}


{{< prev_next_button link_prev_url="../3-prepare-secondary/3.1-ec2" link_next_url="./4.1-aurora/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}
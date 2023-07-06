+++
title = "Failover"
date =  2021-05-11T11:43:28-04:00
weight = 3
+++

Cuando un evento de servicio regional afecta a la aplicación de Unishop en la región principal **Norte de Virginia (us-east-1)**, queremos conmutar por error a la región secundaria **N. California (us-west-1)**.

{{% notice info %}}
Realizaremos **manualmente** una serie de tareas para conmutar por error nuestra carga de trabajo a nuestra región secundaria **Norte de California (us-west-1)**. 
En un entorno de producción, **automatizaríamos** estas tareas como parte de nuestro proceso de conmutación por error.
{{% /notice %}}

#### Simulación de un evento de servicio regional

Ahora simularemos un evento de servicio regional que afecta al sitio web de Unishop en **Norte de Virginia (us-east-1)**. Vamos a lograrlo bloqueando el acceso público al bucket S3 que aloja el sitio web, lo que hace que el sitio web de Unishop no esté disponible.

1.1 Vaya a [S3](https://console.aws.amazon.com/s3/home?region=us-east-1#/).

1.2 Haz clic en el enlace **warm-primary-uibucket-xxxx**.

{{< img f-1-es.png >}}

1.3 Haz clic en el enlace **Permisos**. En la sección **Bloquear acceso público (configuración del depósito) **, haz clic en el botón **Editar**.

{{< img f-2-es.png >}}

1.4 Active la casilla de verificación **Bloquear todo acceso público** y, a continuación, haga clic en el botón **Guardar**.

{{< img f-3-es.png >}}

1.5 Escribe «confirmar» y, a continuación, haz clic en el botón **Confirmar**.

{{< img d-8-es.png >}}

1.6 Haga clic en el enlace **Propiedades**. 

{{< img f-4-es.png >}}

1.7 En la sección **Alojamiento de sitios web estáticos**. Haz clic en el enlace **Punto final del sitio web de Bucket**.

{{< img f-5-es.png >}}

1.8 Debería aparecer un error de**403 Forbidden**.

{{< img d-9.png >}}


Asumiremos que ocurrió un evento regional de servicio. En esta sección, haremos el fail over de forma manual de la aplicación a la región secundaria, **N. California (us-west-1)**. Puede considerar usar Amazon Route53 u otro DNS (Domain Name Services) para enrutar el fail over en un escenario real. Puede crear también automatizaciones subscribiendose a notificaciones de la aplicación.

{{< prev_next_button link_prev_url="../2-verify-websites/" link_next_url="./3.1-aurora/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}

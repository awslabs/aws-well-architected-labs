+++
title = "Promover Aurora"
date =  2021-05-11T11:43:28-04:00
weight = 6
+++

La base de datos Global de Aurora está diseñada para aplicaciones globalmente distribuidas, permitiendo que una única base de datos Aurora pueda expandirse a través de múltiples regiones de AWS. Su información es replicada sin que esto impacte el rendimiento de la base de datos, permite lecturas locales rápidas con poca latencia para cada regiœn y ofrece recuperación de desastres a un nivel regional. En situaciones de recuperación de desastres, puede promover la región secundaria para que se encargue de las responsabilidades de lectura y escritura en menos de un minuto.

Ahora, promovamos la base de datos secundaria de Amazon Aurora MySQL a una instancia independiente.

1.1 Navegue a [RDS](https://us-west-1.console.aws.amazon.com/rds/home?region=us-west-1#/) en la región **N. California (us-west-1)**.

1.2 Oprima **Instancias de base de datos**.

{{< img a-2-ES.png >}}

1.3 Encuentre la instancia **dr-immersionday-secondary-pilot** y oprima **Acciones**. Después oprima la opción **Eliminar de la base de datos global** para promover la instancia a una base de datos independiente.

{{< img a-3-ES.png >}}

1.4 Oprima **Remove and promote** para confirmar la promoción del servidor. (No está traducido en la consola)

{{< img a-4.png >}}

## Felicitaciones! Su base de datos secundaria de Amazon Aurora ahora es una base de datos independiente y puede convertirse en su base de datos primaria!

{{< prev_next_button link_prev_url="../promote-app/" link_next_url="../../verify-failover/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}

+++
title = "Promover Aurora"
date =  2021-05-11T11:43:28-04:00
weight = 1
+++

La base de datos Global de Aurora está diseñada para aplicaciones globalmente distribuidas, permitiendo que una única base de datos Aurora pueda expandirse a través de múltiples regiones de AWS. Su información es replicada sin que esto impacte el rendimiento de la base de datos, permitiendo lecturas locales rápidas con poca latencia para cada región y ofrece recuperación de desastres causadas por fallas a nivel regional. En situaciones de recuperación de desastres, puede promover la región secundaria para que se encargue de las responsabilidades de lectura y escritura en menos de un minuto.

Bases de datos globales de Aurora nos brinda dos opciones para _failover_ dependiendo del escenario.

En éste _workshop_ seguiremos[Recuperación de una base de datos global Amazon Aurora de una interrupción no planificada](https://docs.aws.amazon.com/es_es/AmazonRDS/latest/AuroraUserGuide/aurora-global-database-disaster-recovery.html).

### Promover Aurora

1.1 Navegue a [RDS](https://us-west-1.console.aws.amazon.com/rds/home?region=us-west-1#/) en la región **N. California (us-west-1)**.

1.2 Oprima **Instancias de base de datos**.

{{< img a-2-ES.png >}}

1.3 Encuentre la instancia **pilot-secondary** y oprima **Acciones**. Después oprima la opción **Eliminar de la base de datos global** para promover la instancia a una base de datos independiente.

{{< img a-3-ES.png >}}

1.4 Oprima **Remove and promote** para confirmar la promoción del servidor. (No está traducido en la consola)

{{< img a-4.png >}}


{{< prev_next_button link_prev_url="../" link_next_url="../4.2-ec2/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}

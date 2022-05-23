+++
title = "Verifique el reenvio de escritura de Aurora"
date =  2021-05-11T11:43:28-04:00
weight = 3
+++

La base de datos global de Aurora está diseñada para aplicaciones globalmente distribuidas, permitiendo que una única base de datos Aurora se expanda a múltiples regiones de AWS. Su información es replicada sin que afecte el rendimiento de la base de datos, permite lecturas locales rápidas de baja latencia en cada región y provee capacidades de recuperación de desastres de eventos a nivel regional.

El **Reenvio de escritura para réplicas de lectura** tiene una latencia normal de un segundo entre la base de datos secundaria a la primaria. Esta capacidad permite habilitar lecturas de baja latencia a lo largo de su presencia global. En situaciones de recuperación de desastres, podemos promover una región secundaria a que tome todas las responsabilidades de lectura y escritura en menos de un minuto.

Ahora, verifiquemos el reenvio de escritura para replicas de lectura de Amazon Aurora MySQL en nuestra instancia.

### Verificando el reenvio de escritura de Aurora

1.1 Naveguemos a [RDS](https://us-west-1.console.aws.amazon.com/rds/home?region=us-west-1#/) en la región **N. California (us-west-1)**.

1.2 Ahora, oprima **Instancias de base de datos**.

{{< img a-2-es.png >}}

1.3 Oprima el link **hot-standby-passive-secondary**.

{{< img a-3-es.png >}}

1.4 Oprima el link **Configuración** y verifique que **Reenvio de escritura de réplicas de lectura** esté **Habilitado**.

{{< img a-4-es.png >}}

## Felicitaciones! Ha verificado que la base de datos global de Aurora soporta Reenvio de escritura para réplicas de lectura!

{{< prev_next_button link_prev_url="../dynamodb-global/" link_next_url="../configure-websites/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}
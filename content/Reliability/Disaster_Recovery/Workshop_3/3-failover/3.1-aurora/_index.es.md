+++
title = "Aurora"
date =  2021-05-11T11:43:28-04:00
weight = 1
+++

[Amazon Aurora Global Database](https://aws.amazon.com/rds/aurora/global-database) está diseñada para aplicaciones globalmente distribuidas, permitiendo que una única base de datos Aurora pueda expandirse a través de múltiples regiones de AWS. Su información es replicada sin que esto impacte el rendimiento de la base de datos, permite lecturas locales rápidas con poca latencia para cada regiœn y ofrece recuperación de desastres a un nivel regional. En situaciones de recuperación de desastres, puede promover la región secundaria para que se encargue de las responsabilidades de lectura y escritura en menos de un minuto.

Con una base de datos global de Aurora, hay dos enfoques diferentes para la conmutación por error según el escenario. 

**Conmutación por error manual no planificada («desconectar y promover»)**: para recuperarse de una interrupción no planificada o para realizar pruebas de recuperación ante desastres (DR), realice una conmutación por error entre regiones a uno de los secundarios de la base de datos global de Aurora. El RTO de este proceso manual depende de la rapidez con la que pueda realizar las tareas enumeradas en [Recuperar una base de datos global de Amazon Aurora de una interrupción no planificada](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database-disaster-recovery.html#aurora-global-database-failover). El RPO generalmente se mide en segundos, pero esto depende del retraso de replicación del almacenamiento de Aurora en la red en el momento de la falla.

**Conmutación por error planificada**: esta función está diseñada para entornos controlados, como el mantenimiento operativo y otros procedimientos operativos planificados. Al usar la conmutación por error planificada y administrada, puede reubicar el clúster de base de datos principal de la base de datos global de Aurora en una de las regiones secundarias. Dado que esta función sincroniza los clústeres de base de datos secundarios con los principales antes de realizar cualquier otro cambio, el RPO es 0 (sin pérdida de datos). Para obtener más información, consulte [Realizar conmutaciones por error planificadas y administradas para las bases de datos globales de Amazon Aurora](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database-disaster-recovery.html#aurora-global-database-disaster-recovery.managed-failover).

En un verdadero escenario de desastre, lo más probable es que utilice **Conmutación por error no planificada**, que se muestran en **Módulo 2: Piloto** y **Módulo 4: Espera activa**. 

Para este taller realizaremos una **Conmutación por error planificada**.

#### Promote Aurora

1.1 Vaya a [RDS](https://us-east-1.console.aws.amazon.com/rds/home?region=us-east-1#databases:) en la región **Norte de Virginia (us-east-1)**.

1.2 Observe la base de datos global de **warm-global**. Observe que tenemos un **clúster principal** en **us-east-1** que tiene nuestra **instancia de escritor** y un **clúster secundario** en **us-west-1** que tiene nuestra **instancia de lector**.

{{< img a-8-es.png >}}

1.3 Selecciona **warm-global** y, a continuación, selecciona **Conmutar por error la base de datos global** en el enlace **Acciones**.

{{< img a-5-es.png >}}

1.4 Selecciona **warm-secondary** como **Elegir un clúster secundario para que se convierta en el clúster principal** y, a continuación, haz clic en el botón**Conmutar por error a base de datos global**.

{{< img a-6-es.png >}}

{{% notice warning %}}
Deberá esperar a que la base de datos realice una conmutación por error antes de continuar con el siguiente paso. Esto puede tardar varios minutos.
{{% /notice %}}

1.5 Fíjate en los cambios. El **clúster principal** está ahora en **us-west-1**, que tiene nuestra **instancia de escritor**, y el **Clúster secundario** está ahora en **us-east-1**, que tiene nuestra **instancia de lector**.

{{< img a-7-es.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../3.2-ec2/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}


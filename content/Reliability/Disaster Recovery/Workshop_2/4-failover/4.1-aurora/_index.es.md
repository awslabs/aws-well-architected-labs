+++
title = "Aurora"
date =  2021-05-11T11:43:28-04:00
weight = 6
+++

La [base de datos Global de Amazon Aurora](https://aws.amazon.com/es/rds/aurora/global-database/?nc1=h_ls) está diseñada para aplicaciones globalmente distribuidas, permitiendo que una única base de datos Aurora pueda expandirse a través de múltiples regiones de AWS. Su información es replicada sin que esto impacte el rendimiento de la base de datos, permitiendo lecturas locales rápidas con poca latencia para cada región y ofrece recuperación de desastres causadas por fallas a nivel regional. En situaciones de recuperación de desastres, puede promover la región secundaria para que se encargue de las responsabilidades de lectura y escritura en menos de un minuto.

Bases de datos globales de Aurora nos brinda dos opciones para _failover_ dependiendo del escenario.

**Conmutación por error manual no planificada (“desconectar y promover”)** - para recuperarse de una interrupción no planificada o para realizar pruebas de recuperación de desastres (DR), realice una conmutación por error entre regiones a una de las regiones secundarias en su base de datos global de Aurora. El RTO para este proceso manual depende de la rapidez con la que pueda realizar las tareas enumeradas en [Recuperación de una base de datos global Amazon Aurora de una interrupción no planificada](https://docs.aws.amazon.com/es_es/AmazonRDS/latest/AuroraUserGuide/aurora-global-database-disaster-recovery.html#aurora-global-database-failover). Normalmente, el RPO se mide en segundos, pero esto depende del retraso de reproducción del almacenamiento de información de Aurora en la red en el momento de la falla.

**Conmutación por error planificada y administrada** -  esta característica está pensada para entornos controlados, como el mantenimiento operativo y otros procedimientos operativos planificados. Mediante la conmutación por error planificada administrada, puede reubicar el clúster de base de datos principal de su base de datos global de Aurora en una de las regiones secundarias. Dado que esta característica sincroniza los clústeres secundarios de base de datos con el principal antes de realizar cualquier otro cambio, el RPO es 0 (sin pérdida de datos). Para obtener más información, consulte [Ejecución de la conmutación por error planificada administrada para bases de datos globales de Amazon Aurora](https://docs.aws.amazon.com/es_es/AmazonRDS/latest/AuroraUserGuide/aurora-global-database-disaster-recovery.html#aurora-global-database-disaster-recovery.managed-failover). 

**Conmutación por error planificada y administrada** es demostrado en el **Módulo 3: Warm Standby**

En éste _workshop_ estaremos realizando **Conmutación por error manual no planificada** 

#### Promover Aurora

1.1 Oprima [RDS](https://us-west-1.console.aws.amazon.com/rds/home?region=us-west-1#databases:) para navegar a la consola en la región **N. California (us-west-1)**.

1.2 Fijese la base de datos global **pilot-global** y note como tenemos **pilot-primary** un **Clúster principal** en **us-east-1** que contiene nuestra **instancia de escritor** y un **pilot-secondary** que es **Clúster scundario** en **us-west-1** que contiene nuestar **instancia de lectura**.

{{< img a-5-ES.png >}}

1.3 Encuentre la instancia **pilot-secondary** y oprima **Acciones**. Después oprima la opción **Eliminar de la base de datos global** para promover la instancia a una base de datos independiente.

{{< img a-3-ES.png >}}

1.4 Oprima **Remove and promote** para confirmar la promoción de la base de datos. (No está traducido en la consola)

{{< img a-4.png >}}

{{% notice warning %}}
Debe esperar a que la base de datos sea promovida antes de continuar con el paso siguiente. Esto peude demorar varios minutos.
{{% /notice %}}

1.5 Note los cambios. La instancia **Pilot-secondary** ha sido removida de la  **Base de datos global** y ahora es un **Clúster regional** con su propia **instancia de escritor**. Puede necesitarse **Refrescar** la página web para notar los cambios.

{{< img a-6-ES.png >}}


{{< prev_next_button link_prev_url="../" link_next_url="../4.2-ec2/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}

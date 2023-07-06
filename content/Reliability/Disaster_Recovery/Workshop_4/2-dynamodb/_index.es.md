+++
title = "Tablas globales de DynamoDB"
date =  2021-05-11T11:43:28-04:00
weight = 2
+++

Cuando crea una tabla global de DynamoDB, crea múltiples replicas de tablas (Una por región de AWS) que DynamoDB trata como una única unidad. Cada replica tiene el mismo nombre de tabla y el mismo esquema de llaves primarias. Cuando una aplicación escribe información a una replica en una región, DynamoDB propaga la escritura a las otras replicas (tablas) en otras regiones de AWS de forma automática.

Vamos a configurar las tablas globales de DynamoDB replicando de la región **AWS Region N. Virginia (us-east-1)** a **AWS Region N. California (us-west-1)**.

{{% notice note %}}
**Si está utilizando su propia cuenta de AWS, debe esperar a que la pila de la región primaria se cree de forma exitosa antes de moverse a este paso.**
{{% /notice %}}

### Desplegando tablas globales de Amazon DynamoDB

1.1 Oprima [DynamoDB](https://console.aws.amazon.com/dynamodbv2/home?region=us-east-1#/) para navegar a la consola en la región **N. Virginia (us-east-1)**.

1.2 Oprima el link **Tablas**.

{{< img dd-2-es.png >}}

1.3 Oprima el link **unishophotstandby**.

{{< img dd-3-es.png >}}

1.4 Oprima el link **Tablas globales**, después oprima el botón **Crear réplica**.

{{< img dd-4-es.png >}}

1.5 Seleccione **US West (N. California)** en **Regiones disponibles para replicación**, después oprima el botón **Crear replica**.

{{< img dd-5-es.png >}}

{{% notice note %}}
Esto puede tomar un par de minutos, puede seguir al siguiente paso. Solo asegúrese que el estatus aparece como **Activo** antes del paso **Verifique las páginas web**.
{{% /notice %}}

{{< img dd-6-es.png >}}

#### Felicitaciones! Sus tablas globales de DynamoDB se han creado!

{{< prev_next_button link_prev_url="../prerequisites/cfn-outputs/" link_next_url="../verify-aurora-writefwd/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}

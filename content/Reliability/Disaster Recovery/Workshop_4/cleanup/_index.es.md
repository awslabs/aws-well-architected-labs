+++
title = "Limpieza de recursos"
date =  2021-05-11T11:43:28-04:00
weight = 9
+++

### Amazon S3

1.1 Oprima [S3](https://us-east-1.console.aws.amazon.com/s3/home?region=us-east-1#/) para navegar a la consola.

1.2 Seleccione el bucket **active-primary-uibucket-xxxx** y oprima el botón **Vaciar**.

{{< img cl-2-es.png >}}

1.3 Escriba `eliminar de forma permamente` en la casilla de verificación y oprima **Vaciar**.

{{< img cl-3-es.png >}}

1.4 Espere hasta que vea el banner verde a lo largo de la parte superior de la pantalla indicando que el bucket está vacio. Después oprima el botón **Salir**.

{{< img cl-4-es.png >}}

{{% notice note %}}
Por favor repita los pasos **1.1** a **1.4** para los siguientes buckets:
**passive-secondary-uibucket-xxxx**</br>
**active-primary-assetbucket-xxxx**</br>
**passive-secondary-assetbucket-xxxx**
{{% /notice %}}

### Amazon DynamoDB 

2.1 Oprima [DynamoDB](https://us-east-1.console.aws.amazon.com/dynamodb/home?region=us-east-1#/) para navegar a la consola en la región **N. Virginia (us-east-1)**.

2.2 Oprima el link **Tablas**.

{{< img dd-2-es.png >}}

2.3 Oprima **unishophotstandy**.

{{< img dd-3-es.png >}}

2.4 Oprima el link **Tablas globales**.  Seleccione la región **N. California (us-west-1)**, después oprima el botón **Eliminar región**.

{{< img cl-10-es.png >}}

2.5 Escriba `eliminar` y luego oprima el botón **Eliminar**.

{{< img cl-11-es.png >}}

2.6 Oprima [RDS](https://us-west-1.console.aws.amazon.com/rds/home?region=us-west-1#/) para navegar a la consola en la región **N. California (us-west-1)**.

2.7 Oprima el link **Instancias de base de datos**.

{{< img a-2-es.png >}}

2.8  Selecciones **unishopappv1db**, después oprima **Eliminar** bajo el menu desplegable **Acciones**.

{{< img cl-12-es.png >}}

2.9  Deshabilite la casilla de verificación **Create final snapshot?**. Habilite la casilla de verificación **I acknowledge that ...**.  Escriba `delete me` y oprima el botón **Delete**.

{{< img cl-13-es.png >}}

{{% notice note %}}
Por favor repita estos pasos con la base de datos primaria en la región us-east-1
{{% /notice %}}

### Amazon CloudFormation

3.1 Oprima [CloudFormation](https://us-west-1.console.aws.amazon.com/cloudformation/home?region=us-west-1#/) para navegar a la consola en la región **N. California (us-west-1)**.

3.2 Seleccione **Passive-Secondary**, después oprima el botón **Eliminar**.

{{< img cl-8-es.png >}}

3.3 Oprima el botón **Eliminar pila**.

{{< img cl-9-es.png >}}

3.4 Cambie la región de su [consola](https://us-east-1.console.aws.amazon.com/console) a **N. Virginia (us-east-1)** utilizando el selector de región en la parte superior de la pantalla.

3.5 Seleccione **Active-Primary**, después oprima el botón **Eliminar**.

{{< img cl-6-es.png >}}

3.6 Oprima el botón **Eliminar pila**.

{{< img cl-7-es.png >}}

### Amazon CloudFront

4.1 Oprima [CloudFront](https://console.aws.amazon.com/cloudfront/home?region=us-east-1#/) para navegar a la consola.

4.2 Oprima **Distributions**

{{< img cfn-1-es.png >}}

4.3 Seleccione la distribución y oprima **Delete**

{{< img cfn-2-es.png >}}

4.4 Oprima **Delete**

{{< img cfn-3-es.png >}}

{{< prev_next_button link_prev_url="../verify-failover/" title="Congratulations!" final_step="true" >}}
Este laboratorio le ayuda especificamente con las mejores prácticas cubiertas en la pregunta [REL 13  Como planea para recuperación de desastres? (DR)](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-failure-management.html)
{{< /prev_next_button >}}


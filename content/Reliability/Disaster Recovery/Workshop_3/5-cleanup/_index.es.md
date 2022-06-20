+++
title = "Limpieza de recursos"
date =  2021-05-11T11:43:28-04:00
weight = 5
+++

## Limpieza de Amazon S3

1.1 Navegue a [S3](https://us-east-1.console.aws.amazon.com/s3/home?region=us-east-1#/).

1.2 Seleccione el bucket **warm-primary-uibucket-xxxx** y oprima **Vaciar**.

{{< img cl-2-es.png >}}

1.3 Escriba `eliminar de forma permamente` en la casilla de verificación y oprima **Vaciar**.

{{< img cl-3-es.png >}}

1.4 Espere hasta que vea el banner verde a lo largo de la parte superior de la pantalla indicando que el bucket está vacio. Después oprima el botón **Salir**.

{{% notice note %}}
Por favor repita los pasos **1.1** a **1.4** para los siguientes buckets:

- `warm-secondary-uibucket-xxxx`

{{% /notice %}}

## Limpieza de base de datos

{{% notice note %}}
Este paso es requerido ya que promovimos manualmente la base de datos Aurora.
{{% /notice %}}

2.1 Navegue a [RDS](https://us-west-1.console.aws.amazon.com/rds/home?region=us-west-1#/) en la región **N. California (us-west-1)**.

2.2 Seleccione la base de datos bajo el cluster **dr-immersionday-secondary-warm** y elimine la instancia.

{{< img cl-11-es.png >}}

2.3 De-seleccione la opción Create final snapshot?, seleccione la opción "I acknowledge that..". Escribe "delete me" y pprima el botón **Delete**. (Esta parte de la consola no está traducida al español)

{{< img cl-12.png >}}

2.4 Espere hasta que el cluster de base de datos de Amazon Aurora se elimine. 

## Limpieza de la región secundaria de CloudFormation

3.1 Navegue a [CloudFormation](https://us-west-1.console.aws.amazon.com/cloudformation/home?region=us-west-1#/) en la región **N. California (us-west-1)**.

3.2 Seleccione la pila **Warm-Secondary** y oprima **Eliminar**.

{{< img cl-8-es.png >}}

3.3 Oprima **Eliminar pila** para confirmar la eliminación.

{{< img cl-9-es.png >}}

{{% notice info %}}
**Espere a que termine la eliminación de la pila**.
{{% /notice %}}

3.4 La eliminación de la pila en CloudFormation fallará por la eliminación manual de la base de datos Aurora.

{{< img cl-10-es.png >}}

3.6 Seleccione la pila **Warm-Secondary** y oprima eliminar **Delete**.

3.7 Seleccione todos los **Recursos a retener** (No hay problema con esto pues se eliminaron manualmente en la sección anterior) y oprima **Eliminar la pila**.

{{< img cl-13-es.png >}}

## Limpieza de la región primaria de AWS CloudFormation

4.1 Navegue a [CloudFormation](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/) en la región **N. Virginia (us-east-1)**.

4.2 Seleccione la pila **Warm-Primary**. Posteriormente oprima el botón **Eliminar** para eliminarla.

{{< img cl-6-es.png >}}

4.3 Oprima el botón **Eliminar pila** para confirmar su eliminación.

{{< img cl-7-es.png >}}

{{< prev_next_button link_prev_url="../4-verify-secondary/" title="Congratulations!" final_step="true" >}}
Este laboratorio le ayuda especificamente con las mejores prácticas cubiertas en la pregunta [REL 13  Como planea para recuperación de desastres? (DR)](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-failure-management.html)
{{< /prev_next_button >}}

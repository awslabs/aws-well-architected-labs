+++
title = "Limpiar recursos"
date =  2021-05-11T11:43:28-04:00
weight = 7
+++

## Limpieza de Amazon S3

1.1 Navegue a [S3](https://us-east-1.console.aws.amazon.com/s3/home?region=us-east-1#/).

1.2 Seleccione **pilot-primary-uibucket-xxxx** y oprima **Vaciar**.

{{< img cl-2-ES.png >}}

1.3 Escriba `eliminar de forma permamente` en la casilla de confirmación y oprima **Vaciar**.

{{< img cl-3-ES.png >}}

1.4 Cuando vea el banner verde en la parte superior diciendo que el bucket se vació, oprima **Salir**.

{{% notice note %}}
Porfavor repitas los pasos **1.1** a **1.4** para los siguientes buckets:

- `pilot-secondary-uibucket-xxxx`

{{% /notice %}}

## Limpieza de base de datos

{{% notice note %}}
Este paso es requerido ya que promovimos manualmente la base de datos Aurora.
{{% /notice %}}

2.1 Navegue a [RDS](https://us-west-1.console.aws.amazon.com/rds/home?region=us-west-1#/) en la región **N. California (us-west-1)**.

2.2 Seleccione la base de datos bajo el cluster **dr-immersionday-secondary-pilot** y elimine la instancia.

{{< img cl-11-ES.png >}}

2.3 Deseleccione la opción create a final snapshot?, seleccione la opción "I acknowledge". Escriba "delete me" y oprima el botón **Eliminar**. (No está traducido en la consola)

{{< img cl-12.png >}}

2.4 Espere a que el Cluster de la base de datos Amazon Aurora se termine de eliminar.

## Limpieza de la región secundaria en CloudFormation

3.1 Navegue a [CloudFormation](https://us-west-1.console.aws.amazon.com/cloudformation/home?region=us-west-1#/) en la región **N. California (us-west-1)**.

3.2 Seleccione la pila **Pilot-Secondary** y oprima **Eliminar**.

{{< img cl-8-ES.png >}}

3.3 Oprima **Eliminar pila** para confirmar el borrado.

{{< img cl-9-ES.png >}}

{{% notice info %}}
**Espere a que termine la eliminación de la pila**.
{{% /notice %}}

3.4 La eliminación de la pila de CloudFormation fallará por la eliminación manual de la base de datos Aurora.

{{< img cl-10-ES.png >}}

3.5 Navegue a [CloudFormation](https://us-west-1.console.aws.amazon.com/cloudformation/home?region=us-west-1#/) en la región **N. California (us-west-1)**.

3.6 Seleccione la pila **Pilot-Secondary** y oprima **Eliminar**.

3.7 Seleccione todo en **Es posible que retengas los recursos que no se pueden eliminar** (Esto estará bien pues se eliminaron manualmente en la sección anterior) y oprima **Eliminar pila**.

{{< img cl-13-ES.png >}}

## Limpieza de la región primaria en CloudFormation

4.1 Navegue a [CloudFormation](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/) en la región **N. Virginia (us-east-1)**.

4.2 Seleccione la pila **Pilot-Primary**. Oprima el botón **Eliminar** para removerla.

{{< img cl-6-ES.png >}}

4.3 Opria el botón **Eliminar pila** para confirmar el borrado.

{{< img cl-7-ES.png >}}

{{< prev_next_button link_prev_url="../5-verify-secondary/" title="Congratulations!" final_step="true" >}}
Este laboratorio ayuda le ayuda con las mejores prácticas cubiertas en la preguntas [REL 13  Como planear para recuperación de desastres (DR)](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-failure-management.html)
{{< /prev_next_button >}}

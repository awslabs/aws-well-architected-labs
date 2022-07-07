+++
title = "Limpieza de recursos"
date =  2021-05-11T11:43:28-04:00
weight = 5
+++

{{% notice info %}}
Si está organizando este taller a través de una capacitación dirigida por un instructor, **NO** necesita completar esta sección.
{{% /notice %}}

#### Limpieza de Amazon S3

1.1 Navegue a [S3](https://us-east-1.console.aws.amazon.com/s3/home?region=us-east-1#/).

1.2 Seleccione el bucket **warm-primary-uibucket-xxxx** y oprima **Vaciar**.

{{< img cl-2-es.png >}}

1.3 Escriba `eliminar de forma permamente` en la casilla de verificación y oprima **Vaciar**.

{{< img cl-3-es.png >}}

1.4 Espere hasta que vea el banner verde en la parte superior de la pantalla indicando que el bucket está vacio. Después oprima el botón **Salir**.

{{% notice note %}}
Por favor repita los pasos **1.1** a **1.4** para los siguientes buckets:

- `warm-secondary-uibucket-xxxx`

{{% /notice %}}

#### Limpieza de base de datos

{{% notice note %}}
Este paso es requerido ya que promovimos manualmente la base de datos Aurora.
{{% /notice %}}

2.1 Navegue a [RDS](https://us-west-1.console.aws.amazon.com/rds/home?region=us-west-1#/) en la región **N. California (us-west-1)**.

2.2 Seleccione **unishop-warm** la base de datos bajo el cluster **warm-primary** y seleccione **Eliminar** en el menu **Acciones**.

{{< img cl-11-es.png >}}

2.3 Desactive la opción Create final snapshot?, seleccione la opción "I acknowledge that..". Escribe "delete me" y oprima el botón **Delete**. (Esta parte de la consola no está traducida al español)

{{< img cl-12.png >}}

2.4 Seleccione el cluster **warm-primary** y haga click en **Remove from global database** under **Actions** and then confirm promotion.

{{< img cl-14-es.png >}}

2.5 Seleccione el cluster **warm-primary** y haga click en  **Eliminar** bajo el botón **Acciones**.  **(Debe esperar hasta que la base de datos se elimine antes de eliminar el cluster)**.

{{< img cl-16-es.png >}}

2.6 Seleccione **No** para **Create final snapshot?**, y active **I acknowledge...**, luego haga click en **Delete DB cluster**.

{{< img cl-17.png >}}

{{% notice note %}}
Repita los pasos **2.2** a **2.4** para los siguientes recursos:  **(Debe esperar hasta que la base de datos primaria se elimine antes de ejecutar esto)**
- `warm-secondary cluster`
{{% /notice %}}

2.7 Seleccione **warm-global** y luego seleccione **Eliminar** bajo el botón **Acciones** y luego confirme el borrado.

{{< img cl-15-es.png >}}

{{% notice warning %}}
Espere a que todas las bases de datos y los clústeres terminen de eliminarse antes de pasar al siguiente paso.
{{% /notice %}}

#### Limpieza de la región secundaria en AWS CloudFormation

3.1 Navegue a [CloudFormation](https://us-west-1.console.aws.amazon.com/cloudformation/home?region=us-west-1#/) en la región **N. California (us-west-1)**.

3.2 Seleccione la pila **Warm-Secondary** y oprima **Eliminar**.

{{< img cl-8-es.png >}}

3.3 Oprima **Eliminar pila** para confirmar la eliminación.

{{< img cl-9-es.png >}}

{{% notice info %}}
Espere a que termine la eliminación de la pila antes de continuar con los siguientes pasos.
{{% /notice %}}

## Limpieza de la región primaria en AWS CloudFormation

4.1 Navegue a [CloudFormation](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/) en la región **N. Virginia (us-east-1)**.

4.2 Seleccione la pila **Warm-Primary**. Posteriormente oprima el botón **Eliminar** para eliminarla.

{{< img cl-6-es.png >}}

4.3 Oprima el botón **Eliminar pila** para confirmar su eliminación.

{{< img cl-7-es.png >}}

{{< prev_next_button link_prev_url="../4-verify-secondary/" title="Felicidades!" button_prev_text="Paso anterior" button_next_text="Complete este Laboratorio" final_step="true" >}}
Este laboratorio le ayuda especificamente con las mejores prácticas cubiertas en la pregunta [REL 13  Como planea para recuperación de desastres? (DR)](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-failure-management.html)
{{< /prev_next_button >}}

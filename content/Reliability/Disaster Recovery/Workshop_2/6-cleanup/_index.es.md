+++
title = "Limpiar recursos"
date =  2021-05-11T11:43:28-04:00
weight = 7
+++

{{% notice info %}}
Si ústed está haciendo éste workshop con un instructor y no en su cuenta personal, **No** tiene que completar ésta sección.
{{% /notice %}}

#### Limpieza de Amazon S3

1.1 Navegue a [S3](https://us-east-1.console.aws.amazon.com/s3/home?region=us-east-1#/).

1.2 Seleccione **pilot-primary-uibucket-xxxx** y oprima **Vaciar**.

{{< img cl-2-ES.png >}}

1.3 Escriba `eliminar de forma permanente` en la casilla de confirmación y oprima **Vaciar**.

{{< img cl-3-ES.png >}}

1.4 Cuando vea el banner verde en la parte superior diciendo que el bucket se vació, oprima **Salir**.

{{% notice note %}}
Por favor repitas los pasos **1.1** a **1.4** para los siguientes buckets:

- `pilot-secondary-uibucket-xxxx`

{{% /notice %}}

#### Limpieza de base de datos

{{% notice info %}}
Este paso es requerido ya que promovimos manualmente la base de datos Aurora.
{{% /notice %}}

2.1 Navegue a [RDS](https://us-west-1.console.aws.amazon.com/rds/home?region=us-west-1#databases:) en la región **N. California (us-west-1)**.

2.2 Seleccione la base de datos **unishop** bajo el cluster **pilot-secondary** y seleccione **Eliminar** abjo el menu de **Acciones**.

{{< img cl-11-ES.png >}}

2.3 Deseleccione la opción create a final snapshot?, seleccione la opción "I acknowledge". Escriba `delete me` y oprima el botón **Eliminar**. (No está traducido en la consola)

{{< img cl-12.png >}}

2.4 Cambie de región a **N. Virginia (us-east-1)** utilizando el selector de regiones en el menu superior de la derecha. Luego seleccione la base de datos **unishop** debajo del clúster **pilot-primary** y seleccione **Eliminar** bajo el menu de **Acciones**.

{{< img cl-14-ES.png >}}

2.5 Deseleccione la opción create a final snapshot?, seleccione la opción "I acknowledge". Escriba `delete me` y oprima el botón **Eliminar**. (No está traducido en la consola)

{{< img cl-12.png >}}

2.6 Seleccione **pilot-global**, seleccione **Eliminar** bajo el menu de **Acciones** y luego confirme la eliminación.

{{< img cl-15-ES.png >}}

{{% notice warning %}}
Espere a que la eliminación de la base de datos termine antes de continuar al siguiente paso.
{{% /notice %}}

#### Limpieze de EC2

3.1 Navegue a al consola de [EC2](https://us-west-1.console.aws.amazon.com/ec2/v2/home?region=us-west-1#Instances:instanceState=running)  en la región de **N. California (us-west-1)** region.

3.2 Seleccione la instancia **pilot-secondary** y oprima **Terminar instancia** bajo **Estado de instancia**.

{{< img cl-16-ES.png >}}

#### Limpieza de la región secundaria en CloudFormation

4.1 Navegue a [CloudFormation](https://us-west-1.console.aws.amazon.com/cloudformation/home?region=us-west-1#/) en la región **N. California (us-west-1)**.

4.2 Seleccione la pila **pilot-secondary** y oprima **Eliminar**.

{{< img cl-8-ES.png >}}

4.3 Oprima **Eliminar pila** para confirmar el borrado.

{{< img cl-9-ES.png >}}

#### Limpieza de la región primaria en CloudFormation

5.1 Navegue a [CloudFormation](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/) en la región **N. Virginia (us-east-1)**.

5.2 Seleccione la pila **pilot-primary**. Oprima el botón **Eliminar** para removerla.

{{< img cl-6-ES.png >}}

5.3 Oprima el botón **Eliminar pila** para confirmar el borrado.

{{< img cl-7-ES.png >}}

{{< prev_next_button link_prev_url="../5-verify-secondary/" title="¡Felicidades!" final_step="true" >}}
Este laboratorio ayuda le ayuda con las mejores prácticas cubiertas en la preguntas [REL 13  Como planear para recuperación de desastres (DR)](https://docs.aws.amazon.com/es_es/wellarchitected/latest/framework/a-failure-management.html)
{{< /prev_next_button >}}
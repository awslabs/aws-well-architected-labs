+++
title = "Limpiar recursos"
date =  2021-05-11T20:41:47-04:00
weight = 6
+++

#### Amazon S3

1.1 Oprima [S3](https://console.aws.amazon.com/s3/home?region=us-east-1#/) para ir a la consola.

1.2 Seleccione el bucket con el prefijo **backupandrestore-primary-uibucket-xxxx** y oprima el botón **Vaciar**.

{{< img cl-1-ES.png >}}

1.3 Escriba `eliminar de forma permamente` en la caja de confirmación y oprima **Vaciar**.

{{< img cl-3-ES.png >}}

1.4 Espere hasta que vea el banner verde a lo largo de la parte superior de la pantalla indicando que el bucket está vacio. Después oprima el botón **Salir**.

{{< img cl-4-ES.png >}}

{{% notice note %}}
Por favor repita los pasos **1.1** a **1.4** para los siguientes buckets:</br>
`backupandrestore-secondary-uibucket-xxxx`
{{% /notice %}}

#### Amazon CloudFormation

2.1 Oprima [CloudFormation](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/) para navegar a la consola en la región **N. Virginia (us-east-1)**.

2.2 Seleccione la pila **backupandrestore-primary** y oprima el botón **Eliminar**.

{{< img cl-8-ES.png >}}

2.3 Oprima el botón **Eliminar pila** para confirmar que se va a eliminar.

{{< img cl-9-ES.png >}}

{{% notice note %}}
Por favor repita los pasos **2.1** a **2.3** para la pila `backupandrestore-secondary` en la región secundaria **N. California (us-west-1)**.
{{% /notice %}}

#### AWS Backup

3.1 Oprima [AWS Backup](https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#/) para navegar a la consola en la región **N. Virginia (us-east-1)**.

3.2 Oprima **Almacenes de copia de seguridad** y selecciona **Default**.

{{< img BK-24-ES.png >}}

3.3 Seleccione todas las copias de seguridad y oprima **Acciones**, después oprima **Eliminar**.

{{< img BK-27-ES.png >}}

3.4 Oprima el botón **Confirmar**.

{{< img BK-28-ES.png >}}

{{% notice note %}}
Por favor repita los pasos **3.1** a **3.3** para [AWS Backup](https://us-west-1.console.aws.amazon.com/backup/home?region=us-west-1#/) en la región **N. California (us-west-1)**.
{{% /notice %}}

#### Amazon EC2

5.1 Oprima [EC2](https://us-west-1.console.aws.amazon.com/ec2/home?region=us-west-1#/) para navegar a la consola en la región **N. California (us-west-1)**.

5.2 Seleccione la instancia y oprima **Estado de la instancia**, después oprima **Terminar instancia**.

{{% notice note %}}
Si tiene más de una instancia corriendo puede verificar que está seleccionando la instancia correcta revisando el **nombre del grupo de seguridad** que debe ser **backupandrestore-secondary-EC2SecurityGroup-xxxx**.
{{% /notice %}}

{{< img CL-26-ES.png >}}

{{< prev_next_button link_prev_url="../disaster/modify-application/" title="Felicitaciones!" button_next_text="Complete este lab" button_prev_text="Paso anterior" final_step="true" >}}
Este laboratorio le ayuda a cumplir con las mejores prácticas cubiertas en la pregunta [REL 13  Como planeo para recuperación de desastres (DR)](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-failure-management.html)
{{< /prev_next_button >}}

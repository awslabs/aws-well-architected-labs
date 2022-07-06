+++
title = "EC2"
date =  2021-05-11T20:33:54-04:00
weight = 2
+++

#### Crear la AMI (Imagen de máquina de Amazon) de EC2

1.1 Oprima [EC2](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#Instances:instanceState=running) para navegar a la consola en la región **N. Virginia (us-east-1)**.

1.2 Seleccione **pilot-primary**. Oprima **Crear imagen** dentro del menú **Acciones -> Imagen y plantillas**

{{< img bk-2-ES.png >}}

1.3 Escriba `pilotAMI` en el encasillado **Nombre de la imagen** y luego oprima **Crear imagen**

{{< img bk-3-ES.png >}}

{{% notice warning %}}
La AMI debe mostrar estado **Disponible** antes de continuar al próximo paso. Puede demorar varios minutos.
{{% /notice %}}

#### Copiar la AMI (Imagen de máquina de Amazon) de EC2

2.1 Oprima [AMIs](https://us-east-1.console.aws.amazon.com/ec2/v2/home?region=us-east-1#Images:visibility=owned-by-me) para navegar a la consola.

2.2 Seleccione **pilotAMI**. Oprima **Copiar AMI** dentro del menú de **Acciones**.

{{< img bk-5-ES.png >}}

2.3 Escoja **US West (N. California)** como la  **Región de destino**.

{{< img bk-6-ES.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../../4-failover/" button_next_text="Siguiente paso" button_prev_text="Paso anterior" />}}

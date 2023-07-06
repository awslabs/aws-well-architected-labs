+++
title = "EC2"
date =  2021-05-11T11:43:28-04:00
weight = 2
+++

#### Lanzamiento de la instancia EC2 

1.1 Vaya a [CloudFormation Stacks](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/) en la región **Norte de California (us-west-1)**.

1.2 Selecciona la pila de **warm-secondary** y haz clic en **Actualizar**.

{{< img da-2-es.png >}}

1.3 Elija **Usar plantilla actual** y haga clic en **Siguiente** para continuar.

{{< img da-3-es.png >}}

1.4 Actualice el parámetro **isPromote** a **yes** y haga clic en **Siguiente** para continuar.

{{< img da-4-es.png >}}

1.5 Desplázate hasta el final de la página, haz clic en la casilla de verificación para confirmar la creación de los recursos de IAM y, a continuación, haz clic en **Actualizar pila**.

{{< img da-5-es.png >}}

#### Grupo de Auto Scaling (ASG)

La actualización de la plantilla de CloudFormation consistía en cambiar el grupo de Auto Scaling en la región secundaria **Norte de California (EE. UU. Oeste-1)** para **escalar** nuestra capacidad de EC2 para que coincidiera con nuestra región principal **Norte de Virginia (EE.UU. Este-1)**. De esta forma, sabemos que cuando se produce una conmutación por error, nuestra región secundaria puede gestionar el tráfico de solicitudes.

2.1 Vaya a [Grupos de Auto Scaling](https://us-west-1.console.aws.amazon.com/ec2/v2/home?region=us-west-1#AutoScalingGroups:) en la región **Norte de California (us-west-1)**.

2.2 Haga clic en el enlace **Warm-Secondary-WebServerGroup-XXX**.

{{< img asg-1-es.png >}}

2.3 Haz clic en el enlace **Actividad** y, a continuación, desplázate hacia abajo hasta la sección **Historial de actividades**. Debería ver el lanzamiento de nuevas instancias en respuesta a la actualización de CloudFormation.

{{< img asg-3-es.png >}}

{{< img asg-4-es.png >}}

{{< prev_next_button link_prev_url="../3.1-aurora" link_next_url="../../4-verify-secondary/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}


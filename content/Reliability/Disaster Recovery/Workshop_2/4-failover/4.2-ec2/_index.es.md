+++
title = "Promover la aplicación en la región secundaria"
date =  2021-05-11T11:43:28-04:00
weight = 4
+++

1.1 Navegue a [CloudFormation Stacks](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/) en la región **N. California (us-west-1)**.

1.2 Seleccione la pila **Pilot-Secondary** y oprima **Actualizar**.

{{< img da-2-ES.png >}}

1.3 Escoja **Usar plantilla actual** y oprima el botón **Siguiente**.

{{< img da-3-ES.png >}}

1.4 Actualice el parámetro **IsPromote** a `yes` y oprima **Siguiente**.

{{< img da-4-ES.png >}}

1.5 Desplacese al final de la página, oprima la casilla de confirmación para reconocer la creación de recursos IAM y oprima **Actualizar pila**.

{{< img da-5-ES.png >}}

{{< prev_next_button link_prev_url="../4.1-aurora" link_next_url="../../5-verify-secondary/"  button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}


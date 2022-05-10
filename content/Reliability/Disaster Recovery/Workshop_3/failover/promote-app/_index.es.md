+++
title = "Promover la aplicación en la región secundaria"
date =  2021-05-11T11:43:28-04:00
weight = 4
+++

1.1 Navegue a [CloudFormation Stacks](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/) en la región **N. California (us-west-1)**.

1.2 Seleccione la pila **Warm-Secondary** y oprima **Actualizar**.

{{< img da-2-es.png >}}

1.3 Esccoja la opción **Usar plantilla actual** y oprima el botón **Siguiente** para continuar.

{{< img da-3-es.png >}}

1.4 Actualice el parámetro **IsPromote** a `yes` y oprima **Siguiente** para continuar.

{{< img da-4-es.png >}}

1.5 Desplacese al fono de la página, oprima la casilla de verificación para aceptar la creación de recursos de IAM, y, posteriormente, oprima **Actualizar pila**.

{{< img da-5-es.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../promote-aurora/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}


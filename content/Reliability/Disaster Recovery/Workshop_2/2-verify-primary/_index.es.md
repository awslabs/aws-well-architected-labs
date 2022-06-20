+++
title = "Verificar página web"
date =  2021-05-11T11:43:28-04:00
weight = 3
+++

## Región primaria

1.1 Navegue a [CloudFormation Stacks](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/) en la región **N. Virginia (us-east-1)**.

1.2 Seleccione la pila **Pilot-Primary**.

1.3 Navegue a la pestaña **Salidas**.

{{< img vw-1.png >}}

1.4 Oprima en el link de salida **WebsiteURL**.

{{< img vw-2.png >}}

## Interactúe con la aplicación primaria (La aplicación está en inglés)

2.1 Registrese en la aplicación. Debe proveer su dirección e-mail, que no debe ser válida. Aun así, _asegúrese de recordar este valor_ para verificar la replicación de datos posteriormente.

{{< img vw-3.png >}}

2.2 Debe ver un mensaje de confirmación diciendo **Successfully Signed Up. You may now Login**.

2.3 Inicie sesión en la aplicación utilizando el mismo correo que en el anterior paso.

{{< img vw-4.png >}}

2.4 Añada/remueva objetos de su carrito de compras oprimiendo un Unicornio y posteriormente oprimiendo el botón **Add to cart**.

{{< img vw-5.png >}}

{{< prev_next_button link_prev_url="../1-prerequisites/" link_next_url="../3-prepare-secondary/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}

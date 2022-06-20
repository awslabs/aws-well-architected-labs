+++
title = "Verify Websites"
date =  2021-05-11T11:43:28-04:00
weight = 2
+++

## Región primaria

1.1 Navegue a [Pilas de CloudFormation](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/) en la región **N. Virginia (us-east-1)**.

1.2 Escoja la pila **Warm-Primary**

1.3 Navegue a la ventana **Salidas**.

{{< img vw-1-es.png >}}

1.4 Oprima en el link de salida **WebsiteURL**.

{{< img vw-2.png >}}

## Interactúe con la aplicación primaria (La aplicación está en Inglés)

2.1 Registrese en la aplicación. Debe proveer una dirección de correo, que no debe ser válida. Aún así, _asegúrese de recordarla_ para verificar la replicación de datos posteriormente.

{{< img vw-3.png >}}

2.2 Verá un mensaje de confirmación diciendo **Successfully Signed Up. You may now Login**.

2.3 Inicie sesión en la aplicación utilizando su dirección de correo del paso anterior.

{{< img vw-4.png >}}

2.4 Añada/remueva elementos de su carrito de compras oprimiendo un Unicornio, seguido por oprimir el botón **Add to cart**.

{{< img vw-5.png >}}

## Región secundaria

3.1 Navegue a [Pilas de CloudFormation](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/) en la región **N. California (us-west-1)**.

3.2 Escoja la pila **Warm-Secondary**.

3.3 Navegue a la pestaña **Salidas**.

{{< img vw-6-es.png >}}

3.4 Oprima el link de salida **WebsiteURL**.

{{< img vw-7.png >}}

## Interactúe con la aplicación secundaria

4.1 Inicie sesión en la aplicación utilizando su dirección de correo del paso anterior.

4.2 Intente añadir un nuevo objeto a su carrito. La aplicación web debería aumentar el número total de objetos en el carrito en la parte superior de la página.

{{< prev_next_button link_prev_url="../1-prerequisites/" link_next_url="../3-failover/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}


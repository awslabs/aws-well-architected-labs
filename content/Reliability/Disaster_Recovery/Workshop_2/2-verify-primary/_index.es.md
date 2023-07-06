+++
title = "Verificar página web"
date =  2021-05-11T11:43:28-04:00
weight = 3
+++

### Región primaria

1.1 Navegue a [CloudFormation Stacks](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/) en la región **N. Virginia (us-east-1)**.

1.2 Seleccione la pila **pilot-primary**.

1.3 Navegue a la pestaña **Salidas**.

{{< img vw-1.png >}}

1.4 Oprima en el link de salida **WebsiteURL** y abra en una nueva pestaña o ventana del navegador.

{{< img vw-2.png >}}

#### Inscripción
##### Interactúe con la aplicación primaria (La aplicación está en inglés)

2.1 Registrese en la aplicación. Debe proveer su dirección e-mail, que no tiene que ser válida. Aun así, **asegúrese de recordar este valor** para verificar la replicación de datos posteriormente.

{{< img vw-3.png >}}

2.2 Debe ver un mensaje de confirmación diciendo **Successfully Signed Up. You may now Login**.

{{< img vw-4.png >}}

2.3 Inicie sesión en la aplicación oprimiendo el link **Login** en el menú superior, utilizando el mismo correo que en el paso anterior. Note que la página web está siendo servida desde la región principal **N. Virginia (us-east-1)**.

{{< img vw-6.png >}}

2.4 Añada/remueva objetos de su carrito de compras oprimiendo un Unicornio y posteriormente oprimiendo el botón **Add to cart**. Verifique que el contador se actualice con la cantidad de objetos en el carrito.

{{< img vw-5.png >}}

### Región secundaria

La región secundaria no debe estar disponible. En una estrategia de DR _pilot light_ no hay recursos computacionales en la región secundaria.

3.1  Navegue a [CloudFormation Stacks](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/) en la región **N. California (us-west-1)**.

3.2 Seleccione la pila **pilot-secondary**.

3.3 Navegue a la pestaña **Salidas**.

{{< img vw-7-ES.png >}}

3.4 Haga click en el enlace **WebsiteURL** ubicado en el sección de Salidas y abra en una nueva pestaña o ventana del navegador.

{{< img vw-8-ES.png >}}

3.5 La página debe mostrar un error.

{{< img vw-9.png >}}

{{< prev_next_button link_prev_url="../1-prerequisites/" link_next_url="../3-prepare-secondary/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}

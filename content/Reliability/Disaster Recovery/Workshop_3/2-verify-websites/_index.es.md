+++
title = "Verifique los sitios Web"
date =  2021-05-11T11:43:28-04:00
weight = 2
+++

## Región primaria

1.1 Navegue a [Pilas de CloudFormation](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/) en la región **N. Virginia (us-east-1)**.

1.2 Escoja la pila **Warm-Primary**

1.3 Navegue a la ventana **Salidas**.

{{< img vw-1-es.png >}}

1.4 Abra el link de salida **WebsiteURL** en una nueva pestaña o ventana del navegador.

{{< img vw-2.png >}}

## Registro en la aplicación (La aplicación está en Inglés)

2.1 Regístrese en la aplicación mediante el enlace **Signup** en el menú superior. Debes proporcionar una dirección de correo electrónico, que no necesita ser válida. Sin embargo, **asegúrese de recordarla**, ya que lo necesitará para verificar la replicación de datos más adelante.

{{< img vw-3.png >}}

2.2 Verá un mensaje de confirmación diciendo **Successfully Signed Up. You may now Login**.

2.3 Inicie sesión en la aplicación mediante el enlace **Login** en el menú superior y utilice su dirección de correo electrónico del paso anterior. Observe también que el sitio web se aloja en su región principal **Norte de Virginia (us-east-1)**

{{< img vw-4.png >}}

2.4 Agregue artículos a su carrito de compras, verificando que el recuento total de artículos del carrito que se muestra en la parte superior de la página esté aumentando.

{{< img vw-5.png >}}

### Región secundaria

Estamos aprovechando el [envío de escritura a réplicas de lectura](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/ aurora-global-database-write-forwarding.html)  de Amazon Aurora. Con esta función habilitada, las escrituras se pueden enviar a una réplica de lectura en una región secundaria y se reenviarán sin problemas al escritor de la región principal a través de un canal de comunicación seguro. Se considera una práctica recomendada habilitar el reenvío de escritura en la región secundaria para la estrategia de recuperación ante desastres en espera semi-activa con fines de prueba.

3.1 Navegue a [Pilas de CloudFormation](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/) en la región **N. California (us-west-1)**.

3.2 Escoja la pila **Warm-Secondary**.

3.3 Navegue a la pestaña **Salidas**.

{{< img vw-6-es.png >}}

3.4 Oprima el link de salida **WebsiteURL**.

{{< img vw-7.png >}}

3.5 Inicie sesión en la aplicación mediante el enlace **Login** en el menú superior, utilice su correo electrónico del **Paso 2.1** anterior.

3.6 Debería ver el mismo número de artículos en el carrito que en el anterior **Paso 2.4**. Tenga en cuenta también que el sitio web se aloja en su región secundaria **Norte de California (us-west-1)**

{{< img vw-8.png >}}

3.7 Agregue artículos adicionales a su carrito y vea el aumento en el total de artículos del carrito que se muestra en la parte superior de la página.

{{< img vw-9.png >}}

3.8 Regrese al sitio web de su región principal. Si ya la tiene abierta, actualice la ventana del navegador; de lo contrario, sigue los pasos anteriores en la sección **Región principal**. Debería ver el aumento del total del carrito en tu región principal **Norte de Virginia (us-east-1)**.

{{< img vw-10.png >}}

{{< prev_next_button link_prev_url="../1-prerequisites/" link_next_url="../3-failover/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}


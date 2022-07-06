+++
title = "Verificar Failover"
date =  2021-05-11T11:43:28-04:00
weight = 6
+++

#### Región Secundaria

1.1 Navegue a [CloudFormation Stacks](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/) en la región **N. California (us-west-1)**.

1.2 Escoja la pila **pilot-secondary**.

1.3 Navegue a la pestaña **Salidas**.

{{< img vf-2-es.png >}}

1.4 Oprima el link de salida **WebsiteURL** y abra en una nueva pestaña o ventana del navegador.

{{% notice note %}}
Si no ve la página web de Unishop con todos los productos, puede ser debido a que la instancia EC2 aún no termina de correr el script para inicializarla. Continúe refrescando la página hasta que vea la página de Unishop con todos sus productos.
{{% /notice %}}

#### Verifique la página web

2.1 Inicie sesión en la aplicación. Debe proveer el email registrado de la sección **Pre-requisitos > Región Primaria**.

2.2 Debería ver objetos en su carrito de compras que añadió desde su región primaria **N. Virginia (us-east-1)**.

{{< img vf-1.png >}}

{{< prev_next_button link_prev_url="../4-failover/4.2-ec2/" link_next_url="../6-cleanup"  />}}
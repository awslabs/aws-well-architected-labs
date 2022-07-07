+++
title = "Failover a secundaria"
date =  2021-05-11T11:43:28-04:00
weight = 7
+++

Cuando un evento regional de servicio afecta la aplicación en su región primaria **N. Virginia (us-east-1)**, usted querrá hacer fail-over hacia la región segundaria, **N. California (us-west-1)**.

Asumiremos que ocurrió un evento regional de servicio. En esta sección, haremos el fail over de forma manual de la aplicación a la región secundaria, **N. California (us-west-1)**. La distribución de CloudFront detectará la interrupción de servicio y automáticamente empezará a enrutar peticiones de la página web **Primary-Active** a la página web **Passive-Secondary** de forma transparente.

Antes de simular el desastre, debemos crear datos de prueba a lo largo de la aplicación web. Este paso requiere crear una cuenta en la tienda, para después añadir objetos al carrito de compras. Tras el desastre, la sesión del usuario debe permanecer activa e ininterrumpida.

### Cree y llene el carrito de compras

1.1 Navegue al **Nombre de dominio de CloudFront** utilizando su navegador preferido.

{{% notice info %}}
Si no tiene su **Nombre de dominio de CloudFront**, puede recuperarlo en el **Paso 4.2** en la sección **Configurar CloudFront**.
{{% /notice %}}

1.2 Oprima el botón **Signup**.



1.3 Registrese en su aplicación. Debe proveer una dirección de correo electrónico, que no debe ser válida.



1.4 Inicie sesión en la aplicación utilizando el correo electrónico del anterior paso.



1.5 Añada/remueva objetos de su carrito de compras oprimiendo un Unicornio, y, posteriormente, oprima el botón **Add to cart**.

### Simulando un evento regional de interrupción de servicio

Ahora, simularemos un evento regional de interrupción de servicio que afecte el sitio web estático de S3 en la región **N. Virginia (us-east-1)** que aloja la tienda virtual.

2.1 Oprima [S3](https://console.aws.amazon.com/s3/home?region=us-east-1#/) para navegar a la consola.

2.2 Oprima el link de bucket cuyo nombre empieza con **active-primary-uibucket-** .

{{< img c-9-es.png >}}

2.3 Oprima el link **Permisos**. En la sección **Bloquear acceso público (configuración de bucket)**, oprima el botón **Editar**.

{{< img d-6-es.png >}}

2.4 Habilite la casilla de verificación **Bloquear todo el acceso público**, después oprima el botón **Guardar cambios**.

{{< img d-7-es.png >}}

2.5 Escriba `confirmar`, después oprima el botón **Confirmar**.

{{< img d-8-es.png >}}

{{% notice info %}}
El bucket de Amazon S3 que aloja la página web Primary-Active es inaccesible ahora. Cuando CloudFront intente enrutar las peticiones de los usuarios a esta instancia, recibirá un error HTTP 403 (Forbidden). La distribución manejará automáticamente este escenario haciendo un failover a la instancia Passive-Secondary.
{{% /notice %}}

{{< prev_next_button link_prev_url="../setup-cloudfront/" link_next_url="./promote-aurora/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}


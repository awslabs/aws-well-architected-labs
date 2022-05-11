+++
title = "Configuración de CloudFront"
date =  2021-05-11T11:43:28-04:00
weight = 6
+++

{{% notice note %}}
Este servicio no se encuentra traducido al español en la consola de AWS.
{{% /notice %}}

Puede mejorar su resiliencia y aumentar su disponibilidad para escenarios específicos configurando CloudFront en failover de origen. Para iniciar, puede crear un grupo de origen en el cual designará un origen primario para CloudFront junto a uno secundario. CloudFront cambiará automáticamente al segundo origen cuando el primer origen retorne un código HTTP específico de fallo.

Configuraremos CloudFront con un failover de origen en los siguientes pasos usando el sitio web **active-primary-uibucket-xxx** alojado en S3 como nuestro origen primario y nuestro sitio web **passive-secondary-uibucket-xxxx** alojado en S3 como nuestro origen de failover.

{{% notice note %}}
Necesitará los valores de los parámetros de salida de Amazon CloudFormation de las pilas **Primary-Active** y **Passive-Secondary** para completar esta sección. Para ayuda sobre este paso, revise la sección [Salidas de CloudFormation](../prerequisites/cfn-outputs/) del taller.
{{% /notice %}}

### Crear la distribución en Amazon CloudFront

1.1 Oprima [CloudFront](https://console.aws.amazon.com/cloudfront/home?region=us-east-1#/) para navegar a la consola.

1.2 Oprima el botón **Create a CloudFront distribution**.

{{< img cf-16.png >}}

{{% notice warning %}}
En el paso 1.3, **NO** escoja el bucket de S3 **active-primary-uibucket-xxxx** en el menú desplegable para el **Origin Domain**. La distribución de CloudFront no funcionará si hace esto.
{{% /notice %}}

1.3 Introduzca el valor de la salida **WebsiteURL** de la plantilla de CloudFormation **Active-Primary** como el **Origin Domain**.

{{< img cf-17.png >}}

Uno de los propósitos de usar CloudFront es reducir el número de peticiones que debe responder directamente su servidor de origen. Con el cache de CloudFront, más objetos son entregados desde las ubicaciones de borde de CloudFront, que están más cerca a sus usuarios. Esto reduce la carga de su servidor de origen y reduce la latencia. Para más información, vea (En inglés) [Amazon CloudFront Optimizing caching and availability](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/ConfiguringCaching.html). En producción, los clientes típicamente quieren usar el valor predeterminado **CachingOptimized**.  

{{% notice warning %}}
La siguiente sección **Failover a Secundaria**, no funcionará si no completa el paso 1.4.
{{% /notice %}}

1.4 En la sección **Cache Key and origin requests**, seleccione **CachingDisabled** para la **Política de cache** para deshabilitar el cache de CloudFront. 

{{< img cf-18.png >}}

1.5 Oprima el botón **Create distribution**.  

{{< img cf-27.png >}}

### Configure un origen adicional 

Ahora adicionaremos un **Origen** adicional y utilizaremos nuestro bucket **secondary-passive-uibucket-xxxx**.

2.1 Oprima el link **Origins**, después oprima el botón **Create origin**.

{{< img cf-19.png >}}

{{% notice warning %}}
En el paso 2.2, **NO** escoja el bucket de S3 **passive-secondary-uibucket-xxxx** en el menú desplegable para el **Dominio de Origen**. La distribución de CloudFront no funcionará si hace esto.
{{% /notice %}}

2.2 Introduzca el valor de la salida **WebsiteURL** de la plantilla de CloudFormation **Passive-Secondary** como el **Origin domain**.

{{< img cf-20.png >}}

### Configure el grupo de origen

3.1 Oprima el link **Create origin group**.

{{< img cf-21.png >}}

3.2 Seleccione **active-primary-uibucket-xxxx** como **Origins**, después oprima el botón **Add**.

{{< img cf-28.png >}}

3.3 Seleccione **passive-secondary-uibucket-xxxx** como **Origins**, después oprima el botón **Add**.

{{< img cf-29.png >}}

3.4 Introduzca `hot-standby-origin-group` como el **Name**.  Habilite todas las casillas de verificación para los **Failover criteria**, después oprima **Create origin group**.

{{< img cf-30.png >}}

### Configure comportamientos

4.1 Oprima el link **Behaviors**.  Seleccione **Default (*)**, después oprima el botón **Edit** .

{{< img cf-23.png >}}

4.2 Seleccione **hot-standby-origin-group** como el **Origin and origin groups**.

{{< img cf-24.png >}}

4.3 Oprima el botón **Save changes**.

{{< img cf-31.png >}}

4.4 Oprima el link **Distributions**.

4.5 Espere que el **Status** aparezca como **Enabled** y para que el parámetro **Last modified** tenga una fecha.

{{< img cf-25.png >}}

### Verifique la distribución

5.1 Copie el **Domain name** de la distribución de CloudFront en una nueva pestaña del navegador.

{{< img cf-26.png >}}

5.2 Confirme que el encabezado de la página dice **The Unicorn Shop - us-east-1**.

{{< img cf-14.png >}}

#### Felicitaciones!  Su distribución de CloudFront está funcionando!

{{< prev_next_button link_prev_url="../verify-websites/" link_next_url="../disaster/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}


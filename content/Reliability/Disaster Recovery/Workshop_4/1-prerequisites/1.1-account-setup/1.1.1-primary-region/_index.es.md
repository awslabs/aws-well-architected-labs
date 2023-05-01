+++
title = "Región primaria"
date =  2021-05-11T11:43:28-04:00
weight = 2
+++

### Despliegue de la plantilla de CloudFormation

1.1 Despliegue la aplicación en la región primaria **N. Virginia (us-east-1)** lanzando esta [Plantilla de CloudFormation](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/template?stackName=hot-primary&templateURL=https://ee-assets-prod-us-east-1.s3.amazonaws.com/modules/7ebe40ac15b94a1e815828a877bde9b3/v10/HotStandby.yaml).

1.2  Especifique los parámetros de pila.

{{% notice info %}}
**Deje los valores predeterminados para isPrimary y LatestAmiId**
{{% /notice %}}

1.3 Oprima **Siguiente** para continuar.

{{< img pr-4-es.png >}}

1.4 Deje los valores predeterminados en la página **Configurar opciones de pila** y oprima **Siguiente** para continuar.

1.5 Desplacedse al fondo de la página y oprima la **casilla de verificación** para aceptar la creación de recursos de IAM, posteriormente oprima **Crear pila**.
1.5 Desplacese al fondo de la página y oprima la **casilla de verificación** para aceptar la creación de recursos de IAM, posteriormente oprima **Crear pila**.

{{< img pr-5-es.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../1.1.2-secondary-region" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}


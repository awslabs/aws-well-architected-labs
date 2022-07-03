+++
title = "Región secundaria"
date =  2021-05-11T11:43:28-04:00
weight = 3
+++

## Deploying the Amazon CloudFormation Template

1.1 Cree la aplicación en la región secundaria **N. California (us-west-1)** lanzando una [Plantilla de CloudFormation](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/create/template?stackName=Warm-Secondary&templateURL=https://ee-assets-prod-us-east-1.s3.amazonaws.com/modules/7ebe40ac15b94a1e815828a877bde9b3/v7/WarmStandbyDR.yaml).

1.2  Especifíque los detalles de la pila.

Cambie el parámetro **IsPrimary** al valor de `no`.

{{% notice info %}}
**Deje IsPromote and LatestAmiId con sus valores predeterminados**
{{% /notice %}}

1.3 Oprima el botón **Siguiente** para continuar.

{{< img sr-4-es.png >}}

1.4 Deje los valores predeterminados en la página **Configurar opciones de pila** y oprima **Siguiente**.

1.5 Desplacese al fondo de la página y oprima la **casilla de verificación** para confirmar el entendimiento de que se creará un rol de IAM, después oprima **Crear stack**.

{{< img sr-5-es.png >}}

{{% notice info %}}
**Espere que termine la creación de la pila**.
{{% /notice %}}

{{< img sr-6.png >}}

{{< prev_next_button link_prev_url="../1.1.2-s3-access/" link_next_url="../../../2-verify-websites/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}
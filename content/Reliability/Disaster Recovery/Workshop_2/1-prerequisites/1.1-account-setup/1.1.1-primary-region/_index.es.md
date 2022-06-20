+++
title = "Región primaria"
date =  2021-05-11T11:43:28-04:00
weight = 2
+++

## Desplegando la plantilla de Amazon CloudFormation

1.1 Crear la aplicación en la región primaria **N. Virginia (us-east-1)** lanzando la [Plantilla de CloudFormation](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/template?stackName=Pilot-Primary&templateURL=https://ee-assets-prod-us-east-1.s3.amazonaws.com/modules/630039b9022d4b46bb6cbad2e3899733/v1/PilotLightDR.yaml).

1.2  Especifíque los detalles de la pila.

{{% notice info %}}
**Deje IsPrimary, IsPromote, and LatestAmiId con los valores predeterminados**
{{% /notice %}}

1.3 Oprima **Siguiente** para continuar.

{{< img pr-4-ES.png >}}

1.4 Deje los valores predeterminados en la página **Configurar opciones de pila** y oprima **Siguiente**.

1.5 Desplacese al fondo de la página y oprima la **casilla de verificación** para confirmar el entendimiento de que se crearán recursos de IAM, después oprima **Crear pila**.

{{< img pr-5-ES.png >}}

{{% notice info %}}
**Espere que la creación de la pila termine.**
{{% /notice %}}

{{< img pr-6-ES.png >}}

{{< prev_next_button link_prev_url="../../1.1-account-setup" link_next_url="../1.1.2-s3/"  button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}


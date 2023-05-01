+++
title = "Región primaria"
date =  2021-05-11T11:43:28-04:00
weight = 2
+++

#### Desplegando la plantilla de CloudFormation

1.1 Cree la aplicación en la región primaria **N. Virginia (us-east-1)** lanzando esta [Plantilla de CloudFormation](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/template?stackName=backupandrestore-primary&templateURL=https://ee-assets-prod-us-east-1.s3.amazonaws.com/modules/7ebe40ac15b94a1e815828a877bde9b3/v10/BackupAndRestore.yaml).

1.2 Oprima el botón **Siguiente**.

{{< img CF-1-ES.png >}}

1.3 Oprima el botón **Siguiente**.

{{% notice info %}}
**Deje LatestAmiId como los valores predeterminados**
{{% /notice %}}

{{< img CF-2-ES.png >}}

1.4 Oprima el botón **Siguiente**.

{{< img CF-3-ES.png >}}

1.5 Baje hasta el fondo de la página y **habilite** la casilla de verificación **Conozco que AWS podría crear recursos de IAM con nombres personalizados**, después oprima el botón **Crear pila**.

{{< img pr-5-ES.png >}}

{{% notice info %}}
**Espere a que termine la creación de la pila.**
{{% /notice %}}

{{< img cf-8-ES.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../1.1.2-secondary-region" button_next_text="Siguiente paso" button_prev_text="Paso anterior" />}}

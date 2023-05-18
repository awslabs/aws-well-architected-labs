+++
title = "Región secundaria"
date =  2021-05-11T11:43:28-04:00
weight = 3
+++

## Desplegando la plantilla de Amazon CloudFormation

1.1 Cree la aplicación en la región secundaria **N. California (us-west-1)** desplegando la [Plantilla de CloudFormation](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/create/template?stackName=backupandrestore-secondary&templateURL=https://ee-assets-prod-us-east-1.s3.amazonaws.com/modules/7ebe40ac15b94a1e815828a877bde9b3/v10/BackupAndRestoreDB.yaml).

1.2 Oprima el botón **Siguiente**.

{{< img sr-1.png >}}

1.3 Oprima el botón **Siguiente**.

{{% notice info %}}
**Deje LatestAmiId con el valor predeterminado**
{{% /notice %}}

{{< img sr-2.png >}}

1.4 Oprima el botón **Siguiente**.

{{< img cf-3.png >}}

1.5 Desplacese hasta el final de la página y **habilite** la casilla **Conozco que AWS podría crear recursos de IAM con nombres personalizados**, después oprima el botón **Crear pila**.

{{< img pr-5.png >}}

{{% notice warning %}}
Debe esperar a que la pila **BackupAndRestore Primary Region** tenga un estado de **Completado** antes de seguir al siguiente paso. Esto tomará 15 minutos aproximadamente.
{{% /notice %}}

{{< prev_next_button link_prev_url="../1.1.1-primary-region/" link_next_url="../1.1.3-iam-role/" />}}
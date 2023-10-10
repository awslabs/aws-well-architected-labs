+++
title = "Replicación entre regiones de S3"
date =  2021-05-11T20:33:54-04:00
weight = 2
+++

### Verifique los buckets de S3

{{% notice info %}}
Como parte de la plantilla de CloudFormation, se crearon buckets de Amazon S3 en la región primaria y secundaria.
{{% /notice %}}

1.1 Oprima [Amazon S3](https://s3.console.aws.amazon.com/s3/home) para navegar a la consola.

1.2 Los dos buckets de S3 tienen el prefijo `backupandrestore-`. Note la región para cada bucket de S3.

{{< img crr-1-es.png >}}

### Cree la regla de replicación

2.1 Oprima el link de **backupandrestore-primary-uibucket-xxxx**.

{{< img crr-2-es.png >}}

2.2 Oprima el link **Administración**. En la sección **Regla de replicación**, oprima el botón **Crear regla de replicación**.

{{< img crr-3-es.png >}}

2.3 Escriba `PrimaryToSecondary` como el **Nombre de la regla de replicación** y seleccione **Aplicar a todos los objetos del bucket**.

{{< img crr-4-es.png >}}

2.4 Seleccione **Elegir un bucket en esta cuenta** y después selecionne **backupandrestore-secondary-uibucket-xxxx** como el **Nombre del Bucket**. Seleccione **Team Role** como el **rol de IAM**.

{{< img crr-5-es.png >}}

2.5 Habilite la casilla **Control de tiempo de replicación (RTC)**, después oprima el botón **Guardar**.

{{< img crr-6-es.png >}}

2.6 El bucket está (casi) vacio y no se quiere replicar los objetos existentes, oprima el botón **Enviar**.

{{< img crr-7-es.png >}}

### Replicación del bucket de S3

{{% notice info %}}
Se hará una copia **manual** de los objetos al bucket **backupandrestore-primary-uibucket-xxxx** en la **región primaria** para poder observar la replicación al bucket **backupandrestore-secondary-uibucket-xxxx** en la **región secundarian**.
En un ambiente de producción, estos pasos de automatizarion como parte del pipeline de CI/CD.
{{% /notice %}}

3.1 Oprima [AWS Cloudshell](https://us-east-1.console.aws.amazon.com/cloudshell/home?region=us-east-1) para navegar a la consola en la región **N. Virginia (us-east-1)**.

3.2 Si nunca ha utilizado CloudShell, se mostrará un mensaje de **Bienvenida a AWS CloudShell**, oprima el botón **Cerrar**.

3.3 En la ventana emergente - pegue el siguiente comando de la CLI de AWS. Se mostratá el mensaje **Safe Paste for multiline text**, oprima el botón **Paste**.

```sh
export S3_BUCKET=$(aws s3api list-buckets --region us-east-1 --output text --query 'Buckets[?starts_with(Name, `backupandrestore-primary-uibucket`) == `true`]'.Name)
aws s3 cp s3://ee-assets-prod-us-east-1/modules/630039b9022d4b46bb6cbad2e3899733/v1/UniShopUI/ s3://$S3_BUCKET/ --exclude "config.json" --recursive 
```

### Verificación de la replicación

4.1 Oprima el link **backupandrestore-secondary-uibucket-xxxx**.

{{< img crr-8-es.png >}}

4.2 Debería ver los objetos replicados.

{{< img crr-9-es.png >}}

{{% notice info %}}
Puede tomar un par de minutos en reflejarse los objetos replicados.
{{% /notice %}}

{{< prev_next_button link_prev_url="../1-prerequisites/" link_next_url="../3-verify-primary/" />}}
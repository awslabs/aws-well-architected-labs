+++
title = "Configurar páginas web"
date =  2021-05-11T11:43:28-04:00
weight = 4
+++

### Configure the Active-Primary Website

{{% notice note %}}
Necesitará los valores de los parámetros de salidas de la pila **Active-Primary** para completar esta sección.  Para ayuda en esto, refierase a [Salidas de CloudFormation](../prerequisites/cfn-outputs/) en la sección **Región primaria** de este taller.
{{% /notice %}}

{{< img pr-6-es.png >}}

1.1 Utilizando su editor favorito, cree un nuevo archivo llamado `config.json`. Inicialize el documento como la plantilla entregada más abajo. Ahora, establezca la propieda **host** com el valor de salida **APIGURL** de la pila **Active-Primary** de CloudFormation.  Remueva el backslash (`/`) si hay uno presente. Remueva los corchetes. Finalmente, estableza la propiedad **region** como `us-east-1`.

```json
{
    "host": "{{Replace with your APIGURL copied from above}}",
    "region": "us-east-1"
}
```

Su **config.json** final debe verse similar al siguiente.

```json
{
    "host": "https://xxxxxxxx.execute-api.us-east-1.amazonaws.com/Production",
    "region": "us-east-1"
}
```

### Cargue la configuración a Amazon S3

2.1 Oprima [S3](https://us-east-1.console.aws.amazon.com/s3/home?region=us-east-1#/) para navegar a la consola.

2.2 Oprima sobre el link del bucket que empieza de la siguiente forma **active-primary-uibucket-** .

{{< img pc-9-es.png >}}

2.3 Oprima el botón **Cargar**.

{{< img pc-11-es.png >}}

2.4 Oprima el botón **Añadir archivos** y especifíque el archivo **config.json** del paso anterior.

{{< img pc-12-es.png >}}

2.5 En la sección **Permissions Section**. Seleccione el botón **Especificar permisos ACL Individuales**.  Habilite la casilla de verificación **Lectura** frente a **Todos (acceso público)**.

{{< img pc-13-es.png >}}

2.6 Habilite la casilla de verificación **Entiendo los efectos de estos cambios en los objetos especificados.**.  Oprima el botón **Cargar**.

{{< img pc-14-es.png >}}

### Configure la página web pasiva-secundaria

{{% notice note %}}
Necesitará los valores de los parámetros de salidas de la pila **Passive-Secondary** para completar esta sección.  Para ayuda en esto, refierase a [Salidas de CloudFormation](../prerequisites/cfn-outputs/) en la sección **Secondary Region** de este taller.
{{% /notice %}}

{{< img sr-6-es.png >}}

Utilizando su editor favorito, cree un nuevo archivo llamado `config.json`. Inicialize el documento como la plantilla entregada más abajo. Ahora, establezca la propieda **host** com el valor de salida **APIGURL** de la pila **Passive-Secondary** de CloudFormation.  Remueva el backslash (`/`) si hay uno presente. Remueva los corchetes. Finalmente, estableza la propiedad **region** como `us-west-1`. `us-west-1`.

```json
{
    "host": "{{Replace with your APIGURL copied from above}}",
    "region": "us-west-1"
}
```

YSu **config.json** final debe verse similar al siguiente.

```json
{
    "host": "https://xxxxxxxx.execute-api.us-west-1.amazonaws.com/Production",
    "region": "us-west-1"
}
```

### Cargue la configuración a Amazon S3

4.1 Oprima [S3](https://us-east-1.console.aws.amazon.com/s3/home?region=us-east-1#/) para navegar a la consola.

4.2 Oprima el bucket cuyo nombre empieza con **passive-secondary-uibucket-**.  

{{< img c-14-es.png >}}

4.3 Oprima el botón **Cargar**.

{{< img c-9-es.png >}}

2.4 Oprima el botón **Añadir archivos** y especifíque el archivo **config.json** del paso anterior.

{{< img c-11-es.png >}}

2.5 En la sección **Permissions Section**. Seleccione el botón **Especificar permisos ACL Individuales**.  Habilite la casilla de verificación **Lectura** frente a **Todos (acceso público)**.

{{< img c-12-es.png >}}

2.6 Habilite la casilla de verificación **Entiendo los efectos de estos cambios en los objetos especificados.**.  Oprima el botón **Cargar**.

{{< img c-13-es.png >}}

{{< prev_next_button link_prev_url="../verify-aurora-writefwd/" link_next_url="../verify-websites/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}
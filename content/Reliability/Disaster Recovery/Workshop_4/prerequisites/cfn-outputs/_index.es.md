+++
title = "Salidas de CloudFormation"
date =  2021-05-11T11:43:28-04:00
weight = 2
+++

### Guardando los valores de salida de la plantilla de Cloudformation

#### Región primaria

1.1 Oprima [Pilas de CloudFormation](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/) para navegar a la consola en la región **N. Virginia (us-east-1)**.

1.2 Seleccione **Active-Primary**.

1.3 Espere a que el estatus de la creación de la pila se reporte como **CREATE_COMPLETE**.  Después oprima el link **Salidas** y guarde los valores de las salidas **APIGURL**, **WebsiteURL**, y **WebsiteBucket**. Necesitará estos para completar futuros pasos.

{{< img pr-6.png >}}

#### Región secundaria.

2.1 Oprima [Pilas de CloudFormation](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/) tpara navegar a la consola en la región **N. California (us-west-1)**.

2.2 Seleccione **Passive-Secondary**.

2.3 Espere a que el estatus de la creación de la pila se reporte como **CREATE_COMPLETE**.  Después oprima el link **Salidas** y guarde los valores de las salidas **APIGURL**, **WebsiteURL**, y **WebsiteBucket**. Necesitará estos para completar futuros pasos.

{{< img sr-6.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../../dynamodb-global/" />}}


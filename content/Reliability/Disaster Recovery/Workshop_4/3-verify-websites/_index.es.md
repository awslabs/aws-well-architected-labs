+++
title = "Verificar las páginas web"
date =  2021-05-11T11:43:28-04:00
weight = 5
+++

### Verifique la página web Active-Primaria

{{% notice warning %}}
**Todas las modificaciones a recursos deben ser terminadas antes de continuar a esta sección.**
{{% /notice %}}

{{% notice note %}}
Necesitará los valores de los parámetros de salida de Amazon CloudFormation de la pila **Primary-Active** para completar esta sección. Para ayuda sobre este paso, revise la sección [Salidas de CloudFormation](../prerequisites/cfn-outputs/) del taller.
{{% /notice %}}

{{< img pr-6-es.png >}}

1.1 Copie la URL de **WebsiteURL** en una pestaña del navegador.

1.2 Verifique que el encabezado dice **The Unicorn Shop - us-east-1**.

{{< img vw-5.png >}}

### Verify the Passive-Secondary Website

{{% notice note %}}
Necesitará los valores de los parámetros de salida de Amazon CloudFormation de las pila **Passive-Secondary** para completar esta sección. Para ayuda sobre este paso, revise la sección [Salidas de CloudFormation](../prerequisites/cfn-outputs/) del taller.

{{% /notice %}}

{{< img sr-6-es.png >}}

2.1 Copie el valor de la url **WebsiteURL** en una pestaña del navegador.

2.2 Verifique que el encabezado dice **The Unicorn Shop - us-west-1**.

{{< img vw-6.png >}}

{{< prev_next_button link_prev_url="../configure-websites/" link_next_url="../setup-cloudfront/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}


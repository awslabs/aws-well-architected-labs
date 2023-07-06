+++
title = "Verificar la región primaria"
date =  2021-05-11T11:33:17-04:00
weight = 3
+++

### Verificar la página de la región primaria

Ahora, verifique que todo está funcionando como se esperar en la región primaria **N. Virginia (us-east-1)**. La página web Unishop está siendo alojada como un sitio web estático en un bucket de S3.

1.1 Oprima [Pilas de CloudFormation](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/) para navegar a la consola en la región **N. Virginia (us-east-1)**.

1.2 Seleccione **backupandrestore-primary** bajo la opción **Pilas**.

1.3 Oprima en el link **Salidas**.

{{< img cf-9-es.png >}}

1.4 Oprima en el link **WebsiteURL**. Verá **The Unicorn Shop - us-east-1**.

{{< img vf-2.png >}}

{{< prev_next_button link_prev_url="../2-s3-crr/" link_next_url="../4-prepare-secondary/" />}}
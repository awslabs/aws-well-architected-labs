+++
title = "Copiar"
date =  2021-05-11T20:33:54-04:00
weight = 3
+++

Ahora, copiará los recursos a la región secundaria **N. California (us-west-1)**.

###  Copiar la copia de respaldo de EC2

1.1 Oprima el link **Almacenes de copia de seguridad**, después oprima el link **Default**.

{{< img cp-1.png >}}

1.2 En la sección **Backups**. Seleccione la copia de respaldo de EC2. Oprima **Copiar** bajo el menú desplegable **Acciones**.

{{% notice warning %}}
Si no ve su copia de respaldo, revise el estado del **trabajo de copia de seguridad**. Oprima el link **Trabajos**. después oprima el link **Trabajos de copia de seguridad**. Verifique que el estado de su copia de seguridad de EC2 sea **Completado**
{{% /notice %}}

{{< img cp-4.png >}}

1.3 Seleccione **US West (N. California)** como **Copiar en el destino**, después seleccione **Escoger rol de IAM** y seleccione **Team Role** como el **nombre de rol**. Oprima el botón **Copiar**.

{{< img cp-5.png >}}

1.4 Esto creará un **Trabajo de copiado**.

### Copy the RDS backup

2.1 Oprima el link **Almacenes de copia de seguridad**, después oprima el link **Default**.

{{< img cp-1.png >}}

2.2 En la sección **Backups**. Seleccione la copia de respaldo de RDS. Oprima **Copiar** bajo el menú desplegable **Acciones**.

{{% notice warning %}}
Si no ve su copia de respaldo, revise el estado del **trabajo de copia de seguridad**. Oprima el link **Trabajos**. después oprima el link **Trabajos de copia de seguridad**. Verifique que el estado de su copia de seguridad de RDS sea **Completado**
{{% /notice %}}

{{< img cp-2.png >}}

2.3 Seleccione **US West (N. California)** como **Copiar en el destino**, después seleccione **Escoger rol de IAM** y seleccione **Team Role** como el **nombre de rol**. Oprima el botón **Copiar**.

{{< img cp-3.png >}}

2.4 Esto creará un **Trabajo de copiado**.

Debe ver ahora sus dos trabajos de copiado 

{{< img cp-6.png >}}

{{< prev_next_button link_prev_url="../4.1-backup/" link_next_url="../../5-failover/" />}}

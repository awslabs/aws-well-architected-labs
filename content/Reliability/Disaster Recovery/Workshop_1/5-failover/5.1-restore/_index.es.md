+++
title = "Restauración"
date =  2021-05-11T20:35:50-04:00
weight = 2
+++

#### Restauración de la base de datos RDS

{{% notice info %}}
La instancia RDS ya fue restaurada en la región **N. California (us-west-1)** debido a restricciones de tiempo.  Por favor revise [Restaurar una base de datos de RDS](https://docs.aws.amazon.com/es_es/aws-backup/latest/devguide/restoring-rds.html) para los pasos de restauración para RDS en AWS Backup..
{{% /notice  %}}

### Despliegue de EC2

1.1 Oprima [AWS Backup](https://us-west-1.console.aws.amazon.com/backup/home?region=us-west-1#/) para navegar a la consola en la región **N. California (us-west-1)**.

1.2 Oprima el link **Almacenes de copia de seguridad**, después oprima el link **Default**.

{{< img rs-1-es.png >}}

En la sección **Backups**. Seleccione la copia de respaldo de EC2. Oprima **Restaurar** bajo el menú desplegable **Acciones**.

{{< img rs-19-es.png >}}

{{% notice warning %}}
Si no ve su copia de respaldo, revise el estado del **trabajo de copia de seguridad**. Oprima [AWS Backup](https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#/) para navegar a la consola en la región **N. Virginia (us-east-1)**. Oprima el link **Trabajos**. después oprima el link **Trabajos de copia de seguridad**. Verifique que el estado de su copia de seguridad de EC2 sea **Completado**
{{% /notice %}}

1.4 En la sección **Configuración de red**, seleccione **backupadnrestore-secondary-EC2SecurityGroup-xxxx** como el **Grupo de seguridad**.

{{< img rs-20-es.png >}}

1.5 Seleccione **Escoger el rol de IAM** y seleccione **Team Role** como el **Nombre del rol**. 

{{< img rs-21-es.png >}}

1.6 Vamos a hacer que la instancia tenga tras su creación la configuración necesaria para la aplicación Unishop application en la región  **N. California (us-west-1)*.
Usaremos [Datos de usuario](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html) para lograr esto.

Copie y pegue el siguiente script como *Datos de usuario**, después oprima el botón **Restaurar copia de seguridad**

**Script de datos de usuario**:

```bash
#!/bin/bash     
sudo su ec2-user                        
export AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | python -c "import json,sys; print json.loads(sys.stdin.read())['region']")
export DATABASE=$(aws rds describe-db-instances --region $AWS_DEFAULT_REGION --db-instance-identifier backupandrestore-secondary --query 'DBInstances[*].[Endpoint.Address]' --output text)
sudo bash -c "cat >/home/ec2-user/unishopcfg.sh" <<EOF
#!/bin/bash
export DB_ENDPOINT=$DATABASE
EOF
sudo systemctl restart unishop
```

{{< img rs-22-es.png >}}

{{% notice warning %}}
Debe esperar que el trabajo de restauración tenga un estado de **Completado** antes de moverse al siguiente paso. Esto puede tomar varios minutos.
{{% /notice %}}

{{< prev_next_button link_prev_url="../" link_next_url="../../6-verify-secondary/" />}}


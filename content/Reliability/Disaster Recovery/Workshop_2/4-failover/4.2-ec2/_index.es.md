+++
title = "EC2"
date =  2021-05-11T11:43:28-04:00
weight = 4
+++

#### Desplegar EC2 

1.1 Oprima [AMIs](https://us-west-1.console.aws.amazon.com/ec2/v2/home?region=us-west-1#Images:visibility=owned-by-me) para navegar a la consola en la región **N. California (us-west-1)**.

{{% notice warning %}}
Debe esperar a que pilotAMI cambie a estado **Disponible** antes de comenzar el próximo paso. Ésto peude tomar varios minutos.
{{% /notice %}}

1.2 Seleccione la pila **pilotAMI** y oprima **Lanzar instancia a partir de una AMI**.

{{< img pa-1-ES.png >}}

1.3 Escriba `pilot-secondary` bajo **Nombre**.

{{< img pa-2-ES.png >}}

1.4 Desplácese a la sección **Par de claves (inicio de sesión)** y seleccione **ee-default-keypair** como el **Nombre del par de claves**.

{{< img pa-3-ES.png >}}

1.5 En la sección de **Configuraciones de red** oprima el botón **Editar**.

{{< img pa-6-ES.png >}}

1.6 Seleccione **pilot-secondary** con el VPC **VPC**. Seleccione **Seleccionar un grupo de seguridad existente** bajo la sección **Firewall (grupos de seguridad)** en **Grupos de seguridad comunes**.

{{< img pa-7-ES.png >}}

1.7 Bajo **Detalles avanzados** seleccione **pilot-secondary-S3InstanceProfile-xxx** como **Perfil de instancia de IAM**.

{{< img pa-4-ES.png >}}

1.8 Vamos a _bootstrap_ la instancia de EC2 para que tenga todas las configuraciones necesarias para nuestra aplicación Unishop en la región de **N. California (us-west-1)**. Utilizaremos los [datos de usuario](https://docs.aws.amazon.com/es_es/AWSEC2/latest/UserGuide/user-data.html) para inicializar la instancia.

Copie y pegue el siguiente _script_ como **datos de usuario**, luego oprima **Lanzar instancia**.

**Script Datos de usuario**:

```bash
#!/bin/bash     
sudo su ec2-user                        
export AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | python -c "import json,sys; print json.loads(sys.stdin.read())['region']")
export DATABASE=$(aws rds describe-db-clusters --region $AWS_DEFAULT_REGION --db-cluster-identifier pilot-secondary --query 'DBClusters[*].[Endpoint]' --output text)
sudo bash -c "cat >/home/ec2-user/unishopcfg.sh" <<EOF
#!/bin/bash
export DB_ENDPOINT=$DATABASE
EOF
sudo systemctl restart unishop
```

{{< img pa-5-ES.png >}}

{{% notice warning %}}
Debe esperar que la instancia haya sido desplegada exitosamente. Navegue a la consola de EC2 para ver todas las instancias y  verifique que **pilot-secondary** esté en **Estado ejecución** bajo **Estado de la instancia**. Ésto puede demorar varios minutos. 
{{% /notice %}}


{{< prev_next_button link_prev_url="../4.1-aurora" link_next_url="../../5-verify-secondary/"  button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}


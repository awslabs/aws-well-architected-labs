+++
title = "Preparar región secundaria"
date =  2021-05-11T20:33:54-04:00
weight = 3
+++

{{% notice info %}}
**Manualmente** crearemos y copiaremos [Imágenes de máquina de Amazon (AMI)](https://docs.aws.amazon.com/es_es/AWSEC2/latest/UserGuide/AMIs.html) a nuestra región secundaria en **N. California (us-west-1)**.
En un ambiente de producción, éstos pasos serían **automatizados** como parte de nuestra canalización de CI/CD. Es importante que tanto la región primaria como la secundaria tengan la misma configuración y utilicen los mismos artefactos para asegurar que en caso de que se tenga que conmutar por error hacia la región secundaria, la aplicación funcione igual que en la región primaria.
{{% /notice %}}

{{< prev_next_button link_prev_url="../2-verify-primary" link_next_url="./3.1-ec2/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}

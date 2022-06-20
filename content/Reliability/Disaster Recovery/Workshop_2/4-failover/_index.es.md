+++
title = "Failover a secundaria"
date =  2021-05-11T11:43:28-04:00
weight = 4
+++

Cuando un evento regional afecta la aplicación Unicorn en su región primaria **N. Virginia (us-east-1)**, queremos hacer un fail-over hacia la región secundaria **N. California (us-west-1)**.

Asumiremos que un evento regional de servicio ha ocurrido. En esta sección, haremos el failover de forma manual hacia la aplicación que corre en la región secundaria, **N. California (us-west-1)**. Puede considerar usar Amazon Route53 u otro DNS (Domain Name Services) para configurar las rutas de fail over en un escenario real. Adicionalmente, se puede automatizar el proceso de notificación acerca del funcionamiento de la aplicación.

{{< prev_next_button link_prev_url="../3-prepare-secondary/3.1-ec2" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}

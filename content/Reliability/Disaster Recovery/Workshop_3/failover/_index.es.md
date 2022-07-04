+++
title = "Failover a secundaria"
date =  2021-05-11T11:43:28-04:00
weight = 4
+++

Cuando un evento regional de servicio afecta la aplicación en su región primaria **N. Virginia (us-east-1)**, usted querrá hacer fail-over hacia la región segundaria, **N. California (us-west-1)**.

Asumiremos que ocurrió un evento regional de servicio. En esta sección, haremos el fail over de forma manual de la aplicación a la región secundaria, **N. California (us-west-1)**. Puede considerar usar Amazon Route53 u otro DNS (Domain Name Services) para enrutar el fail over en un escenario real. Puede crear también automatizaciones subscribiendose a notificaciones de la aplicación.

{{< prev_next_button link_prev_url="../verify-websites/" link_next_url="./promote-app/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}

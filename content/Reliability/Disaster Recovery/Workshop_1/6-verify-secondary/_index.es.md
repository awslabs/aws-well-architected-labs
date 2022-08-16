+++
title = "Verificar la región secundaria"
date =  2021-05-11T11:43:28-04:00
weight = 5
+++

### Verificación de la página web de la región secundaria

1.1 Oprima [S3](https://console.aws.amazon.com/s3/home?region=us-east-1#/) para navegar a la consola.

1.2 Oprima el link para **backupandrestore-secondary-uibucket-xxxx**.

{{< img c-11-ES.png >}}


1.3 Oprima el link **Propiedades**.  

{{< img c-17-ES.png >}}

1.4 En la sección **Alojamiento de sitios web estáticos**,  oprima el link **Endpoint de sitio web en el bucket** link.

{{< img rs-46-ES.png >}}

1.5 Ahora, estará apuntando a la región secundaria **N. California (us-west-1)** si ve **us-west-1** en el encabezado y los productos de los unicornios.

{{< img rs-45.png >}}

#### Felicitaciones !  Debería ver su aplicación "The Unicorn Shop" en la región **us-west-1**.

{{< prev_next_button link_prev_url="../rds/" link_next_url="../7-cleanup/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}


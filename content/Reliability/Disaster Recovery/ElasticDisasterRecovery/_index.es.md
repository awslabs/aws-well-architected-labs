+++
title = "AWS Elastic Disaster Recovery"
date = 2021-05-06T09:53:21-04:00
weight = 150
chapter = false
pre = ""
+++

Configure AWS Elastic Disaster Recovery en sus servidores de origen para iniciar la replicación segura de los datos. Estos se replican en una subred del área de almacenamiento provisional en su cuenta de AWS, en la región de AWS que seleccione. El diseño del área de almacenamiento provisional reduce los costos a través del uso de almacenamiento asequible y la menor cantidad de recursos informáticos posible para mantener la replicación continua. Puede realizar pruebas sin interrupciones para confirmar que la implementación se haya completado. Durante el funcionamiento normal, se debe permanecer preparado mediante el monitoreo de la replicación y la realización periódica de simulacros de recuperación y conmutación por recuperación que no generen interrupciones. Si necesita recuperar aplicaciones, puede lanzar instancias de recuperación en AWS en cuestión de minutos, para lo cual puede utilizar el estado más actualizado del servidor o un momento anterior. Una vez que sus aplicaciones se ejecuten en AWS, puede optar por mantenerlas allí, o bien, puede iniciar la replicación de datos de vuelta a su sitio principal después de resolver el problema. Puede realizar la conmutación por recuperación en el sitio principal en cuanto esté listo.
Aprenda más de [AWS Elastic Disaster Recovery.](https://aws.amazon.com/es/disaster-recovery/)

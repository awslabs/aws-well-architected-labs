---
title: "Nível 100: Migrando bancos de dados Amazon RDS para Graviton"
menutitle: "Migrando bancos de dados Amazon RDS para Graviton"
date: 2023-02-17T20:33:27.634Z
chapter: false
weight: 1
hidden: false
---
## Autores

- **Jeff Forrest**, Senior Solutions Architect.

## Introdução
Os processadores [AWS Graviton](https://aws.amazon.com/pt/ec2/graviton/) foram projetados pela Amazon Web Services utilizando núcleos Arm.

AWS Graviton CPUs possuem excelente eficiência no uso de energia, mudando para instâncias EC2 com Graviton pode ser reduzido o uso de energia tanto quanto 60% com a mesma performance em comparação com as instâncias x86-64.

A AWS controla do início ao fim o ciclo de vida do chip, do design ao consumo, elevando sua eficiência como um todo. [Leia mais aqui](https://aws.amazon.com/pt/ec2/graviton/).


## RDS em Graviton
* Até 35% mais rápido do que não Graviton.
* Até 53% melhor preço/performance do que não Graviton.
* Praticamente esforço zero na migração de x86-64.
* Suportado em bancos de dados RDS MySQL, PostgreSQL, MariaDB e para Amazon Aurora.
* Não suportado no momento para bancos de dados comerciais Oracle e SQL Server.

Rodar seu banco de dados em AWS Graviton é apenas uma forma de melhorar sustentabilidade para RDS, veja outras opções [neste blog post](https://aws.amazon.com/blogs/architecture/optimizing-your-aws-infrastructure-for-sustainability-part-iv-databases/).

## Objetivos
Ao final deste laboratório você irá:

* Entender qual banco de dados RDS pode ser migrado de x86-64 para Graviton.
* Entender as diferentes opções de migração e como se aplicam a cada tipo de banco de dados.
* Experiência prática ao migrar bancos de dados RDS de x86-64 para Graviton.

## Pré-requisitos

* Este laboratório foi criado para rodar em sua própria conta.
* Pode ser realizado em qualquer região que suporte RDS e Graviton mas us-east-1 é recomendado.

{{< prev_next_button link_next_url="./1_migration_methodologies/"  first_step="true" title="Próximo" />}}

## Passos:
{{% children  %}}

---
title: "Metodologias de Migração"
date: 2023-02-17T20:33:27.634Z
chapter: false
weight: 2
pre: "<b>1 </b>"
---

- [x] [Metodologias de Migração]({{< ref "./1_migration_methodologies.md" >}})
- [ ] [Preparação]({{< ref "./2_preparation.md" >}})
- [ ] [Lab 1 - Alterar o tipo de instância do banco de dados]({{< ref "./3-1_change_instance_type_and_restart.md" >}})
- [ ] [Lab 2 - Promovendo uma réplica de leitura]({{< ref "./3-2_promote_read_replica.md" >}})
- [ ] [Lab 3 - Failover para réplica de leitura]({{< ref "./3-3_failover_to_read_replica.md" >}})
- [ ] [Lab 4 - Restore de um snapshot]({{< ref "./3-4_restore_from_snapshot.md" >}})
- [ ] [Limpeza]({{< ref "./cleanup.md" >}})

## Métodos de migração

Existem quatro opções para migrar instâncias de x86-64 para Graviton as quais iremos cobrir neste laboratório.

### 1. Altere o tipo de instância e restart o banco de dados

Este é o tipo mais simples de migração. Os endpoints do banco de dados não são alterados, e é tão simples quanto desligar o banco de dados e restart em uma instância apropriada utilizando Graviton.

### 2. Crie uma réplica de leitura e promova-a para um banco de dados separado

Nesta migração, uma nova instância do banco de dados é criado de uma réplica. Qualquer conexão com o banco de dados irá precisar ser direcionado para os endpoints do novo banco de dados. O banco de dados existente não é afetado. Esta pode ser uma boa opção para teste.

### 3. Cria uma réplica de leitura e failover para a mesma

Bancos de dados [Amazon Aurora](https://aws.amazon.com/rds/aurora/), réplicas de leitura pode ser promovidas a escrita. Ao criar uma réplica de leitura em Graviton e promovendo para escrita, uma mudança entre x86-64 e Graviton pode ser feita com o mínimo de downtime.

### 4. Faça um restore a partir de um snapshot do banco de dados

Snashots dos bancos de dados são independentes do tipo de CPU, logo um snapshot realizado em uma instância x86-64 pode ser restored em uma instância Graviton.


## Suporte dos bancos de dados para métodos de migração

|	|Alterar o tipo de instância e restartar	|Criar um novo banco ao promover para réplica de leitura	|Failover de uma réplica de leitura existente	| Restore de um snapshot do banco de dados |
|---	| :---:	| :---:	| :---:	| :---:	|
|RDS: MySQL, Postgres, MariaDB	|Sim|Sim|Não|Sim|
|Aurora: MySQL, Postgres	|Não|Não|Sim|Sim|

{{< prev_next_button link_prev_url="../" link_next_url="../2_preparation" button_next_text="Próximo" button_prev_text="Anterior" />}}
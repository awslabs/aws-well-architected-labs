---
title: "Preparação"
date: 2023-02-17T20:33:27.634Z
chapter: false
weight: 3
pre: "<b>2 </b>"
lang: "pt_br"
---

- [x] [Metodologias de Migração]({{< ref "./1_migration_methodologies.md" >}})
- [x] [Preparação]({{< ref "./2_preparation.md" >}})
- [ ] [Lab 1 - Alterar o tipo de instância do banco de dados]({{< ref "./3-1_change_instance_type_and_restart.md" >}})
- [ ] [Lab 2 - Promovendo uma réplica de leitura]({{< ref "./3-2_promote_read_replica.md" >}})
- [ ] [Lab 3 - Failover para réplica de leitura]({{< ref "./3-3_failover_to_read_replica.md" >}})
- [ ] [Lab 4 - Restore de um snapshot]({{< ref "./3-4_restore_from_snapshot.md" >}})
- [ ] [Limpeza]({{< ref "./cleanup.md" >}})

## Visão geral

Os bancos de dados neste laboratório levam tempo para serem criadores, ao criar todos ao iniciar o laboratório algum tempo pode ser economizado. Para uma certa variedade iremos criar vários tipos diferentes de bancos de dados.

## Crie uma instânca RDS MySQL em x86-64 para o Lab 1

Vár para o [console do RDS](https://console.aws.amazon.com/rds/) e crie um banco de dados MySQL no _free tier_, o nível gratuito:

1. Clique em **Create Database**
2. Selecione **Easy create**
3. Selecione **MySQL** como seu tipo
4. Selecione Free Tier (tipo de instância db.t3.micro)
5. Insira um identificador para o banco de dados (e.g. `mysql-lab1`)
6. Selecione **Auto generate a password**
7. Deixe todo o resto com os valores padrões e clique em **create database**. Sua configuração deve se parecer com a imagem abaixo.


{{% notice note %}}
**NOTA:** Leva-se alguns minutos para criar um banco de dados e para este se tornar disponível, enquanto está se processando você pode iniciar a criar o próximo banco de dados.
{{% /notice %}}

![Lab 1 Database Creation](/Sustainability/100_migrate_rds_to_graviton/lab-1/pt-br/lab-1_create_database-2023-02-20.png)


## Crie uma instância RDS PostgreSQL em x86-64 para o Lab 2

Go to the [RDS Console](https://console.aws.amazon.com/rds/) and create a PostgreSQL database on the free tier:

1. Clique **Create Database**
2. Selecione **Easy create**
3. Selecione **PostgreSQL** como seu tipo
4. Selecione Free Tier (tipo de instância db.t3.micro)
5. Insira um identificador para o banco de dados (e.g. `postgresql-lab2`)
6. Se o usuário estiver definido em Master, deve ser definido para outro (e.g. `postgres`)
7. Selecione **Auto generate a password**
8. Deixe todas  outras configurações com os valores padrões e clique em **create database**. Sua configuração deve se parecer com a imagem abaixo.

![Lab 2 Database Creation](/Sustainability/100_migrate_rds_to_graviton/lab-2/pt-br/lab-2_create_database-2023-02-20.png)


## Crie uma instância Amazon Aurora para o Lab 3

1. Clique **Create Database**
2. Selecione **Standard create**
3. Escolha Amazon Aurora (MySQL-Compatible) como seu tipo
4. Para a versão, mantenha a versão padrão pré-seleciona. Na imagem abaixo a mesma se trata de Aurora (MySQL 5.7) 2.10.2
5. Escolha o tamanho da instância como Dev/Test]. Sua configuração deverá se parecer com a da imagem abaixo:

![Lab 3 Database Creation 1](/Sustainability/100_migrate_rds_to_graviton/lab-3/pt-br/lab-3_aurora_create_1-2023-02-20.png)

6. Insira um identificador para o banco de dados (e.g. `aurora-lab3`)
7. Selecione **Auto generate a password**
8. Em instance configuration, selecione **Burstable classes** (includes t classes)
9. Selecione db.t3.small como o tipo de instância
10. Deixe todas outras configurações com os valores padrões
11. Clique em **Create Database**

![Lab 3 Database Creation 2](/Sustainability/100_migrate_rds_to_graviton/lab-3/pt-br/lab-3_aurora_create_2-2023-02-20.png)


Laverá algunbs minutos para o banco de dados ser criado e estar disponível, continue a criação do banco para o laboratório 4 enquanto isto ocorre.

## Crie uma instância MariaDB para o Lab 4

From the Amazon RDS console:

1. Clique em **Create Database**
2. Selecione **Easy Create**
3. Escolha **MariaDB** como tipo
4. Selecione **Free tier**
5.  Insira um identificador para o banco de dados (e.g. `mariadb-lab4`)
6. Selecione db.t3.micro as the tipo de instância
7. Escolha **Auto Generate a password**
8. Deixe todas outras configurações com os valores padrões
9. Clique em **Create Database**

![Lab 4 Database Creation](/Sustainability/100_migrate_rds_to_graviton/lab-4/pt-br/lab-4_mariadb_create-2022-02-20.png)

Todas estes 4 bancos de dados deverão estarem criados ou ao menos no processo de criação. Agora, avance para os laboratórios.

{{< prev_next_button link_prev_url="../1_migration_methodologies" link_next_url="../3-1_change_instance_type_and_restart" button_next_text="Próximo" button_prev_text="Anterior"/>}}
---
title: "Lab 1 - Alterar o tipo de instância"
date: 2023-02-17T20:33:27.634Z
chapter: false
weight: 4
pre: "<b>3.1 </b>"
lang: "pt_br"
---

- [x] [Metodologias de Migração]({{< ref "./1_migration_methodologies.md" >}})
- [x] [Preparação]({{< ref "./2_preparation.md" >}})
- [x] [Lab 1 - Alterar o tipo de instância do banco de dados]({{< ref "./3-1_change_instance_type_and_restart.md" >}})
- [ ] [Lab 2 - Promovendo uma réplica de leitura]({{< ref "./3-2_promote_read_replica.md" >}})
- [ ] [Lab 3 - Failover para réplica de leitura]({{< ref "./3-3_failover_to_read_replica.md" >}})
- [ ] [Lab 4 - Restore de um snapshot]({{< ref "./3-4_restore_from_snapshot.md" >}})
- [ ] [Limpeza]({{< ref "./cleanup.md" >}})

## Visão geral

Neste laboratório você irá utilizar o banco de dados RDS MySQL criado no passo [Preparação]({{< ref "./2_preparation.md" >}}), e migrá-lo da instância x86-64 em que foi provicionado para uma instância baseada em Graviton.

Este método de migração funciona para todos os bancos de dados RDS que suportam AWS Graviton, incluindo o Amazon Aurora.

Com este tipo de migração, as aplicações poderão continuar a utilizar os endpoints existentes.


{{< prev_next_button link_prev_url="../2_preparation" link_next_url="../3-2_promote_read_replica" button_next_text="Próximo" button_prev_text="Anterior" />}}
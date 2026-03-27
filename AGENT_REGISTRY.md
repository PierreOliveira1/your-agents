# AGENTS_REGISTRY

Este arquivo é a fonte de verdade para o ORQUESTRADOR descobrir:
- quais agentes existem;
- o nome exato de cada agente;
- o tipo de cada agente;
- qual projeto pertence a um agente de domínio;
- quais notes cada agente pode ler;
- quais notes cada agente pode escrever.

Se houver conflito entre suposição do ORQUESTRADOR e este arquivo, este arquivo prevalece.

## TYPES
- `domain`
- `code_review`
- `architect`
- `integration_validator`

## AGENTS

### Agent
- name: [nome exato do agente]
- type: domain
- project: [nome da pasta do projeto]
- reads:
  - [PLAN exato]
  - [TODOS exato]
- writes:
  - [TODOS exato]

### Agent
- name: [nome exato do agente]
- type: domain
- project: [nome da pasta do projeto]
- reads:
  - [PLAN exato]
  - [TODOS exato]
- writes:
  - [TODOS exato]

### Agent
- name: [nome exato do agente]
- type: code_review
- reads:
  - [notes relevantes]
- writes:
  - []

### Agent
- name: [nome exato do agente]
- type: architect
- reads:
  - [notes relevantes]
- writes:
  - []

### Agent
- name: [nome exato do agente]
- type: integration_validator
- reads:
  - [notes relevantes]
- writes:
  - []

## REGRA FINAL
O ORQUESTRADOR deve:
1. ler este arquivo antes de delegar;
2. usar o `name` exato do agente;
3. respeitar o `type` do agente;
4. usar o campo `project` apenas para agentes do tipo `domain`;
5. verificar `reads` e `writes` antes de escrever ou delegar;
6. não assumir agentes fora deste arquivo.

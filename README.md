# Multi-Agent Workspace

Sistema de coordenacao multiagente para **Claude Code** e **Codex CLI**, orquestrado visualmente pelo [**Maestri**](https://www.themaestri.app/pt-br).

Um orquestrador central delega trabalho para agentes especializados, coordena paralelismo, garante rastreabilidade e impede que agentes se percam em contexto ou alterem areas erradas.

---

## Maestri — a interface de orquestracao

Este workspace usa o [Maestri](https://www.themaestri.app/pt-br) como camada de orquestracao visual. Maestri e um app de terminal para macOS que funciona como um canvas infinito onde multiplos agentes de IA rodam simultaneamente.

### Por que Maestri

Em vez de alternar entre abas de terminal, voce coloca cada agente (Claude Code, Codex, shell comum) em um ponto do canvas e ve todos ao mesmo tempo. A comunicacao entre eles e direta: um agente pode delegar tarefas, fazer perguntas ou passar trabalho para outro sem voce precisar copiar e colar entre janelas.

### Como funciona na pratica

- **Terminais no canvas** — cada terminal roda seu proprio agente. Voce posiciona livremente no espaco.
- **Conexao entre terminais** — conecte dois terminais e os agentes se comunicam direto. O orquestrador delega para agentes de dominio, que devolvem resultado, tudo visivel no canvas.
- **Sticky notes** — notes conectados a terminais que o agente escreve automaticamente. Atualizacoes de progresso, resumos, decisoes — tudo capturado sem intervencao manual. E onde os PLAN, TODOS e DAILY deste sistema vivem na pratica.
- **Papeis de agentes** — voce atribui papeis reutilizaveis (orquestrador, dominio, reviewer, arquiteto) que persistem entre sessoes.
- **Desenho no canvas** — diagramas de arquitetura e fluxos direto no espaco de trabalho, uteis para alinhar contexto visual entre frentes.

### Privacidade

Todos os dados ficam localmente no Mac. Sem telemetria, sem conta, sem cloud.

---

## Como usar

### 1. Copie os arquivos de especificacao para o seu projeto

Copie a pasta `.claude/` e/ou `.codex/` para a raiz do projeto onde voce quer usar os agentes. Claude Code le `.claude/CLAUDE.md` automaticamente; Codex CLI le `.codex/AGENTS.md` e `.codex/default.rules`.

Copie tambem os markdowns de especificacao dos agentes (`orquestrador.md`, `agente-dominio.md`, etc.) para uma pasta acessivel no projeto, ou use como referencia para o system prompt.

### 2. Configure o AGENT_REGISTRY.md

Antes de qualquer delegacao, crie um `AGENT_REGISTRY.md` na raiz do projeto com os agentes reais do seu contexto. Use o template deste repositorio como base e preencha com nomes, tipos, projetos e notes reais.

### 3. Crie os notes das frentes

Para cada frente de trabalho, crie notes de:
- **PLAN** — escopo, contexto, objetivo, dependencias, criterios de sucesso
- **TODOS** — tarefas executaveis, verificaveis, com checkpoints
- **DAILY** (opcional) — registro consolidado de andamento, uso exclusivo do orquestrador

### 4. Inicie pela demanda ao orquestrador

Passe a demanda ao orquestrador. Ele analisa, le o `AGENT_REGISTRY.md`, decide quais frentes e agentes precisam atuar, prepara os notes e delega. Voce nao precisa micro-gerenciar a distribuicao.

---

## Agentes

### Orquestrador

O cerebro do sistema. Recebe a demanda, analisa contexto, decide quais frentes precisam atuar e coordena tudo.

**Faz:**
- analisa demanda, arquitetura, dependencias, riscos e impacto
- le o `AGENT_REGISTRY.md` antes de qualquer delegacao
- decide o que roda em paralelo e o que e sequencial
- prepara e atualiza PLAN, TODOS e DAILY
- delega para agentes de dominio
- aciona code review, arquiteto e validador de integracao quando necessario
- consolida a entrega final

**Nao faz:**
- implementar codigo (exceto ausencia total de agente compativel)
- delegar em plan mode (plan mode e apenas para planejar)

Especificacao completa: [`orquestrador.md`](orquestrador.md)

---

### Agente de Dominio

Executa trabalho real em uma frente especifica (frontend, backend, analytics, mobile, infra, etc.).

**Faz:**
- le PLAN e TODOS da propria frente como fonte de verdade
- executa o trabalho
- atualiza o TODOS durante a execucao
- registra bloqueios, riscos e novas tarefas
- escala ao orquestrador mudancas relevantes

**Nao faz:**
- redefinir escopo global
- alterar notes de outras frentes
- redistribuir trabalho
- ler ou atualizar a DAILY

Especificacao completa: [`agente-dominio.md`](agente-dominio.md)

---

### Code Review

Revisor tecnico e de risco. Opcional — acionado pelo orquestrador quando ha mudanca relevante de codigo.

**Faz:**
- revisa correcao tecnica, regressao, quebra de contrato, tratamento de erro
- classifica achados como critico, importante ou melhoria opcional
- devolve parecer com status: aprovado / aprovado com observacoes / mudancas necessarias / escalar

**Nao faz:**
- gerar churn infinito (maximo 1 review + 1 rechecagem)
- bloquear por gosto pessoal ou micro-otimizacao
- alterar notes de outras frentes

Especificacao completa: [`code-review.md`](code-review.md)

---

### Arquiteto

Guardiao de entropia e qualidade estrutural. Opcional — acionado quando ha novo modulo, refactor estrutural, mudanca de fronteira ou risco de acoplamento.

**Faz:**
- avalia fronteiras, acoplamento, coesao, duplicacao estrutural, abstracoes
- classifica como estruturalmente boa / aceitavel com divida / precisa de ajuste / precisa de decisao

**Nao faz:**
- virar code review duplicado
- forcar overengineering
- bloquear por gosto pessoal

Especificacao completa: [`arquiteto.md`](arquiteto.md)

---

### Validador de Integracao

Verifica coerencia entre frentes. Opcional — acionado quando mais de uma frente foi alterada ou ha mudanca de contrato/payload/evento.

**Faz:**
- valida contratos, payloads, eventos, estados e sequencia entre frentes
- verifica se "cada frente esta certa sozinha, mas errada em conjunto"
- devolve parecer: integracao ok / gap de integracao / precisa de replanejamento

**Nao faz:**
- virar code review de detalhes internos
- redesenhar arquitetura
- abrir loop infinito de alinhamento

Especificacao completa: [`validador-integracao.md`](validador-integracao.md)

---

## Regras de seguranca (`.claude/` e `.codex/`)

Ambas as ferramentas possuem regras de seguranca identicas configuradas neste repositorio. Essas regras impedem que os agentes executem acoes destrutivas ou irreversiveis.

### O que e bloqueado

| Categoria | Comandos bloqueados |
|-----------|-------------------|
| **Git destrutivo** | `git commit`, `git push`, `git rebase`, `git reset --hard`, `git merge`, `git tag`, `git cherry-pick` |
| **Releases** | `gh release create`, `gh release upload` |
| **Migracao de banco** | `prisma migrate`, `drizzle-kit migrate`, scripts `db:migrate` |
| **Rede externa** | `curl`, `wget`, `ssh`, `scp`, `rsync` |
| **Infra** | `terraform apply/destroy`, `kubectl apply/delete` |
| **Limpeza destrutiva** | `git clean -fd/-fdx` |

### O que e permitido

- Leitura de git: `git status`, `git diff`, `git log`, `git show`, `git branch`
- Leitura, edicao e busca de arquivos
- Execucao de testes e linters
- Qualquer operacao local e reversivel

### Comportamento quando bloqueado

Quando o agente chega em um ponto que exigiria uma acao bloqueada (como commit), ele:
1. Para antes da acao
2. Resume o que foi feito
3. Entrega os comandos exatos para voce executar manualmente

Isso garante que **voce sempre tem controle sobre acoes irreversiveis**.

### Onde estao as regras

- **Claude Code**: `.claude/CLAUDE.md` — instrucoes em linguagem natural, lidas automaticamente
- **Codex CLI**: `.codex/AGENTS.md` (mesmas instrucoes) + `.codex/default.rules` (regras programaticas com `prefix_rule`)

---

## Modo sem restricoes (`shell.txt`)

O arquivo `shell.txt` contem aliases de shell que desabilitam as protecoes de seguranca:

```bash
# Claude Code sem permissoes interativas
claude-free() {
  command claude --dangerously-skip-permissions "$@"
}

# Codex CLI sem sandbox e sem aprovacao
codex-free() {
  command codex --config approval_policy='"never"' --config sandbox_mode='"danger-full-access"' "$@"
}
```

### Como usar

Adicione os aliases ao seu `.zshrc` ou `.bashrc`:

```bash
cat shell.txt >> ~/.zshrc
source ~/.zshrc
```

Depois, use `claude-free` ou `codex-free` no lugar dos comandos normais.

### Riscos

Ao usar esses aliases, **todas as protecoes de seguranca sao desabilitadas**:

- O agente pode fazer `git commit`, `git push`, `git reset --hard` e qualquer outro comando sem pedir confirmacao
- O agente pode executar comandos de rede (`curl`, `ssh`, etc.)
- O agente pode rodar migracoes de banco, aplicar terraform, deletar arquivos — sem perguntar
- O agente pode executar qualquer comando do sistema com acesso total
- As regras do `.claude/CLAUDE.md` e `.codex/default.rules` continuam escritas, mas o agente pode ignora-las ou a ferramenta pode nao aplica-las dependendo do modo

**Use apenas quando voce confia completamente no que o agente vai fazer e esta em um ambiente onde erros sao reversiveis** (branch descartavel, ambiente de dev isolado, etc.).

---

## Estrutura do repositorio

```
.
├── .claude/
│   └── CLAUDE.md              # Regras de seguranca para Claude Code
├── .codex/
│   ├── AGENTS.md              # Regras de seguranca para Codex CLI
│   └── default.rules          # Regras programaticas do Codex
├── AGENT_REGISTRY.md          # Template de registro de agentes
├── orquestrador.md            # Especificacao do orquestrador
├── agente-dominio.md          # Especificacao do agente de dominio
├── code-review.md             # Especificacao do code review
├── arquiteto.md               # Especificacao do arquiteto
├── validador-integracao.md    # Especificacao do validador de integracao
├── shell.txt                  # Aliases para modo sem restricoes
└── README.md
```

---

## Fluxo tipico de uma demanda

```
Demanda
  │
  ▼
Orquestrador
  ├── Le AGENT_REGISTRY.md
  ├── Analisa contexto e impacto
  ├── Prepara PLAN e TODOS das frentes
  │
  ├──▶ Agente de Dominio A (paralelo)
  ├──▶ Agente de Dominio B (paralelo)
  │
  ├── Checkpoint de sincronizacao
  │
  ├──▶ Code Review (se necessario)
  ├──▶ Arquiteto (se necessario)
  ├──▶ Validador de Integracao (se necessario)
  │
  ├── Correcoes pontuais (se pedidas)
  │
  └── Consolidacao final
```

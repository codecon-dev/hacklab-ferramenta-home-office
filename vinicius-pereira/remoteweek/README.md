# Weekly Impact Report – Rails Planning

## 1. Objetivo do sistema

Criar um app em Rails para gerar **Relatórios Semanais de Impacto** para gestores, a partir dos dados diários de cada membro:

- Cada **usuário** pertence a uma **organização**.
- Todo dia o usuário registra um **standup/daily**:
  - Ontem (`yesterday`)
  - Hoje (`today`)
  - Bloqueios (`blockers`)
  - Métricas diárias:
    - `commits_count`
    - `support_tickets_resolved`
- Semanalmente é gerado um **relatório de impacto** por **organização**, consolidando:
  - O que foi feito
  - Métricas por membro
  - Bloqueios recorrentes
  - Destaques de impacto

---

## 2. Domínio e Modelagem

### 2.1 Organization

- Campos:
  - `name` (string)
  - `slug` (string, único, para URLs)
- Relações:
  - `has_many :users`
  - `has_many :standups`
  - `has_many :weekly_reports`

### 2.2 User

- Campos:
  - `name` (string)
  - `email` (string, único)
  - `organization_id` (FK)
- Relações:
  - `belongs_to :organization`
  - `has_many :standups`
- Futuro:
  - Autenticação (Devise)
  - Campos para integrações (`github_username`, `support_tool_username`)

### 2.3 Standup

Representa a **daily/standup** de um membro em um dia específico.

- Campos:
  - `user_id` (FK)
  - `organization_id` (FK)
  - `date` (date)
  - `yesterday` (text)
  - `today` (text)
  - `blockers` (text)
  - `commits_count` (integer, default 0)
  - `support_tickets_resolved` (integer, default 0)
  - `extra_notes` (text)
- Regras:
  - Um standup por usuário por dia (`uniqueness :date, scope: :user_id`)

### 2.4 WeeklyReport (Relatório de Impacto Semanal)

Relatório consolidado por organização para uma semana.

- Campos:
  - `organization_id` (FK)
  - `week_start` (date)
  - `week_end` (date)
  - `generated_at` (datetime)
  - `report_data` (jsonb) – dados estruturados do relatório
- Relações:
  - `belongs_to :organization`

Exemplo de `report_data`:

```json
{
  "organization_name": "Nodau",
  "week": "2025-11-25 to 2025-11-29",
  "members": [
    {
      "user_id": 1,
      "name": "Vinicius",
      "total_commits": 32,
      "total_support_tickets_resolved": 14,
      "standups": [
        {
          "date": "2025-11-25",
          "yesterday": "Revisou PRs X e Y",
          "today": "Implementar feature Z",
          "blockers": "Aguardando aprovação do time A",
          "commits_count": 6,
          "support_tickets_resolved": 3
        }
      ],
      "impact_summary": "Contribuiu fortemente em Z, fechou X tickets e ajudou no suporte."
    }
  ],
  "highlights": [
    "Feature Z entregue no prazo",
    "Redução no volume de bloqueios em relação à semana anterior"
  ],
  "recurring_blockers": [
    "Dependência de squad externo para deploy",
    "Atrasos em approvals de PR"
  ]
}


rails s

QUEUE=* bundle exec rake resque:work

rake standups:sync_integrations
rake weekly_reports:generate_last_week
rake reports:generate_missing
whenever --update-crontab
crontab -l

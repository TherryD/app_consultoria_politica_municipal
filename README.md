# 🏛️ App Consultoria Política Municipal — Estação/RS

Aplicação móvel desenvolvida em **Flutter** para suporte estratégico e conformidade de campanhas eleitorais municipais no município de **Estação - RS**.

---

## 1. Manual de Utilização

### Pré-requisitos
- **Flutter SDK** instalado (versão `>=3.12.0`)
- **Dart SDK** configurado no ambiente
- Navegador **Google Chrome**, emulador Android/iOS ou ambiente desktop
- **Git** instalado

### Como Executar
1. **Clone o repositório:**
   ```bash
   git clone [https://github.com/therryd/app_consultoria_politica_municipal.git](https://github.com/therryd/app_consultoria_politica_municipal.git)
   cd app_consultoria_politica_municipal
   ```

2. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

3. **Execute o aplicativo:**
   ```bash
   flutter run
   ```

4. **Execute os testes unitários:**
   ```bash
   flutter test
   ```

---

## 📂 Estrutura do Projeto

```text
app_consultoria_politica_municipal/
├── assets/
│   └── data/
│       └── estacao_dados.json         # Dados oficiais de Estação/RS e regras eleitorais
├── lib/
│   ├── models/
│   │   └── dados_estacao_model.dart   # Tipagem estrita e parsing do JSON
│   ├── services/
│   │   └── eleicao_service.dart       # Regras de negócio (QE e cláusula de barreira)
│   └── main.dart                      # Interface Material 3 e fluxo principal
└── test/
    └── widget_test.dart               # Testes automatizados
```

---

## 2. Versionamento

O projeto adota o padrão **Semantic Versioning (SemVer)** no formato `MAJOR.MINOR.PATCH`:

- **`v1.0.0`** — Lançamento da versão estável com os quatro módulos operacionais:
  - Projeção de votos e cálculo do Quociente Eleitoral (QE).
  - Calculadora orçamentária por rubricas de gastos de campanha.
  - Validador de discursos e materiais de campanha contra termos vedados.
  - Painel com indicadores socioeconômicos do IBGE e calendário do MEF.

### Padrão de Commits (Conventional Commits)
- `feat:` Adição de nova funcionalidade (ex.: `feat: implementa calculo de quociente eleitoral`).
- `fix:` Correção de anomalia (ex.: `fix: ajusta parsing nulo de listas no modelo json`).
- `docs:` Atualizações na documentação (ex.: `docs: documenta boas praticas no readme`).
- `test:` Adição ou ajuste de testes automatizados (ex.: `test: adiciona testes unitarios da clausula de barreira`).

---

## 3. Boas Práticas Aplicadas

### DRY (Don't Repeat Yourself)
- **Conceito:** Cada cálculo, validação ou regra de negócio deve residir em um único ponto do código, eliminando redundâncias e facilitando a manutenção futura.
- **Aplicação no Projeto:** O cálculo do Quociente Eleitoral (`calcularQE`) e da Cláusula de Barreira Individual (`calcularBarreiraIndividual`) está centralizado unicamente em `EleicaoService`. Tanto a interface visual (`_AbaSimulador`) quanto a suíte de testes unitários (`test/widget_test.dart`) utilizam essa mesma fonte lógica, evitando a reescrita de equações.

### YAGNI (You Aren't Gonna Need It)
- **Conceito:** Não construa funcionalidades, dependências ou abstrações arquiteturais antes que elas sejam estritamente necessárias para atender aos requisitos atuais.
- **Aplicação no Projeto:** Os dados oficiais de Estação e as regras da eleição foram organizados em um arquivo estático JSON (`assets/data/estacao_dados.json`). Não foi implementado backend remoto, APIs em nuvem ou bancos de dados relacionais pesados sem exigência real, mantendo o escopo conciso e funcional.

### KISS (Keep It Simple, Stupid)
- **Conceito:** Mantenha o design e o fluxo da aplicação o mais diretos, legíveis e simples possível, evitando soluções desnecessariamente rebuscadas.
- **Aplicação no Projeto:** A estrutura de pastas segue uma divisão limpa em três partes (`models/` para tipagem estrita, `services/` para lógica de negócio e regras eleitorais, e a camada visual em Material 3 utilizando `NavigationBar` nativo), garantindo compreensão rápida do código.

### Comentários no Código
- **Conceito:** Comentários devem justificar a regra de negócio ou a motivação por trás de uma decisão técnica, nunca repetir de forma óbvia aquilo que a própria sintaxe do código já expressa.

---

## 4. Diferença entre `camelCase` e `snake_case`

| Convenção | Definição | Onde é Aplicada | Exemplo no Projeto |
| :--- | :--- | :--- | :--- |
| **`camelCase`** | A primeira palavra inicia com letra minúscula e cada palavra posterior inicia com letra maiúscula, sem espaços ou pontuação. | Padrão formal da linguagem Dart para variáveis, métodos, propriedades e nomes de parâmetros. | `calcularBarreiraIndividual`, `votosValidos`, `tetoVereador` |
| **`snake_case`** | Todas as palavras são escritas em minúsculo e separadas pelo caractere sublinhado (`_`). | Padrão para chaves de dados no arquivo JSON, nomes de arquivos `.dart` e nomes de pastas. | `dados_estacao_model.dart`, `"vagas_camara"`, `"codigo_ibge"` |

---

## 5. Aceita Emoji?

- **Onde é aceito:** Em arquivos de documentação (`README.md`), mensagens de commit no Git, mensagens de log informativo e textos de interface voltados ao usuário final (rótulos de botões, títulos de cards e avisos), pois o formato Unicode UTF-8 oferece suporte integral.
- **Onde NÃO deve ser utilizado:** Na sintaxe interna do código-fonte (nomes de classes, variáveis, métodos, constantes), nomes de branches no Git, chaves de dicionários JSON ou nomes de arquivos e pastas. O uso nesses locais quebra analisadores estáticos (linters), dificulta a legibilidade em terminais legados e pode inviabilizar pipelines de integração contínua (CI/CD).

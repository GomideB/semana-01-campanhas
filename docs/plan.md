# Plan — Análise de Campanhas de Marketing

## Contexto

Uma rede de varejo alimentício rodou 6 campanhas de marketing nos últimos 2 anos.
A taxa de aceite é baixa e o time quer saber para quem direcionar a próxima
campanha e por qual canal, para reduzir custo e aumentar conversão.

## 5W2H

| Pergunta | Resposta |
|---|---|
| **What** (o quê) | Analisar o perfil dos clientes que aceitam campanhas e seu canal de compra |
| **Why** (por quê) | Direcionar a próxima campanha e aumentar a taxa de aceite |
| **Where** (onde) | Base de clientes do varejo (dataset Kaggle) |
| **When** (quando) | Semana 1 do desafio, 7 dias |
| **Who** (quem) | Bruno, como analista; público do resultado: gerente de marketing (fictício) |
| **How** (como) | Excel para leitura, Python para limpeza e EDA, SQL para KPIs, Power BI para dashboard |
| **How much** (quanto) | Custo zero: ferramentas gratuitas e base pública |

## Hipóteses

> Variável principal: taxa de aceite da última campanha (`Response`).
> Variável de apoio: total de campanhas aceitas (soma de `AcceptedCmp1` a `AcceptedCmp5` + `Response`).
> Importante: consumir mais não é o mesmo que aceitar mais ofertas. As hipóteses estão separadas entre quem aceita (direcionamento) e quem consome (desenho da oferta).

### Grupo A — Quem aceita campanhas

**H1 — Renda**
Clientes com renda mais alta aceitam mais campanhas.
- **Expectativa:** relação positiva: quanto maior a faixa de renda, maior a taxa de aceite.
- **Como testar:** dividir `Income` em quartis e comparar a taxa de aceite entre eles.
- **Resultado (Dia 5):**

**H2 — Canal web**
Clientes com maior proporção de compras online aceitam mais campanhas.
- **Expectativa:** quem compra mais pela web é mais engajado com ofertas e aceita mais.
- **Como testar:** proporção web = `NumWebPurchases` / (web + catálogo + loja); comparar a taxa de aceite por faixa de proporção.
- **Resultado (Dia 5):**

**H3 — Nunca comprou online**
Clientes que nunca compraram online não são bom público para a campanha.
- **Expectativa:** taxa de aceite bem abaixo da média para quem tem `NumWebPurchases` = 0.
- **Como testar:** comparar a taxa de aceite entre `NumWebPurchases` = 0 e > 0.
- **Resultado (Dia 5):**

**H4 — Idade**
Clientes mais jovens têm maior consumo de ofertas digitais do que os mais velhos.
- **Expectativa:** faixas mais jovens com maior proporção de compras web, mais visitas ao site e maior taxa de aceite.
- **Como testar:** idade calculada a partir de `Year_Birth` com o ano de referência da base; comparar por faixa etária a proporção web, `NumWebVisitsMonth` e a taxa de aceite.
- **Resultado (Dia 5):**

**H5 — Histórico de aceite**
Clientes que já aceitaram uma campanha anterior têm muito mais chance de aceitar a última.
- **Expectativa:** [quanto mais chance? o dobro, o triplo?]
- **Como testar:** comparar `Response` entre quem aceitou ao menos uma de `AcceptedCmp1` a `AcceptedCmp5` e quem nunca aceitou.
- **Resultado (Dia 5):**

### Grupo B — Quem consome mais

**H6 — Renda e gasto**
Clientes com renda mais alta gastam mais.
- **Expectativa:** relação positiva entre renda e gasto total.
- **Como testar:** gasto total = soma das colunas `Mnt`; comparar por quartil de `Income`.
- **Resultado (Dia 5):**

**H7 — Filhos**
Clientes com filhos e adolescentes em casa consomem mais.
- **Expectativa:** domicílios com filhos têm gasto total maior. (Contraponto: o roteiro sugere que clientes sem filhos aceitam mais campanhas; testar gasto e aceite juntos.)
- **Como testar:** comparar gasto total e taxa de aceite entre quem tem e quem não tem `Kidhome` + `Teenhome` > 0.
- **Resultado (Dia 5):**

**H8 — Estado civil**
Clientes casados consomem mais do que solteiros e viúvos.
- **Expectativa:** grupo "com parceiro" (Married, Together) com gasto maior que o grupo "sem parceiro" (Single, Divorced, Widow).
- **Como testar:** agrupar `Marital_Status` e comparar o gasto total; categorias inválidas tratadas na limpeza.
- **Resultado (Dia 5):**

**H9 — Cesta de compras**
Algumas categorias de alimentos são compradas juntas, o que abre espaço para promoção casada.
- **Expectativa:** [quais categorias você acha que andam juntas? ex.: vinho e carne]
- **Como testar:** matriz de correlação entre as colunas `Mnt`.
- **Resultado (Dia 5):**

## KPIs

| KPI | Fórmula | Por que importa | Hipóteses |
|---|---|---|---|
| Taxa de aceite por campanha | clientes que aceitaram ÷ total de clientes (para cada `AcceptedCmp1` a `AcceptedCmp5` e `Response`) | Mostra qual campanha funcionou melhor e a evolução ao longo do tempo | Contexto |
| Taxa de resposta da última campanha | soma de `Response` ÷ total de clientes | Principal variável de resultado; é a base de comparação de todos os segmentos | Todas do Grupo A |
| Taxa de aceite por segmento | soma de `Response` no segmento ÷ clientes do segmento | Compara a resposta entre grupos (renda, idade, canal, filhos) | H1, H2, H3, H4, H7 |
| Lift | taxa de aceite do segmento ÷ taxa de aceite geral | Mostra quantas vezes um público responde acima ou abaixo da média; base da recomendação de direcionamento | H1, H2, H3, H4, H5 |
| Taxa de engajamento | clientes que aceitaram ao menos 1 campanha ÷ total de clientes | Mede o tamanho da base já responsiva a ofertas | H5 |
| Gasto total por cliente | soma das 6 colunas `Mnt` | Mede o valor do cliente | H6, H7, H8 |
| Mix de canal | compras por canal ÷ compras totais (web + catálogo + loja) | Mostra onde o cliente compra; a proporção web é usada nas hipóteses de canal e idade | H2, H3, H4 |
| Ticket médio | gasto total ÷ compras totais (web + catálogo + loja) | Mede o valor por compra | H6, H8 |

**Notas de cálculo**
- `NumDealsPurchases` não entra no total de compras, porque compras com desconto já estão contadas nos canais.
- Clientes com zero compras ficam fora do ticket médio e do mix de canal (divisão por zero); tratamento definido na limpeza.

**Limitação**
- A base não tem custo por campanha nem por canal (`Z_CostContact` e `Z_Revenue` são constantes). Não é possível calcular CPA ou ROI diretamente; a redução de custo será estimada pelo direcionamento, ou seja, impactar menos clientes com maior taxa de aceite.

## Problemas encontrados na exploração inicial

| Coluna | Problema | Linhas afetadas | Tratamento previsto (Dia 2) |
|---|---|---|---|
| `Year_Birth` | Anos de nascimento antes de 1901 (1893, 1899, 1900) | 3 | Remover ou tratar como idade desconhecida |
| `Marital_Status` | Categorias inválidas: Absurd, YOLO | 4 | Remover ou classificar como desconhecido |
| `Marital_Status` | Categoria Alone, equivalente a Single | 3 | Agrupar em Single |
| `Income` | Células vazias | 24 | Remover ou imputar (decidir no Dia 2) |
| `Income` | Outlier extremo: 666.666 | 1 | Remover da análise |
| `Income` | Valor 7.500 repetido muitas vezes | 12 | Investigar se é valor padrão do sistema |
| `Income` | Rendas muito baixas (abaixo de 5.000) | 6 | Investigar coerência com o gasto |
| `Income` | Faixa de 150 mil a 162 mil | 6 | Manter; validar coerência com o gasto na EDA |
| `Z_CostContact`, `Z_Revenue` | Valores constantes | Todas | Remover |

**Impacto estimado:** os problemas com remoção prevista (Year_Birth, categorias inválidas, Income vazio e outlier) somam até 32 linhas, cerca de 1,4% da base de 2.240 clientes. A perda é pequena e não compromete a análise.
-- KPI 1: Taxa de resposta geral
SELECT
    COUNT(*)                          AS total_clientes,
    SUM(Response)                     AS responderam,
    ROUND(AVG(Response) * 100, 2)     AS taxa_resposta_pct
FROM 'data/processed/clientes_limpo.csv';

-- KPI 2: Taxa de resposta por faixa de renda e filhos (H1, H7)
SELECT
    Faixa_Renda,
    Tem_Filhos,
    COUNT(*)                          AS clientes,
    ROUND(AVG(Response) * 100, 2)     AS taxa_resposta_pct
FROM 'data/processed/clientes_limpo.csv'
GROUP BY Faixa_Renda, Tem_Filhos
ORDER BY Faixa_Renda, Tem_Filhos;

-- KPI 3: Mix de canal por resposta (H2)
SELECT
    Response,
    ROUND(SUM(NumWebPurchases)     * 100.0 / SUM(Compras_Total), 1) AS pct_web,
    ROUND(SUM(NumCatalogPurchases) * 100.0 / SUM(Compras_Total), 1) AS pct_catalogo,
    ROUND(SUM(NumStorePurchases)   * 100.0 / SUM(Compras_Total), 1) AS pct_loja
FROM 'data/processed/clientes_limpo.csv'
GROUP BY Response;

-- KPI 4: Resposta por histórico de campanhas (H5)
SELECT
    Ja_Aceitou,
    COUNT(*)                          AS clientes,
    ROUND(AVG(Response) * 100, 2)     AS taxa_resposta_pct
FROM 'data/processed/clientes_limpo.csv'
GROUP BY Ja_Aceitou;

-- KPI 5: Valor do cliente por segmento (H6)
SELECT
    Faixa_Renda,
    ROUND(AVG(Gasto_Total), 0)        AS gasto_medio,
    ROUND(AVG(Ticket_Medio), 1)       AS ticket_medio
FROM 'data/processed/clientes_limpo.csv'
GROUP BY Faixa_Renda
ORDER BY Faixa_Renda;

-- KPI 6: Taxa de engajamento (aceitou ao menos 1 das 6 campanhas)
SELECT
    COUNT(*)                                              AS total_clientes,
    SUM(CASE WHEN Engajado = 'Sim' THEN 1 ELSE 0 END)     AS engajados,
    ROUND(AVG(CASE WHEN Engajado = 'Sim' THEN 1 ELSE 0 END) * 100, 2) AS taxa_engajamento_pct
FROM 'data/processed/clientes_limpo.csv';

-- KPI 7: Resposta e lift por compra online (H3)
SELECT
    Comprou_Online,
    COUNT(*)                          AS clientes,
    ROUND(AVG(Response) * 100, 2)     AS taxa_resposta_pct,
    ROUND(AVG(Response) / (SELECT AVG(Response) FROM 'data/processed/clientes_limpo.csv'), 2) AS lift
FROM 'data/processed/clientes_limpo.csv'
GROUP BY Comprou_Online;

-- KPI 8: Resposta e lift por faixa etária (H4)
SELECT
    Faixa_Etaria,
    COUNT(*)                          AS clientes,
    ROUND(AVG(Response) * 100, 2)     AS taxa_resposta_pct,
    ROUND(AVG(Response) / (SELECT AVG(Response) FROM 'data/processed/clientes_limpo.csv'), 2) AS lift
FROM 'data/processed/clientes_limpo.csv'
GROUP BY Faixa_Etaria
ORDER BY MIN(Idade);

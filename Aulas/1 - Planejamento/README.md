# 📊 Dataset

Este dataset (`chamados.csv`) contém **5.000 registros** de chamados de suporte, com informações detalhadas sobre cada ticket, dados do cliente, métricas do histórico e a categoria final do chamado. Foi preparado para fins de análise exploratória e modelagem de classificação.

---

## 📁 Estrutura do Dataset

O arquivo possui **44 colunas** (listadas abaixo) e a coluna `target_category` (categoria alvo) está posicionada como **última coluna** para facilitar o uso em algoritmos de aprendizado supervisionado. 

*Nota: Algumas colunas possuem sufixos `_x` e `_y` gerados automaticamente pelo processo de junção (merge) de dados de diferentes fontes.*

### Colunas originais do chamado

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| `ticket_id` | int | Identificador único do chamado |
| `created_at` | datetime | Data/hora de abertura (formato ISO) |
| `customer_id` | int | ID do cliente (chave para dados do cliente) |
| `department` | str | Departamento responsável (ex: TI, Financeiro) |
| `city_x` | str | Cidade onde o chamado foi registrado |
| `state_x` | str | Estado (UF) onde o chamado foi registrado |
| `device_type` | str | Tipo de dispositivo (Desktop, Notebook, Mobile) |
| `os` | str | Sistema operacional (Windows, Linux, Android, iOS) |
| `browser` | str | Navegador utilizado (Chrome, Safari, Firefox, Edge) |
| `network_type` | str | Tipo de rede (WiFi, 5G, 4G, Cabo) |
| `historical_tickets` | int | Número de chamados anteriores do mesmo cliente |
| `sla_hours` | int | Prazo de atendimento (horas) |
| `resolution_time_hours` | int | Tempo total até a resolução (horas) |
| `title` | str | Título resumido do chamado |
| `description` | str | Descrição detalhada (enriquecida) |
| `image_path` | str | Caminho para a imagem associada (referência) |
| `image_width` | int | Largura da imagem (pixels) |
| `image_height` | int | Altura da imagem (pixels) |
| `priority` | str | Prioridade (Baixa, Média, Alta, Crítica) |
| `status` | str | Situação atual (Aberto, Em andamento, Fechado) |
| `assigned_team` | str | Equipe designada (N1, N2, Infra, Aplicações) |
| `has_attachment` | bool | Indica se há anexo (1 = sim, 0 = não) |
| `sentiment_score` | float | Pontuação de sentimento (entre -1 e 1) |
| `num_words` | int | Número de palavras na descrição |
| `num_images_x` | int | Quantidade de imagens anexadas no chamado original |
| `latitude` | float | Coordenada geográfica (latitude) |
| `longitude` | float | Coordenada geográfica (longitude) |

### Dados do cliente (incorporados)

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| `company` | str | Nome da empresa cliente |
| `segment` | str | Segmento de atuação (ex: Financeiro, Saúde) |
| `employees` | int | Número de funcionários |
| `city_y` | str | Cidade da sede do cliente |
| `state_y` | str | Estado da sede do cliente |
| `contract_type` | str | Tipo de contrato (Premium, Standard, Enterprise) |
| `customer_since` | date | Data de início do relacionamento |
| `vip` | str | Cliente VIP? (Sim / Não) |
| `monthly_revenue` | int | Faturamento mensal estimado (R$) |

### Métricas do histórico

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| `num_events` | int | Total de eventos registrados no histórico |
| `last_event_date` | datetime | Data do último evento (pode estar vazio) |
| `event_types` | str | Tipos de eventos ocorridos (separados por `\|`) |
| `num_abertura` | int | Quantos eventos de abertura |
| `num_updates` | int | Quantos eventos de atualização |
| `num_encerramento` | int | Quantos eventos de encerramento |
| `num_images_y` | int | Quantidade total de imagens anexadas durante o histórico do chamado |

### Coluna alvo

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| `target_category` | str | **Categoria final do chamado** (Hardware, Software, Rede, RH, Financeiro, Acesso) |

---

## 🧠 Sobre os Dados

- **Descrições e títulos** foram gerados a partir de templates adaptados a cada categoria, tornando o texto mais rico para experimentos de NLP.
- As **imagens** referenciadas nos caminhos não estão incluídas no dataset; apenas os caminhos são mantidos.
- Dados de clientes e histórico podem apresentar valores nulos caso não haja correspondência.
- As colunas de cidade, estado e número de imagens possuem os sufixos `_x` (referentes ao chamado) e `_y` (referentes ao cliente ou histórico) devido à mesclagem das bases.

---

## 🚀 Exemplos de Uso

### Carregar com Pandas

```python
import pandas as pd

df = pd.read_csv('raw/chamados.csv')
print(df.shape)  # (5000, 44)
df.head()

```

### Análise exploratória

```python
# Distribuição das categorias
df['target_category'].value_counts(normalize=True)

# Média de tempo de resolução por prioridade
df.groupby('priority')['resolution_time_hours'].mean()

# Correlação entre sentimento e tempo de resolução
df[['sentiment_score', 'resolution_time_hours']].corr()

```

### Preparação para classificação

```python
# Separar features e target
X = df.drop(columns=['target_category'])
y = df['target_category']

# Identificar colunas categóricas
categoricas = X.select_dtypes(include=['object']).columns.tolist()
# Aplicar One‑Hot Encoding, LabelEncoder, etc.

```

### Visualização geográfica

```python
import folium

mapa = folium.Map(location=[-15, -50], zoom_start=4)
for _, row in df.sample(100).iterrows():
    folium.CircleMarker(
        location=[row['latitude'], row['longitude']],
        popup=row['target_category'],
        radius=3,
        color='red' if row['priority']=='Crítica' else 'blue'
    ).add_to(mapa)
mapa.save('mapa_chamados.html')

```

---

## ⚠️ Considerações Importantes

* O dataset é **sintético** e foi gerado para fins educacionais e de demonstração; não reflete dados reais.
* As colunas de histórico podem estar vazias (zeros) para chamados sem eventos.
* A categoria `target_category` já está no final, facilitando o uso direto em modelos.
* Os caminhos das imagens (`image_path`) correspondem a imagens na pasta "/images".

---

## 📄 Licença

Este dataset é disponibilizado para fins de aprendizado e experimentação. Fique à vontade para utilizá‑lo em projetos acadêmicos ou de estudo.

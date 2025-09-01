## Projeto Python Portátil com Ambiente Isolado (`python-embed` + `.venv`)

Este repositório é um **template de projeto Python 100% isolado e portátil**, sem depender de instalações globais. Ideal para testes, automações, ferramentas CLI, experimentos e execução offline.

---

> ⚙️ **Flexibilidade:** É possível usar este ambiente com projetos próprios ou de terceiros. Basta colocar o código na pasta do projeto e usar o script `tool_install_deps.bat` para instalar as dependências. O template é compatível, em teoria, com qualquer versão do Python Embedded suportada — desde que seja compatível com virtualenv..

---

### 📁 Estrutura do Projeto

```
SeuProjeto/
├── python-embed/                     ← Python portátil (Python Embedded)
│   └── python.exe + arquivos embed
├── .venv/                            ← Ambiente virtual criado automaticamente
├── data/                             ← Simulação de pastas de sistema isoladas (AppData, Temp etc)
├── tools/
│   └── procmon/                      ← (opcional) Sysinternals Process Monitor + config
├── initial_configure_python-embed.bat  ← Faz toda a configuração inicial
├── start_ambiente.bat               ← Ativa o ambiente virtual no terminal
├── tool_install_deps.bat            ← Instala pacotes do requirements.txt
├── tool_export_env.bat              ← Gera requirements.txt com pip freeze
├── tool_clean_cache.bat             ← Limpa cache e arquivos temporários do pip
├── tool_copy_VSCode_configs.bat     ← Copia configurações do seu VSCode para o ambiente isolado
├── tool_monitor_exec.bat            ← Executa o Procmon para monitorar o Python isolado
├── .gitignore
└── README.md
```

---

### 🚀 Como Usar

#### **Passos Obrigatórios**

Para ter o ambiente Python portátil isolado funcionando, execute na ordem:

---

##### 1. 📥 Baixar Python Embedded (OBRIGATÓRIO)

* Site: [https://www.python.org/downloads/windows/](https://www.python.org/downloads/windows/)
* Baixe o **"Windows embeddable package"** (arquivo `.zip`)
* Extraia o conteúdo dentro da pasta `python-embed/`

---

##### 2. ⚙️ Configurar o Python Portátil (OBRIGATÓRIO)

Execute uma vez para configurar o ambiente:

```bat
initial_configure_python-embed.bat
```

Esse script irá:

* Habilitar o `import site`
* Instalar o `pip`
* Instalar o `virtualenv`
* Criar o ambiente `.venv`
* Configurar variáveis de ambiente isoladas (`APPDATA`, `TEMP`, `HOME`, etc.)
* Criar o arquivo `infoVersion_python<versao>.txt`

---

##### 3. 🧪 Ativar o Ambiente Isolado (OBRIGATÓRIO)

Sempre que for trabalhar dentro do ambiente isolado, execute:

```bat
start_ambiente.bat
```

Isso abrirá um terminal com todas as variáveis apontando para a pasta isolada (`data/`).

---

#### **Ferramentas Opcionais**

As ferramentas abaixo são auxiliares e usadas conforme sua necessidade:

---

##### 4. 📦 Instalar Dependências

```bat
tool_install_deps.bat
```

Instala pacotes listados em `requirements.txt` no ambiente virtual.

---

##### 5. 📤 Exportar Dependências

```bat
tool_export_env.bat
```

Atualiza o `requirements.txt` com os pacotes instalados no ambiente.

---

##### 6. 🧹 Limpar Cache e Arquivos Temporários

```bat
tool_clean_cache.bat
```

> **Importante:** Esse script limpa as pastas de cache e temporários de `pip` e do sistema.

Ele **não verifica onde está sendo executado**. Portanto:

* Se executado **dentro do ambiente isolado** (terminal ativado via `start_ambiente.bat`), limpará as pastas de cache e temporários **dentro da pasta `data/` isolada**.
* Se executado **fora do ambiente isolado** (ex: prompt normal do Windows), limpará as pastas reais do sistema.

Use com cuidado dependendo do contexto em que estiver.

---

##### 7. 🖥️ Usar VSCode ou Outras IDEs

Para garantir que o VSCode **herde o ambiente isolado corretamente**, **abra o terminal com o script `start_ambiente.bat`** e depois execute:

```bat
code .
```

Isso vai abrir o VSCode com:

* Variáveis de ambiente já configuradas
* Terminal interno isolado
* Capacidade de instalar a extensão do Python **sem afetar o sistema**
* Debug e execução funcionais com o Python isolado

---

#### 📁 Importar Configurações do VSCode

Se quiser importar suas configurações atuais do VSCode para o ambiente isolado, execute:

```bat
tool_copy_VSCode_configs.bat
```

Alternativamente, você pode copiar manualmente a pasta de configurações para:

```
data\UserProfile\.vscode
```

> Essa técnica também funciona com outras IDEs, desde que você saiba onde ficam as pastas de configuração e copie para o local correspondente em `data/`.

---

### 🕵️‍♂️ Monitoramento com Process Monitor (`Procmon`)

#### O que é?

O **Procmon** (Process Monitor) da Sysinternals é uma ferramenta para monitorar **em tempo real** todas as interações de processos com o sistema de arquivos, registro e muito mais.

#### Como usar

1. Baixe o `Procmon` aqui:
   👉 [https://learn.microsoft.com/en-us/sysinternals/downloads/procmon](https://learn.microsoft.com/en-us/sysinternals/downloads/procmon)

2. Extraia e coloque o executável (`Procmon.exe`) na pasta:

```
tools/procmon/
```

3. Execute:

```bat
tool_monitor_exec.bat
```

> Isso abrirá o `Procmon` com um filtro pré-configurado para monitorar o processo `python.exe`.

---

#### 🧱 Limitações do Procmon

* O filtro não usa **caminhos relativos**, então captura *todos os `python.exe`* do sistema.
* **Atenção**: Isso pode misturar eventos de Python externos com o da pasta isolada.
* Por padrão, o filtro **não ignora a própria pasta do projeto**.

---

#### 🔧 Dica: Configurar Filtros no Procmon Manualmente

##### 🔹 Para excluir a pasta do projeto:

1. No menu, clique em **Filter → Filter...**
2. Adicione o filtro:

   * `Path` → `begins with` → `<CAMINHO_ABSOLUTO_DO_PROJETO>\` → **Exclude**

##### 🔹 Para focar apenas no Python do projeto:

1. Adicione o filtro:

   * `Image Path` → `is` → `<CAMINHO_ABSOLUTO_DO_PROJETO>\.venv\Scripts\python.exe` → **Include**

> Opcionalmente, pode também adicionar o filtro para o Python embutido original:

> * `Image Path` → `is` → `<CAMINHO_ABSOLUTO_DO_PROJETO>\python-embed\python.exe` → **Include**

> Porém normalmente isso não é necessário, já que a aplicação rodará usando o Python do `.venv`.

---

### 📁 Sobre a Pasta `data/`

Todas as variáveis de ambiente e caminhos do usuário são redirecionados para dentro da pasta `data/`:

| Variável                | Caminho Relativo       |
| ----------------------- | ---------------------- |
| `%APPDATA%`             | `data\AppData\Roaming` |
| `%LOCALAPPDATA%`        | `data\AppData\Local`   |
| `%TEMP%`, `%TMP%`       | `data\Temp`            |
| `%USERPROFILE%`         | `data\UserProfile`     |
| `%PYTHONUSERBASE%`      | `data\PythonUserBase`  |
| `%PYTHONPYCACHEPREFIX%` | `data\__pycache__`     |

Isso garante que **nenhuma configuração, cache ou arquivo temporário vá parar no sistema** do usuário.

---

### 📌 Requisitos

* **Windows**
* Nenhum Python instalado no sistema é necessário
* Todo o ambiente é executado localmente a partir da pasta do projeto

---

### ✅ Benefícios e Considerações Importantes

* 🔒 100% isolado e portátil
* 🧼 Sem "sujar" o sistema
* ⚙️ Comportamento previsível e versionável
* 🧰 Scripts prontos para automação
* 🧠 Ideal para estudos, testes e execução local

> ⚠️ Embora o projeto esteja estável e funcional para diversos usos, devido à sua complexidade e abrangência — especialmente ao executar projetos de terceiros — é recomendável realizar testes específicos para garantir que atenda aos requisitos do seu caso, especialmente se considerar distribuir para ambientes de produção. Essa é uma possibilidade, mas recomenda-se cautela e avaliação cuidadosa antes de seguir por esse caminho.

> 🛠️ O projeto é baseado em **virtualenv**, que automatiza a configuração do ambiente isolado sem necessidade de Python instalado no sistema. Por conta dessa abordagem, **não é compatível com Conda** nem com projetos que dependam de frameworks externos nativos ou que não funcionem com ambientes virtuais tradicionais.

> Para distribuição final, recomenda-se “enxugar” o projeto, removendo ferramentas auxiliares como o Procmon e scripts que não sejam estritamente necessários para execução.

---

### 🧠 Dica Final

> Use este projeto como **template** para outros ambientes Python portáteis. Basta copiar a estrutura, colar em outro lugar e rodar o `initial_configure_python-embed.bat`.

---
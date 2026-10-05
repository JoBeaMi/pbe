# Estilo do livro (fixado 12-09-2026, versão 4 de 13-09-2026, escolhido pela Joana a partir de nove direções)

O livro chama-se "E agora? O que fazemos com a evidência?" (subtítulo "Da pergunta clínica à decisão partilhada") e é sobre prática baseada na evidência. É intemporal e da Joana, não da cadeira: título sem sigla, capítulos organizados pelo que se aprende, em três partes (Parte I Ler números; Parte II Do problema ao protocolo; Parte III Da evidência à decisão, prometida no prefácio e por escrever), e cada cadeira/ano é uma página em percursos/ (datas, ordem dos capítulos, enunciado, grelha). Nada de datas, FUC, RUC ou nomes de escola fora de percursos/. As respostas das turmas entram nos capítulos, sem nomes e sem ano. O livro cresce ao ritmo das aulas: nada se escreve antes de fazer falta.

Aspeto: títulos em Archivo 900, corpo em Newsreader, números em JetBrains Mono; uma cor só, o amarelo ácido (#e8ff47), com rosa (#ffb0d6) apenas como segundo marcador; preto de tinta. Nada de caixas pastel, ícones, emojis, gradientes, nem o ponto no meio da linha (" · "): separa-se com vírgula ou travessão. Tudo está em style.css; não se inventa CSS por capítulo.

Arquitetura de cada capítulo (NN-tema.qmd), pela ordem da aula:
1. Título curto, com a parte que interessa marcada: `# O que quer dizer [p < ,01]{.hl}?`. Primeiro parágrafo em prosa: o estudo em duas frases (desenho, n, população, intervenção, comparador) e "a leitura que se segue é a que fizemos na aula".
2. O fio (`::: {.fio}`), com três vozes, sempre nesta ordem:
   - `::: {.msg}` + `<div class="quem">O artigo</div>` + `::: {.clip}` com a frase REAL do artigo (resumo ou resultados), com as partes que interessam marcadas `[...]{.mk}` (amarelo) e `[...]{.mk .p}` (rosa), e `<span class="src">Autor (ano), Revista vol(n), secção</span>`.
   - `::: {.msg .turma}` + `<div class="quem">A turma, no quadro</div>` + as leituras em `<span class="b">...</span>`, sem nomes; as que apareceram de facto entram depois do registo pós-aula.
   - `::: {.msg}` + `<div class="quem">A explicação</div>` + `::: {.jm}` (a nota da docente, uma ou duas por capítulo, nunca mais; começa em minúscula, como uma nota à margem) + `::: {.nums}` com `<div class="num">40<small>legenda</small></div>` para os números do artigo de que o texto fala + a prosa da explicação.
3. `::: {.def}` com a definição (o rótulo "O que é de facto" é automático). Uma por conceito.
4. `::: {.quiz data-certa="n"}` com `<p class="enunciado">Q<cap>.<n> ...</p>`, três `<label><input type="radio" name="qXY" value="k"> ...</label>`, `<button type="button">Verificar</button> <span class="resultado"></span>` e `<p class="explicacao">...</p>`. Pelo menos um por secção.
5. Fim fixo: "## O que fica" (três frases), "## Exercícios" (frases de resultados reais, com fonte), "## Para ler mais" (@irwin2026 com páginas; artigos por @chave). Nenhuma chave entra no .bib sem verificação no Crossref (api.crossref.org/works/DOI: título, autores, ano, revista) registada em bibliografia/verificacao_AAAA-MM-DD.csv; o .bib é gerado por _scripts/gerar_bib.py a partir desse registo, não se edita à mão. A página "Para ler" (bibliografia.qmd) diz para que serve cada referência, por capítulo.

Exemplos: sempre artigos reais, com DOI verificado e os números tal como estão no resumo ou no texto (citar a secção). Nunca frases inventadas a fingir de artigo; se for preciso um caso construído (dados para o Jamovi), diz-se que é construído.

Imagens e gráficos (fixado 13-09-2026):
- Gráficos nascem em blocos de R dentro do .qmd, na paleta do livro (amarelo, rosa, preto de tinta, cinzentos); refazem-se sozinhos quando um número muda. `execute: freeze: auto` está ligado no _quarto.yml: renderiza-se no RStudio, a pasta `_freeze/` vai com o push, e o GitHub Actions só monta o site, sem R.
- Ficheiros de imagem em `imagens/`, nome em minúsculas com hífens (`02-quadro-correlacao.jpg`). Toda a figura tem legenda e texto alternativo (`fig-alt`). Fotografias comprimidas (jpg ou webp, abaixo de 500 KB). Fotografias do quadro sem caras nem nomes de estudantes.
- Imagens engraçadas (cartoons, tiras, ilustrações) vão para a margem (`column: margin`), nunca no fio do texto, e levam a atribuição e a licença na legenda.
- Fontes permitidas: fotografias, desenhos e fotografias do quadro da Joana; capturas de ecrã do Jamovi; gráficos redesenhados a partir dos números de um artigo (citando o artigo e a tabela/figura de origem); xkcd (CC BY-NC 2.5; atribuir "xkcd.com/NNN, Randall Munroe"); ilustrações de Allison Horst (CC BY 4.0; atribuir "Artwork by @allison_horst"); SVG desenhados de propósito no estilo do livro.
- Fontes proibidas: figuras ou tabelas copiadas de artigos ou do Irwin & Donai; memes e imagens apanhadas na internet; tiras de jornal; fotogramas de filmes ou séries. Imagens geradas por IA evitam-se; se alguma entrar, a legenda diz que é gerada.

Voz: primeira pessoa do plural para caminhar; segunda do singular nas tarefas; a nota JM em primeira do singular; o prefácio em primeira do singular. PT-PT. Verbos simples; o termo técnico repete-se; humor raro e só à custa de um número. Comparativos colados ao inglês ("mais estreito" por narrower, "mais largo" por broader) não entram: procurar de propósito na revisão. Passagem final obrigatória com references/sinais-ia.md da skill escrita-academica; zero [...] de trabalho; cada número com origem.

Glossário bilingue: cada termo em português com o equivalente em inglês entre parênteses e o capítulo onde foi trabalhado.

O que nunca entra: notas de docente, tempos, plano B, [CONFIRMAR], nomes de estudantes, figuras ou passagens do Irwin & Donai (só citação com página), dados de pessoas reais, valores normativos, listas onde devia haver prosa.

## Estilo de prosa (fixado 28-09-2026)

Sem metáforas para descrever o livro ("três vozes", "o fio", "o caminho", "o artigo fala"): diz-se o que está em cada capítulo, por que ordem e o que fazer. Sem frases-slogan, sem "não é X, é Y" como fecho, sem perguntas retóricas em série. As notas JM podem ter opinião, mas com o mesmo cuidado.

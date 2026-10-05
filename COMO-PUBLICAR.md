# Como publicar o livro (uma vez)

1. Em github.com/JoBeaMi, criar um repositório novo chamado `pbe` (público, vazio, sem README).
2. No Terminal do Mac (ou no terminal do RStudio), dentro da pasta `livro/`:

    git init -b main
    git add .
    git commit -m "Livro da UC: estrutura"
    git remote add origin https://github.com/JoBeaMi/pbe.git
    git push -u origin main

3. O ramo `gh-pages` (onde o site fica) já existe; não é preciso criá-lo. NUNCA correr `git rm -rf .` na pasta do livro.

4. No GitHub: Settings → Pages → Source: "Deploy from a branch" → Branch: gh-pages / (root) → Save.

A partir daqui, cada `git push` para `main` renderiza e publica sozinho (separador Actions mostra o progresso, 2–3 minutos). O livro fica em https://joanamiguel.pt/pbe/ (e também em https://jobeami.github.io/pbe/ até o domínio estar ligado).

# Cada capítulo novo

O capítulo chega à pasta `livro/` já pronto (ficheiro `sNN-....qmd`) e com a linha correspondente descomentada em `_quarto.yml`. Para o ver antes de publicar: abrir a pasta no RStudio e carregar em Render (ou `quarto preview` no terminal). Para publicar:

    git add .
    git commit -m "S01"
    git push

# Domínio joanamiguel.pt (feito uma vez, 12-09-2026)

Registado no .PT (5 anos, até 2031-09-12). DNS na deSEC (ns1.desec.io / ns2.desec.org): quatro registos A para o GitHub Pages
(185.199.108.153, .109.153, .110.153, .111.153), CNAME www → jobeami.github.io, e o TXT de verificação do GitHub.
O domínio está associado ao repositório JoBeaMi.github.io (site de utilizador), não ao do livro: é isso que faz cada
repositório com Pages aparecer em joanamiguel.pt/<nome-do-repositório>. Não pôr "Custom domain" no repositório pbe.

# Nome do repositório (5-10-2026)

O repositório do livro chamava-se `e-agora` e passou a chamar-se `pbe` a 5-10-2026 (GitHub: Settings, Repository name). O livro fica em https://joanamiguel.pt/pbe/. O `git push` continua a funcionar com o endereço antigo, porque o GitHub redireciona; para acertar o endereço guardado na pasta, uma vez: `git remote set-url origin https://github.com/JoBeaMi/pbe.git`.

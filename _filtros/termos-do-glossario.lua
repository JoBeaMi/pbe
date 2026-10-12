-- Liga os termos do glossário nos capítulos.
--
-- O que faz:
--   * Na página do glossário, dá uma âncora a cada entrada (gl-desvio-padrão, etc.).
--   * Nos capítulos numerados (01-..., 02-...), a primeira vez que um termo do
--     glossário aparece passa a ser uma ligação para a sua entrada, com a definição
--     a aparecer ao passar o rato.
--   * Um termo não é ligado nos capítulos que o ensinam, que são os capítulos para
--     onde a entrada do glossário tem ligação.
--
-- O glossário (glossario.qmd) é a única fonte. Cada entrada é um parágrafo que
-- começa pelo termo a negrito e tem a definição depois dos primeiros dois pontos.
-- Para ligar também o plural ou outra forma de um termo, acrescenta-se no fim da
-- entrada um comentário, por exemplo:
--   <!-- formas: desvios-padrão -->
-- O plural em "s" dos termos de uma só palavra é ligado sem ser preciso escrevê-lo.
--
-- Para um termo ficar no glossário sem ser ligado nos capítulos (por exemplo uma
-- palavra corrente, usada com mais de um sentido), acrescenta-se à entrada:
--   <!-- não ligar -->
-- Para uma ocorrência em particular não ser ligada, escreve-se no capítulo
--   [palavra]{.sem-termo}

local texto = pandoc.text
local stringify = pandoc.utils.stringify

-- caixas dos capítulos onde não se põem ligações
local SALTAR = { clip = true, turma = true, quiz = true, jm = true, nums = true }

local ABRE = { "(", "[", "«", "“", "\"", "'" }
local FECHA = { ")", "]", "»", "”", "\"", "'", ".", ",", ";", ":", "!", "?", "…" }

local function apara(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end

local function slug(s)
  s = texto.lower(s):gsub("%s+", "-")
  s = s:gsub("[^%w%-\128-\255]", "")
  return s
end

-- separa a pontuação colada a uma palavra: "(mediana)," -> "(", "mediana", "),"
local function separa(s)
  local pre, suf = "", ""
  local mudou = true
  while mudou do
    mudou = false
    for _, a in ipairs(ABRE) do
      if #s > #a and s:sub(1, #a) == a then pre = pre .. a; s = s:sub(#a + 1); mudou = true end
    end
  end
  mudou = true
  while mudou do
    mudou = false
    for _, f in ipairs(FECHA) do
      if #s > #f and s:sub(-#f) == f then suf = f .. suf; s = s:sub(1, #s - #f); mudou = true end
    end
  end
  return pre, s, suf
end

local function pasta_do_projeto()
  if quarto and quarto.project and quarto.project.directory then return quarto.project.directory end
  return os.getenv("QUARTO_PROJECT_DIR") or "."
end

local function ficheiro_atual()
  local f = nil
  if quarto and quarto.doc and quarto.doc.input_file then f = quarto.doc.input_file end
  if not f and PANDOC_STATE and PANDOC_STATE.input_files then f = PANDOC_STATE.input_files[1] end
  if not f then return "" end
  return (f:match("([^/\\]+)$") or f):gsub("%.[%a_]+$", "")
end

local function e_entrada(b)
  return b.t == "Para" and b.content[1] and b.content[1].t == "Strong"
end

local function le_glossario()
  local f = io.open(pasta_do_projeto() .. "/glossario.qmd", "r")
  if not f then return {} end
  local fonte = f:read("a")
  f:close()
  local doc = pandoc.read(fonte, "markdown")
  local formas = {}
  for _, b in ipairs(doc.blocks) do
    if e_entrada(b) then
      local nome = stringify(b.content[1])
      local termo = { id = "gl-" .. slug(nome), casas = {}, def = "" }
      local extra = {}
      local ligar = true
      local limpo = b:walk({
        Link = function(l)
          local alvo = l.target:match("^([^#]+)")
          if alvo then
            alvo = alvo:gsub("%.qmd$", ""):gsub("%.html$", "")
            termo.casas[alvo] = true
          end
        end,
        RawInline = function(r)
          local fs = r.text:match("<!%-%-%s*formas:%s*(.-)%s*%-%->")
          if fs then for forma in fs:gmatch("[^,;]+") do extra[#extra + 1] = apara(forma) end end
          if r.text:match("<!%-%-%s*não ligar%s*%-%->") then ligar = false end
          return {}
        end
      })
      local tudo = stringify(limpo)
      local i = tudo:find(": ", 1, true)
      if i then termo.def = apara(tudo:sub(i + 2)) end
      local base = texto.lower(nome)
      local lista = { base }
      if not base:find(" ", 1, true) then lista[#lista + 1] = base .. "s" end
      for _, e in ipairs(extra) do lista[#lista + 1] = texto.lower(e) end
      if not ligar then lista = {} end
      for _, forma in ipairs(lista) do
        local tokens = {}
        for t in forma:gmatch("%S+") do tokens[#tokens + 1] = t end
        formas[#formas + 1] = { tokens = tokens, termo = termo, tam = #forma }
      end
    end
  end
  -- as formas mais compridas primeiro
  table.sort(formas, function(a, b)
    if #a.tokens ~= #b.tokens then return #a.tokens > #b.tokens end
    return a.tam > b.tam
  end)
  return formas
end

local function tenta(inls, i, forma)
  local n = #forma.tokens
  local j, pre, suf = i, "", ""
  local nucleos = {}
  for k = 1, n do
    local s = inls[j]
    if not s or s.t ~= "Str" then return nil end
    local p, nucleo, sx = separa(s.text)
    if k > 1 and p ~= "" then return nil end
    if k < n and sx ~= "" then return nil end
    if texto.lower(nucleo) ~= forma.tokens[k] then return nil end
    if k == 1 then pre = p end
    if k == n then suf = sx end
    nucleos[k] = nucleo
    if k < n then
      local sp = inls[j + 1]
      if not sp or (sp.t ~= "Space" and sp.t ~= "SoftBreak") then return nil end
      j = j + 2
    end
  end
  return j, pre, suf, nucleos
end

local function processa(inls, estado)
  local saida = pandoc.List()
  local i = 1
  while i <= #inls do
    local el = inls[i]
    local feito = false
    if el.t == "Str" then
      for _, forma in ipairs(estado.formas) do
        local termo = forma.termo
        if not estado.ligados[termo.id] and not termo.casas[estado.base] then
          local j, pre, suf, nucleos = tenta(inls, i, forma)
          if j then
            local conteudo = pandoc.List()
            for k, nucleo in ipairs(nucleos) do
              if k > 1 then conteudo:insert(pandoc.Space()) end
              conteudo:insert(pandoc.Str(nucleo))
            end
            if pre ~= "" then saida:insert(pandoc.Str(pre)) end
            saida:insert(pandoc.Link(conteudo, "glossario.html#" .. termo.id, "",
              pandoc.Attr("", { "termo" }, { { "data-def", termo.def } })))
            if suf ~= "" then saida:insert(pandoc.Str(suf)) end
            estado.ligados[termo.id] = true
            i = j + 1
            feito = true
            break
          end
        end
      end
    elseif el.t == "Span" and el.classes:includes("sem-termo") then
      -- ocorrência que a autora não quer ligada
    elseif el.t == "Emph" or el.t == "Strong" or el.t == "Span" or el.t == "Quoted" then
      el.content = processa(el.content, estado)
    end
    if not feito then
      saida:insert(el)
      i = i + 1
    end
  end
  return saida
end

local function blocos(bs, estado)
  for idx, b in ipairs(bs) do
    if b.t == "Para" or b.t == "Plain" then
      b.content = processa(b.content, estado)
      bs[idx] = b
    elseif b.t == "Div" then
      local salta = false
      for _, c in ipairs(b.classes) do
        if SALTAR[c] or c:match("^callout") then salta = true end
      end
      if not salta then
        blocos(b.content, estado)
        bs[idx] = b
      end
    elseif b.t == "BulletList" or b.t == "OrderedList" then
      for _, item in ipairs(b.content) do blocos(item, estado) end
      bs[idx] = b
    end
  end
end

function Pandoc(doc)
  local base = ficheiro_atual()

  if base == "glossario" then
    for idx, b in ipairs(doc.blocks) do
      if e_entrada(b) then
        local nome = stringify(b.content[1])
        local limpo = b:walk({ RawInline = function(r)
          if r.text:match("<!%-%-%s*formas:") or r.text:match("<!%-%-%s*não ligar") then return {} end
        end })
        doc.blocks[idx] = pandoc.Div({ limpo }, pandoc.Attr("gl-" .. slug(nome), { "gl-entrada" }))
      end
    end
    return doc
  end

  if not base:match("^%d%d%-") then return nil end

  local estado = { base = base, formas = le_glossario(), ligados = {} }
  blocos(doc.blocks, estado)
  return doc
end

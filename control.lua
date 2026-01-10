---------------------------------------------------------------------------------------------------
---[ control.lua ]---
---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------
---[ Cargar las funciones comunes ]---
---------------------------------------------------------------------------------------------------

require("__" .. "YAIM904-d00b-core" .. "__/control")

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------
---[ Información del MOD ]---
---------------------------------------------------------------------------------------------------

local This_MOD = GMOD.get_id_and_name()
if not This_MOD then return end
GMOD[This_MOD.id] = This_MOD

---------------------------------------------------------------------------------------------------

function This_MOD.start()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Validación
    if This_MOD.action then return end

    --- Ejecución de las funciones
    This_MOD.reference_values()
    This_MOD.load_events()

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.reference_values()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Combinación de teclas
    This_MOD.key_sequence = This_MOD.prefix .. This_MOD.name

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------
---[ Eventos programados ]---
---------------------------------------------------------------------------------------------------

function This_MOD.load_events()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Acciones comunes
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    script.on_event({
        defines.events.on_built_entity
    }, function(event)
        This_MOD.create_entity(This_MOD.create_data(event))
    end)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Acciones propias del MOD
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    script.on_event({
        This_MOD.key_sequence
    }, function(event)
        This_MOD.activate_tool(This_MOD.create_data(event))
    end)

    script.on_event({
        defines.events.on_lua_shortcut
    }, function(event)
        if event.prototype_name ~= This_MOD.prefix .. This_MOD.name then return end
        This_MOD.activate_tool(This_MOD.create_data(event))
    end)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------

function This_MOD.create_entity(Data)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if not Data.Entity or not Data.Entity.valid then return end
    if not GMOD.has_id(Data.Entity.name, This_MOD.id) then return end
    if not This_MOD.gameplay_mode(Data) then
        Data.Entity.destroy()
        return
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Buscar el regalo
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Agrupar la información
    local Spaces = This_MOD.create_space(Data)

    --- Validar cada chunk
    for _, Space in pairs(Spaces) do
        This_MOD.validate_chunk(Data, Space)
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Procesar
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Variables a usar
    local Zone = 3

    --- Procesar los regalos
    for _, Space in pairs(Spaces) do
        if Space.zone and Zone > Space.zone then
            Zone = Space.zone
        end
    end

    --- Procesar distancia
    local String
    if Zone == 0 then
        This_MOD.give_gift(Data)
    elseif Zone == 1 then
        String = "thermometer-red"
    elseif Zone == 2 then
        String = "thermometer-blue"
    else
        String = "snowflake"
    end

    --- Informar del resultado
    if Zone > 0 then
        This_MOD.sound_bad(Data, Zone)
        Data.Player.create_local_flying_text({
            position = Data.Entity.position,
            text = "[img=virtual-signal.signal-" .. String .. "]"
        })
    end

    --- Eliminar la entidad
    Data.Entity.destroy()

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------
---[ Funciones auxiliares ]---
---------------------------------------------------------------------------------------------------

function This_MOD.create_data(event)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Consolidar la información
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local Data = GMOD.create_data(event or {}, This_MOD)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Renombrar los espacios
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Posición del premio
    Data.gMOD.position = Data.gMOD.position or {}
    Data.position = Data.gMOD.position

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Devolver el consolidado de los datos
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    return Data

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.activate_tool(Data)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if not Data.Player or not Data.Player.valid then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Listo para usar
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    Data.Player.cursor_stack.clear()
    Data.Player.cursor_stack.set_stack {
        name = This_MOD.prefix .. This_MOD.name,
        count = 1
    }

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.create_space(Data)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Variables a usar
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local Position = Data.Entity.position
    local Spaces = {}

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Información para validar
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    for x = Position.x - 5, Position.x + 5, 1 do
        for y = Position.y - 5, Position.y + 5, 1 do
            local Chunk = {
                x = math.floor(x / 32),
                y = math.floor(y / 32)
            }

            local Key =
                "Surface: " .. Data.Entity.surface.index .. " | " ..
                "Chunk: { X: " .. Chunk.x .. ", Y: " .. Chunk.y .. " }"

            if not Spaces[Key] then
                Spaces[Key] = {
                    left_top = {
                        x = Chunk.x * 32,
                        y = Chunk.y * 32
                    },
                    right_bottom = {
                        x = Chunk.x * 32 + 31,
                        y = Chunk.y * 32 + 31
                    },
                    position = {
                        x = math.floor(Position.x),
                        y = math.floor(Position.y)
                    },
                    chunk = Chunk,
                    name = Key
                }
            end
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Devolver el resultado
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    return Spaces

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.validate_chunk(Data, Space)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Crear el regalo de no existir
    if not Data.position[Space.name] then
        Data.position[Space.name] = {
            x = math.floor(math.random(Space.left_top.x, Space.right_bottom.x)),
            y = math.floor(math.random(Space.left_top.y, Space.right_bottom.y))
        }
    end

    --- Regalo encontrado
    if Data.position[Space.name].found then return end

    --- Calcular la distancia al regalo
    local Dx = math.abs(Space.position.x - Data.position[Space.name].x)
    local Dy = math.abs(Space.position.y - Data.position[Space.name].y)
    Space.zone = math.max(Dx, Dy)

    --- Distancia del regalo
    if Space.zone == 0 then
        Data.position[Space.name].found = true
    elseif Space.zone <= 2 then
        Space.zone = 1
    elseif Space.zone <= 5 then
        Space.zone = 2
    else
        Space.zone = 3
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------

function This_MOD.gameplay_mode(Data)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validar el modo del jugador
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Valores a utilizar
    local Controller = Data.Player.controller_type
    local isCharacter = Controller == defines.controllers.character
    local isGod = Controller == defines.controllers.god
    if not isGod and not isCharacter then return false end

    --- Renombrar las variables
    local Level = script.level.level_name

    --- Variable a usar
    local Flag = false

    --- Está en el destino final
    Flag = Level == "wave-defense"
    Flag = Flag and Data.Player.surface.index == 1
    if Flag then return false end

    Flag = Level == "team-production"
    Flag = Flag and Data.Player.force.index == 1
    if Flag then return false end

    Flag = Level == "pvp"
    Flag = Flag and Data.Player.force.index == 1
    if Flag then return false end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Modo valido
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    return true

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.get_available_items(player)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Variables a usar
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local Return = {}
    local added = {}

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local function add(name)
        if name and not added[name] then
            added[name] = true
            table.insert(Return, name)
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- 1. Recetas desbloqueadas
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    for _, recipe in pairs(player.force.recipes) do
        if recipe.enabled then
            for _, product in pairs(recipe.products or {}) do
                if product.type == "item" then
                    add(product.name)
                end
            end
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- 2. Recursos naturales (minería)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    for _, proto in pairs(prototypes.entity) do
        if proto.type == "resource" and proto.mineable_properties then
            for _, product in pairs(proto.mineable_properties.products or {}) do
                if product.type == "item" then
                    add(product.name)
                end
            end
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- 3. Árboles y rocas
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    for _, proto in pairs(prototypes.entity) do
        if proto.type == "tree" or proto.type == "simple-entity" then
            if proto.mineable_properties then
                for _, product in pairs(proto.mineable_properties.products or {}) do
                    if product.type == "item" then
                        add(product.name)
                    end
                end
            end
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- 4. Peces
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    for _, proto in pairs(prototypes.entity) do
        if proto.type == "fish" and proto.mineable_properties then
            for _, product in pairs(proto.mineable_properties.products or {}) do
                if product.type == "item" then
                    add(product.name)
                end
            end
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Devolver el resultado
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    return Return

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.give_gift(Data)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Variables a usar
    local Items = This_MOD.get_available_items(Data.Player)
    local Item = {
        name = Items[math.random(1, #Items)],
        count = math.random(5, 20)
    }

    --- El jugador no tiene un cuerpo
    if not Data.Player.character then
        Data.Player.insert(Item)
    end

    --- El jugador tiene un cuerpo
    if Data.Player.character then
        local IDInvertory = defines.inventory.character_main
        Data.Player.character.get_inventory(IDInvertory).insert(Item)
    end

    --- Informar del premio
    This_MOD.sound_good(Data)
    Data.Player.create_local_flying_text({
        position = Data.Entity.position,
        text = "+" .. Item.count .. " [img=item." .. Item.name .. "]"
    })

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------

function This_MOD.sound_good(Data)
    Data.Player.play_sound({ path = "utility/new_objective" })
end

function This_MOD.sound_bad(Data, distance)
    local Sound = { "axe_fighting", "axe_mining_ore", "axe_mining_stone" }
    Data.Player.play_sound({ path = "utility/" .. Sound[distance] })
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------
---[ Iniciar el MOD ]---
---------------------------------------------------------------------------------------------------

This_MOD.start()

---------------------------------------------------------------------------------------------------

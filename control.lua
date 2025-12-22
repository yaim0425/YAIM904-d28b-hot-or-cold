---------------------------------------------------------------------------------------------------
---[ control.lua ]---
---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------
---[ Cargar las funciones comunes ]---
---------------------------------------------------------------------------------------------------

require("__" .. "YAIM0425-d00b-core" .. "__/control")

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
    local Distance = 100
    local Give = {}

    --- Procesar los regalos
    for _, Space in pairs(Spaces) do
        if Space.distance and Distance > Space.distance then
            Distance = Space.distance
            Give = Space
        end
    end

    --- Procesar distancia
    local String = ""
    if Distance == 0 then
        Give.gift.found = true
        This_MOD.give_gift(Data)
        String = "[img=virtual-signal.signal-star]"
    elseif Distance <= 2 then
        String = "[img=virtual-signal.signal-thermometer-red]"
    elseif Distance <= 5 then
        String = "[img=virtual-signal.signal-thermometer-blue]"
    else
        String = "[img=virtual-signal.signal-snowflake]"
    end

    --- Informar del resultado
    Data.Player.create_local_flying_text {
        text = String,
        position = Data.Entity.position
    }

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
    Space.distance = math.max(Dx, Dy)
    Space.gift = Data.position[Space.name]

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.give_gift(Data)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---



    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------
---[ Iniciar el MOD ]---
---------------------------------------------------------------------------------------------------

This_MOD.start()

---------------------------------------------------------------------------------------------------

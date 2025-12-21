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

    script.on_event({
        defines.events.on_chunk_generated
    }, function(event)
        This_MOD.create_chunk(This_MOD.create_data(event))
    end)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------

function This_MOD.create_chunk(Data)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Validar chunk
    local Surface = Data.Event.surface
    if Data.position[Surface.index] then return end

    -- --- Validar chunk
    -- local Surface = Data.Event.surface
    -- local Chunk = Data.Event.position
    -- local Key =
    --     "Surface [Index: " .. Surface.index .. "]" ..
    --     "Chunk [X: " .. Chunk.x .. "   Y: " .. Chunk.y .. "]"
    -- if Data.position[Key] then return end

    --- Selecciónar posición
    local area = Data.Event.area
    Data.position[Surface.index] = {
        x = math.floor(math.random(area.left_top.x, area.right_bottom.x)),
        y = math.floor(math.random(area.left_top.y, area.right_bottom.y))
    }

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.create_entity(Data)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if not Data.Entity or not Data.Entity.valid then return end
    if Data.Entity.name ~= This_MOD.prefix .. This_MOD.name then return end

    local Pos = Data.Entity.position
    local Gift = Data.position[Data.Entity.surface.index]

    Data.Entity.destroy()

    if not Gift then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Calcular distacia al premio
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local dx = math.abs(Pos.x - Gift.x)
    local dy = math.abs(Pos.y - Gift.y)
    local dist = math.max(dx, dy)

    local state
    if dist == 0 then
        state = "🎁 PREMIO"
    elseif dist <= 2 then
        state = "🌡 Tibio"
    elseif dist <= 5 then
        state = "❄ Frío"
    else
        state = "🥶 Muy frío"
    end

    -- DEBUG / TEST OUTPUT
    Data.Player.print(string.format(
        "%s | Actual: (%d, %d) | Premio: (%d, %d)",
        state,
        math.floor(Pos.x), math.floor(Pos.y),
        Gift.x, Gift.y
    ))

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
    if not Data.Player or not Data.Player.valid then return end
    Data.Player.cursor_stack.clear()
    Data.Player.cursor_stack.set_stack {
        name = This_MOD.prefix .. This_MOD.name,
        count = 1
    }
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------
---[ Iniciar el MOD ]---
---------------------------------------------------------------------------------------------------

This_MOD.start()

---------------------------------------------------------------------------------------------------

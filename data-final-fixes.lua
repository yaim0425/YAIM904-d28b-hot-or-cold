---------------------------------------------------------------------------------------------------
---[ data-final-fixes.lua ]---
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

    --- Valores de la referencia
    This_MOD.reference_values()

    --- Crear los elemtos
    This_MOD.create_item()
    This_MOD.create_entity()

    --- Valores a usar en control.lua
    This_MOD.key_sequence()
    This_MOD.tool_button()

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.reference_values()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Validar si se cargó antes
    if This_MOD.setting then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Valores de la referencia en todos los MODs
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Cargar la configuración
    This_MOD.setting = GMOD.setting[This_MOD.id] or {}

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Valores de la referencia en todos los MODs
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Imagen a usar
    This_MOD.icon = "__base__/graphics/icons/signal/signal-mining.png"

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------
--- [ Valores a usar en control.lua ] ---
---------------------------------------------------------------------------------------------------

function This_MOD.create_item()
    local Table = {}
    Table.type = "item"
    Table.name = This_MOD.prefix .. This_MOD.name
    Table.icon = This_MOD.icon
    Table.icon_size = 64
    Table.flags = { "only-in-cursor" }
    Table.stack_size = 1
    Table.place_result = This_MOD.prefix .. This_MOD.name
    data:extend({ Table })
end

function This_MOD.create_entity()
    local Table = {}
    Table.type = "simple-entity"
    Table.name = This_MOD.prefix .. This_MOD.name
    Table.localised_name = { This_MOD.prefix .. This_MOD.name }
    Table.icon = This_MOD.icon
    Table.icon_size = 64
    Table.flags = {}
    Table.collision_box = { { -0.4, -0.4 }, { 0.4, 0.4 } }
    Table.selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } }
    Table.selectable_in_game = false
    Table.picture = {
        filename = This_MOD.icon,
        width = 64,
        height = 64,
        scale = 0.5
    }
    data:extend({ Table })
end

function This_MOD.key_sequence()
    local Table = {}
    Table.type = "custom-input"
    Table.name = This_MOD.prefix .. This_MOD.name
    Table.localised_name = { This_MOD.prefix .. This_MOD.name }
    Table.key_sequence = "R"
    data:extend({ Table })
end

function This_MOD.tool_button()
    local Table = {}
    Table.type = "shortcut"
    Table.name = This_MOD.prefix .. This_MOD.name
    Table.action = "lua"
    Table.icon = This_MOD.icon
    Table.small_icon = This_MOD.icon
    Table.localised_name = { This_MOD.prefix .. This_MOD.name }
    Table.associated_control_input = This_MOD.prefix .. This_MOD.name
    data:extend({ Table })
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------
---[ Iniciar el MOD ]---
---------------------------------------------------------------------------------------------------

This_MOD.start()

---------------------------------------------------------------------------------------------------

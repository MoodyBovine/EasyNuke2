_addon.name    = 'EasyNuke2'
_addon.author  = 'Nyarlko/MoodyBovine'
_addon.version = '2.0.0'
_addon.command = "ez"

require('sets')
require('tables')
require('strings')

config = require('config')

local defaults = T{}
defaults.current_element = "fire"
defaults.target_mode = "t"
settings = config.load(defaults)

toggle_hud = 1
current_element = "fire"
old_element = "none"
target_mode = "t"

elements = T{"fire","wind","thunder","light","ice","water","earth","dark"}
elements_dark = T{"ice","water","earth","dark"}
elements_light = T{"fire","wind","thunder","light"}
elements_index = 1
other_modes = S{"drain","aspir","absorb","cure"}

targets = T{"t","bt","stnpc",}
targets_index = 1

spell_tables = {}
spell_tables["fire"] = {"Fire","Fire II","Fire III","Fire IV","Fire V","Fire VI",}
spell_tables["fire"]["ga"] = {"Firaga","Firaga II","Firaga III","Firaja",}
spell_tables["fire"]["ra"] = {"Fira","Fira II","Fira III"}
spell_tables["fire"]["helix"] = {"Pyrohelix","Pyrohelix II"}
spell_tables["fire"]["am"] = {"Flare","Flare II"}
spell_tables["fire"]["storm"] = {"Firestorm","Firestorm II"}
spell_tables["earth"] = {"Stone","Stone II","Stone III","Stone IV","Stone V","Stone VI",}
spell_tables["earth"]["ga"] = {"Stonega","Stonega II","Stonega III","Stoneja",}
spell_tables["earth"]["ra"] = {"Stonera","Stonera II","Stonera III"}
spell_tables["earth"]["helix"] = {"Geohelix","Geohelix II"}
spell_tables["earth"]["am"] = {"Quake","Quake II"}
spell_tables["earth"]["storm"] = {"Sandstorm","Sandstorm II"}
spell_tables["wind"] = {"Aero","Aero II","Aero III","Aero IV","Aero V","Aero VI",}
spell_tables["wind"]["ga"] = {"Aeroga","Aeroga II","Aeroga III","Aeroja",}
spell_tables["wind"]["ra"] = {"Aerora","Aerora II","Aerora III"}
spell_tables["wind"]["helix"] = {"Anemohelix","Anemohelix II"}
spell_tables["wind"]["am"] = {"Tornado","Tornado II"}
spell_tables["wind"]["storm"] = {"Windstorm","Windstorm II"}
spell_tables["water"] = {"Water","Water II","Water III","Water IV","Water V","Water VI",}
spell_tables["water"]["ga"] = {"Waterga","Waterga II","Waterga III","Waterja",}
spell_tables["water"]["ra"] = {"Watera","Watera II","Watera III"}
spell_tables["water"]["helix"] = {"Hydrohelix","Hydrohelix II"}
spell_tables["water"]["am"] = {"Flood","Flood II"}
spell_tables["water"]["storm"] = {"Rainstorm","Rainstorm II"}
spell_tables["ice"] = {"Blizzard","Blizzard II","Blizzard III","Blizzard IV","Blizzard V","Blizzard VI",}
spell_tables["ice"]["ga"] = {"Blizzaga","Blizzaga II","Blizzaga III","Blizzaja",}
spell_tables["ice"]["ra"] = {"Blizzara","Blizzara II","Blizzara III"}
spell_tables["ice"]["helix"] = {"Cryohelix","Cryohelix II"}
spell_tables["ice"]["am"] = {"Freeze","Freeze II"}
spell_tables["ice"]["storm"] = {"Hailstorm","Hailstorm II"}
spell_tables["thunder"] = {"Thunder","Thunder II","Thunder III","Thunder IV","Thunder V","Thunder VI",}
spell_tables["thunder"]["ga"] = {"Thundaga","Thundaga II","Thundaga III","Thundaja",}
spell_tables["thunder"]["ra"] = {"Thundara","Thundara II","Thundara III"}
spell_tables["thunder"]["helix"] = {"Ionohelix","Ionohelix II"}
spell_tables["thunder"]["am"] = {"Burst","Burst II"}
spell_tables["thunder"]["storm"] = {"Thunderstorm","Thunderstorm II"}
spell_tables["light"] = {"Banish","Banish II","Holy","Banish III",}
spell_tables["light"]["ga"] = {"Banishga","Banishga II"}
spell_tables["light"]["helix"] = {"Luminohelix","Luminohelix II"}
spell_tables["light"]["storm"] = {"Aurorastorm","Aurorastorm II"}
spell_tables["dark"] = {"Impact"}
spell_tables["dark"]["ga"] = {"Comet"}
spell_tables["dark"]["helix"] = {"Noctohelix", "Noctohelix II"}
spell_tables["dark"]["storm"] = {"Voidstorm","Voidstorm II"}
spell_tables["cure"] = {"Cure","Cure II","Cure III","Cure IV","Cure V","Cure VI"}
spell_tables["cure"]["ga"] = {"Curaga","Curaga II","Curaga III","Curaga IV","Curaga V",}
spell_tables["cure"]["ra"] = {"Cura","Cura II","Cura III"} 
spell_tables["drain"] = {"Aspir","Aspir II","Aspir III","Drain","Drain II","Drain III"}
spell_tables["drain"]["ga"] = spell_tables["drain"]
spell_tables["drain"]["ra"] = spell_tables["drain"]
spell_tables["aspir"] = spell_tables["drain"]
spell_tables["aspir"]["ga"] = spell_tables["drain"]
spell_tables["aspir"]["ra"] = spell_tables["drain"]
spell_tables["absorb"] = {"Absorb-Acc","Absorb-TP","Absorb-Attri","Absorb-STR","Absorb-DEX","Absorb-VIT","Absorb-AGI","Absorb-INT","Absorb-MND","Absorb-CHR"}
spell_tables["absorb"]["ga"] = spell_tables["absorb"]
spell_tables["absorb"]["ra"] = spell_tables["absorb"]

local indices = {
    fire = 1,
    wind = 2,
    thunder = 3,
    light = 4,
    ice = 5,
    water = 6,
    earth = 7,
    dark = 8,
}
local iPosition_x = 600
local iPosition_y = 850

function execute_spell_cast(spell_type, arg)
    local current_spell_table = nil
    if spell_type == nil then
        current_spell_table = spell_tables[current_element]
    else
        current_spell_table = spell_tables[current_element][spell_type]
    end
    if arg == nil then arg = 1 end
    arg = tonumber(arg)
    if current_spell_table == nil or arg > #current_spell_table then
        windower.add_to_chat(206,"Invalid Spell.") return
    end
    windower.chat.input("/ma \""..current_spell_table[arg].."\" <"..target_mode..">")
end

windower.register_event('load', function()

	--fire
	windower.prim.create('fire')
	windower.prim.set_color('fire', 200, 255,255,255)
	windower.prim.set_fit_to_texture('fire', false)
	windower.prim.set_texture('fire', windower.addon_path .. 'data/fire.png')
	windower.prim.set_visibility('fire', true)
	windower.prim.set_position('fire', iPosition_x, iPosition_y)
	windower.prim.set_size('fire', 130, 130)--fire
	--earth
	windower.prim.create('earth')
	windower.prim.set_color('earth',200, 2255,255,255)
	windower.prim.set_fit_to_texture('earth', false)
	windower.prim.set_texture('earth', windower.addon_path .. 'data/earth.png')
	windower.prim.set_visibility('earth', false)
	windower.prim.set_position('earth', iPosition_x, iPosition_y)
	windower.prim.set_size('earth', 130, 130)
	--thunder
	windower.prim.create('thunder')
	windower.prim.set_color('thunder', 200, 255,255,255)
	windower.prim.set_fit_to_texture('thunder', false)
	windower.prim.set_texture('thunder', windower.addon_path .. 'data/thunder.png')
	windower.prim.set_visibility('thunder', false)
	windower.prim.set_position('thunder', iPosition_x, iPosition_y)
	windower.prim.set_size('thunder', 130, 130)
	--water
	windower.prim.create('water')
	windower.prim.set_color('water', 200, 255,255,255)
	windower.prim.set_fit_to_texture('water', false)
	windower.prim.set_texture('water', windower.addon_path .. 'data/water.png')
	windower.prim.set_visibility('water', false)
	windower.prim.set_position('water', iPosition_x, iPosition_y)
	windower.prim.set_size('water', 130, 130)
	--ice
	windower.prim.create('ice')
	windower.prim.set_color('ice', 200, 255,255,255)
	windower.prim.set_fit_to_texture('ice', false)
	windower.prim.set_texture('ice', windower.addon_path .. 'data/ice.png')
	windower.prim.set_visibility('ice', false)
	windower.prim.set_position('ice', iPosition_x, iPosition_y)
	windower.prim.set_size('ice', 130, 130)
	--wind
	windower.prim.create('wind')
	windower.prim.set_color('wind', 200, 255,255,255)
	windower.prim.set_fit_to_texture('wind', false)
	windower.prim.set_texture('wind', windower.addon_path .. 'data/wind.png')
	windower.prim.set_visibility('wind', false)
	windower.prim.set_position('wind', iPosition_x, iPosition_y)
	windower.prim.set_size('wind', 130, 130)
	--dark	
	windower.prim.create('dark')
	windower.prim.set_color('dark', 200, 255,255,255)
	windower.prim.set_fit_to_texture('dark', false)
	windower.prim.set_texture('dark', windower.addon_path .. 'data/dark.png')
	windower.prim.set_visibility('dark', false)
	windower.prim.set_position('dark', iPosition_x, iPosition_y)
	windower.prim.set_size('dark', 130, 130)
	--light
	windower.prim.create('light')
	windower.prim.set_color('light', 200, 255,255,255)
	windower.prim.set_fit_to_texture('light', false)
	windower.prim.set_texture('light', windower.addon_path .. 'data/light.png')
	windower.prim.set_visibility('light', false)
	windower.prim.set_position('light', iPosition_x, iPosition_y)
	windower.prim.set_size('light', 130, 130)
	
end)

function new_draw(old, new)

	windower.prim.set_visibility(old, false)
	windower.prim.set_visibility(new, true)

end

function hud_off(cur)
	windower.prim.set_visibility(cur, false)
end

function hud_on(cur)
	windower.prim.set_visibility(cur, true)
end

windower.register_event("unhandled command", function (command, arg)
    if command == "boom" or command == "nuke" then
        execute_spell_cast(nil, arg)
    elseif command == "boomga" or command == "bga" then
        execute_spell_cast("ga", arg)
    elseif command == "boomra" or command == "bra" then
        execute_spell_cast("ra", arg)
    elseif command == "boomhelix" or command == "bhelix" then
        execute_spell_cast("helix", arg)
    elseif command == "boomam" or command == "bam" then
        execute_spell_cast("am", arg)
	elseif command == "storm" then
		execute_spell_cast("storm", arg)
    end    
end)

windower.register_event('addon command', function (command, arg)

    if command == "boom" or command == "nuke" then
        execute_spell_cast(nil, arg)
    elseif command == "boomga" or command == "bga" then
        execute_spell_cast("ga", arg)
    elseif command == "boomra" or command == "bra" then
        execute_spell_cast("ra", arg)
    elseif command == "boomhelix" or command == "bhelix" then
        execute_spell_cast("helix", arg)
    elseif command == "boomam" or command == "bam" then
        execute_spell_cast("am", arg)
    elseif command == "storm" then
        execute_spell_cast("storm", arg)    
		
    elseif command == "target" then
        if arg then
            arg = string.lower(arg)
            target_mode = arg
        else
            targets_index = targets_index % #targets + 1
            target_mode = targets[targets_index]    
        end
        windower.add_to_chat(206,"Target Mode is now: "..target_mode)
        
    elseif command == "element" or command == "mode" then
        arg = string.lower(arg)
        if elements:contains(arg) or other_modes:contains(arg) then
			old_element = current_element
            current_element = arg
			if toggle_hud == 0 then
				windower.add_to_chat(206,"Element Mode is now: "..string.ucfirst(current_element))
			else
				new_draw(old_element, current_element)
			end
		else
			windower.add_to_chat(206,"Invalid element")
		end
	elseif command == "hud" then
			if arg == 'off' then
				toggle_hud = 0
				hud_off(current_element)
			elseif arg == 'on' then
				toggle_hud = 1
				hud_on(current_element)
			else
				windower.add_to_chat(206, "ez hud [on/off]")
			end
        
        
    elseif command == "cycle" then
        if arg then
            arg = string.lower(arg)
        end
        if arg == nil then
            if not elements:contains(current_element) then
                elements_index = 1
            else
                elements_index = indices[current_element]
                elements_index = elements_index % 8 + 1
            end
            current_element = elements[elements_index]
        elseif arg == "back" then
            if not elements:contains(current_element) then
                elements_index = 1
            else
                elements_index = indices[current_element]
                elements_index = elements_index - 1
            end
            if elements_index < 1 then
                elements_index = 8
            end
            current_element = elements[elements_index]
        elseif arg == "dark" then
            if not elements_dark:contains(current_element) then
                elements_index = 1
            else
                elements_index = elements_index % 4 + 1
            end
                current_element = elements_dark[elements_index]
        elseif arg == "light" then
            if not elements_light:contains(current_element) then
                elements_index = 1
            else
                elements_index = elements_index % 4 + 1
            end    
                current_element = elements_light[elements_index]
        elseif arg == "fusion" or "fus" then
            if current_element ~= "fire" and current_element ~= "light" then
                current_element = "fire"
            elseif current_element == "fire" then
                current_element = "light"
            elseif current_element == "light" then
                current_element = "fire"
            end
        elseif arg == "distortion" or arg == "dist" then
            if current_element ~= "ice" and current_element ~= "water" then
                current_element = "ice"
            elseif current_element == "ice" then
                current_element = "water"
            elseif current_element == "water" then
                current_element = "ice"
            end
        elseif arg == "gravitation" or arg == "grav" then
            if current_element ~= "earth" and current_element ~= "dark" then
                current_element = "earth"
            elseif current_element == "earth" then
                current_element = "dark"
            elseif current_element == "dark" then
                current_element = "earth"
            end
        elseif arg == "fragmentation" or arg == "frag" then
            if current_element ~= "thunder" and current_element ~= "wind" then
                current_element = "thunder"
            elseif current_element == "thunder" then
                current_element = "wind"
            elseif current_element == "wind" then
                current_element = "thunder"
            end
        end
        windower.add_to_chat(206, "Element Mode is now: "..string.ucfirst(current_element))
    elseif command == "show" or command == "current" or command == "showcurrent" then
        windower.add_to_chat(206, "----- Element Mode: "..string.ucfirst(current_element).." --- Target Mode: < "..target_mode.." > -----")
    end
end)


local StaggerPlugin = _detalhes:NewPluginObject ("Details_Stagger")

StaggerPlugin:SetPluginDescription("Shows details on Brewmaster's Stagger.")

local StaggerFrame = StaggerPlugin.Frame

local _detalhes = _G._detalhes
local parser = _detalhes.parser

local _lastStagger = nil
local _updateNextEvent = nil
local PURIFYING_BREW = 119582
local STAGGER_PERIODIC = 124255
local STAGGER_ABSORB = 115069
local LIGHT_STAGGER_DEBUFF = 124275
local _

local function isStaggerTick(event, spellId)
  return event == "SPELL_PERIODIC_DAMAGE" and spellId == STAGGER_PERIODIC
end

local function isStaggerAbsorb(event, spellId)
  return event == "SPELL_ABSORBED" and spellId == STAGGER_ABSORB
end

function StaggerPlugin:OnDetailsEvent(event, ...)
end

function StaggerPlugin:OnCombatLogEvent(ts, event, _, sourceGuid, sourceName, sourceFlags, sourceRaidFlags, targetGuid, targetName, targetFlags, targetRaidFlags, ...)
  if(event == "SPELL_CAST_SUCCESS") then
    local spellId, spellName, spellType = ...
    if (spellId == PURIFYING_BREW) then
      local amount = UnitStagger(sourceName) / 2
      parser:heal (event, ts, sourceGuid, sourceName, sourceFlags, sourceGuid, sourceName, sourceFlags, sourceRaidFlags, spellId, spellName, spellType, amount, 0, 0, false, true)
    end
  end
end

function StaggerPlugin:OnEvent(_, event, ...)
  local eventInfo = {CombatLogGetCurrentEventInfo()}
  if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
    StaggerPlugin:OnCombatLogEvent(unpack(eventInfo))
  elseif (event == "ADDON_LOADED") then
    local AddonName = select(1, ...)
    if (AddonName == "Details_Stagger") then
      if(_G._detalhes) then
        _G._detalhes:RegisterEvent(StaggerPlugin, "COMBAT_PLAYER_ENTER")
        _G._detalhes:RegisterEvent(StaggerPlugin, "COMBAT_PLAYER_LEAVE")
        StaggerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        StaggerPlugin.initialized = true
      end
    end
  end
end

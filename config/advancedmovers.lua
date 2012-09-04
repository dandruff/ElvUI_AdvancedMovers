-- =======================================================================================
-- Add-On Name: ElvUI Advanced Movers
--     License: MIT
--      Author: Dandruff @ Whisperwind
-- Description: Extends the functionality of ElvUI's movers.
-- =======================================================================================

local ADDON_NAME = ...
ElvUI_AdvancedMovers = ...

if not ElvUI then return end
local E, L, V, P, G, _ = unpack(ElvUI)


-- positions:
--  ALL - trump all others
-- combine the following
--  RIGHT
--  LEFT
--  TOP
--  BOTTOM

local default = {
  position = {
    TOP     = { first = "TOPLEFT", second = "BOTTOMLEFT", x = 3, y = 0, },
    BOTTOM  = { first = "BOTTOMLEFT", second = "TOPLEFT", x = 3, y = 3, },
  },
}

local defaultLarge = {
  position = {
    ALL = { first = "TOP", second = "CENTER", x = "MID", y = -6, },
  },
}

P["AdvancedMovers"] = {
  -- default profile for unknow movers
  ["UnknownMover"] = default,

  ["Profiles"] = {
    ["AlertFrameMover"] = default,
    ["AltPowerBarMover"] = default,
    ["ArenaHeaderMover"] = default,
    ["AurasMover"] = defaultLarge,
    ["BagsMover"] = default,
    ["BNETMover"] = default,
    ["BossButton"] = default,
    ["BossHeaderMover"] = default,
    ["ElvAB_1"] = default,
    ["ElvAB_2"] = default,
    ["ElvAB_3"] = default,
    ["ElvAB_4"] = default,
    ["ElvAB_5"] = default,
    ["ElvUF_AssistMover"] = defaultLarge,
    ["ElvUF_FocusMover"] = default,
    ["ElvUF_FocusCastbarMover"] = default,
    ["ElvUF_FocusTargetMover"] = default,
    ["ElvUF_PartyMover"] = defaultLarge,
    ["ElvUF_PetMover"] = default,
    ["ElvUF_PetTargetMover"] = default,
    ["ElvUF_PlayerMover"] = default,
    ["ElvUF_PlayerCastbarMover"] = default,
    ["ElvUF_Raid10Mover"] = defaultLarge,
    ["ElvUF_Raid25Mover"] = defaultLarge,
    ["ElvUF_Raid40Mover"] = defaultLarge,
    ["ElvUF_TankMover"] = defaultLarge,
    ["ElvUF_TargetMover"] = default,
    ["ElvUF_TargetCastbarMover"] = default,
    ["ElvUF_TargetTargetMover"] = default,
    ["ExperienceBarMover"] = default,
    ["GMMover"] = defaultLarge,
    ["LootFrameMover"] = default,
    ["MicrobarMover"] = default,
    ["MinimapMover"] = default,
    ["PetAB"] = default,
    ["ReputationBarMover"] = default,
    ["ShiftAB"] = default,
    ["TempEnchantMover"] = default,
    ["TooltipMover"] = default,
    ["TotemBarMover"] = default,
    ["WatchFrameMover"] = default,
  },
}

-- HUD
--[[
ElvUF_PlayerHudMover
ElvUF_TargetTargetHudMover
ElvUF_PetTargetHudMover
ElvUF_PetHudMover
ElvUF_TargetHudMover]]

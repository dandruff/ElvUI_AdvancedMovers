-- =======================================================================================
-- Add-On Name: ElvUI Advanced Movers
--     License: MIT
--      Author: Dandruff @ Whisperwind
-- Description: Extends the functionality of ElvUI's movers.
-- =======================================================================================

local ADDON_NAME = ...
ElvUI_AdvancedMovers = ...

local E, L, V, P, G, _ = unpack(ElvUI)

-- Custom Location Postions Settings
--    ALL - trump all others
--    RIGHT, LEFT, TOP, BOTTOM
--    TOPRIGHT, TOPLEFT, BOTTOMRIGHT, BOTTOMLEFT
local default = {
  position = {
    TOP     = { first = "TOPLEFT", second = "BOTTOMLEFT", x = 3, y = -3, },
    BOTTOM  = { first = "BOTTOMLEFT", second = "TOPLEFT", x = 3, y = 3, },
  },
}

-- A default profile that basically centers the positions (for large frames)
local defaultLarge = {
  position = {
    ALL = { first = "TOP", second = "CENTER", x = 0, y = -6, },
  },
}

-- A default profile that is optimal for AB frames
local defaultAB = {
  position = {
    ALL = { first = "LEFT", second = "LEFT", x = 3, y = 0, },
  },
}


P["advancedmovers"] = {
  -- Mover's Transparency
  ["alpha"] = 0.5,
  
  -- Show Mover's Locations
  ["showlocation"] = true,

  -- default profile for unknown movers
  ["UnknownMover"] = default,

  ["Profiles"] = {
    ["AlertFrameMover"] = default,
    ["AltPowerBarMover"] = default,
    ["ArenaHeaderMover"] = defaultLarge,
    ["AurasMover"] = defaultLarge,
    ["BagsMover"] = default,
    ["BNETMover"] = defaultAB,
    ["BossButton"] = default,
    ["BossHeaderMover"] = defaultLarge,
    ["ElvAB_1"] = defaultAB,
    ["ElvAB_2"] = defaultAB,
    ["ElvAB_3"] = defaultAB,
    ["ElvAB_4"] = {
        position = {
          TOP     = { first = "TOPRIGHT", second = "BOTTOMRIGHT", x = -3, y = 0, },
          BOTTOM  = { first = "BOTTOMRIGHT", second = "TOPRIGHT", x = -3, y = 3, },
        },
      },
    ["ElvAB_5"] = defaultAB,
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
    ["ReputationBarMover"] = {
        position = {
          TOP     = { first = "TOPRIGHT", second = "BOTTOMRIGHT", x = -3, y = 0, },
          BOTTOM  = { first = "BOTTOMRIGHT", second = "TOPRIGHT", x = -3, y = 3, },
        },
      },
    ["ShiftAB"] = defaultAB,
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

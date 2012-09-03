-- =======================================================================================
-- Add-On Name: ElvUI Advanced Movers
--     License: MIT
--      Author: Dandruff @ Whisperwind
-- Description: Extends the functionality of ElvUI's movers.
-- =======================================================================================

-- =======================================================================================
-- Add-On Name: ElvUI Advanced Movers
--     License: MIT
--      Author: Dandruff @ Whisperwind
-- Description: Extends the functionality of ElvUI's movers.
-- =======================================================================================

--[===[
local ADDON_NAME, AdvancedMovers = ...

if not ElvUI then return end
local E, L, V, P, G = unpack(ElvUI)

local mfloor = math.floor

-- Install
P["movers"] = {
  ["alpha"] = 0.5,
  ["showlocation"] = true,
}

-- Create Font Strings that show the Location of the mover
function E.AddAdvanceProperties(moverDefinition)
  if not moverDefinition.CreatedAdvanced and moverDefinition.Created then
    local mover = moverDefinition.mover

    local visibleFrame = CreateFrame("FRAME", mover:GetName().."Location", mover)
    visibleFrame:SetWidth(1)
    visibleFrame:SetHeight(1)
    visibleFrame:SetFrameLevel(mover:GetFrameLevel() + 1)
    visibleFrame:SetPoint("TOPLEFT", mover, "BOTTOMLEFT", 3, -3)

    -- Create Location Label
    local fs = visibleFrame:CreateFontString(nil, "OVERLAY")
    fs:FontTemplate(nil, nil, "OUTLINE")
    fs:SetPoint("TOPLEFT", visibleFrame, "TOPLEFT", 3, -3)
    fs:SetText("")

    -- Save the Location Label
    mover.location = fs
    mover.visibleFrame = visibleFrame

    -- Loaded Labels for this frame
    moverDefinition.CreatedAdvanced = true
  end
end

-- Turn on and off the location updater
local function UpdateLocationLabel_On(mover)
  local ResX, ResY = GetScreenWidth(), GetScreenHeight()
  local midX, midY = ResX / 2, ResY / 2
  mover.parent:SetScript("OnUpdate", function(...)
      local left, top = mover:GetLeft(), mover:GetTop()

      -- in case the unit frame does not exist
      if left and top then
        mover.location:SetText(mfloor(left - midX + 1) .. ", " ..  mfloor(top - midY + 1))
      end
    end)
end

local function UpdateLocationLabel_Off(mover)
  mover.parent:SetScript("OnUpdate", nil)
end

-- Hook into critical ElvUI events
hooksecurefunc(E, 'CreateMover', function(self, frame, name)
  E.AddAdvanceProperties(E.CreatedMovers[name])
end)

hooksecurefunc(E, 'ToggleMovers', function(self, show, mType)
    for name, moverDef in pairs(E.CreatedMovers) do
      -- One of elvs weird frames, we have to manually add our properties
      if not moverDef.CreatedAdvanced then
        E.AddAdvanceProperties(moverDef)
      end

      -- Set Alpha Levels
      moverDef.mover:SetAlpha(E.db.movers.alpha)
      if E.db.movers.showlocation then
        if show and moverDef.type[mType] then
          --moverDef.mover.location:Show()
          moverDef.oldParentAlpha = moverDef.parent:GetAlpha()
          moverDef.parent:SetAlpha(0)
          moverDef.parent:Show()
          moverDef.mover.visibleFrame:Show()
          UpdateLocationLabel_On(moverDef.mover)
        else
          if moverDef.oldParentAlpha then moverDef.parent:SetAlpha(moverDef.oldParentAlpha); moverDef.oldParentAlpha = nil end
          UpdateLocationLabel_Off(moverDef.mover)
          --moverDef.mover.location:Hide()
          moverDef.mover.visibleFrame:Hide()
        end
      end
    end
  end)

-- Advanced Movers Options
E.Options.args.general.args["movers"] = {
  order = 10,
  type = "group",
  name = "Movers",
  guiInline = true,
  args = {
    moverAlpha = {
      order = 1,
      name = L['Alpha'],
      desc = L['Change the alpha level of the frame.'],
      type = 'range',
      isPercent = true,
      min = 0, max = 1, step = 0.01,
      set = function(info, value)
          E.db.movers.alpha = value
          for _,f in pairs(E.CreatedMovers) do
            if f.Created then
              f.mover:SetAlpha(E.db.movers.alpha)
            end
          end
        end,
      get = function(info)
          return E.db.movers.alpha
        end,
    },
    moverLocation = {
      name = L['Location Text'],
      order = 1,
      type = 'toggle',
      set = function(info, value)
          E.db.movers.showlocation = value

          -- Update all the mover's location labels
          for name, moverDef in pairs(E.CreatedMovers) do
            if moverDef.CreatedAdvanced then
              if not value then
                moverDef.mover.location:Hide()
                moverDef.mover.visibleFrame:Hide()
              else
                if moverDef.mover:IsShown() then
                  moverDef.mover.location:Show()
                  moverDef.mover.visibleFrame:Show()
                end
              end
            end
          end

        end,
      get = function(info)
          return E.db.movers.showlocation
        end,
    },
  },
}
]===]



local ADDON_NAME = ...
ElvUI_AdvancedMovers = ...

if not ElvUI then return end
local E, L, V, P = unpack(ElvUI)
local Sticky = LibStub("LibSimpleSticky-1.0")
local mfloor = math.floor

-- Install
P["movers"] = {
  ["alpha"] = 0.5,
  ["showlocation"] = true,
}

-- Create Font Strings that show the Location of the mover
function E.AddAdvanceProperties(moverDefinition)
  if not moverDefinition.CreatedAdvanced and moverDefinition.Created then
    local mover = moverDefinition.mover
    
    local visibleFrame = CreateFrame("FRAME", mover:GetName().."Location")
    visibleFrame:SetWidth(1)
    visibleFrame:SetHeight(1)
    visibleFrame:SetFrameLevel(mover:GetFrameLevel() + 1)
    visibleFrame:SetPoint("TOPLEFT", mover, "BOTTOMLEFT", 3, -3)
    visibleFrame:SetAlpha(1)
    
    -- Create Location Label
    local fs = visibleFrame:CreateFontString(nil, "OVERLAY")
    fs:FontTemplate(nil, nil, "OUTLINE")
    fs:SetPoint("TOPLEFT", visibleFrame, "TOPLEFT", 3, -3)
    fs:SetText("")
    
    if not E.db.movers.showlocation then
      fs:Hide()
    end
    -- Save the Location Label 
    mover.location = fs
    mover.visibleFrame = visibleFrame
    
    -- Loaded Labels for this frame
    moverDefinition.CreatedAdvanced = true
  end
end

local function UpdateLocationText(mover)
  local ResX, ResY = GetScreenWidth(), GetScreenHeight()
  local midX, midY = ResX / 2, ResY / 2

  local left, top = mover:GetLeft(), mover:GetTop()
  local halfWidth, halfHeight = mover:GetWidth() / 2, mover:GetHeight() / 2
  -- in case the unit frame does not exist
  if left and top then
    mover.location:SetText(mfloor(left - midX + halfWidth) .. ", " ..  mfloor(top - midY + 1 - halfHeight))
  end
end

-- Turn on and off the location updater
local function UpdateLocationLabel_On(mover)
  -- Initial Update
  UpdateLocationText(mover)

  mover:SetScript("OnDragStart", function(self)
      if InCombatLockdown() then E:Print(ERR_NOT_IN_COMBAT) return end	

      if E.db['general'].stickyFrames then
        Sticky:StartMoving(self, E['snapBars'], self.snapOffset, self.snapOffset, self.snapOffset, self.snapOffset)
      else
        self:StartMoving() 
      end
      
      mover.updater = CreateFrame("FRAME")
      mover.updater:SetScript("OnUpdate", function(...)
          UpdateLocationText(mover)  -- Continous Update
        end)
    end)
  mover:SetScript("OnDragStop", function(self)
      if InCombatLockdown() then E:Print(ERR_NOT_IN_COMBAT) return end
      if E.db['general'].stickyFrames then
        Sticky:StopMoving(self)
      else
        self:StopMovingOrSizing()
      end
      
      local screenWidth, screenHeight = E.UIParent:GetRight(), E.UIParent:GetTop()
      local x, y = self:GetCenter()
      local point
      
      if y > (screenHeight / 2) then
        point = "TOP"
        y = -(screenHeight - self:GetTop())
      else
        point = "BOTTOM"
        y = self:GetBottom()
      end
      
      if x > (screenWidth / 2) then
        point = point.."RIGHT"
        x = -(screenWidth - self:GetRight())
      else
        point = point.."LEFT"
        x = self:GetLeft()
      end

      self:ClearAllPoints()
      self:Point(point, E.UIParent, point, x, y)

      E:SaveMoverPosition(name)
      
      if postdrag ~= nil and type(postdrag) == 'function' then
        postdrag(self, E:GetScreenQuadrant(self))
      end

      self:SetUserPlaced(false)
      
      if not mover.updater then return end
      mover.updater:SetScript("OnUpdate", nil)
    end)
end

local function UpdateLocationLabel_Off(mover)
  mover:SetScript("OnUpdate", nil)
end

-- Hook into critical ElvUI events
hooksecurefunc(E, 'CreateMover', function(self, frame, name)
  E.AddAdvanceProperties(E.CreatedMovers[name])
end)

hooksecurefunc(E, 'ToggleMovers', function(self, show, mType)
    for name, moverDef in pairs(E.CreatedMovers) do
      -- One of elvs weird frames, we have to manually add our properties
      if not moverDef.CreatedAdvanced then
        E.AddAdvanceProperties(moverDef)
      end
      
      -- Set Alpha Levels
      moverDef.mover:SetAlpha(E.db.movers.alpha)
      
      if show and moverDef.type[mType] then
        _G[name.."Location"]:Show()
        UpdateLocationLabel_On(moverDef.mover)
      else
        UpdateLocationLabel_Off(moverDef.mover)
        _G[name.."Location"]:Hide()
      end

    end
  end)

-- Advanced Movers Options
E.Options.args.general.args["movers"] = {
  order = 10,
  type = "group",
  name = "Movers",
  guiInline = true,
  args = {
    moverAlpha = {
      order = 1,
      name = L['Alpha'],
      desc = L['Change the alpha level of the frame.'],
      type = 'range',
      isPercent = true,
      min = 0, max = 1, step = 0.01,
      set = function(info, value)
          E.db.movers.alpha = value
          for _,f in pairs(E.CreatedMovers) do
            if f.Created then
              f.mover:SetAlpha(E.db.movers.alpha)
            end
          end
        end,
      get = function(info)
          return E.db.movers.alpha
        end,
    },
    moverLocation = {
      name = L['Location Text'],
      order = 1,
      type = 'toggle',
      set = function(info, value)
          E.db.movers.showlocation = value
          
          -- Update all the mover's location labels
          for name, moverDef in pairs(E.CreatedMovers) do
            if moverDef.CreatedAdvanced then
              if not value then
                moverDef.mover.location:Hide()
              else
                --if moverDef.mover:IsShown() then
                  moverDef.mover.location:Show()
                --end
              end
            end
          end
          
        end,
      get = function(info)
          return E.db.movers.showlocation
        end,
    },
  },
}



--[==[
The MIT License (MIT)
Copyright (c) 2012 Reuben DeLeon

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]==]
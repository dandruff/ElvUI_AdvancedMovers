-- =======================================================================================
-- Add-On Name: ElvUI Advanced Movers
--     License: MIT
--      Author: Dandruff @ Whisperwind
-- Description: Extends the functionality of ElvUI's movers.
-- =======================================================================================

local ADDON_NAME = ...
ElvUI_AdvancedMovers = ...

if not ElvUI then return end
local E, L, V, P = unpack(ElvUI)
local Sticky = LibStub("LibSimpleSticky-1.0")
local mfloor, tinsert = math.floor, table.insert

-- Create Font Strings that show the Location of the mover
function E.AddAdvanceProperties(moverDefinition)
  if not moverDefinition.CreatedAdvanced and moverDefinition.Created then
    local mover = moverDefinition.mover
    
    local visibleFrame = CreateFrame("FRAME", mover:GetName().."Location")
    visibleFrame:SetFrameStrata("FULLSCREEN_DIALOG")
    
    -- Create Location Label
    local fs = visibleFrame:CreateFontString(nil, "OVERLAY")
    fs:FontTemplate(nil, nil, "OUTLINE")
    fs:SetPoint("TOPLEFT", visibleFrame, "TOPLEFT", 0, 0)
    fs:SetText(" ")
    visibleFrame:SetWidth(1)
    visibleFrame:SetHeight(fs:GetHeight())

    if not E.db.advancedmovers.showlocation then
      fs:Hide()
    end
    
    -- Save the Location Label 
    mover.location = fs
    mover.visibleFrame = visibleFrame
    
    -- Loaded Labels for this frame
    moverDefinition.CreatedAdvanced = true
  end
end

-- gives me the MID or coordinate relative to a frame
local function RelativeCoords(frame, x, y)
  local returnX, returnY = 0, 0
  
  if x == "MID" then
    returnX = -frame:GetWidth() / 2
  else
    returnX = tonumber(x)
  end
  
  if y == "MID" then
    returnY = frame:GetHeight() / 2
  else
    returnY = tonumber(y)
  end
  
  return returnX, returnY
end

-- Updates the location text for a mover
local function UpdateLocationText(mover)
  if not mover:IsShown() then return end

  local x, y
  
  if E.db.advancedmovers.calcFromCenter then
    local ResX, ResY = mfloor(GetScreenWidth()), mfloor(GetScreenHeight())
    local midX, midY = ResX / 2, ResY / 2

    local left, top = mover:GetLeft(), mover:GetTop()
    if not left or not top then left = 0; top = 0 end
    local halfWidth, halfHeight = mover:GetWidth() / 2, mover:GetHeight() / 2
    x, y = mfloor(left - midX + halfWidth + 0.5), mfloor(top - midY - halfHeight + 0.5)
  else
    E:UpdateNudgeFrame(mover)
    x = ElvUIMoverNudgeWindow.xOffset.currentValue
    y = ElvUIMoverNudgeWindow.yOffset.currentValue
  end
  
  -- in case the unit frame does not exist
  if x and y then
    mover.location:SetText(x .. ", " .. y)
  end
  
  local moverProfile = P.advancedmovers.Profiles[mover:GetName()]
  if not moverProfile then
    moverProfile = P.advancedmovers.UnknownMover
  end
  positionList = moverProfile.position
  
  mover.visibleFrame:SetWidth(mover.location:GetWidth())
  mover.visibleFrame:ClearAllPoints()
  
  -- Only do one of the following
  if positionList["ALL"] then
    local newX, newY = RelativeCoords(mover.location, positionList["ALL"].x, positionList["ALL"].y)
    mover.visibleFrame:SetPoint(positionList["ALL"].first, mover, positionList["ALL"].second, newX, newY)
    return
  end
  
  -- Need to do some more calcs
  local hor, ver
  
  if E.db.advancedmovers.calcFromCenter then
    if tonumber(y) < 0 then ver = "BOTTOM" else ver = "TOP" end
    if tonumber(x) < 0 then hor = "RIGHT" else hor = "LEFT" end
  else
    if tonumber(y) > 0 then ver = "BOTTOM" else ver = "TOP" end
    if tonumber(x) > 0 then hor = "RIGHT" else hor = "LEFT" end
  end
  
  if positionList[ver] then  -- TOP OR BOTTOM
    local newX, newY = RelativeCoords(mover.location, positionList[ver].x, positionList[ver].y)
    mover.visibleFrame:SetPoint(positionList[ver].first, mover, positionList[ver].second, newX, newY)
    return
  end
  
  if positionList[hor] then  -- LEFT OR RIGHT
    local newX, newY = RelativeCoords(mover.location, positionList[hor].x, positionList[hor].y)
    mover.visibleFrame:SetPoint(positionList[hor].first, mover, positionList[hor].second, newX, newY)
    return
  end
  
  local pos = ver..hor
  if positionList[pos] then  -- TOPLEFT, TOPRIGHT, BOTTOMLEFT, BOTTOMRIGHT
    local newX, newY = RelativeCoords(mover.location, positionList[pos].x, positionList[pos].y)
    mover.visibleFrame:SetPoint(positionList[pos].first, mover, positionList[pos].second, newX, newY)
    return
  end
end

-- Turn on and off the location updater
local function UpdateLocationLabel_On(mover)
  -- Initial Update
  UpdateLocationText(mover)
  
  mover:HookScript("OnDragStart", function(self)
      -- do my mover's update
      if not mover.updater then
        mover.updater = CreateFrame("FRAME")
      end
      mover.updater:SetScript("OnUpdate", function(...)
          UpdateLocationText(mover)  -- Continous Update
        end)
    end)
    
  mover:HookScript("OnDragStop", function(self)
      -- do my code to unregister stuff
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
      moverDef.mover:SetAlpha(E.db.advancedmovers.alpha)
      
      if show and moverDef.type[mType] then
        _G[name.."Location"]:Show()
        UpdateLocationLabel_On(moverDef.mover)
      else
        UpdateLocationLabel_Off(moverDef.mover)
        _G[name.."Location"]:Hide()
      end

    end
  end)

hooksecurefunc(E, 'CreateMoverPopup', function(self)
  if not self.db.advancedmovers.enableNudge then
    self.oldNudgeFrame = ElvUIMoverNudgeWindow
    ElvUIMoverNudgeWindow = CreateFrame("FRAME")
  end
end)
  
-- Advanced Movers Options
E.Options.args.general.args["advancemovers"] = {
  order = 9,
  type = "group",
  name = "Advanced Movers",
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
          E.db.advancedmovers.alpha = value
          for _,f in pairs(E.CreatedMovers) do
            if f.Created then
              f.mover:SetAlpha(E.db.advancedmovers.alpha)
            end
          end
        end,
      get = function(info)
          return E.db.advancedmovers.alpha
        end,
    },
    moverLocation = {
      name = L['Location Text'],
      order = 2,
      type = 'toggle',
      set = function(info, value)
          E.db.advancedmovers.showlocation = value
          
          -- Update all the mover's location labels
          for name, moverDef in pairs(E.CreatedMovers) do
            if moverDef.CreatedAdvanced then
              if not value then
                moverDef.mover.location:Hide()
              else
                moverDef.mover.location:Show()
              end
            end
          end
          
        end,
      get = function(info)
          return E.db.advancedmovers.showlocation
        end,
    },
    
    nudgeEnabled = {
      name = "Nudge Enabled",
      order = 3,
      type = 'toggle',
      set = function(info, value)
          E.db.advancedmovers.enableNudge = value
          
          if value then
            if E.oldNudgeFrame then
              ElvUIMoverNudgeWindow = E.oldNudgeFrame
            end
          else
            E.oldNudgeFrame = ElvUIMoverNudgeWindow
            ElvUIMoverNudgeWindow = CreateFrame("FRAME")
          end
          
        end,
      get = function(info)
          return E.db.advancedmovers.enableNudge
        end,
    },
    
    calcFromCenter = {
      name = "Calculate From Center",
      desc = "|cff5599DDEnabled|r: Shows coordinates from the center of the frame\n\n|cff5599DDDisabled:|r Shows coordinates according to ElvUI |cffFF0000(default)|r",
      order = 4,
      type = 'toggle',
      set = function(info, value) E.db.advancedmovers.calcFromCenter = value end,
      get = function(info) return E.db.advancedmovers.calcFromCenter end,
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
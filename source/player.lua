import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/animation"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Player').extends(gfx.sprite)

function Player:init(xx, yy)
    local dinoImageTable = gfx.imagetable.new("images/dino")
    self.animationLoop = gfx.animation.loop.new(150, dinoImageTable, true)
    self.animationLoop.endFrame = 4
    self.transform = {
        x = xx,
        y = yy,
        xspeed = 5,
        flip = gfx.kImageUnflipped
    }

    self.animationData = {
        idle = { startFrame = 1, endFrame = 4 },
        running = { startFrame = 5, endFrame = 10 }
    }

    self:setAnimationState('running')
    self:moveTo(self.transform.x, self.transform.y)
    self:setSize(48, 48)
    self:add()
end

function Player:setAnimationState(state, direction) 
    if direction == 'left' then self.transform.flip = gfx.kImageFlippedX end
    if direction == 'right' then self.transform.flip = gfx.kImageUnflipped end
    if self.animationState == state then 
        return nil
    end
    self.animationState = state
    self.animationLoop.startFrame = self.animationData[state].startFrame
    self.animationLoop.endFrame = self.animationData[state].endFrame
end

function Player:update()
    self:setImage(self.animationLoop:image(), self.transform.flip, 2)
    local idle = true
    -- jump 
    if pd.buttonIsPressed(pd.kButtonUp) then
        -- idle = false
    end

    -- direction
    if pd.buttonIsPressed(pd.kButtonLeft) then
        idle = false
        self:setAnimationState('running', 'left')
        if self.x > 0 then
            self:moveBy(-self.transform.xspeed, 0)
        end
    elseif pd.buttonIsPressed(pd.kButtonRight) then
        idle = false
        self:setAnimationState('running', 'right')
        if self.x < 320 then
            self:moveBy(self.transform.xspeed, 0)
        end
    end

    if idle then
        self:setAnimationState('idle')
    end
end

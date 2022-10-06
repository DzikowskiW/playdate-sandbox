import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/animation"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Player').extends(gfx.sprite)

function Player:init(x, y)
    local dinoImageTable = gfx.imagetable.new("images/dino")
    self.animationLoop = gfx.animation.loop.new(150, dinoImageTable, true)
    self.animationLoop.endFrame = 4
    self.pos = {
        x = x,
        y = y,
        vx = 5,
        vy = 2,
        flip = gfx.kImageUnflipped,
        gravity = 10
    }

    self.animationData = {
        idle = { startFrame = 1, endFrame = 4 },
        running = { startFrame = 5, endFrame = 10 }
    }

    self:setAnimationState('running')
    self:moveTo(self.pos.x, self.pos.y)
    self:setSize(48, 48)
    self:setCollideRect(7, 7, 32, 36)
    self:add()
end

function Player:setAnimationState(state, direction) 
    if direction == 'left' then self.pos.flip = gfx.kImageFlippedX end
    if direction == 'right' then self.pos.flip = gfx.kImageUnflipped end
    if self.animationState == state then 
        return nil
    end
    self.animationState = state
    self.animationLoop.startFrame = self.animationData[state].startFrame
    self.animationLoop.endFrame = self.animationData[state].endFrame
end

function Player:collisionResponse(other)
    return 'freeze'
end

function Player:update()
    self:setImage(self.animationLoop:image(), self.pos.flip, 2)
    local idle = true

    -- check for input
    -- check for physics
    -- move 

    oldY = self.y
    local actualX, actualY, collisions = self:moveWithCollisions(self.x, self.y + self.pos.vy)
    if self.y + self.pos.vy == actualY then
        self.pos.vy += self.pos.gravity
    else
        self.pos.vy = 0
    end
    
    -- jump 
    if pd.buttonIsPressed(pd.kButtonUp) then
        self.pos.vy += -10
        -- idle = false
    end
    print('inAir', self.pos.vy)

    -- direction
    if pd.buttonIsPressed(pd.kButtonLeft) then
        idle = false
        self:setAnimationState('running', 'left')
        if self.x > 0 then
            self:moveBy(-self.pos.vx, 0)
        end
    elseif pd.buttonIsPressed(pd.kButtonRight) then
        idle = false
        self:setAnimationState('running', 'right')
        if self.x < 320 then
            self:moveWithCollisions(self.x + self.pos.vx, self.y)
        end
    end

    if idle then
        self:setAnimationState('idle')
    end

    -- print(#self:overlappingSprites())
end

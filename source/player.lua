import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/animation"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Player').extends(gfx.sprite)

function Player:init(x, y, world)
    local dinoImageTable = gfx.imagetable.new("images/dino")
    self.animationLoop = gfx.animation.loop.new(150, dinoImageTable, true)
    self.animationLoop.endFrame = 4
    
    self.world = world
    self.animationState = 'idle'
    self.pos = {
        x = x,
        y = y,
        vx = 5,
        vy = 2,
        ay = 1,
        flip = gfx.kImageUnflipped,
        inAir = true
    }

    self.animationData = {
        idle = { startFrame = 1, endFrame = 4 },
        running = { startFrame = 5, endFrame = 10 }
    }

    self:setAnimationState('running')
    self:moveTo(self.pos.x, self.pos.y)
    self:setSize(48, 48)
    self:setCollideRect(14, 10, 16, 32)
    self:add()
end

function Player:setAnimationState(state, direction) 
    if direction == -1 then self.pos.flip = gfx.kImageFlippedX end
    if direction == 1 then self.pos.flip = gfx.kImageUnflipped end
    if self.animationState == state then 
        return nil
    end
    self.animationState = state
    self.animationLoop.startFrame = self.animationData[state].startFrame
    self.animationLoop.endFrame = self.animationData[state].endFrame
end

function Player:collisionResponse(other)
    return 'slide'
end

function Player:update()
    
    -- check for input
    local jump = false
    local dx = 0

    if pd.buttonIsPressed(pd.kButtonUp) then
        jump = true
    end

    if pd.buttonIsPressed(pd.kButtonLeft) then
        dx = -1
    elseif pd.buttonIsPressed(pd.kButtonRight) then
        dx = 1
    end

    -- check for physics
    if self.pos.ay < 1 then
        self.pos.ay += 1
    end

    if self.pos.inAir then
        self.pos.vy += self.pos.ay
    elseif jump then
        self.pos.ay = -4
        self.pos.inAir = true
        self.pos.vy += self.pos.ay
    end

    local expectedY = self.y + self.pos.vy
    local expectedX = self.x + self.pos.vx

   
    -- set animation
    if dx ~= 0 then
        self:setAnimationState('running', dx)
    else
        self:setAnimationState('idle')
    end
    self:setImage(self.animationLoop:image(), self.pos.flip, 2)

    -- move 
    local worldOffestX = gfx.getDrawOffset()
    expectedOffsetX = expectedX + worldOffestX

    if (expectedOffsetX < 200) and (dx < 0) then 
        print('left s', dx)
        self.world:scrollTiles(-self.pos.vx * dx)
    elseif (expectedOffsetX > 200) and (dx > 0) then
        print('right s', dx)
        self.world:scrollTiles(-self.pos.vx * dx)
    end

    if (expectedY > 240) then
        -- ded :( 
        self.pos.vy = 2
        self.pos.ay = 1
        self:moveTo(30, 0)
        self.world:scrollToStart()
    else
        local actualX, actualY, collisions =  self:moveWithCollisions(self.x + dx * self.pos.vx, expectedY)
        if #collisions > 0 then
            -- on the ground (let's assume for now) 
            -- set default values
            self.pos.vy = 2
            self.pos.inAir = false
            self.pos.ay = 1
        else
            self.pos.inAir = true
        end
    end
end
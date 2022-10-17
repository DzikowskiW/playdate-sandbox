import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/animation"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Platform').extends(gfx.sprite)

function Platform:init(x,y, width, dx, dy)
    local platformImageTable = gfx.imagetable.new("images/tiles")

    self.pos = {
        x = x,
        y = y,
        minX = x,
        minY = y,
        maxX = x + dx,
        maxY = y + dy,
        dx = dx,
        dy = dy
    }

    self.timer = pd.timer.new(2000, self.pos.minX, self.pos.maxX)
    self.timer.reverses = true
    self.timer.repeats = true
    self.timer:start()

    self:setImage(platformImageTable:getImage(7))
    self:setSize(16, 16)
    self:moveTo(x,y)
    self:setCenter(0, 0)
    self:setCollideRect(0, 0, 16, 16)
    self:add()

end

function Platform:update()
    self.pos.x = self.timer.value
    self:moveTo(self.pos.x, self.pos.y)
end
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/animation"
import "CoreLibs/timer"

import "platform"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('World').extends(gfx.sprite)

function World:init()
    self.tileMap = gfx.tilemap.new()

    local platformImageTable = gfx.imagetable.new("images/tiles")
    local mapData = json.decodeFile("maps/mapa1.json")
    local mapLayer= mapData.layers[1]

    self.pos= {
        x= 0
    }

    self.tileMap:setImageTable(platformImageTable)
    self.tileMap:setSize(mapLayer.width, mapLayer.height)
    self.tileMap:setTiles(mapLayer.data, mapLayer.width)

    Platform(128,128,32, 100, 0)

    self.addWallSprites(self.tileMap)
    self:setBounds(0, 0, mapLayer.width * mapData.tilewidth, 240)
    self:add()

    self.draw = function() self.tileMap:draw(0,0) end
end

function World:scrollTiles(dx)
    if dx == 0 then
        return
    end
    self.pos.x += dx
    gfx.setDrawOffset(self.pos.x, 0)
end

function World:scrollToStart()
    self.pos.x = 0
    gfx.setDrawOffset(self.pos.x, 0)
end

function World:update()
end
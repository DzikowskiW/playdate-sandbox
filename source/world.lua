import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/animation"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('World').extends(gfx.sprite)

function World:init()
    self.tileMap = gfx.tilemap.new()

    local platformImageTable = gfx.imagetable.new("images/tiles")
    local mapData = json.decodeFile("maps/map1.json")
    local mapLayer= mapData.layers[1]

    self.tileMap:setImageTable(platformImageTable)
    self.tileMap:setSize(25, 15)
    self.tileMap:setTiles(mapLayer.data, mapLayer.width)
    self.tileMap:draw(0,0)

    -- printTable(self.tileMap:getTiles())
    self:add()
end

function World:update()
    self.tileMap:draw(0,0)
end
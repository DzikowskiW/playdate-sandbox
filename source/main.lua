import "CoreLibs/graphics"
import "player"
import "world"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local world = World()
Player(30, 0, world)

function playdate.update() 
    gfx.sprite.update()
    pd.timer.updateTimers()
    
end
import "CoreLibs/graphics"
import "player"
import "world"

local pd <const> = playdate
local gfx <const> = playdate.graphics

World()
Player(30, 130)

function playdate.update() 
    gfx.sprite.update()
    pd.timer.updateTimers()
    
end
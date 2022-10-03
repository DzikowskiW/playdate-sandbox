import "CoreLibs/graphics"
import "player"
import "world"

local pd <const> = playdate
local gfx <const> = playdate.graphics


Player(30, 142)
World()

function playdate.update() 
    gfx.sprite.update()
    pd.timer.updateTimers()
    
end
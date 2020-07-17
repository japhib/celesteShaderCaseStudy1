local class = require 'libs.middleclass'
local vector = require 'libs.vector'

function loadTilingImage(filename)
    local ret = love.graphics.newImage(filename)
    ret:setWrap('repeat', 'repeat')
    return ret
end

-- load images only once (not once per instance)
local backgroundImg = loadTilingImage('img/background.png')
local middleImg = loadTilingImage('img/middle.png')
local frontImg = loadTilingImage('img/front.png')

local shader = love.graphics.newShader('iceblock_shader.fs')

local IceBlock = class('IceBlock')

function IceBlock:initialize(x, y, w, h)
    self.pos = vector(x, y)
    self.size = vector(w, h)

    -- assumes all 3 images are the same dimensions
    self.imgScaling = {
        w / backgroundImg:getWidth(),
        h / backgroundImg:getHeight(),
    }

    shader:send('tiling', self.imgScaling)
    shader:send('offset', {0, 0})
end

function IceBlock:draw(camPos)
    love.graphics.setShader(shader)

    love.graphics.draw(backgroundImg, camPos.x + self.pos.x, camPos.y + self.pos.y, 0, self.imgScaling[1], self.imgScaling[2])

    love.graphics.setShader()
end

return IceBlock

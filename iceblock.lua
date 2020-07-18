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

local backgroundShader = love.graphics.newShader('shaders/background_shader.fs')
local middleShader = love.graphics.newShader('shaders/middle_shader.fs')
middleShader:send('resolution', {middleImg:getWidth(), middleImg:getHeight()})
local frontShader = love.graphics.newShader('shaders/front_shader.fs')
frontShader:send('resolution', {frontImg:getWidth(), frontImg:getHeight()})

local MiddleParallaxLevel = .75

local IceBlock = class('IceBlock')

function IceBlock:initialize(x, y, w, h)
    self.pos = vector(x, y)
    self.size = vector(w, h)

    self.timeElapsed = 0

    self.backgroundImgScaling = vector(
        w / backgroundImg:getWidth(),
        h / backgroundImg:getHeight()
    )

    self.middleImgScaling = vector(
        w / middleImg:getWidth(),
        h / middleImg:getHeight()
    )

    self.frontImgScaling = vector(
        w / frontImg:getWidth(),
        h / frontImg:getHeight()
    )
end

function IceBlock:update(dt)
    self.timeElapsed = self.timeElapsed + dt
end

function IceBlock:draw(camPos)
    love.graphics.setShader(backgroundShader)
    backgroundShader:send('tiling', {self.backgroundImgScaling.x, self.backgroundImgScaling.y})
    backgroundShader:send('offset', {camPos.x / gameWidth, camPos.y / gameHeight})
    love.graphics.draw(backgroundImg, camPos.x + self.pos.x, camPos.y + self.pos.y, 0, self.backgroundImgScaling.x, self.backgroundImgScaling.y)

    love.graphics.setShader(middleShader)

    middleShader:send('tiling', {self.middleImgScaling.x, self.middleImgScaling.y})
    middleShader:send('offset', {camPos.x / gameWidth * MiddleParallaxLevel, camPos.y / gameHeight * MiddleParallaxLevel})
    middleShader:send('time', self.timeElapsed)
    love.graphics.draw(middleImg, camPos.x + self.pos.x, camPos.y + self.pos.y, 0, self.middleImgScaling.x, self.middleImgScaling.y)

    -- draw again with different offsets
    middleShader:send('offset', {camPos.x / gameWidth * MiddleParallaxLevel + .4, camPos.y / gameHeight * MiddleParallaxLevel + .4})
    middleShader:send('time', self.timeElapsed + (3.14 * 2))
    love.graphics.draw(middleImg, camPos.x + self.pos.x, camPos.y + self.pos.y, 0, self.middleImgScaling.x, self.middleImgScaling.y)

    love.graphics.setShader(frontShader)
    frontShader:send('tiling', {self.frontImgScaling.x, self.frontImgScaling.y})

    frontShader:send('offset', {0, 0})
    frontShader:send('time', self.timeElapsed)
    love.graphics.draw(frontImg, camPos.x + self.pos.x, camPos.y + self.pos.y, 0, self.frontImgScaling.x, self.frontImgScaling.y)

    -- draw again with different offsets
    frontShader:send('offset', {.5, .5})
    frontShader:send('time', self.timeElapsed + 1)
    love.graphics.draw(frontImg, camPos.x + self.pos.x, camPos.y + self.pos.y, 0, self.frontImgScaling.x, self.frontImgScaling.y)

    love.graphics.setShader()
end

return IceBlock

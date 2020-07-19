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
local waveShader = love.graphics.newShader('shaders/wavy_shader.fs')

local MiddleParallaxLevel = .75
local BorderOffset = 5

local IceBlock = class('IceBlock')

function IceBlock:initialize(x, y, w, h)
    x = math.floor(x)
    y = math.floor(y)
    w = math.floor(w)
    h = math.floor(h)

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

    self.canvas = love.graphics.newCanvas(w + BorderOffset * 2, h + BorderOffset * 2)
end

function IceBlock:update(dt)
    self.timeElapsed = self.timeElapsed + dt
end

function IceBlock:draw(camPos)
    local canvasBefore = love.graphics.getCanvas()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear(0, 0, 0, 0)

    -- ***** Background image *****
    love.graphics.setShader(backgroundShader)
    backgroundShader:send('tiling', {self.backgroundImgScaling.x, self.backgroundImgScaling.y})
    backgroundShader:send('offset', {camPos.x / gameWidth, camPos.y / gameHeight})
    love.graphics.draw(backgroundImg, BorderOffset, BorderOffset, 0, self.backgroundImgScaling.x, self.backgroundImgScaling.y)

    -- ***** Middle image *****

    love.graphics.setShader(middleShader)

    middleShader:send('tiling', {self.middleImgScaling.x, self.middleImgScaling.y})
    middleShader:send('offset', {camPos.x / gameWidth * MiddleParallaxLevel, camPos.y / gameHeight * MiddleParallaxLevel})
    middleShader:send('time', self.timeElapsed)
    love.graphics.draw(middleImg, BorderOffset, BorderOffset, 0, self.middleImgScaling.x, self.middleImgScaling.y)

    -- draw again with different offsets
    middleShader:send('offset', {camPos.x / gameWidth * MiddleParallaxLevel + .4, camPos.y / gameHeight * MiddleParallaxLevel + .4})
    middleShader:send('time', self.timeElapsed + (3.14 * 2))
    love.graphics.draw(middleImg, BorderOffset, BorderOffset, 0, self.middleImgScaling.x, self.middleImgScaling.y)

    -- ***** Front image *****

    love.graphics.setShader(frontShader)
    frontShader:send('tiling', {self.frontImgScaling.x, self.frontImgScaling.y})

    frontShader:send('offset', {0, 0})
    frontShader:send('time', self.timeElapsed)
    love.graphics.draw(frontImg, BorderOffset, BorderOffset, 0, self.frontImgScaling.x, self.frontImgScaling.y)

    -- draw again with different offsets
    frontShader:send('offset', {.5, .5})
    frontShader:send('time', self.timeElapsed + .5)
    love.graphics.draw(frontImg, BorderOffset, BorderOffset, 0, self.frontImgScaling.x, self.frontImgScaling.y)

    -- ***** Border *****

    love.graphics.setShader()

    -- draw rectangle border
    love.graphics.setColor(1, 1, 1)
    -- by default the rectangle is drawn halfway between two pixels, making it 2 pixels wide. So we have to add .5 to get it one pixel wide
    love.graphics.rectangle('line', BorderOffset + .5, BorderOffset + .5, self.size.x, self.size.y)

    -- ***** Draw to screen *****

    love.graphics.setCanvas(canvasBefore)
    love.graphics.setBlendMode('alpha', 'premultiplied')

    love.graphics.setShader(waveShader)
    waveShader:send('time', self.timeElapsed)
    waveShader:send('size', {self.size.x, self.size.y})
    waveShader:send('borderSize', BorderOffset + 4)
    love.graphics.draw(self.canvas, camPos.x + self.pos.x - BorderOffset, camPos.y + self.pos.y - BorderOffset)

    -- ***** Cleanup *****

    love.graphics.setShader()
    love.graphics.setBlendMode('alpha')
end

return IceBlock

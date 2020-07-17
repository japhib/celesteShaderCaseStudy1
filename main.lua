love.graphics.setDefaultFilter('nearest', 'nearest')

local push = require 'libs.push'
local vector = require 'libs.vector'
local IceBlock = require 'iceblock'

local gameWidth, gameHeight = 320, 180 --fixed game resolution
local windowWidth, windowHeight = love.window.getDesktopDimensions()
windowWidth, windowHeight = windowWidth*.8, windowHeight * .8 --make the window a bit smaller than the screen itself

push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false})

local iceblock = nil

local camPos = vector(0, 0)
local CamMoveSpd = 100

function love.load()
    local w = 160
    local h = 300
    iceblock = IceBlock:new(gameWidth / 2 - w / 2, gameHeight / 2 - h / 2, w, h)
end

function love.update(dt)
    if love.keyboard.isDown('left') then
        camPos.x = camPos.x + CamMoveSpd * dt
    elseif love.keyboard.isDown('right') then
        camPos.x = camPos.x - CamMoveSpd * dt
    elseif love.keyboard.isDown('up') then
        camPos.y = camPos.y + CamMoveSpd * dt
    elseif love.keyboard.isDown('down') then
        camPos.y = camPos.y - CamMoveSpd * dt
    elseif love.keyboard.isDown('escape') then
        love.event.quit()
    end
end

function love.draw()
    push:start()

    love.graphics.clear(.2, .2, .2)

    iceblock:draw(camPos)

    push:finish()
end
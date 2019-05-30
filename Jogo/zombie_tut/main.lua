function love.load()
  sprites = {}
  -- sprites.player = love.graphics.newImage('sprites/player.png')
  sprites.player = love.graphics.newImage('sprites/plane.png')
  sprites.bala = love.graphics.newImage('sprites/bala.png')
  sprites.adversario = love.graphics.newImage('sprites/adversario.png')
  -- sprites.background = love.graphics.newImage('sprites/background.png')
  sprites.background = love.graphics.newImage('sprites/bg.png')

  player = {}
  player.x = love.graphics.getWidth()/2
  player.y = 500
  player.speed = 180

  adversarios = {}
  balas = {}

  gameState = 1
  maxTime = 2
  timer = maxTime
  score = 0

  myFont = love.graphics.newFont(20)
end

function love.update(dt)
  if gameState == 2 then
    if love.keyboard.isDown("s") and player.y < love.graphics.getHeight() then
      player.y = player.y + player.speed * dt
    end

    if love.keyboard.isDown("w") and player.y > 0 then
      player.y = player.y - player.speed * dt
    end

    if love.keyboard.isDown("a") and player.x > 0 then
      player.x = player.x - player.speed * dt
    end

    if love.keyboard.isDown("d") and player.x < love.graphics.getWidth() then
      player.x = player.x + player.speed * dt
    end
  end

  for i,z in ipairs(adversarios) do
    z.x = z.x + math.cos(adversario_player_angle(z)) * z.speed * dt
    z.y = z.y + math.sin(adversario_player_angle(z)) * z.speed * dt

    if distanceBetween(z.x, z.y, player.x, player.y) < 30 then
      for i,z in ipairs(adversarios) do
        adversarios[i] = nil
        gameState = 1
        -- player.x = love.graphics.getWidth()/2
        player.x = love.graphics.getWidth()/2
        player.y = love.graphics.getHeight()/2
      end
    end
  end

  for i,b in ipairs(balas) do
    b.x = b.x + math.cos(b.direction) * b.speed * dt
    b.y = b.y + math.sin(b.direction) * b.speed * dt
  end

  for i=#balas,1,-1 do
    local b = balas[i]
    if b.x < 0 or b.y < 0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() then
      table.remove(balas, i)
    end
  end

  for i,z in ipairs(adversarios) do
    for j,b in ipairs(balas) do
      if distanceBetween(z.x, z.y, b.x, b.y) < 20 then
        z.dead = true
        b.dead = true
        score = score + 1
      end
    end
  end

  for i=#adversarios,1,-1 do
    local z = adversarios[i]
    if z.dead == true then
      table.remove(adversarios, i)
    end
  end

  for i=#balas, 1, -1 do
    local b = balas[i]
    if b.dead == true then
      table.remove(balas, i)
    end
  end

  if gameState == 2 then
    timer = timer - dt
    if timer <= 0 then
      spawnZombie()
      maxTime = maxTime * 0.95
      timer = maxTime
    end
  end
end

function love.draw()
  love.graphics.draw(sprites.background, 0, 0)

  if gameState == 1 then
    love.graphics.setFont(myFont)
    love.graphics.printf("Click anywhere to begin!", 0, 50, love.graphics.getWidth(), "center")
  end

  love.graphics.printf("Score: " .. score, 0, love.graphics.getHeight() - 100, 760, "right")

  love.graphics.draw(sprites.player, player.x, player.y, player_mouse_angle(), nil, nil, sprites.player:getWidth()/2, sprites.player:getHeight()/2)

  for i,z in ipairs(adversarios) do
    love.graphics.draw(sprites.adversario, z.x, z.y, adversario_player_angle(z), nil, nil, sprites.adversario:getWidth()/2, sprites.adversario:getHeight()/2)
  end

  for i,b in ipairs(balas) do
    love.graphics.draw(sprites.bala, b.x, b.y, nil, 0.5, 0.5, sprites.bala:getWidth()/2, sprites.bala:getHeight()/2)
  end
end

function player_mouse_angle()
  return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX()) + math.pi
end

function adversario_player_angle(enemy)
  return math.atan2(player.y - enemy.y, player.x - enemy.x)
end

function spawnZombie()
  adversario = {}
  adversario.x = 0
  adversario.y = 0
  adversario.speed = 140
  adversario.dead = false

  local side = math.random(1, 4)

  if side == 1 then
    adversario.x = -30
    adversario.y = math.random(0, love.graphics.getHeight())
  elseif side == 2 then
    adversario.x = math.random(0, love.graphics.getWidth())
    adversario.y = -30
  elseif side == 3 then
    adversario.x = love.graphics.getWidth() + 30
    adversario.y = math.random(0, love.graphics.getHeight())
  else
    adversario.x = math.random(0, love.graphics.getWidth())
    adversario.y = love.graphics.getHeight() + 30
  end

  table.insert(adversarios, adversario)
end

function spawnBullet()
  bala = {}
  bala.x = player.x
  bala.y = player.y
  bala.speed = 500
  bala.direction = player_mouse_angle()
  bala.dead = false

  table.insert(balas, bala)
end

function love.keypressed(key, scancode, isrepeat)
  if key == "space" then
    spawnZombie()
  end
end

function love.mousepressed( x, y, b, istouch)
  if b == 1 and gameState == 2 then
    spawnBullet()
  end

  if gameState == 1 then
    gameState = 2
    maxTime = 2
    timer = maxTime
    score = 0
  end
end

function distanceBetween(x1, y1, x2, y2)
  return math.sqrt((y2 - y1)^2 + (x2 - x1)^2)
end

-- -- =============== 1 =========================
-- function love.draw()
--     love.graphics.print("Hello World")
-- end
--
--
--
-- -- =============== 2 ==========================
-- local px -- posicao x do texto
--
-- function love.load()
--     love.graphics.setColor(0, 0, 0)
--     love.graphics.setBackgroundColor(255, 255, 255)
--     px = 0
-- end
--
-- function love.update(dt)
--     px = px + (100 * dt)
-- end
--
-- function love.draw()
--     love.graphics.print("Hello World", px, 300)
-- end


--================ 3 ==============================

-- function love.draw()
--     -- love.graphics.print("Hello World")
--     love.graphics.rectangle("fill", 300, 250, 200, 100)
--     -- love.graphics.rectangle(mode, x, y, width, height)
-- end


-- ============== 4 =============================
function love.draw()

    -- retangulo
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 100, 300, 400)

    -- losango
    love.graphics.setBackgroundColor(252, 252, 0)
    love.graphics.polygon("fill", 120, 300, 400, 120, 680, 300, 400, 480)

    -- circulo
    love.graphics.setBackgroundColor(0, 0, 140)
    love.graphics.circle("fill", 400, 600, 120, 100)

end

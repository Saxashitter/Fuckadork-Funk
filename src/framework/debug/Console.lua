local Console = {}

function Console.init(cap, fuse)
	Console.cap = cap or 5
	Console.fuse = fuse or 5

	Engine.postUpdate:connect(Console.update)
	Engine.postDraw:connect(Console.draw)

	Console.messages = {}
end

function Console.print(...)
	for i = 1, select("#", ...) do
		table.insert(Console.messages, {
			fuse = Console.fuse,
			message = tostring(select(i, ...))
		})
	
		if #Console.messages > Console.cap then
			table.remove(Console.messages, 1)
		end
	end
end

function Console.update(dt)
	for i = #Console.messages, 1, -1 do
		local msg = Console.messages[i]

		msg.fuse = msg.fuse - dt
		if msg.fuse <= 0 then
			table.remove(Console.messages, i)
		end
	end
end

function Console.draw()
	local y = love.graphics.getHeight() - 10

	for i = #Console.messages, 1, -1 do
		local msg = Console.messages[i]

		y = y - 10
		love.graphics.print(msg.message, 6, y)
	end
end

return Console
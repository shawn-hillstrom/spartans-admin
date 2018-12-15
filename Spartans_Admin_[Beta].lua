--Version 2.0 - [Beta]

--Installation Instructions:
-- 1) Insert this script into the ServerScriptService.
-- 2) Change any variables you want to change.

--[Variables & other necessities]

owner = {} --Add either the names or userIDs of the players you want to be owners here.
admin = {} --Add either the names or userIDs of the players you want to be admins here.
banned = {} --Add either the names or the userIDs of the players you want to be banned here.
muted = {} --Add either the names or the userIDs of the players you want to be muted here.
insrtdobjcts = {}
chatlogs = {}

cmdprefix = "/" --Change this to whatever you want to say before a command.

cmds = {
	"clean", "- Cleans the game.",
	"kill", "plr - Kills a player.",
	"respawn", "plr - Respawns a player.",
	"behead", "plr - Beheads a player.",
	"c", "code - Creates a script with specified code.",
	"lc", "code - Creates a localscript with specified code.",
	"tp", "plr plr - Teleports a player to another player.",
	"m", "msg - Creates a message that is visible to all players.",
	"pm", "plr msg - Sends a message to a player.",
	"ff", "plr - Gives a player a forcefield.",
	"unff", "plr - Removes a player's forcefield.",
	"god", "plr - Gods a player.",
	"ungod", "plr - Ungods a player.",
	"gt", "plr tool - Gives a specified tool to a player.",
	"rt", "plr tool - Removes a specified tool from a player.",
	"fly", "plr - Gives a player the ability to fly.",
	"unfly", "plr - Removes the ability to fly from a player.",
	"kick", "plr - Kicks a player from the game.",
	"ban", "plr - Bans a player from the game.",
	"unban", "plr - Unbans a player from the game.",
	"mute", "plr - Mutes a player.",
	"unmute", "plr - Unmutes a player.",
	"admin", "plr - Gives a player admin commands.",
	"unadmin", "plr - Removes a player's admin commands.",
	"owner", "plr - Gives a player owner commands [Owner Command].",
	"unowner", "plr - Removes a player's owner commands [Owner Command].",
	"clr", "- Clears all inserted objects from the game.",
	"place", "plr gameid - Teleports a player to a specified game.",
	"team", "plr team - Changes the team of a player to a specified team.",
	"cmds", "- Shows a list of all the commands.",
	"logs", "- Shows a list of all the activities of admins and owners.",
	"admins", "- Shows a list of all current admins.",
	"owners", "- Shows a list of all current owners.",
	"bans", "- Shows a list of all current banned players.",
	"mutes", "- Shows a list of all current muted players.",
	"rank", "plr groupid - Gets the rank of a player in a specified group.",
	"destroy", "plr - Crashes a player out of the game [Owner Command].",
	"health", "plr number - Changes a player's health to a specified number.",
	"heal", "plr - Heals a player.",
	"speed", "plr number - Changes a player's walkspeed to a specified number.",
	"damage", "plr number - Damages a player by a specified number of health.",
	"fling", "plr - Flings a player in a random direction.",
	"antigrav", "plr - Makes a player weightless.",
	"grav", "plr - Returns a player to normal gravity.",
	"setgrav", "plr number - Sets a player's gravity to a specified number.",
	"invis", "plr - Turns a player invisible.",
	"vis", "plr - Turns a player visible.",
	"name", "plr name - Names a player a specified name.",
	"unname", "plr - Unnames a player.",
	"shutdown", "- Shuts down the game.",
	"tools", "- Shows a list of all tools that can be accessed by this admin.",
	"countdown", "number - Reveals a countdown based on a specified number.",
	"minimap", "- Shows a mini-map of the entire game.",
	"change", "leaderboard plr number - Changes a specific player's specified leaderboard to a specified number.",
	"clrstats", "plr - Changes the leaderboard stats of a specified player to 0.",
	"clrcountdown", "- Stops any current countdowns.",
	"sit", "plr - Makes a specified player sit.",
	"jump", "plr - Makes a specified player jump.",
	"light", "plr brightness size - Inserts a pointlight of a specified brightness and size into a specified player's torso.",
	"unlight", "plr - Removes any pointlights in a specified player's torso."
}

--[Core functions]

function separatestr(str)

	local strsfrm = {}
	local stra = {1}
	local strb = {}

	for i = 1, #str do
		if str:sub(i, i) == "," then
			table.insert(stra, i + 1)
			table.insert(strb, i - 1)
		end
	end

	for i = 1, #stra do
		table.insert(strsfrm, str:sub(stra[i], strb[i]))
	end

	return strsfrm
end

function chkadmin(p)

	if #owner > 0 then
		for i = 1, #owner do
			if p.userId == owner[i] or p.Name:lower() == tostring(owner[i]):lower() then
				return true
			end
		end
	end

	if #admin > 0 then
		for i = 1, #admin do
			if p.userId == admin[i] or p.Name:lower() == tostring(admin[i]):lower() then 
				return true
			end
		end
	end

	return false
end

function findplr(str, s)

	local returnednames = {}

	if str ~= "" then
		if str == "all" then
			for i, p in pairs(game.Players:GetPlayers()) do
				table.insert(returnednames, p.Name)
			end
		elseif str == "others" then
			for i, p in pairs(game.Players:GetPlayers()) do
				if p.Name ~= s.Name then
					table.insert(returnednames, p.Name)
				end
			end
		elseif str == "me" then
			table.insert(returnednames, s.Name)
		elseif str == "random" then
			local p = game.Players:GetPlayers()[math.random(1, #game.Players:GetPlayers())]
			table.insert(returnednames, p.Name)
		elseif str == "admins" then
			for i, p in pairs(game.Players:GetPlayers()) do
				if chkadmin(p) then
					table.insert(returnednames, p.Name)
				end
			end
		elseif str == "nonadmins" then
			for i, p in pairs(game.Players:GetPlayers()) do
				if not chkadmin(p) then
					table.insert(returnednames, p.Name)
				end
			end
		elseif str:sub(1, 4) == "team" then
			local teamclrs = {}
			for i, t in pairs(game.Teams:GetChildren()) do
				local str = str:sub(6)
				if str ~= "" and t:IsA("Team") and t.Name:lower():sub(1, str:len()) == str then
					table.insert(teamclrs, t.TeamColor)
				end
			end
			if #teamclrs > 0 then
				for i, p in pairs(game.Players:GetPlayers()) do
					for c = 1, #teamclrs do
						if p.TeamColor == teamclrs[c] then
							table.insert(returnednames, p.Name)
						end
					end
				end
			else
				for i, p in pairs(game.Players:GetPlayers()) do
					if p.Name:lower():sub(1, str:len()) == str then
						table.insert(returnednames, p.Name)
					end
				end
			end
		else
			for i, p in pairs(game.Players:GetPlayers()) do
				if p.Name:lower():sub(1, str:len()) == str then
					table.insert(returnednames, p.Name)
				end
			end
		end
	end

	return returnednames
end

function getplrs(strs, p)

	local returnedplrs = {}

	for i = 1, #strs do
		local plrname = findplr(strs[i], p)
		if #plrname > 0 then
			for r = 1, #plrname do
				table.insert(returnedplrs, plrname[r])
			end
		end
	end

	return returnedplrs
end

function createmsg(msg, ttl, pf, pt, wt)
	coroutine.resume(coroutine.create(function()
		if script:FindFirstChild("Message_Gui") and script.Message_Gui:IsA("ScreenGui") then
			local mg = script.Message_Gui:Clone()
			if mg:FindFirstChild("Background") and mg.Background:FindFirstChild("Message_Bar") and mg.Background.Message_Bar:FindFirstChild("Message") and mg.Background.Message_Bar:FindFirstChild("Title") then
				local b = mg.Background
				local mb = mg.Background.Message_Bar
				local m = mg.Background.Message_Bar.Message
				local t = mg.Background.Message_Bar.Title
				m.Text = msg.."" 
				t.Text = ttl.." From "..pf
				if pt and pt:FindFirstChild("PlayerGui") then
					mg.Parent = pt.PlayerGui
					coroutine.resume(coroutine.create(function()
						b:TweenPosition(UDim2.new(-0.05, 0, 0.05, 0))
						if wt then
							wait(wt)
						else
							wait(0.02 * msg:len() + 3)
						end
						for i = 1, 10 do
							wait(0.02)
							if b.BackgroundTransparency < 1 then
								b.BackgroundTransparency = b.BackgroundTransparency + 0.1
							end
							if mb.BackgroundTransparency < 1 then
								mb.BackgroundTransparency = mb.BackgroundTransparency + 0.1
							end
							if m.TextTransparency < 1 then
								m.TextTransparency = m.TextTransparency + 0.1
							end
							if t.TextTransparency < 1 then
								t.TextTransparency = t.TextTransparency + 0.1
							end
						end
						mg:remove()
					end))
				end
			end
		end
	end))
end

--[Command functions]

function kill(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		local plrlist = getplrs(refinedstr, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				if p and p.Character then
					p.Character:BreakJoints()
				end
			end
		end
	end
end

function respawn(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		local plrlist = getplrs(refinedstr, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				if p and p.Character then
					p:LoadCharacter()
				end
			end
		end
	end
end

function behead(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		local plrlist = getplrs(refinedstr, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				if p and p.Character then
					for i, chld in pairs(p.Character:GetChildren()) do
						if chld:IsA("Hat") or (chld:IsA("Part") and chld.Name == "Head") then
							chld:remove()
						end
					end
				end
			end
		end
	end
end

function code(t, c)
	if script:FindFirstChild("Command_Code") and script.Command_Code:IsA("Script") then
		local cs = script.Command_Code:Clone()
		cs.Parent = game.Workspace table.insert(insrtdobjcts, cs)
		if cs:FindFirstChild("Code") and cs.Code:IsA("StringValue") then
			local code = t:sub(c:len() + 2)
			cs.Code.Value = code
			cs.Disabled = false
		end
	end
end

function localcode(p, t, c)
	if script:FindFirstChild("Local_Command_Code") and script.Local_Command_Code:IsA("LocalScript") then
		local cl = script.Local_Command_Code:Clone()
		if p:FindFirstChild("PlayerGui") then
			cl.Parent = p.PlayerGui
			table.insert(insrtdobjcts, cl)
		end
		if cl:FindFirstChild("Code") and cl.Code:IsA("StringValue") then
			local code = t:sub(c:len() + 2)
			cl.Code.Value = code
			cl.Disabled = false
		end
	end
end

function teleport(p, t, c)

	local findendstr = nil

	pcall (function() 
		findendstr = t:sub(c:len() + 2):find(" ") + c:len() + 1
	end)

	if findendstr then
		local refinedstr = separatestr(t:lower():sub(c:len() + 2, findendstr - 1))
		local endstr = separatestr(t:lower():sub(findendstr + 1))
		if #refinedstr > 0 and #endstr == 1 then
			local plrlist = getplrs(refinedstr, p)
			local plrto = getplrs(endstr, p)
			if #plrlist > 0 and #plrto == 1 then
				for i = 1, #plrlist do
					local p = game.Players:FindFirstChild(plrlist[i])
					local pt = game.Players:FindFirstChild(plrto[1])
					if p and pt and p.Character and pt.Character and p.Character:FindFirstChild("Torso") and pt.Character:FindFirstChild("Torso") then
						p.Character.Torso.CFrame = pt.Character.Torso.CFrame * CFrame.new(math.random(-3, 3), 0, math.random(-3, 3))
					end
				end
			end
		end
	end
end

function message(p, t, c)
	for i = 1, #game.Players:GetPlayers() do
		createmsg(t:sub(c:len() + 2), "Message", p.Name, game.Players:GetPlayers()[i], nil)
	end
end

function privatemessage(p, t, c)

	local findendstr = nil

	pcall (function()
		findendstr = t:sub(c:len() + 2):find(" ") + c:len() + 1
	end)

	if findendstr then
		local refinedstr = separatestr(t:lower():sub(c:len() + 2, findendstr - 1))
		if #refinedstr > 0 then
			local plrlist = getplrs(refinedstr, p)
			if #plrlist > 0 then
				for i = 1, #plrlist do
					local pt = game.Players:FindFirstChild(plrlist[i])
					createmsg(t:sub(findendstr + 1), "Private Message", p.Name, pt, nil)
				end
			end
		end
	end
end

function forcefield(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		local plrlist = getplrs(refinedstr, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				if p and p.Character then
					local f = Instance.new("ForceField")
					f.Parent = p.Character
				end
			end
		end
	end
end

function unforcefield(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		local plrlist = getplrs(refinedstr, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				if p and p.Character then
					for i, chld in pairs(p.Character:GetChildren()) do
						if chld:IsA("ForceField") then
							chld:remove()
						end
					end
				end
			end
		end
	end
end

function god(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		local plrlist = getplrs(refinedstr, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				if p and p.Character and p.Character:FindFirstChild("Humanoid") then
					p.Character.Humanoid.MaxHealth = math.huge
					p.Character.Humanoid.Health = 9e9
				end
			end
		end
	end
end

function ungod(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		local plrlist = getplrs(refinedstr, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				if p and p.Character and p.Character:FindFirstChild("Humanoid") then
					p.Character.Humanoid.MaxHealth = 100
					p.Character.Humanoid.Health = 100
				end
			end
		end
	end
end

function givetool(p, t, c)

	local findendstr = nil

	pcall (function()
		findendstr = t:sub(c:len() + 2):find(" ") + c:len() + 1
	end)

	if findendstr then
		local refinedstra = separatestr(t:lower():sub(c:len() + 2, findendstr - 1))
		local refinedstrb = separatestr(t:lower():sub(findendstr + 1))
		if #refinedstra > 0 and #refinedstrb > 0 then
			local plrlist = getplrs(refinedstra, p)
			if #plrlist > 0 then
				for i = 1, #plrlist do
					local p = game.Players:FindFirstChild(plrlist[i])
					if p and p:FindFirstChild("Backpack") then
						for s = 1, #refinedstrb do
							if refinedstrb ~= "" then
								if refinedstrb[s] == "all" then 
									for i, c in pairs(game.Lighting:GetChildren()) do
										if c:IsA("Tool") or c:IsA("HopperBin") then
											local t = c:Clone()
											t.Parent = p.Backpack
										end
									end
									for i, c in pairs(game.Soundscape:GetChildren()) do
										if c:IsA("Tool") or c:IsA("HopperBin") then
											local t = c:Clone()
											t.Parent = p.Backpack
										end
									end
								else
									for i, c in pairs(game.Lighting:GetChildren()) do
										if (c:IsA("Tool") or c:IsA("HopperBin")) and c.Name:lower():sub(1, refinedstrb[s]:len()) == refinedstrb[s] then
											local t = c:Clone()
											t.Parent = p.Backpack
										end
									end
									for i, c in pairs(game.Soundscape:GetChildren()) do
										if (c:IsA("Tool") or c:IsA("HopperBin")) and c.Name:lower():sub(1, refinedstrb[s]:len()) == refinedstrb[s] then
											local t = c:Clone()
											t.Parent = p.Backpack
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

function removetool(p, t, c)

	local findendstr = nil

	pcall (function()
		findendstr = t:sub(c:len() + 2):find(" ") + c:len() + 1
	end)

	if findendstr then
		local refinedstra = separatestr(t:lower():sub(c:len() + 2, findendstr - 1))
		local refinedstrb = separatestr(t:lower():sub(findendstr + 1))
		if #refinedstra > 0 and #refinedstrb > 0 then
			local plrlist = getplrs(refinedstra, p)
			if #plrlist > 0 then
				for i = 1, #plrlist do
					local p = game.Players:FindFirstChild(plrlist[i])
					if p and p:FindFirstChild("Backpack") and p.Character then
						for s = 1, #refinedstrb do
							if refinedstrb ~= "" then
								if refinedstrb[s] == "all" then 
									for i, c in pairs(p.Backpack:GetChildren()) do
										if c:IsA("Tool") or c:IsA("HopperBin") then
											c:remove()
										end
									end
									for i, c in pairs(p.Character:GetChildren()) do
										if c:IsA("Tool") or c:IsA("HopperBin") then
											c:remove()
										end
									end
								else
									for i, c in pairs(p.Backpack:GetChildren()) do
										if (c:IsA("Tool") or c:IsA("HopperBin")) and c.Name:lower():sub(1, refinedstrb[s]:len()) == refinedstrb[s] then
											c:remove()
										end
									end
									for i, c in pairs(p.Character:GetChildren()) do
										if (c:IsA("Tool") or c:IsA("HopperBin")) and c.Name:lower():sub(1, refinedstrb[s]:len()) == refinedstrb[s] then
											c:remove()
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

function fly(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		local plrlist = getplrs(refinedstr, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				if p and p:FindFirstChild("PlayerGui") and script:FindFirstChild("Local_Command_Code") and script.Local_Command_Code:IsA("LocalScript") then
					local cl = script.Local_Command_Code:Clone() cl.Name = "Fly_Script" cl.Parent = p.PlayerGui
					if cl:FindFirstChild("Code") and cl.Code:IsA("StringValue") then

						cl.Code.Value = [[
						fly = true
						b1down = false
						maxspeed = 75
						speed = 0
						g = nil
						v = nil
						p = script.Parent.Parent

						if p and p:IsA("Player") then

							local m = p:GetMouse()

							coroutine.resume(coroutine.create(function()
								while wait() do
									if p.Character and p.Character:FindFirstChild("Torso") then
										if fly then
											v = p.Character.Torso:FindFirstChild("BodyVelocity")
											g = p.Character.Torso:FindFirstChild("BodyGyro")
											if v and g and v:IsA("BodyVelocity") and g:IsA("BodyGyro") then
												if not b1down then
													g.cframe = m.Hit
												else
													g.cframe = m.Hit * CFrame.Angles(-math.pi/4, 0, 0)
												end
											else
												local v = Instance.new("BodyVelocity")
												local g = Instance.new("BodyGyro")
												v.maxForce = Vector3.new(9e9, 9e9, 9e9)
												v.velocity = Vector3.new(0, 0.157, 0)
												g.maxTorque = Vector3.new(9e9, 9e9, 9e9)
												v.Parent = p.Character.Torso
												g.Parent = p.Character.Torso
												if p.Character:FindFirstChild("Humanoid") then
													p.Character.Humanoid.PlatformStand = true
												end
											end
										else
											v = p.Character.Torso:FindFirstChild("BodyVelocity")
											g = p.Character.Torso:FindFirstChild("BodyGyro")
											if v and g and v:IsA("BodyVelocity") and g:IsA("BodyGyro") then
												v:remove()
												g:remove()
												v = nil
												g = nil
												speed = 0
												if p.Character:FindFirstChild("Humanoid") then
													p.Character.Humanoid.PlatformStand = false
												end
											end
										end
									end
								end
							end))

							m.KeyDown:connect(function(k)
								if k then
									if k:lower() == "f" then
										if fly then
											fly = false
										else
											fly = true
										end
									end
								end
							end)

							m.Button1Down:connect(function(m)

								b1down = true

								while b1down and wait(0.05) do
									if fly and v and g then
										speed = speed + 1
										if speed > maxspeed then
											speed = maxspeed
										end
										local c = g.cframe * CFrame.Angles(math.pi/4, 0, 0)
										v.velocity = Vector3.new(0, 0.157, 0) + c.lookVector * speed
									end
								end
							end)

							m.Button1Up:connect(function(m)
								b1down = false
								while not b1down and wait(0.025) do
									if fly and v and g then
										speed = speed - 1
										if speed < 0 then
											speed = 0
										end
										v.velocity = Vector3.new(0, 0.157, 0) + g.cframe.lookVector * speed
									end
								end
							end)
						end]]

						cl.Disabled = false

					end
				end
			end
		end
	end
end

function unfly(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		local plrlist = getplrs(refinedstr, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				if p and p:FindFirstChild("PlayerGui") and p.Character and p.Character:FindFirstChild("Torso") and p.Character:FindFirstChild("Humanoid") then
					for i, c in pairs(p.PlayerGui:GetChildren()) do
						if c.Name == "Fly_Script" and c:IsA("LocalScript") then
							c:remove()
						end
					end
					for i, c in pairs(p.Character.Torso:GetChildren()) do
						if c:IsA("BodyVelocity") or c:IsA("BodyGyro") then
							c:remove()
						end
					end
					p.Character.Humanoid.PlatformStand = false
				end
			end
		end
	end
end

function kick(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		local plrlist = getplrs(refinedstr, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				if p and not chkadmin(p) then
					p:Kick()
				end
			end
		end
	end
end

function ban(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		local plrlist = getplrs(refinedstr, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				if p and not chkadmin(p) then
					p:Kick()
					table.insert(banned, p.Name)
				end
			end
		end
	end
end

function unban(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		for i = 1, #refinedstr do
			if refinedstr[i] ~= "" and #banned > 0 then
				if refinedstr[i] == "all" or refinedstr[i] == "others" then
					banned = {}
				else
					for b = 1, #banned do
						if tostring(banned[b]):lower():sub(1, refinedstr[i]:len()) == refinedstr[i] then
							table.remove(banned, b)
						end
					end
				end
			end
		end
	end
end

function mute(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		local plrlist = getplrs(refinedstr, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				if p and not chkadmin(p) and p:FindFirstChild("PlayerGui") and script:FindFirstChild("Local_Command_Code") and script.Local_Command_Code:IsA("LocalScript") then
					local cl = script.Local_Command_Code:Clone()
					cl.Name = "Mute_Script"
					cl.Parent = p.PlayerGui
					if cl:FindFirstChild("Code") and cl.Code:IsA("StringValue") then
						cl.Code.Value = [[game.StarterGui:SetCoreGuiEnabled(3, false)]]
						cl.Disabled = false
						table.insert(muted, p.Name)
					end
				end
			end
		end
	end
end

function unmute(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 and #muted > 0 then
		for i = 1, #refinedstr do
			if refinedstr[i] == "all" or refinedstr[i] == "others" then
				muted = {}
			end
		end

		local plrlist = getplrs(refinedstr, p)

		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				if p and not chkadmin(p) and p:FindFirstChild("PlayerGui") and script:FindFirstChild("Local_Command_Code") and script.Local_Command_Code:IsA("LocalScript") then
					local cl = script.Local_Command_Code:Clone()
					cl.Name = "Mute_Script"
					cl.Parent = p.PlayerGui
					if cl:FindFirstChild("Code") and cl.Code:IsA("StringValue") then
						cl.Code.Value = [[game.StarterGui:SetCoreGuiEnabled(3, true)]]
						cl.Disabled = false
						for m = 1, #muted do
							if p.Name == muted[m] or p.userId == muted[m] then
								table.remove(muted, m)
							end
						end
					end
				end
			end
		end
	end
end

function addadmin(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		local plrlist = getplrs(refinedstr, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				local isadmin = false
				for a = 1, #admin do
					if p.userId == admin[a] or p.Name == admin[a] then
						isadmin = true
					end
				end
				if p and not isadmin then
					table.insert(admin, p.Name)
					createmsg("You've Been Made An Admin", "Message", "System", p, nil)
				end
			end
		end
	end
end

function removeadmin(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		for i = 1, #refinedstr do
			if refinedstr[i] ~= "" and #admin > 0 then
				if refinedstr[i] == "all" or refinedstr[i] == "others" then
					for a = 1, #admin do
						if admin[a] ~= p.userId and tostring(admin[a]):lower() ~= p.Name:lower() then
							table.remove(admin, a)
						end
					end
				else
					for a = 1, #admin do
						if admin[a] ~= p.userId and tostring(admin[a]):lower() ~= p.Name:lower() and tostring(admin[a]):lower():sub(1, refinedstr[i]:len()) == refinedstr[i] then
							table.remove(admin, a)
						end
					end
				end
			end
		end
	end
end

function addowner(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		local plrlist = getplrs(refinedstr, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				local isowner = false
				for o = 1, #owner do
					if p.userId == owner[o] or p.Name == owner[o] then
						isowner = true
					end
				end
				if p and not isowner then
					table.insert(owner, p.Name)
					createmsg("You've Been Made An Owner", "Message", "System", p, nil)
				end
			end
		end
	end
end

function removeowner(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		for i = 1, #refinedstr do
			if refinedstr[i] ~= "" and #owner > 0 then
				if refinedstr[i] == "all" or refinedstr[i] == "others" then
					for o = 1, #owner do
						if owner[o] ~= p.userId and tostring(owner[o]):lower() ~= p.Name:lower() then
							table.remove(owner, o)
						end
					end
				else
					for o = 1, #owner do
						if owner[o] ~= p.userId and tostring(owner[o]):lower() ~= p.Name:lower() and tostring(owner[o]):lower():sub(1, refinedstr[i]:len()) == refinedstr[i] then
							table.remove(owner, o)
						end
					end
				end
			end
		end
	end
end

function clear()
	if #insrtdobjcts > 0 then
		for i = 1, #insrtdobjcts do
			if insrtdobjcts[i]:IsA("Script") or insrtdobjcts[i]:IsA("LocalScript") then
				insrtdobjcts[i].Disabled = true
				insrtdobjcts[i]:remove()
			end
		end
	end
end

function place(p, t, c)

	local findendstr = nil

	pcall (function()
		findendstr = t:sub(c:len() + 2):find(" ") + c:len() + 1
	end)

	if findendstr then
		local refinedstr = separatestr(t:lower():sub(c:len() + 2, findendstr - 1))
		local endstr = separatestr(t:lower():sub(findendstr + 1))
		if #refinedstr > 0 and #endstr == 1 then
			local plrlist = getplrs(refinedstr, p)
			if #plrlist > 0 then
				for i = 1, #plrlist do
					local p = game.Players:FindFirstChild(plrlist[i])
					local pt = tonumber(endstr[1])
					if p and p.Character then
						pcall (function()
							game:GetService("TeleportService"):Teleport(pt, p.Character)
						end)
					end
				end
			end
		end
	end
end

function team(p, t, c)

	local findendstr = nil

	pcall (function()
		findendstr = t:sub(c:len() + 2):find(" ") + c:len() + 1
	end)

	if findendstr then
		local refinedstr = separatestr(t:lower():sub(c:len() + 2, findendstr - 1))
		local endstr = separatestr(t:lower():sub(findendstr + 1))
		if #refinedstr > 0 and #endstr == 1 then
			local plrlist = getplrs(refinedstr, p)
			if #plrlist > 0 then
				for i = 1, #plrlist do
					local p = game.Players:FindFirstChild(plrlist[i])
					local t = nil
					for i, tm in pairs(game.Teams:GetChildren()) do
						if tm:IsA("Team") and tm.Name:lower():sub(1, endstr[1]:len()) == endstr[1] then
							t = tm
						end
					end
					if p and t then
						p.TeamColor = t.TeamColor
					end
				end
			end
		end
	end
end

function commands(p)

	local g = script:FindFirstChild("Statistics_Gui")

	if p:FindFirstChild("PlayerGui") and g and g:IsA("ScreenGui") and g:FindFirstChild("Background") then
		local c = g:Clone()
		local t = c.Background:FindFirstChild("Title")
		if t and c.Background:FindFirstChild("Statistics_Bar") then
			t.Text = "Commands"
			local l = c.Background.Statistics_Bar:FindFirstChild("Template")
			if l then
				local cmdnum = 1
				local spacenum = 2
				for i = 1, #cmds do
					if i == 1 then
						l.Name = "1"
						l.Text = cmds[i].." "..cmds[i + 1]
					elseif i == cmdnum + 2 then
						local lc = l:Clone()
						lc.Name = tostring(i)..""
						lc.Position = UDim2.new(0.05, 0, 0, (spacenum * 30) - 30)
						lc.Text = cmdprefix..""..cmds[i].." "..cmds[i + 1]
						lc.Parent = c.Background.Statistics_Bar
						cmdnum = i
						spacenum = spacenum + 1
					end
				end
				c.Parent = p.PlayerGui
			end
		end
	end
end


function logs(p)

	local g = script:FindFirstChild("Statistics_Gui")

	if p:FindFirstChild("PlayerGui") and g and g:IsA("ScreenGui") then
		local c = g:Clone()
		if c:FindFirstChild("Background") and c.Background:FindFirstChild("Title") and c.Background:FindFirstChild("Statistics_Bar") and c.Background.Statistics_Bar:FindFirstChild("Template") then
			local t = c.Background.Title t.Text = "Logs"
			local l = c.Background.Statistics_Bar.Template
			if #chatlogs > 0 then
				for i = 1, #chatlogs do
					if i == 1 then
						l.Name = "1"
						l.Text = chatlogs[#chatlogs]..""
					else
						local lc = l:Clone()
						lc.Name = tostring(i)..""
						lc.Position = UDim2.new(0.05, 0, 0, (i * 30) - 30)
						lc.Text = chatlogs[#chatlogs - i + 1]..""
						lc.Parent = c.Background.Statistics_Bar
					end
				end
				c.Parent = p.PlayerGui
			end
		end
	end
end

function admins(p)

	local g = script:FindFirstChild("Statistics_Gui")

	if p:FindFirstChild("PlayerGui") and g and g:IsA("ScreenGui") then
		local c = g:Clone()
		if c:FindFirstChild("Background") and c.Background:FindFirstChild("Title") and c.Background:FindFirstChild("Statistics_Bar") and c.Background.Statistics_Bar:FindFirstChild("Template") then
			local t = c.Background.Title t.Text = "Admins"
			local l = c.Background.Statistics_Bar.Template
			if #admin > 0 then
				for i = 1, #admin do
					if i == 1 then
						l.Name = "1"
						l.Text = admin[i]..""
					else
						local lc = l:Clone()
						lc.Name = tostring(i)..""
						lc.Position = UDim2.new(0.05, 0, 0, (i * 30) - 30)
						lc.Text = admin[i]..""
						lc.Parent = c.Background.Statistics_Bar
					end
				end
				c.Parent = p.PlayerGui
			end
		end
	end
end

function owners(p)

	local g = script:FindFirstChild("Statistics_Gui")

	if p:FindFirstChild("PlayerGui") and g and g:IsA("ScreenGui") then
		local c = g:Clone()
		if c:FindFirstChild("Background") and c.Background:FindFirstChild("Title") and c.Background:FindFirstChild("Statistics_Bar") and c.Background.Statistics_Bar:FindFirstChild("Template") then
			local t = c.Background.Title t.Text = "Owners"
			local l = c.Background.Statistics_Bar.Template
			if #owner > 0 then
				for i = 1, #owner do
					if i == 1 then
						l.Name = "1"
						l.Text = owner[i]..""
					else
						local lc = l:Clone()
						lc.Name = tostring(i)..""
						lc.Position = UDim2.new(0.05, 0, 0, (i * 30) - 30)
						lc.Text = owner[i]..""
						lc.Parent = c.Background.Statistics_Bar
					end
				end
				c.Parent = p.PlayerGui
			end
		end
	end
end

function bans(p)

	local g = script:FindFirstChild("Statistics_Gui")

	if p:FindFirstChild("PlayerGui") and g and g:IsA("ScreenGui") then
		local c = g:Clone()
		if c:FindFirstChild("Background") and c.Background:FindFirstChild("Title") and c.Background:FindFirstChild("Statistics_Bar") and c.Background.Statistics_Bar:FindFirstChild("Template") then
			local t = c.Background.Title t.Text = "Bans"
			local l = c.Background.Statistics_Bar.Template
			if #banned > 0 then
				for i = 1, #banned do
					if i == 1 then
						l.Name = "1"
						l.Text = banned[i]..""
					else
						local lc = l:Clone()
						lc.Name = tostring(i)..""
						lc.Position = UDim2.new(0.05, 0, 0, (i * 30) - 30)
						lc.Text = banned[i]..""
						lc.Parent = c.Background.Statistics_Bar
					end
				end
				c.Parent = p.PlayerGui
			end
		end
	end
end

function mutes(p)

	local g = script:FindFirstChild("Statistics_Gui")

	if p:FindFirstChild("PlayerGui") and g and g:IsA("ScreenGui") then
		local c = g:Clone()
		if c:FindFirstChild("Background") and c.Background:FindFirstChild("Title") and c.Background:FindFirstChild("Statistics_Bar") and c.Background.Statistics_Bar:FindFirstChild("Template") then
			local t = c.Background.Title t.Text = "Mutes"
			local l = c.Background.Statistics_Bar.Template
			if #muted > 0 then
				for i = 1, #muted do
					if i == 1 then
						l.Name = "1"
						l.Text = muted[i]..""
					else
						local lc = l:Clone()
						lc.Name = tostring(i)..""
						lc.Position = UDim2.new(0.05, 0, 0, (i * 30) - 30)
						lc.Text = muted[i]..""
						lc.Parent = c.Background.Statistics_Bar
					end
				end
				c.Parent = p.PlayerGui
			end
		end
	end
end

function rank(p, t, c)

	local findendstr = nil

	pcall (function()
		findendstr = t:sub(c:len() + 2):find(" ") + c:len() + 1
	end)

	if findendstr then
		local refinedstr = separatestr(t:lower():sub(c:len() + 2, findendstr - 1))
		local endstr = separatestr(t:lower():sub(findendstr + 1))]
		if #refinedstr > 0 and #endstr == 1 then
			local plrlist = getplrs(refinedstr, p)
			if #plrlist > 0 then
				for i = 1, #plrlist do
					local plr = game.Players:FindFirstChild(plrlist[i])
					local g = tonumber(endstr[1])
					if plr and g then
						if plr:IsInGroup(g) then
							createmsg(plr.Name.."'s Rank Is "..plr:GetRoleInGroup(g), "Message", "System", p, nil)
						elseif not plr:IsInGroup(g) then
							createmsg(plr.Name.." Is Not In The Specified Group", "Message", "System", p, nil)
						end
					end
				end
			end
		end
	end
end

function destroy(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		local plrlist = getplrs(refinedstr, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				if p and not chkadmin(p) and p:FindFirstChild("PlayerGui") and script:FindFirstChild("Local_Command_Code") and script.Local_Command_Code:IsA("LocalScript") then
					local cl = script.Local_Command_Code:Clone()
					cl.Name = "Crash_Script"
					cl.Parent = p.PlayerGui
					if cl:FindFirstChild("Code") and cl.Code:IsA("StringValue") then
						cl.Code.Value = [[while true do delay(0, function() end) end]]
						cl.Disabled = false
						coroutine.resume(coroutine.create(function()
							wait(2)
							if p then
								p:Kick()
							end
						end))
					end
				end
			end
		end
	end
end

function health(p, t, c)

	local findendstr = nil

	pcall (function()
		findendstr = t:sub(c:len() + 2):find(" ") + c:len() + 1
	end)

	if findendstr then
		local refinedstr = separatestr(t:lower():sub(c:len() + 2, findendstr - 1))
		local endstr = separatestr(t:lower():sub(findendstr + 1))
		if #refinedstr > 0 and #endstr == 1 then
			local plrlist = getplrs(refinedstr, p)
			if #plrlist > 0 then
				for i = 1, #plrlist do
					local p = game.Players:FindFirstChild(plrlist[i])
					local h = tonumber(endstr[1])
					if p and h and p.Character and p.Character:FindFirstChild("Humanoid") then
						p.Character.Humanoid.MaxHealth = h
						p.Character.Humanoid.Health = h
					end
				end
			end
		end
	end
end

function heal(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		local plrlist = getplrs(refinedstr, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				if p and p.Character and p.Character:FindFirstChild("Humanoid") then
					p.Character.Humanoid.Health = p.Character.Humanoid.MaxHealth
				end
			end
		end
	end
end

function speed(p, t, c)

	local findendstr = nil

	pcall (function()
		findendstr = t:sub(c:len() + 2):find(" ") + c:len() + 1
	end)

	if findendstr then
		local refinedstr = separatestr(t:lower():sub(c:len() + 2, findendstr - 1))
		local endstr = separatestr(t:lower():sub(findendstr + 1))
		if #refinedstr > 0 and #endstr == 1 then
			local plrlist = getplrs(refinedstr, p)
			if #plrlist > 0 then
				for i = 1, #plrlist do
					local p = game.Players:FindFirstChild(plrlist[i])
					local s = tonumber(endstr[1])
					if p and s and p.Character and p.Character:FindFirstChild("Humanoid") then
						p.Character.Humanoid.WalkSpeed = s
					end
				end
			end
		end
	end
end

function damage(p, t, c)

	local findendstr = nil

	pcall (function()
		findendstr = t:sub(c:len() + 2):find(" ") + c:len() + 1
	end)

	if findendstr then
		local refinedstr = separatestr(t:lower():sub(c:len() + 2, findendstr - 1))
		local endstr = separatestr(t:lower():sub(findendstr + 1))
		if #refinedstr > 0 and #endstr == 1 then
			local plrlist = getplrs(refinedstr, p)
			if #plrlist > 0 then
				for i = 1, #plrlist do
					local p = game.Players:FindFirstChild(plrlist[i])
					local d = tonumber(endstr[1])
					if p and d and p.Character and p.Character:FindFirstChild("Humanoid") then
						p.Character.Humanoid.Health = p.Character.Humanoid.Health - d
					end
				end
			end
		end
	end
end

function fling(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		local plrlist = getplrs(refinedstr, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				if p and p.Character and p.Character:FindFirstChild("Torso") and p.Character:FindFirstChild("Humanoid") then
					p.Character.Humanoid.Sit = true
					local v = Instance.new("BodyVelocity", p.Character.Torso)
					v.maxForce = Vector3.new(9e9, 9e9, 9e9)
					v.velocity = Vector3.new(math.random(-120, 120), math.random(70, 90), math.random(-120, 120))
					coroutine.resume(coroutine.create(function()
						wait(0.5)
						v:remove()
					end))
				end
			end
		end
	end
end

function antigrav(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		local plrlist = getplrs(refinedstr, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				if p and p.Character then
					for i, c in pairs(p.Character:GetChildren()) do
						local f = Instance.new("BodyForce")
						if c:IsA("Part") then
							f.Parent = c
							f.force = Vector3.new(0, c:GetMass() * 196.2, 0)
						elseif c:IsA("Hat") and c:FindFirstChild("Handle") and c.Handle:IsA("Part") then
							f.Parent = c.Handle
							f.force = Vector3.new(0, c.Handle:GetMass() * 196.2, 0)
						end
					end
				end
			end
		end
	end
end

function grav(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		local plrlist = getplrs(refinedstr, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				if p and p.Character then
					for i, c in pairs(p.Character:GetChildren()) do
						if c:IsA("Part") then
							for i, f in pairs(c:GetChildren()) do
								if f:IsA("BodyForce") then
									f:remove()
								end
							end
						elseif c:IsA("Hat") and c:FindFirstChild("Handle") and c.Handle:IsA("Part") then
							for i, f in pairs(c.Handle:GetChildren()) do
								if f:IsA("BodyForce") then
									f:remove()
								end
							end
						end
					end
				end
			end
		end
	end
end

function setgrav(p, t, c)

	local findendstr = nil

	pcall (function()
		findendstr = t:sub(c:len() + 2):find(" ") + c:len() + 1
	end)

	if findendstr then
		local refinedstr = separatestr(t:lower():sub(c:len() + 2, findendstr - 1))
		local endstr = separatestr(t:lower():sub(findendstr + 1))
		if #refinedstr > 0 and #endstr == 1 then
			local plrlist = getplrs(refinedstr, p)
			if #plrlist > 0 then
				for i = 1, #plrlist do
					local p = game.Players:FindFirstChild(plrlist[i])
					local n = tonumber(endstr[1])
					if p and n and p.Character then
						for i, c in pairs(p.Character:GetChildren()) do
							local f = Instance.new("BodyForce")
							if c:IsA("Part") then
								f.Parent = c
								f.force = Vector3.new(0, n, 0)
							elseif c:IsA("Hat") and c:FindFirstChild("Handle") and c.Handle:IsA("Part") then
								f.Parent = c.Handle
								f.force = Vector3.new(0, n, 0)
							end
						end
					end
				end
			end
		end
	end
end

function invis(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		local plrlist = getplrs(refinedstr, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				if p and p.Character then
					for i, c in pairs(p.Character:GetChildren()) do
						if c:IsA("Part") then
							c.Transparency = 1
						elseif c:IsA("Hat") and c:FindFirstChild("Handle") and c.Handle:IsA("Part") then
							c.Handle.Transparency = 1
						end
						if c:FindFirstChild("face") then
							c.face.Transparency = 1
						end
					end
				end
			end
		end
	end
end

function vis(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		local plrlist = getplrs(refinedstr, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				if p and p.Character then
					for i, c in pairs(p.Character:GetChildren()) do
						if c:IsA("Part") and c.Name ~= "HumanoidRootPart" then
							c.Transparency = 0
						elseif c:IsA("Hat") and c:FindFirstChild("Handle") and c.Handle:IsA("Part") then
							c.Handle.Transparency = 0
						end
						if c:FindFirstChild("face") then
							c.face.Transparency = 0
						end
					end
				end
			end
		end
	end
end

function name(p, t, c)

	local findendstr = nil

	pcall (function()
		findendstr = t:sub(c:len() + 2):find(" ") + c:len() + 1
	end)

	if findendstr then
		local refinedstr = separatestr(t:lower():sub(c:len() + 2, findendstr - 1))
		local endstr = separatestr(t:sub(findendstr + 1))
		if #refinedstr > 0 and #endstr == 1 then
			local plrlist = getplrs(refinedstr, p)
			if #plrlist > 0 then
				for i = 1, #plrlist do
					local p = game.Players:FindFirstChild(plrlist[i])
					local n = endstr[1]
					if p and n and p.Character and p.Character:FindFirstChild("Head") then
						for i, c in pairs(p.Character:GetChildren()) do
							if c:IsA("Model") and c:FindFirstChild("NewName") and c.NewName:IsA("Humanoid") then
								p.Character.Head.Transparency = 0
								c:remove()
							end
						end
						local m = Instance.new("Model", p.Character)
						m.Name = n
						local nh = p.Character.Head:Clone()
						nh.Parent = m
						local h = Instance.new("Humanoid", m)
						h.Name = "NewName"
						h.MaxHealth = 0
						h.Health = 0
						local w = Instance.new("Weld", nh)
						w.Part0 = nh
						w.Part1 = p.Character.Head
						p.Character.Head.Transparency = 1
					end
				end
			end
		end
	end
end

function unname(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		local plrlist = getplrs(refinedstr, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				if p and p.Character and p.Character:FindFirstChild("Head") then
					for i, c in pairs(p.Character:GetChildren()) do
						if c:IsA("Model") and c:FindFirstChild("NewName") and c.NewName:IsA("Humanoid") then
							c:remove()
							p.Character.Head.Transparency = 0
						end
					end
				end
			end
		end
	end
end

function shutdown()

	for i, p in pairs(game.Players:GetPlayers()) do
		createmsg("Game Shutting Down...", "Message", "System", p, nil)
	end

	coroutine.resume(coroutine.create(function()
		wait(2)
		repeat
			wait()
			for i, p in pairs(game.Players:GetPlayers()) do
				p:Kick()
			end
		until nil
	end))
end

function tools(p)

	local g = script:FindFirstChild("Statistics_Gui")

	if p:FindFirstChild("PlayerGui") and g and g:IsA("ScreenGui") then
		local c = g:Clone()
		if c:FindFirstChild("Background") and c.Background:FindFirstChild("Title") and c.Background:FindFirstChild("Statistics_Bar") and c.Background.Statistics_Bar:FindFirstChild("Template") then
			local t = c.Background.Title t.Text = "Tools"
			local l = c.Background.Statistics_Bar.Template
			local alltools = {}
			for i, c in pairs(game.Lighting:GetChildren()) do
				if c:IsA("Tool") or c:IsA("HopperBin") then
					table.insert(alltools, c.Name)
				end
			end
			for i, c in pairs(game.Soundscape:GetChildren()) do
				if c:IsA("Tool") or c:IsA("HopperBin") then
					table.insert(alltools, c.Name)
				end
			end
			if #alltools > 0 then
				for i = 1, #alltools do
					if i == 1 then
						l.Name = "1"
						l.Text = alltools[i]..""
					else
						local lc = l:Clone()
						lc.Name = tostring(i)..""
						lc.Position = UDim2.new(0.05, 0, 0, (i * 30) - 30)
						lc.Text = alltools[i]..""
						lc.Parent = c.Background.Statistics_Bar
					end
				end
				c.Parent = p.PlayerGui
			end
		end
	end
end

counting = false

function countdown(t, c)

	local num = nil

	pcall (function()
		num = tonumber(t:sub(c:len() + 2))
	end)

	if num and num > 0 and not counting then
		coroutine.resume(coroutine.create(function()
			counting = true
			for i = 1, num do
				if counting then
					for p = 1, #game.Players:GetPlayers() do
						createmsg(tostring(num).."", "Message", "System", game.Players:GetPlayers()[p], 0.7)
					end
					num = num - 1 wait(1)
				end
			end
			counting = false
		end))
	end
end

function minimap(p)

	local g = script:FindFirstChild("Mini-Map_Gui")

	if p:FindFirstChild("PlayerGui") and g and g:IsA("ScreenGui") then
		local c = g:Clone()
		if c:FindFirstChild("Background") and c.Background:FindFirstChild("Map_Background") and c.Background.Map_Background:FindFirstChild("ScrollBase") and c.Background.Map_Background.ScrollBase:FindFirstChild("Mini-Mapping") then
			local m = c.Background.Map_Background.ScrollBase:FindFirstChild("Mini-Mapping")
			if m:IsA("Script") then
				c.Parent = p.PlayerGui
				m.Disabled = false
			end
		end
	end
end

function changestats(p, t, c)

	local t = t:sub(c:len() + 2)
	local separationone = nil
	local separationtwo = nil
	local num = nil
	local refinedstra = nil
	local refinedstrb = nil

	pcall (function()
		separationone = t:find(" ")
		separationtwo = t:sub(separationone + 1):find(" ") + separationone
		num = tonumber(t:lower():sub(separationtwo + 1))
		refinedstra = separatestr(t:lower():sub(1, separationone - 1))
		refinedstrb = separatestr(t:lower():sub(separationone + 1, separationtwo - 1))
	end)

	if separationone and separationtwo and num and refinedstra and refinedstrb and #refinedstra > 0 and #refinedstrb > 0 then
		local plrlist = getplrs(refinedstrb, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				if p and p:FindFirstChild("leaderstats") then
					for s = 1, #refinedstra do
						for _, l in pairs(p.leaderstats:GetChildren()) do
							if l.Name:lower():sub(1, refinedstra[s]:len()) == refinedstra[s] and l:IsA("IntValue") then
								l.Value = num
							end
						end
					end
				end
			end
		end
	end
end

function clrstats(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		local plrlist = getplrs(refinedstr, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				if p and p:FindFirstChild("leaderstats") then
					for _, l in pairs(p.leaderstats:GetChildren()) do
						if l:IsA("IntValue") then
							l.Value = 0
						end
					end
				end
			end
		end
	end
end

function sit(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		local plrlist = getplrs(refinedstr, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				if p and p.Character and p.Character:FindFirstChild("Humanoid") then
					p.Character.Humanoid.Sit = true
				end
			end
		end
	end
end

function jump(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		local plrlist = getplrs(refinedstr, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				if p and p.Character and p.Character:FindFirstChild("Humanoid") then
					p.Character.Humanoid.Jump = true
				end
			end
		end
	end
end

function light(p, t, c)

	local t = t:sub(c:len() + 2)
	local separationone = nil
	local separationtwo = nil
	local numone = nil
	local numtwo = nil
	local refinedstr = nil

	pcall (function()
		separationone = t:find(" ")
		separationtwo = t:sub(separationone + 1):find(" ") + separationone
		numone = tonumber(t:lower():sub(separationone + 1, separationtwo - 1))
		numtwo = tonumber(t:lower():sub(separationtwo + 1))
		refinedstr = separatestr(t:lower():sub(1, separationone - 1))
	end)

	if separationone and separationtwo and numone and numtwo and refinedstr and #refinedstr > 0 then
		local plrlist = getplrs(refinedstr, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				if p and p.Character and p.Character:FindFirstChild("Torso") then
					for _, c in pairs(p.Character.Torso:GetChildren()) do
						if c:IsA("PointLight") then
							c:remove()
						end
					end
					local l = Instance.new("PointLight", p.Character.Torso)
					l.Brightness = numone
					l.Range = numtwo
				end
			end
		end
	end
end

function unlight(p, t, c)

	local refinedstr = separatestr(t:lower():sub(c:len() + 2))

	if #refinedstr > 0 then
		local plrlist = getplrs(refinedstr, p)
		if #plrlist > 0 then
			for i = 1, #plrlist do
				local p = game.Players:FindFirstChild(plrlist[i])
				if p and p.Character and p.Character:FindFirstChild("Torso") then
					for _, c in pairs(p.Character.Torso:GetChildren()) do
						if c:IsA("PointLight") then
							c:remove()
						end
					end
				end
			end
		end
	end
end

--[Chat recognition function]

game.Players.PlayerAdded:connect(function(p)

	p:WaitForDataReady()

	if #banned > 0 then
		for i = 1, #banned do
			if p.userId == banned[i] or p.Name:lower() == tostring(banned[i]):lower() then
				p:Kick()
				break
			end
		end
	end

	if #muted > 0 then
		for i = 1, #muted do
			if p.userId == muted[i] or p.Name:lower() == tostring(muted[i]):lower() and p:FindFirstChild("PlayerGui") then
				local cl = script.Local_Command_Code:Clone()
				cl.Name = "Mute_Script"
				cl.Parent = p.PlayerGui
				if cl:FindFirstChild("Code") and cl.Code:IsA("StringValue") then
					cl.Code.Value = [[game.StarterGui:SetCoreGuiEnabled(3, false)]]
					cl.Disabled = false
					break
				end
			end
		end
	end

	local isowner = false

	if #owner > 0 then
		for i = 1, #owner do
			if p.userId == owner[i] or p.Name:lower() == tostring(owner[i]):lower() then
				isowner = true
				createmsg("Welcome Owner "..p.Name, "Message", "System", p, nil)
				break
			end
		end
	end

	if not isowner then
		if #admin > 0 then
			for i = 1, #admin do
				if p.userId == admin[i] or p.Name:lower() == tostring(admin[i]):lower() then
					createmsg("Welcome Admin "..p.Name, "Message", "System", p, nil)
					break
				end
			end
		end
	end

	coroutine.resume(coroutine.create(function()
		p.Chatted:connect(function(t)
			if chkadmin(p) then
				table.insert(chatlogs, p.Name..": "..t)
				if t:sub(1, 1) == cmdprefix then
					t = t:sub(cmdprefix:len() + 1, t:len())
					for i, c in pairs(cmds) do
						if t:lower():sub(1, c:len()) == c:lower() and (t:sub(c:len() + 1, c:len() + 1) == " " or t:sub(c:len() + 1, c:len() + 1) == "") then

							if c == cmds[3] then kill(p, t, c) end
							if c == cmds[5] then respawn(p, t, c) end
							if c == cmds[7] then behead(p, t, c) end
							if c == cmds[9] then code(t, c) end
							if c == cmds[11] then localcode(p, t, c) end
							if c == cmds[13] then teleport(p, t, c) end
							if c == cmds[15] then message(p, t, c) end
							if c == cmds[17] then privatemessage(p, t, c) end
							if c == cmds[19] then forcefield(p, t, c) end
							if c == cmds[21] then unforcefield(p, t, c) end
							if c == cmds[23] then god(p, t, c) end
							if c == cmds[25] then ungod(p, t, c) end
							if c == cmds[27] then givetool(p, t, c) end
							if c == cmds[29] then removetool(p, t, c) end
							if c == cmds[31] then fly(p, t, c) end
							if c == cmds[33] then unfly(p, t, c) end
							if c == cmds[35] then kick(p, t, c) end
							if c == cmds[37] then ban(p, t, c) end
							if c == cmds[39] then unban(p, t, c) end
							if c == cmds[41] then mute(p, t, c) end
							if c == cmds[43] then unmute(p, t, c) end
							if c == cmds[45] then addadmin(p, t, c) end
							if c == cmds[47] then removeadmin(p, t, c) end
							if c == cmds[53] then clear() end
							if c == cmds[55] then place(p, t, c) end
							if c == cmds[57] then team(p, t, c) end
							if c == cmds[59] then commands(p) end
							if c == cmds[61] then logs(p) end
							if c == cmds[63] then admins(p) end
							if c == cmds[65] then owners(p) end
							if c == cmds[67] then bans(p) end
							if c == cmds[69] then mutes(p) end
							if c == cmds[71] then rank(p, t, c) end
							if c == cmds[75] then health(p, t, c) end
							if c == cmds[77] then heal(p, t, c) end
							if c == cmds[79] then speed(p, t, c) end
							if c == cmds[81] then damage(p, t, c) end
							if c == cmds[83] then fling(p, t, c) end
							if c == cmds[85] then antigrav(p, t, c) end
							if c == cmds[87] then grav(p, t, c) end
							if c == cmds[89] then setgrav(p, t, c) end
							if c == cmds[91] then invis(p, t, c) end
							if c == cmds[93] then vis(p, t, c) end
							if c == cmds[95] then name(p, t, c) end
							if c == cmds[97] then unname(p, t, c) end
							if c == cmds[101] then tools(p) end
							if c == cmds[103] then countdown(t, c) end
							if c == cmds[105] then minimap(p) end
							if c == cmds[107] then changestats(p, t, c) end
							if c == cmds[109] then clrstats(p, t, c) end
							if c == cmds[111] then counting = false end
							if c == cmds[113] then sit(p, t, c) end
							if c == cmds[115] then jump(p, t, c) end
							if c == cmds[117] then light(p, t, c) end
							if c == cmds[119] then unlight(p, t, c) end

							local isowner = false

							for i = 1, #owner do
								if p.Name:lower() == tostring(owner[i]):lower() or p.userId == owner[i] then
									isowner = true
								end
							end

							if isowner then
								if c == cmds[49] then addowner(p, t, c) end
								if c == cmds[51] then removeowner(p, t, c) end
								if c == cmds[73] then destroy(p, t, c) end
								if c == cmds[99] then shutdown() end
							end
						end
					end
				end
			end

			if t:lower() == cmds[1]:lower() then
				for i, c in pairs(game.Workspace:GetChildren()) do
					if c:IsA("Hat") or c:IsA("Tool") or c:IsA("HopperBin") then
						c:remove()
					end
				end
			end
		end)
	end))
end)

--[Auto-update statement]

adminmod = game:GetService("InsertService"):LoadAsset(138323346)

if adminmod:FindFirstChild("Spartans_Admin_[Beta]") and adminmod:FindFirstChild("Spartans_Admin_[Beta]"):IsA("Script") and adminmod:FindFirstChild("Spartans_Admin_[Beta]"):FindFirstChild("SAV#") and adminmod:FindFirstChild("Spartans_Admin_[Beta]"):FindFirstChild("SAV#"):IsA("NumberValue") then
	local newadmin = adminmod:FindFirstChild("Spartans_Admin_[Beta]")
	newadmin.Disabled = true
	local newversion = newadmin:FindFirstChild("SAV#").Value
	local crntversion = nil
	if script:FindFirstChild("SAV#") and script:FindFirstChild("SAV#"):IsA("NumberValue") then
		crntversion = script:FindFirstChild("SAV#").Value
	end
	if crntversion and newversion > crntversion then
		_G.owner = owner
		_G.admin = admin
		_G.banned = banned
		_G.muted = muted
		_G.cmdprefix = cmdprefix
		newadmin.Parent = game.ServerScriptService
		newadmin.Disabled = false
		script.Disabled = true
		script:remove()
	elseif crntversion and newversion <= crntversion then
		if _G.owner and _G.admin and _G.banned and _G.muted and _G.cmdprefix then
			owner = _G.owner
			admin = _G.admin
			banned = _G.banned
			muted = _G.muted
			cmdprefix = _G.cmdprefix
		end
	end
end

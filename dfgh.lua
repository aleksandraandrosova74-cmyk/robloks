local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- ===================================================================
-- 1. НАЛАШТУВАННЯ АТМОСФЕРИ (М'ятно-рожевий стиль)
-- ===================================================================
Lighting.Ambient = Color3.fromRGB(210, 250, 245)
Lighting.OutdoorAmbient = Color3.fromRGB(255, 230, 240)
Lighting.ClockTime = 14

local colorCorrection = Instance.new("ColorCorrectionEffect")
colorCorrection.TintColor = Color3.fromRGB(255, 235, 245)
colorCorrection.Saturation = 0.2
colorCorrection.Parent = Lighting

-- ===================================================================
-- 2. СТВОРЕННЯ МЕНЮ ТА ОБКЛАДИНКИ (GUI)
-- ===================================================================
local function setupUI(player)
	local playerGui = player:WaitForChild("PlayerGui")

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "MintPinkMenu"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	-- Обкладинка на увесь екран
	local bgFrame = Instance.new("Frame")
	bgFrame.Name = "Background"
	bgFrame.Size = UDim2.new(1, 0, 1, 0)
	bgFrame.BackgroundColor3 = Color3.fromRGB(230, 255, 250)
	bgFrame.Parent = screenGui

	-- М'ятно-рожевий градієнт
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 250, 240)), -- М'ятний
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 215, 230))  -- Рожевий
	})
	gradient.Rotation = 45
	gradient.Parent = bgFrame

	-- Заголовок
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(0, 400, 0, 80)
	title.Position = UDim2.new(0.5, -200, 0.25, 0)
	title.BackgroundTransparency = 1
	title.Text = "MINT & PINK WORLD"
	title.TextColor3 = Color3.fromRGB(80, 80, 100)
	title.TextScaled = true
	title.Font = Enum.Font.FredokaOne
	title.Parent = bgFrame

	-- Кнопка "ГРАТИ"
	local playBtn = Instance.new("TextButton")
	playBtn.Size = UDim2.new(0, 220, 0, 60)
	playBtn.Position = UDim2.new(0.5, -110, 0.55, 0)
	playBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 205)
	playBtn.Text = "ГРАТИ"
	playBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	playBtn.TextScaled = true
	playBtn.Font = Enum.Font.FredokaOne
	playBtn.Parent = bgFrame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 20)
	corner.Parent = playBtn

	-- Логіка для кнопки при кліку
	playBtn.MouseButton1Click:Connect(function()
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			local hrp = character.HumanoidRootPart

			-- Ефект салюту/частинок навколо гравця
			local attachment = Instance.new("Attachment", hrp)
			local emitter = Instance.new("ParticleEmitter", attachment)
			emitter.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(168, 240, 229)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(251, 182, 206))
			})
			emitter.Size = NumberSequence.new(1.5, 0)
			emitter.Rate = 300
			emitter.Speed = NumberRange.new(15, 30)
			emitter.Lifetime = NumberRange.new(0.5, 1)

			task.delay(0.6, function()
				emitter.Enabled = false
				attachment:Destroy()
			end)
		end

		-- Плавне зникання меню
		local tween = TweenService:Create(bgFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
		tween:Play()
		tween.Completed:Connect(function()
			screenGui:Destroy()
		end)
	end)
end

-- ===================================================================
-- 3. ІНТЕРАКТИВНА ФІШКА: Сяюча кольорова стежка під ногами
-- ===================================================================
local function startInteractiveTrail(character)
	local hrp = character:WaitForChild("HumanoidRootPart")
	local lastPos = hrp.Position

	task.spawn(function()
		while character and character:Parent() do
			if (hrp.Position - lastPos).Magnitude > 2.5 then
				lastPos = hrp.Position

				-- Створюємо неонову плиту
				local tile = Instance.new("Part")
				tile.Size = Vector3.new(2.8, 0.2, 2.8)
				tile.Position = hrp.Position - Vector3.new(0, 2.8, 0)
				tile.Anchored = true
				tile.CanCollide = false
				tile.Material = Enum.Material.Neon
				tile.Color = Color3.fromRGB(168, 240, 229) -- Світло-м'ятний
				tile.Parent = workspace

				-- Анімація: колір змінюється на рожевий, а плита зменшується і зникає
				local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				local tween = TweenService:Create(tile, tweenInfo, {
					Color = Color3.fromRGB(251, 182, 206), -- Рожевий
					Transparency = 1,
					Size = Vector3.new(0.2, 0.2, 0.2)
				})
				tween:Play()
				tween.Completed:Connect(function()
					tile:Destroy()
				end)
			end
			task.wait(0.08)
		end
	end)
end

-- Підключення до гравців
Players.PlayerAdded:Connect(function(player)
	setupUI(player)

	player.CharacterAdded:Connect(function(character)
		startInteractiveTrail(character)
	end)
end)
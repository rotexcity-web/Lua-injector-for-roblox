-- =============================================================
--  RluaRB Injector Panel v3.0 (ПОЛНАЯ ВЕРСИЯ)
--  ПРОСТАЯ СЕРАЯ ПАНЕЛЬ ДЛЯ ВВОДА И ЗАПУСКА LUA-КОДА
--  ПОДДЕРЖИВАЕТ loadstring, game:HttpGet И ДРУГИЕ КОМАНДЫ
--  ОТКРЫТИЕ: Shift (ПК) / ПЛАВАЮЩАЯ КНОПКА (МОБИЛА)
-- =============================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- ===== ПЕРЕМЕННЫЕ =====
local panelOpen = false

-- ===== СОЗДАНИЕ GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "RluaRB"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui") or game:GetService("CoreGui")

-- ===== ПАНЕЛЬ =====
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0, 420, 0, 340)
panel.Position = UDim2.new(0.5, -210, 0.5, -170)
panel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
panel.BackgroundTransparency = 0
panel.BorderSizePixel = 2
panel.BorderColor3 = Color3.fromRGB(100, 100, 100)
panel.Visible = true
panel.ZIndex = 1000
panel.Active = true
panel.Draggable = true

local panelCorner = Instance.new("UICorner", panel)
panelCorner.CornerRadius = UDim.new(0, 8)

-- ===== ЗАГОЛОВОК =====
local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1, 0, 0.1, 0)
title.Text = "RluaRB Injector v3.0"
title.TextColor3 = Color3.fromRGB(220, 220, 220)
title.TextScaled = true
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.ZIndex = 1001

-- ===== КНОПКА ЗАКРЫТИЯ =====
local closeBtn = Instance.new("ImageButton", panel)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(0.92, 0, 0.01, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
closeBtn.BackgroundTransparency = 0
closeBtn.Image = "rbxassetid://"
closeBtn.BorderSizePixel = 1
closeBtn.BorderColor3 = Color3.fromRGB(200, 200, 200)
closeBtn.ZIndex = 1002
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0, 4)
local closeText = Instance.new("TextLabel", closeBtn)
closeText.Size = UDim2.new(1, 0, 1, 0)
closeText.Text = "✕"
closeText.TextColor3 = Color3.fromRGB(255, 255, 255)
closeText.TextScaled = true
closeText.BackgroundTransparency = 1
closeText.Font = Enum.Font.GothamBold

closeBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
    panelOpen = false
end)

-- ===== ТЕКСТОВОЕ ПОЛЕ =====
local codeBox = Instance.new("TextBox", panel)
codeBox.Size = UDim2.new(0.9, 0, 0.5, 0)
codeBox.Position = UDim2.new(0.05, 0, 0.15, 0)
codeBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
codeBox.TextColor3 = Color3.fromRGB(220, 220, 220)
codeBox.PlaceholderText = "Введите Lua-код здесь..."
codeBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
codeBox.TextScaled = false
codeBox.TextSize = 14
codeBox.Font = Enum.Font.Code
codeBox.MultiLine = true
codeBox.ClearTextOnFocus = false
codeBox.ZIndex = 1001
local codeCorner = Instance.new("UICorner", codeBox)
codeCorner.CornerRadius = UDim.new(0, 6)

-- ===== СТАТУС БАР =====
local statusBar = Instance.new("Frame", panel)
statusBar.Size = UDim2.new(0.9, 0, 0.04, 0)
statusBar.Position = UDim2.new(0.05, 0, 0.67, 0)
statusBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
statusBar.BackgroundTransparency = 0
statusBar.BorderSizePixel = 0
statusBar.ZIndex = 1001
local statusCorner = Instance.new("UICorner", statusBar)
statusCorner.CornerRadius = UDim.new(0, 3)

local statusText = Instance.new("TextLabel", statusBar)
statusText.Size = UDim2.new(1, 0, 1, 0)
statusText.Text = "готов к выполнению"
statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
statusText.TextScaled = true
statusText.BackgroundTransparency = 1
statusText.Font = Enum.Font.Gotham
statusText.TextSize = 12

-- ===== КНОПКА "ВЫПОЛНИТЬ" =====
local execBtn = Instance.new("ImageButton", panel)
execBtn.Size = UDim2.new(0.25, 0, 0.12, 0)
execBtn.Position = UDim2.new(0.05, 0, 0.74, 0)
execBtn.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
execBtn.BackgroundTransparency = 0
execBtn.Image = "rbxassetid://"
execBtn.BorderSizePixel = 1
execBtn.BorderColor3 = Color3.fromRGB(200, 200, 200)
execBtn.ZIndex = 1001
local execCorner = Instance.new("UICorner", execBtn)
execCorner.CornerRadius = UDim.new(0, 6)
local execText = Instance.new("TextLabel", execBtn)
execText.Size = UDim2.new(1, 0, 1, 0)
execText.Text = "▶ ВЫПОЛНИТЬ"
execText.TextColor3 = Color3.fromRGB(255, 255, 255)
execText.TextScaled = true
execText.BackgroundTransparency = 1
execText.Font = Enum.Font.GothamBold

execBtn.MouseButton1Click:Connect(function()
    local code = codeBox.Text
    if not code or code == "" then
        statusText.Text = "❌ Введите код!"
        statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    statusText.Text = "⏳ Выполнение..."
    statusText.TextColor3 = Color3.fromRGB(255, 200, 100)
    
    local success, result = pcall(function()
        local func, err = loadstring(code)
        if func then
            return func()
        else
            error(err)
        end
    end)
    
    if success then
        statusText.Text = "✅ Код выполнен успешно!"
        statusText.TextColor3 = Color3.fromRGB(100, 255, 100)
        print("✅ КОД ВЫПОЛНЕН!")
        task.wait(1.5)
        statusText.Text = "готов к выполнению"
        statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
    else
        statusText.Text = "❌ Ошибка: " .. tostring(result)
        statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
        print("❌ ОШИБКА: " .. tostring(result))
        task.wait(3)
        statusText.Text = "готов к выполнению"
        statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end)

-- ===== КНОПКА "ОЧИСТИТЬ" =====
local clearBtn = Instance.new("ImageButton", panel)
clearBtn.Size = UDim2.new(0.15, 0, 0.12, 0)
clearBtn.Position = UDim2.new(0.33, 0, 0.74, 0)
clearBtn.BackgroundColor3 = Color3.fromRGB(160, 80, 80)
clearBtn.BackgroundTransparency = 0
clearBtn.Image = "rbxassetid://"
clearBtn.BorderSizePixel = 1
clearBtn.BorderColor3 = Color3.fromRGB(200, 200, 200)
clearBtn.ZIndex = 1001
local clearCorner = Instance.new("UICorner", clearBtn)
clearCorner.CornerRadius = UDim.new(0, 6)
local clearText = Instance.new("TextLabel", clearBtn)
clearText.Size = UDim2.new(1, 0, 1, 0)
clearText.Text = "✖ ОЧИСТИТЬ"
clearText.TextColor3 = Color3.fromRGB(255, 255, 255)
clearText.TextScaled = true
clearText.BackgroundTransparency = 1
clearText.Font = Enum.Font.GothamBold

clearBtn.MouseButton1Click:Connect(function()
    codeBox.Text = ""
    statusText.Text = "поле очищено"
    statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

-- ===== КНОПКА "ВСТАВИТЬ" =====
local pasteBtn = Instance.new("ImageButton", panel)
pasteBtn.Size = UDim2.new(0.15, 0, 0.12, 0)
pasteBtn.Position = UDim2.new(0.51, 0, 0.74, 0)
pasteBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 160)
pasteBtn.BackgroundTransparency = 0
pasteBtn.Image = "rbxassetid://"
pasteBtn.BorderSizePixel = 1
pasteBtn.BorderColor3 = Color3.fromRGB(200, 200, 200)
pasteBtn.ZIndex = 1001
local pasteCorner = Instance.new("UICorner", pasteBtn)
pasteCorner.CornerRadius = UDim.new(0, 6)
local pasteText = Instance.new("TextLabel", pasteBtn)
pasteText.Size = UDim2.new(1, 0, 1, 0)
pasteText.Text = "📋 ВСТАВИТЬ"
pasteText.TextColor3 = Color3.fromRGB(255, 255, 255)
pasteText.TextScaled = true
pasteText.BackgroundTransparency = 1
pasteText.Font = Enum.Font.GothamBold

pasteBtn.MouseButton1Click:Connect(function()
    local success, result = pcall(function()
        return UserInputService:GetStringFromClipboard()
    end)
    if success and result and result ~= "" then
        codeBox.Text = result
        statusText.Text = "✅ Вставлено из буфера"
        statusText.TextColor3 = Color3.fromRGB(100, 255, 100)
        task.wait(1)
        statusText.Text = "готов к выполнению"
        statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
    else
        statusText.Text = "❌ Не удалось вставить"
        statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
        task.wait(1.5)
        statusText.Text = "готов к выполнению"
        statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end)

-- ===== КНОПКА "СОХРАНИТЬ" =====
local saveBtn = Instance.new("ImageButton", panel)
saveBtn.Size = UDim2.new(0.12, 0, 0.12, 0)
saveBtn.Position = UDim2.new(0.69, 0, 0.74, 0)
saveBtn.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
saveBtn.BackgroundTransparency = 0
saveBtn.Image = "rbxassetid://"
saveBtn.BorderSizePixel = 1
saveBtn.BorderColor3 = Color3.fromRGB(200, 200, 200)
saveBtn.ZIndex = 1001
local saveCorner = Instance.new("UICorner", saveBtn)
saveCorner.CornerRadius = UDim.new(0, 6)
local saveText = Instance.new("TextLabel", saveBtn)
saveText.Size = UDim2.new(1, 0, 1, 0)
saveText.Text = "💾"
saveText.TextColor3 = Color3.fromRGB(255, 255, 255)
saveText.TextScaled = true
saveText.BackgroundTransparency = 1
saveText.Font = Enum.Font.GothamBold

saveBtn.MouseButton1Click:Connect(function()
    local code = codeBox.Text
    if code and code ~= "" then
        _G.SavedCode = code
        statusText.Text = "✅ Код сохранён в _G.SavedCode"
        statusText.TextColor3 = Color3.fromRGB(100, 255, 100)
        print("✅ КОД СОХРАНЁН В _G.SavedCode")
        task.wait(1.5)
        statusText.Text = "готов к выполнению"
        statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
    else
        statusText.Text = "❌ Нет кода для сохранения"
        statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
        task.wait(1.5)
        statusText.Text = "готов к выполнению"
        statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end)

-- ===== КНОПКА "ЗАГРУЗИТЬ" =====
local loadBtn = Instance.new("ImageButton", panel)
loadBtn.Size = UDim2.new(0.12, 0, 0.12, 0)
loadBtn.Position = UDim2.new(0.83, 0, 0.74, 0)
loadBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
loadBtn.BackgroundTransparency = 0
loadBtn.Image = "rbxassetid://"
loadBtn.BorderSizePixel = 1
loadBtn.BorderColor3 = Color3.fromRGB(200, 200, 200)
loadBtn.ZIndex = 1001
local loadCorner = Instance.new("UICorner", loadBtn)
loadCorner.CornerRadius = UDim.new(0, 6)
local loadText = Instance.new("TextLabel", loadBtn)
loadText.Size = UDim2.new(1, 0, 1, 0)
loadText.Text = "📂"
loadText.TextColor3 = Color3.fromRGB(255, 255, 255)
loadText.TextScaled = true
loadText.BackgroundTransparency = 1
loadText.Font = Enum.Font.GothamBold

loadBtn.MouseButton1Click:Connect(function()
    if _G.SavedCode then
        codeBox.Text = _G.SavedCode
        statusText.Text = "✅ Код загружен из _G.SavedCode"
        statusText.TextColor3 = Color3.fromRGB(100, 255, 100)
        print("✅ КОД ЗАГРУЖЕН ИЗ _G.SavedCode")
        task.wait(1.5)
        statusText.Text = "готов к выполнению"
        statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
    else
        statusText.Text = "❌ Нет сохранённого кода"
        statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
        task.wait(1.5)
        statusText.Text = "готов к выполнению"
        statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end)

-- ===== ПЛАВАЮЩАЯ КНОПКА =====
local mobileBtn = Instance.new("ImageButton", gui)
mobileBtn.Size = UDim2.new(0, 55, 0, 55)
mobileBtn.Position = UDim2.new(0.85, 0, 0.8, 0)
mobileBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
mobileBtn.BackgroundTransparency = 0
mobileBtn.Image = "rbxassetid://"
mobileBtn.BorderSizePixel = 2
mobileBtn.BorderColor3 = Color3.fromRGB(200, 200, 200)
mobileBtn.Visible = true
mobileBtn.ZIndex = 9999
local mbCorner = Instance.new("UICorner", mobileBtn)
mbCorner.CornerRadius = UDim.new(1, 0)
local mbText = Instance.new("TextLabel", mobileBtn)
mbText.Size = UDim2.new(1, 0, 1, 0)
mbText.Text = "📜"
mbText.TextColor3 = Color3.fromRGB(255, 255, 255)
mbText.TextScaled = true
mbText.BackgroundTransparency = 1
mbText.Font = Enum.Font.GothamBold

-- ===== ПЕРЕТАСКИВАНИЕ =====
local dragging = false
local dragStart = nil
local startPos = nil

mobileBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mobileBtn.Position
    end
end)

mobileBtn.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        local newX = startPos.X.Scale + delta.X / gui.AbsoluteSize.X
        local newY = startPos.Y.Scale + delta.Y / gui.AbsoluteSize.Y
        mobileBtn.Position = UDim2.new(
            math.clamp(newX, 0, 0.95),
            0,
            math.clamp(newY, 0, 0.95),
            0
        )
    end
end)

mobileBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- ===== ОТКРЫТИЕ =====
mobileBtn.MouseButton1Click:Connect(function()
    panel.Visible = not panel.Visible
    panelOpen = panel.Visible
end)

-- ===== SHIFT =====
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
        panel.Visible = not panel.Visible
        panelOpen = panel.Visible
    end
end)

-- ===== СТАРТ =====
print("==========================================")
print("📜 RluaRB Injector v3.0 ЗАГРУЖЕН!")
print("⌨️ SHIFT (ПК) или кнопка (мобила) - открыть")
print("✅ ПОДДЕРЖИВАЕТ loadstring, game:HttpGet И ДР.")
print("==========================================")

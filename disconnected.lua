-- created by colddeath on 2026-07-16
-- colddeath was here

local Library = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local gethui = gethui or function() return CoreGui end
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local TweenTime = 0.1
local FadeSpeed = 0.12

local function FromRGB(r, g, b) return Color3.fromRGB(r, g, b) end
local function FromHSV(h, s, v) return Color3.fromHSV(h, s, v) end
local function FromHex(hex) return Color3.fromHex(hex) end

local function TableInsert(t, v) table.insert(t, v) end
local function TableFind(t, v) return table.find(t, v) end
local function TableRemove(t, i) return table.remove(t, i) end
local function TableConcat(t, s) return table.concat(t, s or ", ") end
local function TableClone(t) return table.clone(t) end

local function MathClamp(v, min, max) return math.clamp(v, min, max) end
local function MathFloor(v) return math.floor(v) end
local function MathAbs(v) return math.abs(v) end
local function MathSin(v) return math.sin(v) end

local function StringFormat(fmt, ...) return string.format(fmt, ...) end
local function StringFind(str, pat) return string.find(str, pat) end
local function StringGSub(str, pat, rep) return string.gsub(str, pat, rep) end
local function StringLower(str) return string.lower(str) end
local function StringLen(str) return string.len(str) end

local function InstanceNew(cls) return Instance.new(cls) end

local Themes = {
    Preset = {
        Background = FromRGB(14, 17, 15),
        Border = FromRGB(12, 12, 12),
        Inline = FromRGB(20, 24, 21),
        HoveredElement = FromRGB(37, 42, 45),
        PageBackground = FromRGB(25, 30, 26),
        Outline = FromRGB(42, 49, 45),
        Element = FromRGB(30, 36, 31),
        Gradient = FromRGB(208, 208, 208),
        Text = FromRGB(235, 235, 235),
        TextStroke = FromRGB(0, 0, 0),
        PlaceholderText = FromRGB(185, 185, 185),
        Accent = FromRGB(0, 191, 255)
    }
}

Library.Theme = TableClone(Themes.Preset)
Library.Flags = {}
Library.SetFlags = {}
Library.Connections = {}
Library.Threads = {}
Library.ThemeItems = {}
Library.ThemeMap = {}
Library.OpenFrames = {}
Library.SearchItems = {}
Library.Colorpickers = {}
Library.UnnamedConnections = 0
Library.UnnamedFlags = 0
Library.MenuKeybind = tostring(Enum.KeyCode.RightShift)

Library.Folders = {
    Directory = "disconnected",
    Configs = "disconnected/Configs",
    Assets = "disconnected/Assets",
}

for _, v in pairs(Library.Folders) do
    if not isfolder(v) then makefolder(v) end
end

local Keys = {
    ["Unknown"] = "Unknown", ["Backspace"] = "Back", ["Tab"] = "Tab",
    ["Clear"] = "Clear", ["Return"] = "Return", ["Pause"] = "Pause",
    ["Escape"] = "Escape", ["Space"] = "Space", ["QuotedDouble"] = '"',
    ["Hash"] = "#", ["Dollar"] = "$", ["Percent"] = "%",
    ["Ampersand"] = "&", ["Quote"] = "'", ["LeftParenthesis"] = "(",
    ["RightParenthesis"] = ")", ["Asterisk"] = "*", ["Plus"] = "+",
    ["Comma"] = ",", ["Minus"] = "-", ["Period"] = ".",
    ["Slash"] = "`", ["Three"] = "3", ["Seven"] = "7",
    ["Eight"] = "8", ["Colon"] = ":", ["Semicolon"] = ";",
    ["LessThan"] = "<", ["GreaterThan"] = ">", ["Question"] = "?",
    ["Equals"] = "=", ["At"] = "@", ["LeftBracket"] = "[",
    ["RightBracket"] = "]", ["BackSlash"] = "\\", ["Caret"] = "^",
    ["Underscore"] = "_", ["Backquote"] = "`", ["LeftCurly"] = "{",
    ["Pipe"] = "|", ["RightCurly"] = "}", ["Tilde"] = "~",
    ["Delete"] = "Delete", ["End"] = "End", ["KeypadZero"] = "Keypad0",
    ["KeypadOne"] = "Keypad1", ["KeypadTwo"] = "Keypad2",
    ["KeypadThree"] = "Keypad3", ["KeypadFour"] = "Keypad4",
    ["KeypadFive"] = "Keypad5", ["KeypadSix"] = "Keypad6",
    ["KeypadSeven"] = "Keypad7", ["KeypadEight"] = "Keypad8",
    ["KeypadNine"] = "Keypad9", ["KeypadPeriod"] = "KeypadP",
    ["KeypadDivide"] = "KeypadD", ["KeypadMultiply"] = "KeypadM",
    ["KeypadMinus"] = "KeypadM", ["KeypadPlus"] = "KeypadP",
    ["KeypadEnter"] = "KeypadE", ["KeypadEquals"] = "KeypadE",
    ["Insert"] = "Insert", ["Home"] = "Home", ["PageUp"] = "PageUp",
    ["PageDown"] = "PageDown", ["RightShift"] = "RightShift",
    ["LeftShift"] = "LeftShift", ["RightControl"] = "RightControl",
    ["LeftControl"] = "LeftControl", ["LeftAlt"] = "LeftAlt",
    ["RightAlt"] = "RightAlt"
}

local SpecialCharacters = { "[", "]", "(", ")", "{", "}", "!", "@", "#", "$", "%", "^", "&", "*", "+", "=" }

local function LoadFont()
    if isfile(Library.Folders.Assets .. "/Monaco.json") then
        return Font.new(getcustomasset(Library.Folders.Assets .. "/Monaco.json"))
    end
    if not isfile(Library.Folders.Assets .. "/Monaco.ttf") then
        writefile(Library.Folders.Assets .. "/Monaco.ttf", 
            game:HttpGet("https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/Monaco.ttf"))
    end
    local data = {
        name = "Monaco",
        faces = { { name = "Regular", weight = 400, style = "Regular", 
                    assetId = getcustomasset(Library.Folders.Assets .. "/Monaco.ttf") } }
    }
    writefile(Library.Folders.Assets .. "/Monaco.json", HttpService:JSONEncode(data))
    return Font.new(getcustomasset(Library.Folders.Assets .. "/Monaco.json"))
end
Library.Font = pcall(LoadFont) and LoadFont() or Enum.Font.GothamBold

Library.Holder = Instance.new("ScreenGui")
Library.Holder.Name = "\0"
Library.Holder.ZIndexBehavior = Enum.ZIndexBehavior.Global
Library.Holder.DisplayOrder = 2
Library.Holder.ResetOnSpawn = false
Library.Holder.Parent = gethui()

Library.UnusedHolder = Instance.new("ScreenGui")
Library.UnusedHolder.Name = "\0"
Library.UnusedHolder.ZIndexBehavior = Enum.ZIndexBehavior.Global
Library.UnusedHolder.Enabled = false
Library.UnusedHolder.ResetOnSpawn = false
Library.UnusedHolder.Parent = gethui()

local SnowHolder = Instance.new("ScreenGui")
SnowHolder.Name = "\0"
SnowHolder.ZIndexBehavior = Enum.ZIndexBehavior.Global
SnowHolder.DisplayOrder = 1
SnowHolder.ResetOnSpawn = false
SnowHolder.Parent = gethui()

local SnowFrame = Instance.new("Frame")
SnowFrame.Size = UDim2.new(1, 0, 1, 0)
SnowFrame.BackgroundTransparency = 1
SnowFrame.BorderSizePixel = 0
SnowFrame.Parent = SnowHolder
SnowFrame.Visible = false

local Snowflakes = {}
local SnowConnection

for i = 1, 25 do
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, 5, 0, 5)
    f.BackgroundColor3 = Color3.new(1, 1, 1)
    f.BackgroundTransparency = 0
    f.BorderSizePixel = 0
    f.Parent = SnowFrame
    f.Visible = false
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = f
    Snowflakes[i] = {
        Frame = f,
        X = math.random(),
        Y = math.random(-100, 0) / 100,
        Speed = math.random(20, 60) / 100,
        Drift = math.random(-15, 15) / 100,
        Opacity = math.random(30, 80) / 100
    }
end

function Library:StartSnow()
    SnowFrame.Visible = true
    for _, s in pairs(Snowflakes) do
        s.Frame.Visible = true
        s.Frame.Position = UDim2.new(s.X, 0, s.Y, 0)
        s.Frame.BackgroundTransparency = 1 - s.Opacity
    end
    if SnowConnection then SnowConnection:Disconnect() end
    SnowConnection = RunService.RenderStepped:Connect(function(dt)
        for _, s in pairs(Snowflakes) do
            local pos = s.Frame.Position
            local ny = pos.Y.Scale + s.Speed * dt * 0.2
            local nx = pos.X.Scale + s.Drift * dt * 0.05
            if ny > 1.1 then ny = -0.1; nx = math.random() end
            if nx > 1.1 then nx = -0.1 elseif nx < -0.1 then nx = 1.1 end
            s.Frame.Position = UDim2.new(nx, 0, ny, 0)
            s.X = nx; s.Y = ny
        end
    end)
end

function Library:StopSnow()
    for _, s in pairs(Snowflakes) do
        s.Frame.Visible = false
    end
    SnowFrame.Visible = false
    if SnowConnection then SnowConnection:Disconnect(); SnowConnection = nil end
end

Library.NotifHolder = Instance.new("Frame")
Library.NotifHolder.Name = "\0"
Library.NotifHolder.BackgroundTransparency = 1
Library.NotifHolder.Size = UDim2.new(0, 0, 1, 0)
Library.NotifHolder.BorderColor3 = FromRGB(0, 0, 0)
Library.NotifHolder.BorderSizePixel = 0
Library.NotifHolder.AutomaticSize = Enum.AutomaticSize.X
Library.NotifHolder.BackgroundColor3 = FromRGB(255, 255, 255)
Library.NotifHolder.Parent = Library.Holder

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.Parent = Library.NotifHolder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Padding = UDim.new(0, 12)
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder

local NotifPadding = Instance.new("UIPadding")
NotifPadding.Parent = Library.NotifHolder
NotifPadding.PaddingTop = UDim.new(0, 12)
NotifPadding.PaddingBottom = UDim.new(0, 12)
NotifPadding.PaddingRight = UDim.new(0, 12)
NotifPadding.PaddingLeft = UDim.new(0, 12)

function Library:Connect(event, cb)
    local conn = event:Connect(cb)
    TableInsert(self.Connections, { Connection = conn })
    return conn
end

function Library:Thread(fn)
    local t = coroutine.create(fn)
    coroutine.wrap(function() coroutine.resume(t) end)()
    TableInsert(self.Threads, t)
    return t
end

function Library:SafeCall(fn, ...)
    local args = { ... }
    local ok, err = pcall(fn, table.unpack(args))
    if not ok then warn(err) return false end
    return true
end

function Library:NextFlag()
    self.UnnamedFlags = self.UnnamedFlags + 1
    return "flag_" .. self.UnnamedFlags .. "_" .. HttpService:GenerateGUID(false)
end

function Library:EscapePattern(str)
    for _, v in pairs(SpecialCharacters) do
        if StringFind(str, v) then
            return StringGSub(str, "[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
        end
    end
    return str
end

function Library:Round(num, dec)
    local mult = 1 / (dec or 1)
    return MathFloor(num * mult) / mult
end

function Library:AddToTheme(item, props)
    item = item.Instance or item
    local data = { Item = item, Properties = props }
    for prop, val in pairs(props) do
        item[prop] = type(val) == "string" and self.Theme[val] or val()
    end
    TableInsert(self.ThemeItems, data)
    self.ThemeMap[item] = data
end

function Library:ChangeTheme(theme, color)
    self.Theme[theme] = color
    for _, item in pairs(self.ThemeItems) do
        for prop, val in pairs(item.Properties) do
            if type(val) == "string" and val == theme then
                item.Item[prop] = color
            elseif type(val) == "function" then
                item.Item[prop] = val()
            end
        end
    end
end

local Instances = {}
Instances.__index = Instances

function Instances:Create(cls, props)
    local obj = { Instance = InstanceNew(cls), Properties = props }
    setmetatable(obj, Instances)
    for prop, val in pairs(props) do obj.Instance[prop] = val end
    return obj
end

function Instances:AddToTheme(props) Library:AddToTheme(self, props) end
function Instances:Connect(event, cb) return Library:Connect(self.Instance[event], cb) end
function Instances:Tween(info, goal) 
    return TweenService:Create(self.Instance, info or TweenInfo.new(TweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal) 
end
function Instances:ChangeItemTheme(props) 
    Library:ChangeItemTheme(self, props) 
end

local function BuildWindow(data)
    local win = Instances:Create("Frame", {
        Parent = data.Parent,
        Name = "\0",
        AnchorPoint = data.AnchorPoint,
        Position = data.Position,
        BorderColor3 = FromRGB(12, 12, 12),
        Size = data.Size,
        BorderSizePixel = 2,
        BackgroundColor3 = FromRGB(14, 17, 15)
    })
    win:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
    return win
end

local function BuildToggle(parent, name, flag, default, callback)
    local toggle = Instances:Create("TextButton", {
        Parent = parent,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(0, 0, 0),
        BorderColor3 = FromRGB(0, 0, 0),
        Text = "",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 12),
        BorderSizePixel = 0,
        TextSize = 14,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    
    local indicator = Instances:Create("Frame", {
        Parent = toggle.Instance,
        Name = "\0",
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        BorderColor3 = FromRGB(12, 12, 12),
        Size = UDim2.new(0, 12, 0, 12),
        BorderSizePixel = 2,
        BackgroundColor3 = FromRGB(30, 36, 31)
    })
    indicator:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
    
    local check = Instances:Create("ImageLabel", {
        Parent = indicator.Instance,
        Name = "\0",
        ImageColor3 = FromRGB(0, 0, 0),
        ScaleType = Enum.ScaleType.Fit,
        ImageTransparency = 1,
        BorderColor3 = FromRGB(0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = "rbxassetid://108016671469439",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 0, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    
    local text = Instances:Create("TextLabel", {
        Parent = toggle.Instance,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(235, 235, 235),
        BorderColor3 = FromRGB(0, 0, 0),
        Text = name,
        Size = UDim2.new(0, 0, 0, 15),
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 22, 0.5, 0),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 9,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    text:AddToTheme({TextColor3 = "Text"})
    
    local value = false
    local obj = {
        Get = function() return value end,
        Set = function(v)
            value = v
            Library.Flags[flag] = v
            if value then
                indicator:ChangeItemTheme({BackgroundColor3 = "Accent", BorderColor3 = "Border"})
                indicator.Instance.BackgroundColor3 = Library.Theme.Accent
                check.Instance:TweenSize(UDim2.new(1, 2, 1, 2), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.2, true)
                check.Instance.ImageTransparency = 0
            else
                indicator:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
                indicator.Instance.BackgroundColor3 = Library.Theme.Element
                check.Instance:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.2, true)
                check.Instance.ImageTransparency = 1
            end
            if callback then Library:SafeCall(callback, value) end
        end
    }
    toggle:Connect("MouseButton1Down", function() obj:Set(not value) end)
    obj:Set(default or false)
    Library.SetFlags[flag] = function(v) obj:Set(v) end
    return obj
end

function Library:Window(data)
    data = data or {}
    local win = BuildWindow({
        Parent = self.Holder,
        AnchorPoint = Vector2.new(0, 0),
        Position = data.Position or UDim2.new(0, Camera.ViewportSize.X / 3.3, 0, Camera.ViewportSize.Y / 3.3),
        Size = data.Size or UDim2.new(0, 751, 0, 539)
    })
    
    local logo = Instances:Create("ImageLabel", {
        Parent = win.Instance,
        Name = "\0",
        ImageColor3 = FromRGB(0, 191, 255),
        ScaleType = Enum.ScaleType.Fit,
        BorderColor3 = FromRGB(0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0),
        Image = "rbxassetid://132447680232071",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0, 12),
        Size = UDim2.new(0, 75, 0, 75),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    logo:AddToTheme({ImageColor3 = "Accent"})
    
    local content = Instances:Create("Frame", {
        Parent = win.Instance,
        Name = "\0",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 100),
        Size = UDim2.new(1, -24, 1, -112),
        BorderColor3 = FromRGB(0, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    
    local windowObj = {
        Win = win,
        Content = content,
        Pages = {},
        IsOpen = false,
        SetOpen = function(self, bool)
            self.IsOpen = bool
            win.Instance.Visible = bool
            if bool then Library:StartSnow() else Library:StopSnow() end
        end
    }
    
    Library:Connect(UserInputService.InputBegan, function(input)
        if tostring(input.KeyCode) == Library.MenuKeybind or tostring(input.UserInputType) == Library.MenuKeybind then
            windowObj:SetOpen(not windowObj.IsOpen)
        end
    end)
    
    windowObj:SetOpen(true)
    return windowObj
end

function Library:Page(window, name)
    local page = Instances:Create("Frame", {
        Parent = window.Content.Instance,
        Name = "\0",
        BackgroundTransparency = 1,
        Visible = false,
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = page.Instance
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalFlex = Enum.UIFlexAlignment.Fill
    layout.Padding = UDim.new(0, 14)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local columns = {}
    for i = 1, 2 do
        local col = Instance.new("ScrollingFrame")
        col.Parent = page.Instance
        col.Name = "\0"
        col.ScrollBarImageColor3 = FromRGB(0, 0, 0)
        col.Active = true
        col.AutomaticCanvasSize = Enum.AutomaticSize.Y
        col.ScrollBarThickness = 0
        col.BackgroundTransparency = 1
        col.Size = UDim2.new(1, 0, 1, 0)
        col.BackgroundColor3 = FromRGB(255, 255, 255)
        col.BorderColor3 = FromRGB(0, 0, 0)
        col.BorderSizePixel = 0
        col.CanvasSize = UDim2.new(0, 0, 0, 0)
        columns[i] = col
    end
    
    local pageObj = { Page = page, Columns = columns, Active = false }
    pageObj.Turn = function(self, bool)
        self.Active = bool
        page.Instance.Visible = bool
    end
    
    table.insert(window.Pages, pageObj)
    if #window.Pages == 1 then pageObj:Turn(true) end
    return pageObj
end

function Library:Section(page, name, side)
    side = side or 1
    local section = Instance.new("Frame")
    section.Parent = page.Columns[side]
    section.Name = "\0"
    section.Size = UDim2.new(1, 0, 0, 25)
    section.BorderColor3 = FromRGB(42, 49, 45)
    section.BorderSizePixel = 2
    section.AutomaticSize = Enum.AutomaticSize.Y
    section.BackgroundColor3 = FromRGB(20, 24, 21)
    
    local title = Instance.new("TextLabel")
    title.Parent = section
    title.Name = "\0"
    title.FontFace = Library.Font
    title.TextColor3 = FromRGB(235, 235, 235)
    title.BorderColor3 = FromRGB(0, 0, 0)
    title.Text = name
    title.Size = UDim2.new(0, 0, 0, 15)
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 6, 0, 5)
    title.BorderSizePixel = 0
    title.AutomaticSize = Enum.AutomaticSize.X
    title.TextSize = 9
    title.BackgroundColor3 = FromRGB(255, 255, 255)
    
    local content = Instance.new("Frame")
    content.Parent = section
    content.Name = "\0"
    content.BorderColor3 = FromRGB(0, 0, 0)
    content.BackgroundTransparency = 1
    content.Position = UDim2.new(0, 10, 0, 26)
    content.Size = UDim2.new(1, -20, 0, 0)
    content.BorderSizePixel = 0
    content.AutomaticSize = Enum.AutomaticSize.Y
    content.BackgroundColor3 = FromRGB(255, 255, 255)
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = content
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    return { Content = content, Section = section }
end

function Library:Toggle(section, data)
    data = data or {}
    return BuildToggle(
        section.Content,
        data.Name or "Toggle",
        data.Flag or Library:NextFlag(),
        data.Default or false,
        data.Callback or function() end
    )
end

function Library:Notification(title, desc, duration)
    duration = duration or 3
    local frame = Instance.new("Frame")
    frame.Name = "\0"
    frame.Size = UDim2.new(0, 0, 0, 25)
    frame.BorderColor3 = FromRGB(12, 12, 12)
    frame.BorderSizePixel = 2
    frame.AutomaticSize = Enum.AutomaticSize.XY
    frame.BackgroundColor3 = FromRGB(14, 17, 15)
    frame.Parent = Library.NotifHolder
    
    local t = Instance.new("TextLabel")
    t.Parent = frame
    t.Name = "\0"
    t.FontFace = Library.Font
    t.TextColor3 = FromRGB(235, 235, 235)
    t.BorderColor3 = FromRGB(0, 0, 0)
    t.Text = title
    t.BackgroundTransparency = 1
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.BorderSizePixel = 0
    t.AutomaticSize = Enum.AutomaticSize.XY
    t.TextSize = 9
    t.BackgroundColor3 = FromRGB(255, 255, 255)
    
    local d = Instance.new("TextLabel")
    d.Parent = frame
    d.Name = "\0"
    d.FontFace = Library.Font
    d.TextColor3 = FromRGB(235, 235, 235)
    d.TextTransparency = 0.4
    d.Text = desc
    d.Position = UDim2.new(0, 0, 0, 15)
    d.BorderSizePixel = 0
    d.BackgroundTransparency = 1
    d.TextXAlignment = Enum.TextXAlignment.Left
    d.BorderColor3 = FromRGB(0, 0, 0)
    d.AutomaticSize = Enum.AutomaticSize.XY
    d.TextSize = 9
    d.BackgroundColor3 = FromRGB(255, 255, 255)
    
    task.delay(duration, function()
        frame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        task.wait(0.3)
        frame:Destroy()
    end)
end

function Library:Unload()
    for _, v in pairs(self.Connections) do pcall(function() v.Connection:Disconnect() end) end
    for _, v in pairs(self.Threads) do pcall(function() coroutine.close(v) end) end
    if self.Holder then pcall(function() self.Holder:Destroy() end) end
    self:StopSnow()
    getgenv().Library = nil
end

local UIS = game:GetService("UserInputService")
if UIS.TouchEnabled then
    local TouchGui = Instance.new("ScreenGui")
    TouchGui.Name = "\0"
    TouchGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    TouchGui.DisplayOrder = 9999
    TouchGui.ResetOnSpawn = false
    TouchGui.Parent = gethui()

    local ToggleButton = Instance.new("ImageButton")
    ToggleButton.Size = UDim2.new(0, 55, 0, 55)
    ToggleButton.Position = UDim2.new(0, 25, 0.8, 0)
    ToggleButton.BackgroundColor3 = FromRGB(25, 25, 25)
    ToggleButton.BackgroundTransparency = 0
    ToggleButton.BorderSizePixel = 0
    ToggleButton.AutoButtonColor = false
    ToggleButton.Image = "rbxassetid://132447680232071"
    ToggleButton.ImageTransparency = 0
    ToggleButton.Parent = TouchGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1, 0)
    Corner.Parent = ToggleButton

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = FromRGB(0, 191, 255)
    Stroke.Thickness = 2
    Stroke.Transparency = 0
    Stroke.Parent = ToggleButton

    local dragging = false
    local dragDist = 0
    local dragStart = Vector2.new()
    local buttonStart = UDim2.new()

    ToggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            dragDist = 0
            dragStart = input.Position
            buttonStart = ToggleButton.Position
        end
    end)

    ToggleButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and not dragging then
            local delta = (input.Position - dragStart).Magnitude
            if delta > 10 then
                dragging = true
            end
        end
    end)

    ToggleButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                ToggleButton.Position = UDim2.new(0, buttonStart.X.Offset + delta.X, 0, buttonStart.Y.Offset + delta.Y)
                dragging = false
            else
                if Library._ToggleMenu then
                    Library._ToggleMenu()
                end
            end
        end
    end)
end

function Library:SetToggleFunction(fn)
    self._ToggleMenu = fn
end

getgenv().Library = Library
return Library

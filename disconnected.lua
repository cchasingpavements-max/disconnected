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

function Library:ChangeItemTheme(item, props)
    item = item.Instance or item
    if not self.ThemeMap[item] then return end
    self.ThemeMap[item].Properties = props
    for prop, val in pairs(props) do
        item[prop] = type(val) == "string" and self.Theme[val] or val()
    end
end

function Library:IsMouseOverFrame(frame, xOff, yOff)
    frame = frame.Instance
    xOff = xOff or 0
    yOff = yOff or 0
    local mp = UserInputService:GetMouseLocation()
    return mp.X >= frame.AbsolutePosition.X - xOff and mp.X <= frame.AbsolutePosition.X + frame.AbsoluteSize.X + xOff
        and mp.Y >= frame.AbsolutePosition.Y - yOff and mp.Y <= frame.AbsolutePosition.Y + frame.AbsoluteSize.Y + yOff
end

function Library:GetImage(img)
    local data = self.Images and self.Images[img]
    if not data then return end
    return getcustomasset(self.Folders.Assets .. "/" .. data[1])
end

function Library:ToRich(text, color)
    return `<font color="rgb({MathFloor(color.R * 255)}, {MathFloor(color.G * 255)}, {MathFloor(color.B * 255)})">{text}</font>`
end

function Library:Lerp(start, finish, t)
    return start + (finish - start) * t
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
function Instances:ChangeItemTheme(props) Library:ChangeItemTheme(self, props) end
function Instances:Connect(event, cb) return Library:Connect(self.Instance[event], cb) end
function Instances:Disconnect(name) return Library:Disconnect(name) end
function Instances:Clean() self.Instance:Destroy(); self = nil end
function Instances:Tween(info, goal)
    return TweenService:Create(self.Instance, info or TweenInfo.new(TweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal)
end
function Instances:Fade(visible, speed)
    local item = self.Instance
    if visible then item.Visible = true end
    local descendants = item:GetDescendants()
    TableInsert(descendants, item)
    local tw
    for _, v in pairs(descendants) do
        local props = {}
        if v:IsA("Frame") then props = { "BackgroundTransparency" }
        elseif v:IsA("TextLabel") or v:IsA("TextButton") then props = { "TextTransparency", "BackgroundTransparency" }
        elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then props = { "BackgroundTransparency", "ImageTransparency" }
        elseif v:IsA("ScrollingFrame") then props = { "BackgroundTransparency", "ScrollBarImageTransparency" }
        elseif v:IsA("TextBox") then props = { "TextTransparency", "BackgroundTransparency" }
        elseif v:IsA("UIStroke") then props = { "Transparency" }
        end
        for _, prop in pairs(props) do
            local old = v[prop]
            v[prop] = visible and 1 or old
            tw = TweenService:Create(v, TweenInfo.new(speed or FadeSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                [prop] = visible and old or 1
            })
            tw:Play()
            if not visible then
                tw.Completed:Connect(function()
                    task.wait()
                    v[prop] = old
                end)
            end
        end
    end
    return tw
end

function Instances:MakeDraggable()
    local gui = self.Instance
    local dragging = false
    local dragStart, startPos
    local inputChanged
    local function set(input)
        local delta = input.Position - dragStart
        self:Tween(TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        })
    end
    self:Connect("InputBegan", function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            if inputChanged then return end
            inputChanged = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    inputChanged:Disconnect()
                    inputChanged = nil
                end
            end)
        end
    end)
    Library:Connect(UserInputService.InputChanged, function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
            set(input)
        end
    end)
end

function Instances:MakeResizeable(min, max)
    local gui = self.Instance
    local resizing = false
    local start, delta, resizeMax
    local btn = Instances:Create("ImageButton", {
        Parent = gui,
        Image = "rbxassetid://",
        AnchorPoint = Vector2.new(1, 1),
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2.new(0, 6, 0, 6),
        Position = UDim2.new(1, -4, 1, -4),
        Name = "\0",
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ZIndex = 5,
        AutoButtonColor = false,
        Visible = true,
    })
    btn:AddToTheme({ImageColor3 = "Accent"})
    local inputChanged
    btn:Connect("InputBegan", function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            start = gui.Size - UDim2.new(0, input.Position.X, 0, input.Position.Y)
            if inputChanged then return end
            inputChanged = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resizing = false
                    inputChanged:Disconnect()
                    inputChanged = nil
                end
            end)
        end
    end)
    Library:Connect(UserInputService.InputChanged, function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and resizing then
            resizeMax = max or gui.Parent.AbsoluteSize - gui.AbsoluteSize
            delta = start + UDim2.new(0, input.Position.X, 0, input.Position.Y)
            delta = UDim2.new(0, MathClamp(delta.X.Offset, min.X, resizeMax.X), 0, MathClamp(delta.Y.Offset, min.Y, resizeMax.Y))
            self:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = delta})
        end
    end)
end

function Instances:OnHover(fn) return Library:Connect(self.Instance.MouseEnter, fn) end
function Instances:OnHoverLeave(fn) return Library:Connect(self.Instance.MouseLeave, fn) end
function Instances:Border(type)
    local color = type == "Border" and Library.Theme.Border or type == "Outline" and Library.Theme.Outline
    local stroke = Instances:Create("UIStroke", {
        Parent = self.Instance,
        Color = color,
        Thickness = 1,
        LineJoinMode = Enum.LineJoinMode.Miter
    })
    stroke:AddToTheme({Color = type})
    return stroke
end
function Instances:TextBorder()
    local stroke = Instances:Create("UIStroke", {
        Parent = self.Instance,
        Color = Library.Theme["Text Stroke"],
        Thickness = 1,
        Transparency = 0.6,
        LineJoinMode = Enum.LineJoinMode.Miter
    })
    stroke:AddToTheme({Color = "Text Stroke"})
    return stroke
end

function Instances:Tooltip(data)
    if not data.Text then return end
    local gui = self.Instance
    local mousePos = UserInputService:GetMouseLocation()
    local renderStepped
    local items = {}
    items.Tooltip = Instances:Create("Frame", {
        Parent = Library.Holder.Instance,
        Name = "\0",
        Size = UDim2.new(0, 0, 0, 25),
        Position = UDim2.new(0, gui.AbsolutePosition.X, 0, gui.AbsolutePosition.Y),
        BorderColor3 = FromRGB(12, 12, 12),
        BorderSizePixel = 2,
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundTransparency = 1,
        BackgroundColor3 = FromRGB(14, 17, 15)
    })
    items.Tooltip:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
    items.UIStroke = Instances:Create("UIStroke", {
        Parent = items.Tooltip.Instance,
        Color = FromRGB(0, 0, 0),
        Thickness = 1,
        Transparency = 1,
        LineJoinMode = Enum.LineJoinMode.Miter
    })
    items.UIStroke:AddToTheme({Color = "Outline"})
    Instances:Create("UIPadding", {
        Parent = items.Tooltip.Instance,
        Name = "\0",
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 5)
    })
    items.Title = Instances:Create("TextLabel", {
        Parent = items.Tooltip.Instance,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(202, 243, 255),
        BorderColor3 = FromRGB(0, 0, 0),
        Text = data.Text,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 1,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.XY,
        TextSize = 9,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    items.Title:AddToTheme({TextColor3 = "Accent"})
    items.UIStroke2 = items.Title:TextBorder()
    items.UIStroke2.Instance.Transparency = 1
    items.Description = Instances:Create("TextLabel", {
        Parent = items.Tooltip.Instance,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(235, 235, 235),
        BorderColor3 = FromRGB(0, 0, 0),
        Text = data.Description,
        Position = UDim2.new(0, 0, 0, 15),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        TextTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.XY,
        TextSize = 9,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    items.Description:AddToTheme({TextColor3 = "Text"})
    items.UIStroke3 = items.Description:TextBorder()
    items.UIStroke3.Instance.Transparency = 1
    Library:Connect(gui.MouseEnter, function()
        items.Tooltip.Instance.Position = UDim2.new(0, mousePos.X + 8, 0, mousePos.Y - 32)
        items.Tooltip:Tween(nil, {BackgroundTransparency = 0})
        items.Title:Tween(nil, {TextTransparency = 0})
        items.Description:Tween(nil, {TextTransparency = 0})
        items.UIStroke:Tween(nil, {Transparency = 0})
        items.UIStroke2:Tween(nil, {Transparency = 0})
        items.UIStroke3:Tween(nil, {Transparency = 0})
        renderStepped = RunService.RenderStepped:Connect(function()
            mousePos = UserInputService:GetMouseLocation()
            items.Tooltip:Tween(nil, {Position = UDim2.new(0, mousePos.X + 8, 0, mousePos.Y - 35)})
        end)
    end)
    Library:Connect(gui.MouseLeave, function()
        items.Tooltip:Tween(nil, {BackgroundTransparency = 1})
        items.Title:Tween(nil, {TextTransparency = 1})
        items.Description:Tween(nil, {TextTransparency = 1})
        items.UIStroke:Tween(nil, {Transparency = 1})
        items.UIStroke2:Tween(nil, {Transparency = 1})
        items.UIStroke3:Tween(nil, {Transparency = 1})
        if renderStepped then renderStepped:Disconnect(); renderStepped = nil end
    end)
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

local function BuildAutosizingLabel(data)
    local label = {}
    local items = {}
    items.Label = Instances:Create("TextLabel", {
        Parent = data.Parent.Instance,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(235, 235, 235),
        BorderColor3 = FromRGB(0, 0, 0),
        Text = data.Text,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.XY,
        TextSize = 9,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    items.Label:AddToTheme({TextColor3 = "Text"})
    items.UIStroke = items.Label:TextBorder()
    function label:SetProperty(prop, val) items.Label.Instance[prop] = val end
    return label, items
end

local function BuildWindowPage(data)
    local page = {
        Active = false,
        SubPages = {},
        Items = {},
        Window = data.Window,
        ColumnsData = {}
    }
    local items = {}
    items.Inactive = Instances:Create("TextButton", {
        Parent = data.Parent.Instance,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(0, 0, 0),
        BorderColor3 = FromRGB(12, 12, 12),
        Text = "",
        AutoButtonColor = false,
        BackgroundTransparency = 0.6,
        Size = UDim2.new(1, 0, 0, 25),
        BorderSizePixel = 2,
        TextSize = 14,
        BackgroundColor3 = FromRGB(25, 30, 26)
    })
    items.Inactive:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Border"})
    items.ButtonBorder = Instances:Create("UIStroke", {
        Parent = items.Inactive.Instance,
        Name = "\0",
        Color = FromRGB(61, 60, 65),
        Transparency = 0.6,
        LineJoinMode = Enum.LineJoinMode.Miter,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
    items.ButtonBorder:AddToTheme({Color = "Outline"})
    items.Liner = Instances:Create("Frame", {
        Parent = items.Inactive.Instance,
        Name = "\0",
        BackgroundTransparency = 1,
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2.new(0, 1, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(25, 30, 26)
    })
    items.Liner:AddToTheme({BackgroundColor3 = "Accent"})
    items.Text = Instances:Create("TextLabel", {
        Parent = items.Inactive.Instance,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(235, 235, 235),
        BorderColor3 = FromRGB(0, 0, 0),
        Text = data.Name,
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 0, 0, 15),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0.5, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 9,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    items.Text:AddToTheme({TextColor3 = "Text"})
    items.TextStroke = items.Text:TextBorder()
    items.Glow = Instances:Create("Frame", {
        Parent = items.Inactive.Instance,
        Name = "\0",
        BackgroundTransparency = 1,
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2.new(0, 20, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(25, 30, 26)
    })
    items.Glow:AddToTheme({BackgroundColor3 = "Accent"})
    Instances:Create("UIGradient", {
        Parent = items.Glow.Instance,
        Name = "\0",
        Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.193, 0.86875), NumberSequenceKeypoint.new(0.504, 0.96875), NumberSequenceKeypoint.new(1, 1)})
    })
    items.Page = Instances:Create("Frame", {
        Parent = data.ContentHolder.Instance,
        Name = "\0",
        BackgroundTransparency = 1,
        Visible = false,
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    if data.SubPages then
        items.SubPages = Instances:Create("Frame", {
            Parent = items.Page.Instance,
            Name = "\0",
            Size = UDim2.new(0, 0, 0, 35),
            BorderColor3 = FromRGB(42, 49, 45),
            BorderSizePixel = 2,
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundColor3 = FromRGB(20, 24, 21)
        })
        items.SubPages:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Outline"})
        items.SubPages:Border("Border")
        Instances:Create("UIPadding", {
            Parent = items.SubPages.Instance,
            Name = "\0",
            PaddingRight = UDim.new(0, 7),
            PaddingLeft = UDim.new(0, 7)
        })
        Instances:Create("UIListLayout", {
            Parent = items.SubPages.Instance,
            Name = "\0",
            VerticalAlignment = Enum.VerticalAlignment.Center,
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 12),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        items.Columns = Instances:Create("Frame", {
            Parent = items.Page.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 51),
            BorderColor3 = FromRGB(42, 49, 45),
            Size = UDim2.new(1, 0, 1, -51),
            BorderSizePixel = 0,
            BackgroundColor3 = FromRGB(255, 255, 255)
        })
    else
        Instances:Create("UIListLayout", {
            Parent = items.Page.Instance,
            Name = "\0",
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Padding = UDim.new(0, 14),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        for i = 1, data.Columns do
            local col = Instances:Create("ScrollingFrame", {
                Parent = items.Page.Instance,
                Name = "\0",
                ScrollBarImageColor3 = FromRGB(0, 0, 0),
                Active = true,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 0,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                CanvasSize = UDim2.new(0, 0, 0, 0)
            })
            Instances:Create("UIPadding", {
                Parent = col.Instance,
                Name = "\0",
                PaddingTop = UDim.new(0, 2),
                PaddingBottom = UDim.new(0, 2),
                PaddingRight = UDim.new(0, 2),
                PaddingLeft = UDim.new(0, 2)
            })
            Instances:Create("UIListLayout", {
                Parent = col.Instance,
                Name = "\0",
                Padding = UDim.new(0, 14),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            page.ColumnsData[i] = col
        end
    end
    page.Items = items
    local debounce = false
    function page:Turn(bool)
        if debounce then return end
        page.Active = bool
        debounce = true
        items.Page.Instance.Visible = bool
        items.Page.Instance.Parent = bool and data.ContentHolder.Instance or Library.UnusedHolder.Instance
        if page.Active then
            items.Inactive:Tween(nil, {BackgroundTransparency = 0})
            items.ButtonBorder:Tween(nil, {Transparency = 0})
            items.Glow:Tween(nil, {BackgroundTransparency = 0})
            items.Liner:Tween(nil, {BackgroundTransparency = 0})
            items.Text:Tween(nil, {Position = UDim2.new(0, 13, 0.5, 0)})
            Library.CurrentPage = page
        else
            items.Inactive:Tween(nil, {BackgroundTransparency = 0.6})
            items.ButtonBorder:Tween(nil, {Transparency = 0.6})
            items.Glow:Tween(nil, {BackgroundTransparency = 1})
            items.Liner:Tween(nil, {BackgroundTransparency = 1})
            items.Text:Tween(nil, {Position = UDim2.new(0, 8, 0.5, 0)})
        end
        local all = items.Page.Instance:GetDescendants()
        TableInsert(all, items.Page.Instance)
        local tw
        for _, v in pairs(all) do
            local props = {}
            if v:IsA("Frame") then props = { "BackgroundTransparency" }
            elseif v:IsA("TextLabel") or v:IsA("TextButton") then props = { "TextTransparency", "BackgroundTransparency" }
            elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then props = { "BackgroundTransparency", "ImageTransparency" }
            elseif v:IsA("ScrollingFrame") then props = { "BackgroundTransparency", "ScrollBarImageTransparency" }
            elseif v:IsA("TextBox") then props = { "TextTransparency", "BackgroundTransparency" }
            elseif v:IsA("UIStroke") then props = { "Transparency" }
            end
            for _, prop in pairs(props) do
                local old = v[prop]
                v[prop] = bool and 1 or old
                tw = TweenService:Create(v, TweenInfo.new(data.Window.FadeTime or FadeSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    [prop] = bool and old or 1
                })
                tw:Play()
                if not bool then
                    tw.Completed:Connect(function()
                        task.wait()
                        v[prop] = old
                    end)
                end
            end
        end
        Library:Connect(tw.Completed, function() debounce = false end)
    end
    items.Inactive:Connect("MouseButton1Down", function()
        for _, v in pairs(data.Window.Pages) do
            if v == page and page.Active then return end
            v:Turn(v == page)
        end
    end)
    items.Inactive:OnHover(function()
        items.Inactive:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
        items.Inactive:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
    end)
    items.Inactive:OnHoverLeave(function()
        items.Inactive:ChangeItemTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Border"})
        items.Inactive:Tween(nil, {BackgroundColor3 = Library.Theme["Page Background"]})
    end)
    if #data.Window.Pages == 0 then page:Turn(true) end
    TableInsert(data.Window.Pages, page)
    return page, items
end

local function BuildWindowSubPage(data)
    local subPage = {
        Active = false,
        ColumnsData = {}
    }
    local items = {}
    items.Inactive = Instances:Create("TextButton", {
        Parent = data.Page.Items.SubPages.Instance,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(0, 0, 0),
        BorderColor3 = FromRGB(12, 12, 12),
        Text = "",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, 20),
        BorderSizePixel = 2,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 14,
        BackgroundColor3 = FromRGB(25, 30, 26)
    })
    items.Inactive:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Border"})
    items.ButtonBorder = Instances:Create("UIStroke", {
        Parent = items.Inactive.Instance,
        Name = "\0",
        Color = FromRGB(61, 60, 65),
        Transparency = 1,
        LineJoinMode = Enum.LineJoinMode.Miter,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
    items.ButtonBorder:AddToTheme({Color = "Outline"})
    items.Text = Instances:Create("TextLabel", {
        Parent = items.Inactive.Instance,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(235, 235, 235),
        BorderColor3 = FromRGB(0, 0, 0),
        Text = data.Name,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 0, 0, 15),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, -5, 0.5, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 9,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    items.Text:AddToTheme({TextColor3 = "Text"})
    items.TextStroke = items.Text:TextBorder()
    Instances:Create("UIPadding", {
        Parent = items.Text.Instance,
        Name = "\0",
        PaddingRight = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8)
    })
    Instances:Create("UIPadding", {
        Parent = items.Inactive.Instance,
        Name = "\0",
        PaddingTop = UDim.new(0, 2),
        PaddingLeft = UDim.new(0, 18),
        PaddingRight = UDim.new(0, 12)
    })
    items.Glow = Instances:Create("Frame", {
        Parent = items.Inactive.Instance,
        Name = "\0",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -18, 0, -2),
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2.new(0, 20, 1, 2),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(202, 243, 255)
    })
    items.Glow:AddToTheme({BackgroundColor3 = "Accent"})
    Instances:Create("UIGradient", {
        Parent = items.Glow.Instance,
        Name = "\0",
        Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.193, 0.86875), NumberSequenceKeypoint.new(0.504, 0.96875), NumberSequenceKeypoint.new(1, 1)})
    })
    items.Liner = Instances:Create("Frame", {
        Parent = items.Inactive.Instance,
        Name = "\0",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -18, 0, -2),
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2.new(0, 1, 1, 2),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(202, 243, 255)
    })
    items.Liner:AddToTheme({BackgroundColor3 = "Accent"})
    items.Page = Instances:Create("Frame", {
        Parent = data.Page.Items.Columns.Instance,
        Name = "\0",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -2, 0, -2),
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2.new(1, 2, 1, 0),
        BorderSizePixel = 0,
        Visible = false,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    Instances:Create("UIListLayout", {
        Parent = items.Page.Instance,
        Name = "\0",
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        Padding = UDim.new(0, 14),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    for i = 1, data.Columns do
        local col = Instances:Create("ScrollingFrame", {
            Parent = items.Page.Instance,
            Name = "\0",
            ScrollBarImageColor3 = FromRGB(0, 0, 0),
            Active = true,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 0,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = FromRGB(255, 255, 255),
            BorderColor3 = FromRGB(0, 0, 0),
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        })
        Instances:Create("UIPadding", {
            Parent = col.Instance,
            Name = "\0",
            PaddingTop = UDim.new(0, 2),
            PaddingBottom = UDim.new(0, 2),
            PaddingRight = UDim.new(0, 2),
            PaddingLeft = UDim.new(0, 2)
        })
        Instances:Create("UIListLayout", {
            Parent = col.Instance,
            Name = "\0",
            Padding = UDim.new(0, 14),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        subPage.ColumnsData[i] = col
    end
    Library.SearchItems[subPage] = {}
    local debounce = false
    function subPage:Turn(bool)
        if debounce then return end
        subPage.Active = bool
        debounce = true
        items.Page.Instance.Visible = bool
        items.Page.Instance.Parent = bool and data.Page.Items.Columns.Instance or Library.UnusedHolder.Instance
        if subPage.Active then
            items.Inactive:Tween(nil, {BackgroundTransparency = 0})
            items.ButtonBorder:Tween(nil, {Transparency = 0})
            items.Liner:Tween(nil, {BackgroundTransparency = 0})
            items.Glow:Tween(nil, {BackgroundTransparency = 0})
            items.Text:Tween(nil, {Position = UDim2.new(0.5, 0, 0.5, 0)})
            Library.CurrentPage = subPage
        else
            items.Inactive:Tween(nil, {BackgroundTransparency = 1})
            items.ButtonBorder:Tween(nil, {Transparency = 1})
            items.Liner:Tween(nil, {BackgroundTransparency = 1})
            items.Glow:Tween(nil, {BackgroundTransparency = 1})
            items.Text:Tween(nil, {Position = UDim2.new(0.5, -5, 0.5, 0)})
        end
        local all = items.Page.Instance:GetDescendants()
        TableInsert(all, items.Page.Instance)
        local tw
        for _, v in pairs(all) do
            local props = {}
            if v:IsA("Frame") then props = { "BackgroundTransparency" }
            elseif v:IsA("TextLabel") or v:IsA("TextButton") then props = { "TextTransparency", "BackgroundTransparency" }
            elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then props = { "BackgroundTransparency", "ImageTransparency" }
            elseif v:IsA("ScrollingFrame") then props = { "BackgroundTransparency", "ScrollBarImageTransparency" }
            elseif v:IsA("TextBox") then props = { "TextTransparency", "BackgroundTransparency" }
            elseif v:IsA("UIStroke") then props = { "Transparency" }
            end
            for _, prop in pairs(props) do
                local old = v[prop]
                v[prop] = bool and 1 or old
                tw = TweenService:Create(v, TweenInfo.new(data.Window.FadeTime or FadeSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    [prop] = bool and old or 1
                })
                tw:Play()
                if not bool then
                    tw.Completed:Connect(function()
                        task.wait()
                        v[prop] = old
                    end)
                end
            end
        end
        Library:Connect(tw.Completed, function() debounce = false end)
    end
    items.Inactive:Connect("MouseButton1Down", function()
        for _, v in pairs(data.Page.SubPages) do
            if v == subPage and subPage.Active then return end
            v:Turn(v == subPage)
        end
    end)
    if #data.Page.SubPages == 0 then subPage:Turn(true) end
    TableInsert(data.Page.SubPages, subPage)
    return subPage
end

local function BuildToggle(parent, name, flag, default, callback, page)
    local toggle = {}
    local items = {}
    items.Toggle = Instances:Create("TextButton", {
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
    items.Indicator = Instances:Create("Frame", {
        Parent = items.Toggle.Instance,
        Name = "\0",
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        BorderColor3 = FromRGB(12, 12, 12),
        Size = UDim2.new(0, 12, 0, 12),
        BorderSizePixel = 2,
        BackgroundColor3 = FromRGB(30, 36, 31)
    })
    items.Indicator:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
    Instances:Create("UIStroke", {
        Parent = items.Indicator.Instance,
        Name = "\0",
        Color = FromRGB(42, 49, 45),
        LineJoinMode = Enum.LineJoinMode.Miter,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }):AddToTheme({Color = "Outline"})
    Instances:Create("UIGradient", {
        Parent = items.Indicator.Instance,
        Name = "\0",
        Rotation = -165,
        Color = ColorSequence.new({ColorSequenceKeypoint.new(0, FromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, FromRGB(208, 208, 208))})
    }):AddToTheme({Color = function()
        return ColorSequence.new({ColorSequenceKeypoint.new(0, FromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Library.Theme.Gradient)})
    end})
    items.Check = Instances:Create("ImageLabel", {
        Parent = items.Indicator.Instance,
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
    items.Text = Instances:Create("TextLabel", {
        Parent = items.Toggle.Instance,
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
    items.Text:AddToTheme({TextColor3 = "Text"})
    items.TextStroke = items.Text:TextBorder()
    items.SubElements = Instances:Create("Frame", {
        Parent = items.Toggle.Instance,
        Name = "\0",
        BorderColor3 = FromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, items.Text.Instance.TextBounds.X + 30, 0, 0),
        Size = UDim2.new(0, 0, 1, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    Instances:Create("UIListLayout", {
        Parent = items.SubElements.Instance,
        Name = "\0",
        VerticalAlignment = Enum.VerticalAlignment.Center,
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local value = false
    function toggle:Get() return value end
    function toggle:SetText(text) items.Text.Instance.Text = tostring(text) end
    function toggle:Set(v)
        value = v
        Library.Flags[flag] = v
        if value then
            items.Indicator:ChangeItemTheme({BackgroundColor3 = "Accent", BorderColor3 = "Border"})
            items.Indicator:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})
            task.wait(0.05)
            items.Check:Tween(TweenInfo.new(TweenTime, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {ImageTransparency = 0, Size = UDim2.new(1, 2, 1, 2)})
        else
            items.Indicator:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
            items.Indicator:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
            task.wait(0.05)
            items.Check:Tween(TweenInfo.new(TweenTime, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {ImageTransparency = 1, Size = UDim2.new(0, 0, 0, 0)})
        end
        if callback then Library:SafeCall(callback, value) end
    end
    function toggle:SetVisibility(bool) items.Toggle.Instance.Visible = bool end
    local pageSearch = Library.SearchItems[page]
    if pageSearch then
        TableInsert(pageSearch, { Element = items.Toggle, Name = name })
    end
    items.Toggle:Connect("MouseButton1Down", function() toggle:Set(not value) end)
    items.Toggle:OnHover(function()
        if value then return end
        items.Indicator:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
        items.Indicator:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
    end)
    items.Toggle:OnHoverLeave(function()
        if value then return end
        items.Indicator:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
        items.Indicator:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
    end)
    toggle:Set(default or false)
    Library.SetFlags[flag] = function(v) toggle:Set(v) end
    return toggle, items
end

local function BuildButton(parent, page)
    local button = {}
    local items = {}
    items.Button = Instances:Create("Frame", {
        Parent = parent,
        Name = "\0",
        BackgroundTransparency = 1,
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2.new(1, 0, 0, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    Instances:Create("UIListLayout", {
        Parent = items.Button.Instance,
        Name = "\0",
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    function button:Add(name, cb)
        local btn = {}
        local subItems = {}
        subItems.NewButton = Instances:Create("TextButton", {
            Parent = items.Button.Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = FromRGB(0, 0, 0),
            BorderColor3 = FromRGB(12, 12, 12),
            Text = "",
            AutoButtonColor = false,
            Size = UDim2.new(1, 0, 0, 20),
            BorderSizePixel = 2,
            TextSize = 14,
            BackgroundColor3 = FromRGB(30, 36, 31)
        })
        subItems.NewButton:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
        Instances:Create("UIGradient", {
            Parent = subItems.NewButton.Instance,
            Name = "\0",
            Rotation = -165,
            Color = ColorSequence.new({ColorSequenceKeypoint.new(0, FromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, FromRGB(208, 208, 208))})
        }):AddToTheme({Color = function()
            return ColorSequence.new({ColorSequenceKeypoint.new(0, FromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Library.Theme.Gradient)})
        end})
        Instances:Create("UIStroke", {
            Parent = subItems.NewButton.Instance,
            Name = "\0",
            Color = FromRGB(42, 49, 45),
            LineJoinMode = Enum.LineJoinMode.Miter,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        }):AddToTheme({Color = "Outline"})
        subItems.Text = Instances:Create("TextLabel", {
            Parent = subItems.NewButton.Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = FromRGB(235, 235, 235),
            BorderColor3 = FromRGB(0, 0, 0),
            Text = name,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            TextSize = 9,
            BackgroundColor3 = FromRGB(255, 255, 255)
        })
        subItems.Text:AddToTheme({TextColor3 = "Text"})
        subItems.TextStroke = subItems.Text:TextBorder()
        function btn:Press()
            subItems.NewButton:ChangeItemTheme({BackgroundColor3 = "Accent", BorderColor3 = "Border"})
            subItems.NewButton:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})
            Library:SafeCall(cb)
            task.wait(0.1)
            subItems.NewButton:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
            subItems.NewButton:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
        end
        function btn:SetVisibility(bool) subItems.NewButton.Instance.Visible = bool end
        local pageSearch = Library.SearchItems[page]
        if pageSearch then
            TableInsert(pageSearch, { Element = subItems.NewButton, Name = name })
        end
        subItems.NewButton:OnHover(function()
            subItems.NewButton:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
            subItems.NewButton:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
        end)
        subItems.NewButton:OnHoverLeave(function()
            subItems.NewButton:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
            subItems.NewButton:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
        end)
        subItems.NewButton:Connect("MouseButton1Down", function() btn:Press() end)
        return btn
    end
    function button:SetVisibility(bool) items.Button.Instance.Visible = bool end
    return button, items
end

local function BuildSlider(parent, name, flag, min, max, decimals, suffix, default, callback, page)
    local slider = {
        Value = 0,
        Sliding = false
    }
    local items = {}
    items.Slider = Instances:Create("Frame", {
        Parent = parent,
        Name = "\0",
        BackgroundTransparency = 1,
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2.new(1, 0, 0, 28),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    items.Text = Instances:Create("TextLabel", {
        Parent = items.Slider.Instance,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(235, 235, 235),
        BorderColor3 = FromRGB(0, 0, 0),
        Text = name,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, 15),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 9,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    items.Text:AddToTheme({TextColor3 = "Text"})
    items.TextStroke = items.Text:TextBorder()
    items.RealSlider = Instances:Create("TextButton", {
        Parent = items.Slider.Instance,
        AutoButtonColor = false,
        Text = "",
        Name = "\0",
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        BorderColor3 = FromRGB(12, 12, 12),
        Size = UDim2.new(1, 0, 0, 10),
        BorderSizePixel = 2,
        BackgroundColor3 = FromRGB(30, 36, 31)
    })
    items.RealSlider:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
    Instances:Create("UIGradient", {
        Parent = items.RealSlider.Instance,
        Name = "\0",
        Rotation = -165,
        Color = ColorSequence.new({ColorSequenceKeypoint.new(0, FromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, FromRGB(208, 208, 208))})
    }):AddToTheme({Color = function()
        return ColorSequence.new({ColorSequenceKeypoint.new(0, FromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Library.Theme.Gradient)})
    end})
    Instances:Create("UIStroke", {
        Parent = items.RealSlider.Instance,
        Name = "\0",
        Color = FromRGB(42, 49, 45),
        LineJoinMode = Enum.LineJoinMode.Miter,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }):AddToTheme({Color = "Outline"})
    items.Accent = Instances:Create("Frame", {
        Parent = items.RealSlider.Instance,
        Name = "\0",
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(202, 243, 255)
    })
    items.Accent:AddToTheme({BackgroundColor3 = "Accent"})
    Instances:Create("UIGradient", {
        Parent = items.Accent.Instance,
        Name = "\0",
        Rotation = -165,
        Color = ColorSequence.new({ColorSequenceKeypoint.new(0, FromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, FromRGB(208, 208, 208))})
    }):AddToTheme({Color = function()
        return ColorSequence.new({ColorSequenceKeypoint.new(0, FromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Library.Theme.Gradient)})
    end})
    items.Dragger = Instances:Create("Frame", {
        Parent = items.Accent.Instance,
        Name = "\0",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        BorderColor3 = FromRGB(42, 49, 45),
        Size = UDim2.new(0, 3, 1, 3),
        BorderSizePixel = 2,
        BackgroundColor3 = FromRGB(14, 17, 15)
    })
    items.Dragger:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Outline"})
    Instances:Create("UIStroke", {
        Parent = items.Dragger.Instance,
        Name = "\0",
        Color = FromRGB(12, 12, 12),
        LineJoinMode = Enum.LineJoinMode.Miter,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }):AddToTheme({Color = "Border"})
    items.Value = Instances:Create("TextLabel", {
        Parent = items.Slider.Instance,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(235, 235, 235),
        BorderColor3 = FromRGB(0, 0, 0),
        Text = "50%",
        AnchorPoint = Vector2.new(1, 0),
        Size = UDim2.new(0, 0, 0, 15),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, 0, 0, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 9,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    items.Value:AddToTheme({TextColor3 = "Text"})
    items.ValueStroke = items.Value:TextBorder()
    function slider:Get() return slider.Value end
    function slider:SetVisibility(bool) items.Slider.Instance.Visible = bool end
    function slider:Set(v)
        slider.Value = Library:Round(MathClamp(v, min, max), decimals)
        Library.Flags[flag] = slider.Value
        items.Accent:Tween(TweenInfo.new(TweenTime, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new((slider.Value - min) / (max - min), 0, 1, 0)})
        items.Value.Instance.Text = StringFormat("%s%s", tostring(slider.Value), suffix)
        if callback then Library:SafeCall(callback, slider.Value) end
    end
    local inputChanged
    items.RealSlider:Connect("InputBegan", function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            slider.Sliding = true
            local sizeX = (UserInputService:GetMouseLocation().X - items.RealSlider.Instance.AbsolutePosition.X) / items.RealSlider.Instance.AbsoluteSize.X
            local v = ((max - min) * sizeX) + min
            slider:Set(v)
            if inputChanged then return end
            inputChanged = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    slider.Sliding = false
                    inputChanged:Disconnect()
                    inputChanged = nil
                end
            end)
        end
    end)
    Library:Connect(UserInputService.InputChanged, function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and slider.Sliding then
            local sizeX = (UserInputService:GetMouseLocation().X - items.RealSlider.Instance.AbsolutePosition.X) / items.RealSlider.Instance.AbsoluteSize.X
            local v = ((max - min) * sizeX) + min
            slider:Set(v)
        end
    end)
    items.Slider:OnHover(function()
        items.RealSlider:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
        items.RealSlider:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
    end)
    items.Slider:OnHoverLeave(function()
        items.RealSlider:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
        items.RealSlider:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
    end)
    if default then slider:Set(default) end
    Library.SetFlags[flag] = function(v) slider:Set(v) end
    return slider, items
end

local function BuildLabel(parent, name, page)
    local label = {}
    local items = {}
    items.Label = Instances:Create("Frame", {
        Parent = parent,
        Name = "\0",
        BackgroundTransparency = 1,
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2.new(1, 0, 0, 20),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    items.Text = Instances:Create("TextLabel", {
        Parent = items.Label.Instance,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(235, 235, 235),
        BorderColor3 = FromRGB(0, 0, 0),
        Text = name,
        Size = UDim2.new(0, 0, 0, 15),
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 9,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    items.Text:AddToTheme({TextColor3 = "Text"})
    items.TextStroke = items.Text:TextBorder()
    items.SubElements = Instances:Create("Frame", {
        Parent = items.Label.Instance,
        Name = "\0",
        BorderColor3 = FromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, items.Text.Instance.TextBounds.X + 8, 0, 0),
        Size = UDim2.new(0, 0, 1, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    Instances:Create("UIListLayout", {
        Parent = items.SubElements.Instance,
        Name = "\0",
        VerticalAlignment = Enum.VerticalAlignment.Center,
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    function label:SetText(text) items.Text.Instance.Text = tostring(text) end
    function label:SetVisibility(bool) items.Label.Instance.Visible = bool end
    local pageSearch = Library.SearchItems[page]
    if pageSearch then
        TableInsert(pageSearch, { Element = items.Label, Name = name })
    end
    function label:Colorpicker(data)
        data = data or {}
        local cp = {}
        return cp, {}
    end
    function label:Keybind(data)
        data = data or {}
        local kb = {}
        return kb, {}
    end
    return label, items
end

local function BuildDropdown(parent, name, flag, itemsList, default, multi, callback, page)
    local dropdown = {
        Value = {},
        Options = {},
        IsOpen = false
    }
    local items = {}
    items.Dropdown = Instances:Create("Frame", {
        Parent = parent,
        Name = "\0",
        BackgroundTransparency = 1,
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2.new(1, 0, 0, 40),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    items.Text = Instances:Create("TextLabel", {
        Parent = items.Dropdown.Instance,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(235, 235, 235),
        BorderColor3 = FromRGB(0, 0, 0),
        Text = name,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, 15),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 9,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    items.Text:AddToTheme({TextColor3 = "Text"})
    items.TextStroke = items.Text:TextBorder()
    items.RealDropdown = Instances:Create("TextButton", {
        Parent = items.Dropdown.Instance,
        AutoButtonColor = false,
        Text = "",
        Name = "\0",
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        BorderColor3 = FromRGB(12, 12, 12),
        Size = UDim2.new(1, 0, 0, 20),
        BorderSizePixel = 2,
        BackgroundColor3 = FromRGB(30, 36, 31)
    })
    items.RealDropdown:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
    Instances:Create("UIGradient", {
        Parent = items.RealDropdown.Instance,
        Name = "\0",
        Rotation = -165,
        Color = ColorSequence.new({ColorSequenceKeypoint.new(0, FromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, FromRGB(208, 208, 208))})
    }):AddToTheme({Color = function()
        return ColorSequence.new({ColorSequenceKeypoint.new(0, FromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Library.Theme.Gradient)})
    end})
    Instances:Create("UIStroke", {
        Parent = items.RealDropdown.Instance,
        Name = "\0",
        Color = FromRGB(42, 49, 45),
        LineJoinMode = Enum.LineJoinMode.Miter,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }):AddToTheme({Color = "Outline"})
    items.Value = Instances:Create("TextLabel", {
        Parent = items.RealDropdown.Instance,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(235, 235, 235),
        BorderColor3 = FromRGB(0, 0, 0),
        Text = "--",
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(1, -25, 0, 15),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0, 8, 0.5, 0),
        BorderSizePixel = 0,
        TextSize = 9,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    items.Value:AddToTheme({TextColor3 = "Text"})
    items.ValueStroke = items.Value:TextBorder()
    items.Icon = Instances:Create("ImageLabel", {
        Parent = items.RealDropdown.Instance,
        Name = "\0",
        ImageColor3 = FromRGB(202, 243, 255),
        ScaleType = Enum.ScaleType.Fit,
        BorderColor3 = FromRGB(0, 0, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Image = "rbxassetid://113229176886493",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -2, 0.5, 0),
        Size = UDim2.new(0, 20, 0, 20),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    items.Icon:AddToTheme({ImageColor3 = "Accent"})
    items.OptionHolder = Instances:Create("Frame", {
        Parent = Library.UnusedHolder.Instance,
        Name = "\0",
        Visible = false,
        BorderColor3 = FromRGB(12, 12, 12),
        BorderSizePixel = 2,
        Position = UDim2.new(0, 0, 1, 8),
        Size = UDim2.new(1, 0, 0, 25),
        ZIndex = 5,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = FromRGB(20, 24, 21)
    })
    items.OptionHolder:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Border"})
    Instances:Create("UIStroke", {
        Parent = items.OptionHolder.Instance,
        Name = "\0",
        Color = FromRGB(42, 49, 45),
        LineJoinMode = Enum.LineJoinMode.Miter,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }):AddToTheme({Color = "Outline"})
    Instances:Create("UIPadding", {
        Parent = items.OptionHolder.Instance,
        Name = "\0",
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 8)
    })
    Instances:Create("UIListLayout", {
        Parent = items.OptionHolder.Instance,
        Name = "\0",
        Padding = UDim.new(0, 3),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    function dropdown:Get() return dropdown.Value end
    local debounce = false
    local renderStepped
    function dropdown:SetOpen(bool)
        if debounce then return end
        dropdown.IsOpen = bool
        debounce = true
        if dropdown.IsOpen then
            items.OptionHolder.Instance.Visible = true
            items.OptionHolder.Instance.Parent = Library.Holder.Instance
            items.Icon:Tween(nil, {Rotation = -90})
            renderStepped = RunService.RenderStepped:Connect(function()
                items.OptionHolder.Instance.Position = UDim2.new(0, items.RealDropdown.Instance.AbsolutePosition.X, 0, items.RealDropdown.Instance.AbsolutePosition.Y + items.RealDropdown.Instance.AbsoluteSize.Y + 5)
                items.OptionHolder.Instance.Size = UDim2.new(0, items.RealDropdown.Instance.AbsoluteSize.X, 0, 0)
            end)
            if not debounce then
                for _, v in pairs(Library.OpenFrames) do
                    if v ~= dropdown then v:SetOpen(false) end
                end
                Library.OpenFrames[dropdown] = dropdown
            end
        else
            if not debounce then
                if Library.OpenFrames[dropdown] then Library.OpenFrames[dropdown] = nil end
            end
            if renderStepped then renderStepped:Disconnect(); renderStepped = nil end
            items.Icon:Tween(nil, {Rotation = 0})
        end
        local descendants = items.OptionHolder.Instance:GetDescendants()
        TableInsert(descendants, items.OptionHolder.Instance)
        local tw
        for _, v in pairs(descendants) do
            local props = {}
            if v:IsA("Frame") then props = { "BackgroundTransparency" }
            elseif v:IsA("TextLabel") or v:IsA("TextButton") then props = { "TextTransparency", "BackgroundTransparency" }
            elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then props = { "BackgroundTransparency", "ImageTransparency" }
            elseif v:IsA("ScrollingFrame") then props = { "BackgroundTransparency", "ScrollBarImageTransparency" }
            elseif v:IsA("TextBox") then props = { "TextTransparency", "BackgroundTransparency" }
            elseif v:IsA("UIStroke") then props = { "Transparency" }
            end
            for _, prop in pairs(props) do
                local old = v[prop]
                v[prop] = bool and 1 or old
                tw = TweenService:Create(v, TweenInfo.new(FadeSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    [prop] = bool and old or 1
                })
                tw:Play()
                if not bool then
                    tw.Completed:Connect(function()
                        task.wait()
                        v[prop] = old
                    end)
                end
            end
        end
        tw.Completed:Connect(function()
            debounce = false
            items.OptionHolder.Instance.Visible = dropdown.IsOpen
            task.wait(0.2)
            items.OptionHolder.Instance.Parent = not dropdown.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
        end)
  end

      function dropdown:SetVisibility(bool) items.Dropdown.Instance.Visible = bool end
    function dropdown:Set(option)
        if multi then
            if type(option) ~= "table" then return end
            dropdown.Value = option
            Library.Flags[flag] = option
            for _, v in pairs(option) do
                local opt = dropdown.Options[v]
                if opt then
                    opt.Selected = true
                    opt:Toggle("Active")
                end
            end
            items.Value.Instance.Text = TableConcat(option, ", ")
        else
            if not dropdown.Options[option] then return end
            local opt = dropdown.Options[option]
            dropdown.Value = option
            Library.Flags[flag] = option
            for _, v in pairs(dropdown.Options) do
                if v ~= opt then
                    v.Selected = false
                    v:Toggle("Inactive")
                else
                    v.Selected = true
                    v:Toggle("Active")
                end
            end
            items.Value.Instance.Text = option
        end
        if callback then Library:SafeCall(callback, dropdown.Value) end
    end
    function dropdown:Add(option)
        local btn = Instances:Create("TextButton", {
            Parent = items.OptionHolder.Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = FromRGB(235, 235, 235),
            BorderColor3 = FromRGB(0, 0, 0),
            Text = option,
            AutoButtonColor = false,
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, 0, 0, 15),
            ZIndex = 5,
            TextSize = 9,
            BackgroundColor3 = FromRGB(255, 255, 255)
        })
        btn:AddToTheme({TextColor3 = "Text"})
        local optData = { Button = btn, Name = option, Selected = false }
        function optData:Toggle(status)
            if status == "Active" then
                optData.Button:ChangeItemTheme({TextColor3 = "Accent"})
                optData.Button:Tween(nil, {TextColor3 = Library.Theme.Accent})
            else
                optData.Button:ChangeItemTheme({TextColor3 = "Text"})
                optData.Button:Tween(nil, {TextColor3 = Library.Theme.Text})
            end
        end
        function optData:Set()
            optData.Selected = not optData.Selected
            if multi then
                local idx = TableFind(dropdown.Value, optData.Name)
                if idx then
                    TableRemove(dropdown.Value, idx)
                else
                    TableInsert(dropdown.Value, optData.Name)
                end
                optData:Toggle(idx and "Inactive" or "Active")
                Library.Flags[flag] = dropdown.Value
                local text = #dropdown.Value > 0 and TableConcat(dropdown.Value, ", ") or "--"
                items.Value.Instance.Text = text
            else
                if optData.Selected then
                    dropdown.Value = optData.Name
                    Library.Flags[flag] = optData.Name
                    optData.Selected = true
                    optData:Toggle("Active")
                    for _, v in pairs(dropdown.Options) do
                        if v ~= optData then
                            v.Selected = false
                            v:Toggle("Inactive")
                        end
                    end
                    items.Value.Instance.Text = optData.Name
                else
                    dropdown.Value = nil
                    Library.Flags[flag] = nil
                    optData.Selected = false
                    optData:Toggle("Inactive")
                    items.Value.Instance.Text = "--"
                end
            end
            if callback then Library:SafeCall(callback, dropdown.Value) end
        end
        btn:Connect("MouseButton1Down", function() optData:Set() end)
        dropdown.Options[optData.Name] = optData
        return optData
    end
    function dropdown:Remove(option)
        if not dropdown.Options[option] then return end
        dropdown.Options[option].Button:Clean()
        dropdown.Options[option] = nil
    end
    function dropdown:Refresh(list)
        for _, v in pairs(dropdown.Options) do dropdown:Remove(v.Name) end
        for _, v in pairs(list) do dropdown:Add(v) end
    end
    items.RealDropdown:Connect("MouseButton1Down", function() dropdown:SetOpen(not dropdown.IsOpen) end)
    items.Dropdown:OnHover(function()
        items.RealDropdown:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
        items.RealDropdown:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
    end)
    items.Dropdown:OnHoverLeave(function()
        items.RealDropdown:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
        items.RealDropdown:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
    end)
    Library:Connect(UserInputService.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if not dropdown.IsOpen then return end
            if Library:IsMouseOverFrame(items.OptionHolder) then return end
            dropdown:SetOpen(false)
        end
    end)
    for _, v in pairs(itemsList) do dropdown:Add(v) end
    if default then dropdown:Set(default) end
    Library.SetFlags[flag] = function(v) dropdown:Set(v) end
    return dropdown, items
end

local function BuildColorpickerTab(data)
    local tab = { Name = data.Name, Active = false }
    local items = {}
    items.Inactive = Instances:Create("TextButton", {
        Parent = data.PageHolder.Instance,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(235, 235, 235),
        BorderColor3 = FromRGB(0, 0, 0),
        Text = tab.Name,
        AutoButtonColor = false,
        Size = UDim2.new(1, 0, 1, 0),
        BorderSizePixel = 0,
        TextSize = 9,
        BackgroundColor3 = FromRGB(20, 24, 21)
    })
    items.Inactive:AddToTheme({BackgroundColor3 = "Inline"})
    items.InactiveStroke = items.Inactive:TextBorder()
    items.PageContent = Instances:Create("Frame", {
        Parent = data.ContentHolder.Instance,
        Name = "\0",
        Visible = false,
        BackgroundTransparency = 1,
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    function tab:Turn(bool)
        tab.Active = bool
        if tab.Active then
            items.PageContent.Instance.Visible = true
            items.PageContent.Instance.Parent = data.ContentHolder.Instance
            items.Inactive:ChangeItemTheme({BackgroundColor3 = "Background"})
            items.Inactive:Tween(nil, {BackgroundColor3 = Library.Theme.Background})
        else
            items.PageContent.Instance.Visible = false
            items.PageContent.Instance.Parent = Library.UnusedHolder.Instance
            items.Inactive:ChangeItemTheme({BackgroundColor3 = "Inline"})
            items.Inactive:Tween(nil, {BackgroundColor3 = Library.Theme.Inline})
        end
    end
    items.Inactive:Connect("MouseButton1Down", function()
        for _, v in pairs(data.Stack) do v:Turn(v == tab) end
    end)
    if #data.Stack == 0 then tab:Turn(true) end
    TableInsert(data.Stack, tab)
    return tab, items
end

local function BuildColorpickerPalette(parent)
    local items = {}
    items.Palette = Instances:Create("TextButton", {
        Parent = parent,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(0, 0, 0),
        BorderColor3 = FromRGB(42, 49, 45),
        Text = "",
        AutoButtonColor = false,
        Position = UDim2.new(0, 8, 0, 8),
        Size = UDim2.new(1, -46, 1, -46),
        BorderSizePixel = 2,
        TextSize = 14,
        BackgroundColor3 = FromRGB(157, 175, 255)
    })
    items.Palette:AddToTheme({BorderColor3 = "Outline"})
    Instances:Create("UIStroke", {
        Parent = items.Palette.Instance,
        Name = "\0",
        Color = FromRGB(12, 12, 12),
        LineJoinMode = Enum.LineJoinMode.Miter,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }):AddToTheme({Color = "Border"})
    items.Saturation = Instances:Create("ImageLabel", {
        Parent = items.Palette.Instance,
        Name = "\0",
        BorderColor3 = FromRGB(0, 0, 0),
        Image = Library:GetImage("Saturation"),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 2,
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    items.Value = Instances:Create("ImageLabel", {
        Parent = items.Palette.Instance,
        Name = "\0",
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2.new(1, 2, 1, 0),
        Image = Library:GetImage("Value"),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -1, 0, 0),
        ZIndex = 3,
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    items.PaletteDragger = Instances:Create("Frame", {
        Parent = items.Palette.Instance,
        Name = "\0",
        Position = UDim2.new(0, 8, 0, 8),
        ZIndex = 5,
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2.new(0, 2, 0, 2),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    Instances:Create("UIStroke", {
        Parent = items.PaletteDragger.Instance,
        Name = "\0",
        Color = FromRGB(12, 12, 12),
        LineJoinMode = Enum.LineJoinMode.Miter,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }):AddToTheme({Color = "Border"})
    items.Hue = Instances:Create("Frame", {
        Parent = parent,
        Name = "\0",
        Active = true,
        BorderColor3 = FromRGB(42, 49, 45),
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -8, 0, 8),
        Size = UDim2.new(0, 20, 1, -16),
        Selectable = true,
        BorderSizePixel = 2,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    items.Hue:AddToTheme({BorderColor3 = "Outline"})
    Instances:Create("UIStroke", {
        Parent = items.Hue.Instance,
        Name = "\0",
        Color = FromRGB(12, 12, 12),
        LineJoinMode = Enum.LineJoinMode.Miter,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }):AddToTheme({Color = "Border"})
    items.HueInline = Instances:Create("TextButton", {
        Parent = items.Hue.Instance,
        Text = "",
        AutoButtonColor = false,
        Name = "\0",
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    Instances:Create("UIGradient", {
        Parent = items.HueInline.Instance,
        Name = "\0",
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, FromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.17, FromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, FromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, FromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.67, FromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.83, FromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, FromRGB(255, 0, 0))
        })
    })
    items.HueDragger = Instances:Create("Frame", {
        Parent = items.Hue.Instance,
        Name = "\0",
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2.new(1, 0, 0, 1),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    Instances:Create("UIStroke", {
        Parent = items.HueDragger.Instance,
        Name = "\0",
        Color = FromRGB(12, 12, 12),
        LineJoinMode = Enum.LineJoinMode.Miter,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }):AddToTheme({Color = "Border"})
    items.Alpha = Instances:Create("TextButton", {
        Parent = parent,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(0, 0, 0),
        BorderColor3 = FromRGB(42, 49, 45),
        Text = "",
        AutoButtonColor = false,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 8, 1, -8),
        Size = UDim2.new(1, -46, 0, 20),
        BorderSizePixel = 2,
        TextSize = 14,
        BackgroundColor3 = FromRGB(157, 175, 255)
    })
    items.Alpha:AddToTheme({BorderColor3 = "Outline"})
    Instances:Create("UIStroke", {
        Parent = items.Alpha.Instance,
        Name = "\0",
        Color = FromRGB(12, 12, 12),
        LineJoinMode = Enum.LineJoinMode.Miter,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }):AddToTheme({Color = "Border"})
    items.Checkers = Instances:Create("ImageLabel", {
        Parent = items.Alpha.Instance,
        Name = "\0",
        ScaleType = Enum.ScaleType.Tile,
        BorderColor3 = FromRGB(0, 0, 0),
        TileSize = UDim2.new(0, 6, 0, 6),
        Image = Library:GetImage("Checkers"),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 2,
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    Instances:Create("UIGradient", {
        Parent = items.Checkers.Instance,
        Name = "\0",
        Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.37, 0.5), NumberSequenceKeypoint.new(1, 0)})
    })
    items.AlphaDragger = Instances:Create("Frame", {
        Parent = items.Alpha.Instance,
        Name = "\0",
        ZIndex = 5,
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2.new(0, 1, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    Instances:Create("UIStroke", {
        Parent = items.AlphaDragger.Instance,
        Name = "\0",
        Color = FromRGB(12, 12, 12),
        LineJoinMode = Enum.LineJoinMode.Miter,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }):AddToTheme({Color = "Border"})
    return items
end

local function BuildColorpicker(parent, flag, default, alpha, callback, page)
    local cp = {
        IsOpen = false,
        Hue = 0, Saturation = 0, Value = 0, Alpha = 0,
        Color = FromRGB(255, 255, 255),
        HexValue = "#ffffff",
        Pages = {},
        Flag = flag
    }
    local items = {}
    items.ColorpickerButton = Instances:Create("TextButton", {
        Parent = parent,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(0, 0, 0),
        BorderColor3 = FromRGB(12, 12, 12),
        Text = "",
        AutoButtonColor = false,
        Size = UDim2.new(0, 15, 0, 15),
        BorderSizePixel = 2,
        TextSize = 14,
        BackgroundColor3 = FromRGB(157, 175, 255)
    })
    items.ColorpickerButton:AddToTheme({BorderColor3 = "Border"})
    Instances:Create("UIStroke", {
        Parent = items.ColorpickerButton.Instance,
        Name = "\0",
        Color = FromRGB(42, 49, 45),
        LineJoinMode = Enum.LineJoinMode.Miter,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }):AddToTheme({Color = "Outline"})
    items.ColorpickerButtonInline = Instances:Create("Frame", {
        Parent = items.ColorpickerButton.Instance,
        Name = "\0",
        Position = UDim2.new(0, 1, 0, 1),
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2.new(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(157, 175, 255)
    })
    Instances:Create("UIGradient", {
        Parent = items.ColorpickerButtonInline.Instance,
        Name = "\0",
        Rotation = -165,
        Color = ColorSequence.new({ColorSequenceKeypoint.new(0, FromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, FromRGB(208, 208, 208))})
    }):AddToTheme({Color = function()
        return ColorSequence.new({ColorSequenceKeypoint.new(0, FromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Library.Theme.Gradient)})
    end})
    items.ColorpickerWindow = Instances:Create("TextButton", {
        Parent = Library.UnusedHolder.Instance,
        Text = "",
        AutoButtonColor = false,
        Name = "\0",
        Position = UDim2.new(0, 12, 0, 12),
        BorderColor3 = FromRGB(12, 12, 12),
        Size = UDim2.new(0, 266, 0, 258),
        BorderSizePixel = 2,
        BackgroundColor3 = FromRGB(14, 17, 15)
    })
    items.ColorpickerWindow:AddToTheme({BorderColor3 = "Border", BackgroundColor3 = "Background"})
    Instances:Create("UIStroke", {
        Parent = items.ColorpickerWindow.Instance,
        Name = "\0",
        Color = FromRGB(42, 49, 45),
        LineJoinMode = Enum.LineJoinMode.Miter,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }):AddToTheme({Color = "Outline"})
    items.Pages = Instances:Create("Frame", {
        Parent = items.ColorpickerWindow.Instance,
        Name = "\0",
        BackgroundTransparency = 1,
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2.new(1, 0, 0, 20),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    Instances:Create("UIListLayout", {
        Parent = items.Pages.Instance,
        Name = "\0",
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalFlex = Enum.UIFlexAlignment.Fill
    })
    items.Content = Instances:Create("Frame", {
        Parent = items.ColorpickerWindow.Instance,
        Name = "\0",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 25),
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2.new(1, 0, 1, -25),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    local colorTab, colorTabItems = BuildColorpickerTab({
        ContentHolder = items.Content,
        Pages = cp.Pages,
        PageHolder = items.Pages,
        Stack = cp.Pages,
        Name = "Color"
    })
    local animTab, animTabItems = BuildColorpickerTab({
        ContentHolder = items.Content,
        Pages = cp.Pages,
        PageHolder = items.Pages,
        Stack = cp.Pages,
        Name = "Animations"
    })
    local otherTab, otherTabItems = BuildColorpickerTab({
        ContentHolder = items.Content,
        Pages = cp.Pages,
        PageHolder = items.Pages,
        Stack = cp.Pages,
        Name = "Other"
    })
    local paletteItems = BuildColorpickerPalette(colorTabItems.PageContent.Instance)
    for k, v in pairs(paletteItems) do items[k] = v end
    function cp:SetOpen(bool)
        if cp.IsOpen == bool then return end
        cp.IsOpen = bool
        items.ColorpickerWindow.Instance.Visible = bool
        items.ColorpickerWindow.Instance.Parent = bool and Library.Holder.Instance or Library.UnusedHolder.Instance
        if bool then
            for _, v in pairs(Library.OpenFrames) do
                if v ~= cp then v:SetOpen(false) end
            end
            Library.OpenFrames[cp] = cp
        else
            Library.OpenFrames[cp] = nil
        end
    end
    function cp:Update(updateSync)
        local h, s, v = cp.Hue, cp.Saturation, cp.Value
        cp.Color = FromHSV(h, s, v)
        cp.HexValue = cp.Color:ToHex()
        Library.Flags[flag] = { Alpha = cp.Alpha, Color = cp.HexValue }
        items.ColorpickerButton:Tween(nil, {BackgroundColor3 = cp.Color})
        items.ColorpickerButtonInline:Tween(nil, {BackgroundColor3 = cp.Color})
        items.Palette:Tween(nil, {BackgroundColor3 = FromHSV(h, 1, 1)})
        items.Alpha:Tween(nil, {BackgroundColor3 = cp.Color})
        if callback then Library:SafeCall(callback, cp.Color, cp.Alpha) end
    end
    function cp:Set(color, alpha)
        if type(color) == "table" then
            color = FromRGB(color[1], color[2], color[3])
            alpha = color[4]
        elseif type(color) == "string" then
            color = FromHex(color)
        end
        cp.Hue, cp.Saturation, cp.Value = color:ToHSV()
        cp.Alpha = alpha or 0
        local px = MathClamp(1 - cp.Saturation, 0, 0.99)
        local py = MathClamp(1 - cp.Value, 0, 0.99)
        local ax = MathClamp(cp.Alpha, 0, 0.995)
        local hy = MathClamp(cp.Hue, 0, 0.995)
        items.PaletteDragger:Tween(TweenInfo.new(TweenTime, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(px, 0, py, 0)})
        items.HueDragger:Tween(TweenInfo.new(TweenTime, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, hy, 0)})
        items.AlphaDragger:Tween(TweenInfo.new(TweenTime, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(ax, 0, 0, 0)})
        cp:Update(true)
    end
    items.ColorpickerButton:Connect("MouseButton1Down", function() cp:SetOpen(not cp.IsOpen) end)
    local slidingPalette = false
    items.Palette:Connect("InputBegan", function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            slidingPalette = true
        end
    end)
    items.Palette:Connect("InputEnded", function() slidingPalette = false end)
    Library:Connect(UserInputService.InputChanged, function(input)
        if slidingPalette and input.UserInputType == Enum.UserInputType.MouseMovement then
            local x = MathClamp(1 - (input.Position.X - items.Palette.Instance.AbsolutePosition.X) / items.Palette.Instance.AbsoluteSize.X, 0, 1)
            local y = MathClamp(1 - (input.Position.Y - items.Palette.Instance.AbsolutePosition.Y) / items.Palette.Instance.AbsoluteSize.Y, 0, 1)
            cp.Saturation = x
            cp.Value = y
            local sx = MathClamp((input.Position.X - items.Palette.Instance.AbsolutePosition.X) / items.Palette.Instance.AbsoluteSize.X, 0, 0.99)
            local sy = MathClamp((input.Position.Y - items.Palette.Instance.AbsolutePosition.Y) / items.Palette.Instance.AbsoluteSize.Y, 0, 0.99)
            items.PaletteDragger:Tween(TweenInfo.new(TweenTime, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(sx, 0, sy, 0)})
            cp:Update(true)
        end
    end)
    Library:Connect(UserInputService.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if not cp.IsOpen then return end
            if Library:IsMouseOverFrame(items.ColorpickerWindow) then return end
            cp:SetOpen(false)
        end
    end)
    if default then cp:Set(default, alpha) end
    Library.Colorpickers[cp] = cp
    Library.SetFlags[flag] = function(v, a) cp:Set(v, a) end
    return cp, items
end

local function BuildKeybind(parent, name, flag, default, mode, callback, page)
    local kb = {
        IsOpen = false,
        Key = "",
        Value = "",
        Mode = mode or "Toggle",
        Toggled = false,
        Picking = false
    }
    local items = {}
    items.KeyButton = Instances:Create("TextButton", {
        Parent = parent,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(235, 235, 235),
        TextTransparency = 0.4,
        Text = "MB2",
        AutoButtonColor = false,
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        BorderColor3 = FromRGB(0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 9,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    items.KeyButton:AddToTheme({TextColor3 = "Text"})
    items.KeyButtonStroke = items.KeyButton:TextBorder()
    items.KeybindWindow = Instances:Create("Frame", {
        Parent = Library.UnusedHolder.Instance,
        Name = "\0",
        Position = UDim2.new(0.0077, 0, 0.353, 0),
        BorderColor3 = FromRGB(12, 12, 12),
        Size = UDim2.new(0, 70, 0, 90),
        BorderSizePixel = 2,
        BackgroundColor3 = FromRGB(14, 17, 15)
    })
    items.KeybindWindow:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
    items.Toggle = Instances:Create("TextButton", {
        Parent = items.KeybindWindow.Instance,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(235, 235, 235),
        BorderColor3 = FromRGB(0, 0, 0),
        Text = "Toggle",
        AutoButtonColor = false,
        Position = UDim2.new(0, 8, 0, 8),
        Size = UDim2.new(1, -16, 0, 20),
        BorderSizePixel = 0,
        TextSize = 9,
        BackgroundColor3 = FromRGB(202, 243, 255)
    })
    items.Toggle:AddToTheme({BackgroundColor3 = "Accent", TextColor3 = "Text"})
    items.ToggleStroke = items.Toggle:TextBorder()
    items.Hold = Instances:Create("TextButton", {
        Parent = items.KeybindWindow.Instance,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(235, 235, 235),
        BorderColor3 = FromRGB(0, 0, 0),
        Text = "Hold",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, 38),
        Size = UDim2.new(1, -16, 0, 20),
        BorderSizePixel = 0,
        TextSize = 9,
        BackgroundColor3 = FromRGB(202, 243, 255)
    })
    items.Hold:AddToTheme({BackgroundColor3 = "Accent", TextColor3 = "Text"})
    items.HoldStroke = items.Hold:TextBorder()
    items.Always = Instances:Create("TextButton", {
        Parent = items.KeybindWindow.Instance,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(235, 235, 235),
        BorderColor3 = FromRGB(0, 0, 0),
        Text = "Always",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, 68),
        Size = UDim2.new(1, -16, 0, 20),
        BorderSizePixel = 0,
        TextSize = 9,
        BackgroundColor3 = FromRGB(202, 243, 255)
    })
    items.Always:AddToTheme({BackgroundColor3 = "Accent", TextColor3 = "Text"})
    items.AlwaysStroke = items.Always:TextBorder()
    local modes = { Toggle = items.Toggle, Hold = items.Hold, Always = items.Always }
    function kb:Get() return kb.Key, kb.Mode, kb.Toggled end
    function kb:Set(key)
        if StringFind(tostring(key), "Enum") then
            kb.Key = tostring(key)
            key = key.Name == "Backspace" and "None" or key.Name
            local ks = Keys[kb.Key] or StringGSub(key, "Enum.", "") or "None"
            local display = StringGSub(StringGSub(ks, "KeyCode.", ""), "UserInputType.", "") or "None"
            kb.Value = display
            items.KeyButton.Instance.Text = display
            Library.Flags[flag] = { Mode = kb.Mode, Key = kb.Key, Toggled = kb.Toggled }
            if callback then Library:SafeCall(callback, kb.Toggled) end
        elseif type(key) == "table" then
            kb.Key = tostring(key.Key)
            if key.Mode then kb.Mode = key.Mode; kb:SetMode(key.Mode) else kb.Mode = "Toggle"; kb:SetMode("Toggle") end
            local ks = Keys[kb.Key] or StringGSub(tostring(key.Key), "Enum.", "") or key.Key
            local display = StringGSub(StringGSub(ks, "KeyCode.", ""), "UserInputType.", "")
            kb.Value = display
            items.KeyButton.Instance.Text = display
            if callback then Library:SafeCall(callback, kb.Toggled) end
        elseif TableFind({"Toggle", "Hold", "Always"}, key) then
            kb.Mode = key
            kb:SetMode(kb.Mode)
            if callback then Library:SafeCall(callback, kb.Toggled) end
        end
        kb.Picking = false
    end
    function kb:SetOpen(bool)
        if kb.IsOpen == bool then return end
        kb.IsOpen = bool
        items.KeybindWindow.Instance.Visible = bool
        items.KeybindWindow.Instance.Parent = bool and Library.Holder.Instance or Library.UnusedHolder.Instance
        if bool then
            for _, v in pairs(Library.OpenFrames) do
                if v ~= kb then v:SetOpen(false) end
            end
            Library.OpenFrames[kb] = kb
        else
            Library.OpenFrames[kb] = nil
        end
    end
    function kb:SetMode(m)
        for k, v in pairs(modes) do
            if k == m then v:Tween(nil, {BackgroundTransparency = 0}) else v:Tween(nil, {BackgroundTransparency = 1}) end
        end
        Library.Flags[flag] = { Mode = kb.Mode, Key = kb.Key, Toggled = kb.Toggled }
        if callback then Library:SafeCall(callback, kb.Toggled) end
    end
    function kb:Press(bool)
        if kb.Mode == "Toggle" then kb.Toggled = not kb.Toggled
        elseif kb.Mode == "Hold" then kb.Toggled = bool
        elseif kb.Mode == "Always" then kb.Toggled = true end
        Library.Flags[flag] = { Mode = kb.Mode, Key = kb.Key, Toggled = kb.Toggled }
        if callback then Library:SafeCall(callback, kb.Toggled) end
    end
    items.KeyButton:Connect("MouseButton1Click", function()
        kb.Picking = true
        items.KeyButton.Instance.Text = "."
        Library:Thread(function()
            local c = 1
            while kb.Picking do
                if c == 4 then c = 1 end
                items.KeyButton.Instance.Text = c == 1 and "." or c == 2 and ".." or c == 3 and "..."
                c = c + 1
                task.wait(0.5)
            end
        end)
        local ib
        ib = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then kb:Set(input.KeyCode)
            else kb:Set(input.UserInputType) end
            ib:Disconnect()
            ib = nil
        end)
    end)
    items.KeyButton:Connect("MouseButton2Down", function() kb:SetOpen(not kb.IsOpen) end)
    Library:Connect(UserInputService.InputBegan, function(input)
        if kb.Value == "None" then return end
        if tostring(input.KeyCode) == kb.Key or tostring(input.UserInputType) == kb.Key then
            if kb.Mode == "Toggle" then kb:Press()
            elseif kb.Mode == "Hold" then kb:Press(true)
            elseif kb.Mode == "Always" then kb:Press(true) end
        end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if not kb.IsOpen then return end
            if Library:IsMouseOverFrame(items.KeybindWindow) then return end
            kb:SetOpen(false)
        end
    end)
    Library:Connect(UserInputService.InputEnded, function(input)
        if kb.Value == "None" then return end
        if tostring(input.KeyCode) == kb.Key or tostring(input.UserInputType) == kb.Key then
            if kb.Mode == "Hold" then kb:Press(false)
            elseif kb.Mode == "Always" then kb:Press(true) end
        end
    end)
    items.Toggle:Connect("MouseButton1Down", function() kb.Mode = "Toggle"; kb:SetMode("Toggle") end)
    items.Hold:Connect("MouseButton1Down", function() kb.Mode = "Hold"; kb:SetMode("Hold") end)
    items.Always:Connect("MouseButton1Down", function() kb.Mode = "Always"; kb:SetMode("Always") end)
    if default then kb:Set({Key = default, Mode = mode or "Toggle"}) end
    Library.SetFlags[flag] = function(v) kb:Set(v) end
    return kb, items
end

local function BuildTextbox(parent, name, flag, placeholder, default, numeric, finished, callback, page)
    local tb = { Value = "", Flag = flag }
    local items = {}
    items.Textbox = Instances:Create("Frame", {
        Parent = parent,
        Name = "\0",
        BackgroundTransparency = 1,
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2.new(1, 0, 0, 40),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    items.Text = Instances:Create("TextLabel", {
        Parent = items.Textbox.Instance,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(235, 235, 235),
        BorderColor3 = FromRGB(0, 0, 0),
        Text = name,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, 15),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 9,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    items.Text:AddToTheme({TextColor3 = "Text"})
    items.TextStroke = items.Text:TextBorder()
    items.Background = Instances:Create("Frame", {
        Parent = items.Textbox.Instance,
        Name = "\0",
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        BorderColor3 = FromRGB(12, 12, 12),
        Size = UDim2.new(1, 0, 0, 20),
        BorderSizePixel = 2,
        BackgroundColor3 = FromRGB(30, 36, 31)
    })
    items.Background:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
    Instances:Create("UIGradient", {
        Parent = items.Background.Instance,
        Name = "\0",
        Rotation = -165,
        Color = ColorSequence.new({ColorSequenceKeypoint.new(0, FromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, FromRGB(208, 208, 208))})
    }):AddToTheme({Color = function()
        return ColorSequence.new({ColorSequenceKeypoint.new(0, FromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Library.Theme.Gradient)})
    end})
    Instances:Create("UIStroke", {
        Parent = items.Background.Instance,
        Name = "\0",
        Color = FromRGB(42, 49, 45),
        LineJoinMode = Enum.LineJoinMode.Miter,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }):AddToTheme({Color = "Outline"})
    items.Input = Instances:Create("TextBox", {
        Parent = items.Background.Instance,
        Name = "\0",
        FontFace = Library.Font,
        PlaceholderColor3 = FromRGB(185, 185, 185),
        PlaceholderText = placeholder,
        TextSize = 9,
        Size = UDim2.new(1, 0, 1, 0),
        ClipsDescendants = true,
        BorderColor3 = FromRGB(0, 0, 0),
        Text = "",
        TextColor3 = FromRGB(235, 235, 235),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0, 0, 0, 0),
        ClearTextOnFocus = false,
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    items.Input:AddToTheme({TextColor3 = "Text", PlaceholderColor3 = "Placeholder Text"})
    items.InputStroke = items.Input:TextBorder()
    Instances:Create("UIPadding", {
        Parent = items.Input.Instance,
        Name = "\0",
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8)
    })
    function tb:Get() return tb.Value end
    function tb:SetVisibility(bool) items.Textbox.Instance.Visible = bool end
    function tb:Set(v)
        if numeric and (not tonumber(v)) and StringLen(tostring(v)) > 0 then v = tb.Value end
        tb.Value = v
        items.Input.Instance.Text = v
        Library.Flags[flag] = v
        if callback then Library:SafeCall(callback, v) end
    end
    if finished then
        items.Input:Connect("FocusLost", function(enter) if enter then tb:Set(items.Input.Instance.Text) end end)
    else
        items.Input.Instance:GetPropertyChangedSignal("Text"):Connect(function() tb:Set(items.Input.Instance.Text) end)
    end
    if default then tb:Set(default) end
    Library.SetFlags[flag] = function(v) tb:Set(v) end
    return tb, items
end

local function BuildSearchbox(parent, flag, itemsList, default, multi, callback)
    local sb = { Value = {}, Options = {}, IsOpen = false, Flag = flag }
    local items = {}
    items.Listbox = Instances:Create("Frame", {
        Parent = parent,
        Name = "\0",
        BackgroundTransparency = 1,
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2.new(1, 0, 0, 185),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    items.Search = Instances:Create("Frame", {
        Parent = items.Listbox.Instance,
        Name = "\0",
        BackgroundTransparency = 0.4,
        Size = UDim2.new(0, 0, 0, 20),
        BorderColor3 = FromRGB(12, 12, 12),
        BorderSizePixel = 2,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = FromRGB(14, 17, 15)
    })
    items.Search:AddToTheme({BorderColor3 = "Border", BackgroundColor3 = "Background"})
    Instances:Create("UIStroke", {
        Parent = items.Search.Instance,
        Name = "\0",
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Transparency = 0.4,
        Color = FromRGB(42, 49, 45),
        LineJoinMode = Enum.LineJoinMode.Miter
    }):AddToTheme({Color = "Outline"})
    items.Icon = Instances:Create("ImageLabel", {
        Parent = items.Search.Instance,
        Name = "\0",
        ScaleType = Enum.ScaleType.Fit,
        BorderColor3 = FromRGB(0, 0, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Image = "rbxassetid://71197946135150",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(0, 16, 0, 16),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    items.Icon:AddToTheme({ImageColor3 = "Text"})
    items.Input = Instances:Create("TextBox", {
        Parent = items.Search.Instance,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(235, 235, 235),
        BorderColor3 = FromRGB(0, 0, 0),
        Text = "",
        Size = UDim2.new(0, 0, 1, 0),
        Position = UDim2.new(0, 22, 0, 0),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        PlaceholderColor3 = FromRGB(185, 185, 185),
        AutomaticSize = Enum.AutomaticSize.X,
        PlaceholderText = "search..",
        TextSize = 9,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    items.Input:AddToTheme({TextColor3 = "Text", PlaceholderColor3 = "Placeholder Text"})
    items.InputStroke = items.Input:TextBorder()
    Instances:Create("UIPadding", {
        Parent = items.Search.Instance,
        Name = "\0",
        PaddingRight = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 3)
    })
    items.RealListbox = Instances:Create("Frame", {
        Parent = items.Listbox.Instance,
        Name = "\0",
        ClipsDescendants = true,
        BorderColor3 = FromRGB(12, 12, 12),
        Size = UDim2.new(1, 0, 1, -28),
        SelectionGroup = true,
        Position = UDim2.new(0, 0, 0, 28),
        Selectable = true,
        Active = true,
        BorderSizePixel = 2,
        BackgroundColor3 = FromRGB(30, 36, 31)
    })
    items.RealListbox:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
    Instances:Create("UIStroke", {
        Parent = items.RealListbox.Instance,
        Name = "\0",
        Color = FromRGB(42, 49, 45),
        LineJoinMode = Enum.LineJoinMode.Miter,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }):AddToTheme({Color = "Outline"})
    Instances:Create("UIGradient", {
        Parent = items.RealListbox.Instance,
        Name = "\0",
        Rotation = -165,
        Color = ColorSequence.new({ColorSequenceKeypoint.new(0, FromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, FromRGB(208, 208, 208))})
    }):AddToTheme({Color = function()
        return ColorSequence.new({ColorSequenceKeypoint.new(0, FromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Library.Theme.Gradient)})
    end})
    items.List = Instances:Create("ScrollingFrame", {
        Parent = items.RealListbox.Instance,
        Name = "\0",
        Active = true,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarImageColor3 = FromRGB(202, 243, 255),
        MidImage = "rbxassetid://136419474381965",
        BorderColor3 = FromRGB(0, 0, 0),
        ScrollBarThickness = 2,
        Size = UDim2.new(1, -12, 1, -10),
        Position = UDim2.new(0, 3, 0, 5),
        TopImage = "rbxassetid://136419474381965",
        CanvasPosition = Vector2.new(0, 57),
        BottomImage = "rbxassetid://136419474381965",
        BackgroundTransparency = 1,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    items.List:AddToTheme({ScrollBarImageColor3 = "Accent"})
    Instances:Create("UIListLayout", {
        Parent = items.List.Instance,
        Name = "\0",
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    Instances:Create("UIPadding", {
        Parent = items.List.Instance,
        Name = "\0",
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 5)
    })
    function sb:Get() return sb.Value end
    function sb:SetVisibility(bool) items.Listbox.Instance.Visible = bool end
    function sb:Set(option)
        if multi then
            if type(option) ~= "table" then return end
            sb.Value = option
            Library.Flags[flag] = option
            for _, v in pairs(option) do
                local opt = sb.Options[v]
                if opt then opt.Selected = true; opt:Toggle("Active") end
            end
        else
            if not sb.Options[option] then return end
            local opt = sb.Options[option]
            sb.Value = option
            Library.Flags[flag] = option
            for _, v in pairs(sb.Options) do
                if v ~= opt then v.Selected = false; v:Toggle("Inactive")
                else v.Selected = true; v:Toggle("Active") end
            end
        end
        if callback then Library:SafeCall(callback, sb.Value) end
    end
    function sb:Add(option)
        local btn = Instances:Create("TextButton", {
            Parent = items.List.Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = FromRGB(235, 235, 235),
            BorderColor3 = FromRGB(0, 0, 0),
            Text = option,
            AutoButtonColor = false,
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, 0, 0, 20),
            ZIndex = 1,
            TextSize = 9,
            BackgroundColor3 = FromRGB(255, 255, 255)
        })
        btn:AddToTheme({TextColor3 = "Text"})
        btn:TextBorder()
        local optData = { Button = btn, Name = option, Selected = false }
        function optData:Toggle(status)
            if status == "Active" then
                optData.Button:ChangeItemTheme({TextColor3 = "Accent"})
                optData.Button:Tween(nil, {TextColor3 = Library.Theme.Accent})
            else
                optData.Button:ChangeItemTheme({TextColor3 = "Text"})
                optData.Button:Tween(nil, {TextColor3 = Library.Theme.Text})
            end
        end
        function optData:Set()
            optData.Selected = not optData.Selected
            if multi then
                local idx = TableFind(sb.Value, optData.Name)
                if idx then TableRemove(sb.Value, idx) else TableInsert(sb.Value, optData.Name) end
                optData:Toggle(idx and "Inactive" or "Active")
                Library.Flags[flag] = sb.Value
            else
                if optData.Selected then
                    sb.Value = optData.Name
                    Library.Flags[flag] = optData.Name
                    optData.Selected = true
                    optData:Toggle("Active")
                    for _, v in pairs(sb.Options) do
                        if v ~= optData then v.Selected = false; v:Toggle("Inactive") end
                    end
                else
                    sb.Value = nil
                    Library.Flags[flag] = nil
                    optData.Selected = false
                    optData:Toggle("Inactive")
                end
            end
            if callback then Library:SafeCall(callback, sb.Value) end
        end
        btn:Connect("MouseButton1Down", function() optData:Set() end)
        sb.Options[optData.Name] = optData
        return optData
    end
    function sb:Remove(option)
        if not sb.Options[option] then return end
        sb.Options[option].Button:Clean()
        sb.Options[option] = nil
    end
    function sb:Refresh(list)
        for _, v in pairs(sb.Options) do sb:Remove(v.Name) end
        for _, v in pairs(list) do sb:Add(v) end
    end
    local searchStepped
    items.Input:Connect("Focused", function()
        searchStepped = RunService.RenderStepped:Connect(function()
            for _, v in pairs(sb.Options) do
                if items.Input.Instance.Text ~= "" then
                    v.Button.Instance.Visible = StringFind(StringLower(v.Name), StringLower(items.Input.Instance.Text))
                else
                    v.Button.Instance.Visible = true
                end
            end
        end)
    end)
    items.Input:Connect("FocusLost", function()
        if searchStepped then searchStepped:Disconnect(); searchStepped = nil end
    end)
    for _, v in pairs(itemsList) do sb:Add(v) end
    if default then sb:Set(default) end
    Library.SetFlags[flag] = function(v) sb:Set(v) end
    return sb, items
end

function Library:Watermark(name)
    name = name or "disconnected.wtf | discord.gg/hZAj73bwnv"
    local wm = {}
    local items = {}
    items.Watermark = Instances:Create("Frame", {
        Parent = Library.Holder.Instance,
        Name = "\0",
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -12),
        BorderColor3 = FromRGB(12, 12, 12),
        BorderSizePixel = 2,
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundColor3 = FromRGB(14, 17, 15)
    })
    items.Watermark:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
    items.Watermark:MakeDraggable()
    Instances:Create("UIStroke", {
        Parent = items.Watermark.Instance,
        Name = "\0",
        Color = FromRGB(42, 49, 45),
        LineJoinMode = Enum.LineJoinMode.Miter,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }):AddToTheme({Color = "Outline"})
    Instances:Create("UIPadding", {
        Parent = items.Watermark.Instance,
        Name = "\0",
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 7),
        PaddingRight = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 5)
    })
    items.Text = Instances:Create("TextLabel", {
        Parent = items.Watermark.Instance,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(235, 235, 235),
        BorderColor3 = FromRGB(0, 0, 0),
        Text = name,
        Position = UDim2.new(0, 0, 0, 2),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.XY,
        TextSize = 9,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    items.Text:AddToTheme({TextColor3 = "Text"})
    items.TextStroke = items.Text:TextBorder()
    items.Liner = Instances:Create("Frame", {
        Parent = items.Watermark.Instance,
        Name = "\0",
        Position = UDim2.new(0, -5, 0, -5),
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2.new(1, 10, 0, 1),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(202, 243, 255)
    })
    items.Liner:AddToTheme({BackgroundColor3 = "Accent"})
    function wm:SetVisibility(bool) items.Watermark.Instance.Visible = bool end
    return wm
end

function Library:KeybindList()
    local kbl = {}
    Library.KeyList = kbl
    local items = {}
    items.KeybindList = Instances:Create("Frame", {
        Parent = Library.Holder.Instance,
        Name = "\0",
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 12, 0.5, 55),
        BorderColor3 = FromRGB(12, 12, 12),
        Size = UDim2.new(0, 116, 0, 32),
        BorderSizePixel = 2,
        BackgroundColor3 = FromRGB(14, 17, 15)
    })
    items.KeybindList:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
    items.KeybindList:MakeDraggable()
    Instances:Create("UIStroke", {
        Parent = items.KeybindList.Instance,
        Name = "\0",
        Color = FromRGB(42, 49, 45),
        LineJoinMode = Enum.LineJoinMode.Miter,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }):AddToTheme({Color = "Outline"})
    items.Title = Instances:Create("TextLabel", {
        Parent = items.KeybindList.Instance,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(235, 235, 235),
        BorderColor3 = FromRGB(0, 0, 0),
        Text = "Keybinds",
        Size = UDim2.new(0, 0, 0, 20),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, -4),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 9,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    items.Title:AddToTheme({TextColor3 = "Text"})
    items.TitleStroke = items.Title:TextBorder()
    Instances:Create("UIPadding", {
        Parent = items.KeybindList.Instance,
        Name = "\0",
        PaddingTop = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8)
    })
    items.Liner = Instances:Create("Frame", {
        Parent = items.KeybindList.Instance,
        Name = "\0",
        Position = UDim2.new(0, 0, 0, 15),
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2.new(1, 0, 0, 1),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(202, 243, 255)
    })
    items.Liner:AddToTheme({BackgroundColor3 = "Accent"})
    items.Content = Instances:Create("Frame", {
        Parent = items.KeybindList.Instance,
        Name = "\0",
        BorderColor3 = FromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 32),
        Size = UDim2.new(1, 0, 0, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    Instances:Create("UIListLayout", {
        Parent = items.Content.Instance,
        Name = "\0",
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    function kbl:Add(key, name, mode)
        local nk = Instances:Create("TextLabel", {
            Parent = items.Content.Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = FromRGB(235, 235, 235),
            BorderColor3 = FromRGB(0, 0, 0),
            Text = "" .. key .. " - " .. name .. " (" .. mode .. ")",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 0, 15),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.X,
            TextTransparency = 1,
            Visible = false,
            TextSize = 9,
            BackgroundColor3 = FromRGB(255, 255, 255)
        })
        nk:AddToTheme({TextColor3 = "Text"})
        nk:TextBorder()
        function nk:SetText(k, n, m) nk.Instance.Text = "" .. k .. " - " .. n .. " (" .. m .. ")" end
        function nk:SetStatus(bool)
            if bool then
                nk.Instance.Visible = true
                nk:Tween(nil, {TextTransparency = 0})
            else
                nk:Tween(nil, {TextTransparency = 1}).Tween.Completed:Connect(function()
                    nk.Instance.Visible = false
                end)
            end
        end
        return nk
    end
    function kbl:SetVisibility(bool) items.KeybindList.Instance.Visible = bool end
    return 

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
    local page, items = BuildWindowPage({
        Name = name,
        ContentHolder = window.Content,
        Parent = window.Win.Instance,
        Columns = 2,
        SubPages = false,
        Window = window,
        FadeTime = FadeSpeed
    })
    return page
end

function Library:PageWithSubPages(window, name)
    local page, items = BuildWindowPage({
        Name = name,
        ContentHolder = window.Content,
        Parent = window.Win.Instance,
        Columns = 2,
        SubPages = true,
        Window = window,
        FadeTime = FadeSpeed
    })
    return page
end

function Library:SubPage(page, name)
    local subPage = BuildWindowSubPage({
        Name = name,
        Page = page,
        Columns = 2,
        Window = page.Window
    })
    return subPage
end

function Library:Section(page, name, side)
    side = side or 1
    local section = Instance.new("Frame")
    section.Parent = page.ColumnsData[side].Instance
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
    local tog, items = BuildToggle(
        section.Content,
        data.Name or "Toggle",
        data.Flag or Library:NextFlag(),
        data.Default or false,
        data.Callback or function() end,
        data.Page
    )
    if data.Tooltip then
        items.Toggle:Tooltip({
            Text = data.Tooltip.Name,
            Description = data.Tooltip.Description
        })
    end
    return tog
end

function Library:Button(section, data)
    data = data or {}
    local btn, items = BuildButton(section.Content, data.Page)
    return btn
end

function Library:Slider(section, data)
    data = data or {}
    local sl, items = BuildSlider(
        section.Content,
        data.Name or "Slider",
        data.Flag or Library:NextFlag(),
        data.Min or 0,
        data.Max or 100,
        data.Decimals or 1,
        data.Suffix or "",
        data.Default or 0,
        data.Callback or function() end,
        data.Page
    )
    if data.Tooltip then
        items.Slider:Tooltip({
            Text = data.Tooltip.Name,
            Description = data.Tooltip.Description
        })
    end
    return sl
end

function Library:Label(section, name, tooltip)
    local lb, items = BuildLabel(section.Content, name or "Label", section.Page)
    if tooltip then
        items.Label:Tooltip({
            Text = tooltip.Name,
            Description = tooltip.Description
        })
    end
    return lb
end

function Library:Dropdown(section, data)
    data = data or {}
    local dd, items = BuildDropdown(
        section.Content,
        data.Name or "Dropdown",
        data.Flag or Library:NextFlag(),
        data.Items or {},
        data.Default or nil,
        data.Multi or false,
        data.Callback or function() end,
        data.Page
    )
    if data.Tooltip then
        items.Dropdown:Tooltip({
            Text = data.Tooltip.Name,
            Description = data.Tooltip.Description
        })
    end
    return dd
end

function Library:Colorpicker(section, data)
    data = data or {}
    local cp, items = BuildColorpicker(
        section.Content,
        data.Flag or Library:NextFlag(),
        data.Default or FromRGB(255, 255, 255),
        data.Alpha or 0,
        data.Callback or function() end,
        data.Page
    )
    return cp
end

function Library:Keybind(section, data)
    data = data or {}
    local kb, items = BuildKeybind(
        section.Content,
        data.Name or "Keybind",
        data.Flag or Library:NextFlag(),
        data.Default or Enum.KeyCode.RightShift,
        data.Mode or "Toggle",
        data.Callback or function() end,
        data.Page
    )
    return kb
end

function Library:Textbox(section, data)
    data = data or {}
    local tb, items = BuildTextbox(
        section.Content,
        data.Name or "Textbox",
        data.Flag or Library:NextFlag(),
        data.Placeholder or "...",
        data.Default or "",
        data.Numeric or false,
        data.Finished or false,
        data.Callback or function() end,
        data.Page
    )
    if data.Tooltip then
        items.Textbox:Tooltip({
            Text = data.Tooltip.Name,
            Description = data.Tooltip.Description
        })
    end
    return tb
end

function Library:Searchbox(section, data)
    data = data or {}
    local sb, items = BuildSearchbox(
        section.Content,
        data.Flag or Library:NextFlag(),
        data.Items or {},
        data.Default or nil,
        data.Multi or false,
        data.Callback or function() end
    )
    return sb
end

function Library:BlankElement(section, data)
    data = data or {}
    local el = Instance.new("Frame")
    el.Parent = section.Content
    el.Name = "\0"
    el.BackgroundTransparency = 1
    el.BorderColor3 = FromRGB(0, 0, 0)
    el.Size = UDim2.new(1, 0, 0, data.Size or 18)
    el.BorderSizePixel = 0
    el.BackgroundColor3 = FromRGB(255, 255, 255)
    return el
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
    local dragStart = Vector2.new()
    local buttonStart = UDim2.new()

    ToggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            dragStart = input.Position
            buttonStart = ToggleButton.Position
        end
    end)

    ToggleButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and not dragging then
            if (input.Position - dragStart).Magnitude > 10 then
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

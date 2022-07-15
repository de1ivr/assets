--[[
	A number spinner component; shows a value as a series of rotating digits.

	Props:
		Required:
		- Value: State<number>
		- NumDigits: number

		Optional:
		- Position: UDim2
		- AnchorPoint: Vector2
		- Size: UDim2
		- Font: string
		- TextColor3: Color3
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Fusion)
local New = Fusion.New
local Children = Fusion.Children

local Computed = Fusion.Computed
local ComputedPairs = Fusion.ComputedPairs

local Spring = Fusion.Spring

local function NumberSpinner(props)
	local digits = {}
	
	for digitPosition=1, props.NumDigits do
		local fauxRotation = Spring(Computed(function()
			-- each digit should move 10 times slower than the last, and needs
			-- to snap to integer steps
			return math.floor(props.Value:get() / 10^(digitPosition - 1))
		end))
		
		-- when the digit hasn't moved yet, fade it out for a cleaner look
		local digitTransparency = Computed(function()
			return math.clamp(1 - fauxRotation:get(), 0, 1) * 0.75
		end)
		
		digits[digitPosition] = New "Frame" {
			Name = "Digit" .. digitPosition,
			
			-- digits are written right to left
			LayoutOrder = -digitPosition,
			Size = UDim2.fromScale(0.6, 1),
			SizeConstraint = "RelativeYY",
			
			BackgroundTransparency = 1,
			
			[Children] = New "Frame" {
				Name = "DigitMover",
				
				Position = Computed(function()
					return UDim2.fromScale(0, -(fauxRotation:get() % 10))
				end),
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				
				[Children] = ComputedPairs({0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0}, function(index, digit)
					return New "TextLabel" {
						Name = "Label" .. index,
						
						Position = UDim2.fromScale(0, index - 1),
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						
						Font = props.Font,
						Text = digit,
						TextScaled = true,
						TextColor3 = props.TextColor3,
						TextTransparency = digitTransparency
					}
				end)
			}
		}
	end
	
	return New "Frame" {
		Name = "NumberSpinner",
		
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		Size = props.Size,
		
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		
		[Children] = {
			New "UIListLayout" {
				SortOrder = "LayoutOrder",
				FillDirection = "Horizontal",
				HorizontalAlignment = "Center",
				VerticalAlignment = "Center"
			},
			
			digits
		}
	}
end

return NumberSpinner

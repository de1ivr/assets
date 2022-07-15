local Node = {}
Node.__index = Node

function Node.new(variable)
    local self = setmetatable({
        _value = variable,
        _bindable = Instance.new("BindableEvent")
    }, Node)
	
    self.Changed = self._bindable.Event
	
    return self
end


function Node:GetValue()
	return self._value
end


function Node:SetValue(newValue)
	if self._value == newValue then
		return 
	end
	
	self._value = newValue
	self._bindable:Fire()
end

function Node:Destroy()
	if not self._bindable then
		return
	end
	
	self._value = nil
	self.Changed = nil
	self._bindable:Destroy()
    self._bindable = nil
end


return Node

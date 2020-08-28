if not rawget(_G, "DrillFixer") then
	rawset(_G, "DrillFixer", {
		enabled = false,
		i_list = {
			-- devices
			["apartment_drill_jammed"] = true,
			["apartment_saw_jammed"] = true,
			["cas_fix_bfd_drill"] = true,
			["circle_cutter_jammed"] = true,
			["drill_jammed"] = true,
			["gen_int_saw_jammed"] = true,
			["glass_cutter_jammed"] = true,
			["goldheist_drill_jammed"] = true,
			["hospital_saw_jammed"] = true,
			["lance_jammed"] = true,
			["huge_lance_jammed"] = true,
			["secret_stash_saw_jammed"] = true,
			["suburbia_drill_jammed"] = true,

			-- device requirements such as breakers, bfd parts etc
			["circuit_breaker"] = true,
			["hold_circuit_breaker"] = true,
		}
	})

	-- this allows you to interact with anything no matter if you have
	-- [...] the required equipments or not to perform the interaction
	local can_interact = function()
		return true
	end

	function DrillFixer:interact()
		local player = managers.player:player_unit()

		if alive(player) then
			local interaction
			for _, unit in pairs(managers.interaction._interactive_units) do
				interaction = unit and unit:interaction()
				if self.i_list[interaction.tweak_data] then
					interaction.can_interact = can_interact
					interaction:interact(player)
					break
				end
			end
		end
	end

	function DrillFixer:message(text, title)
		managers.chat:_receive_message(1, (title or "SYSTEM"), text, tweak_data.system_chat_color)
	end

	function DrillFixer:toggle()
		self.enabled = not self.enabled
		self:message( (self.enabled and "enabled") or "disabled", "DrillFixer" )
	end

	-- In teory I should stop the loop when we want to stop it
	-- But I'm too lazy to do that and I want the most clean code possible
	function DrillFixer:init()
		BetterDelayedCalls:Add("loop", 0.1, function()
			if (not self.enabled) then
				return
			end
			self:interact()
		end, true)
	end

	DrillFixer:init()
end

DrillFixer:toggle()
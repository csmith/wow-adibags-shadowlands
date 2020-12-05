--[[
AdiBags - Shadowlands item filter
by PsyKzz
version: v1.0
Adds a new filter for Anima and Conduit items
]]

local addonName, addon = ...
local AdiBags = LibStub("AceAddon-3.0"):GetAddon("AdiBags")

local L = addon.L

local covenantFilter = AdiBags:RegisterFilter("Shadowlands - Covenant Items", 100, "ABEvent-1.0")
covenantFilter.uiName = "Shadowlands - Covenant Items"
covenantFilter.uiDesc = "Separate out different Shadowlands items, like Anima and Conduits."

function covenantFilter:OnInitialize()
    self.db = AdiBags.db:RegisterNamespace("Covenant Items", {
        profile = {
            anima = true,
			conduits = true,
			covenantCrafting = true,
		}
	})
end

function covenantFilter:Update()
	self:SendMessage("AdiBags_FiltersChanged")
end

function covenantFilter:OnEnable()
	AdiBags:UpdateFilters()
end

function covenantFilter:OnDisable()
	AdiBags:UpdateFilters()
end

function covenantFilter:Filter(slotData)
    local itemLoc = ItemLocation:CreateFromBagAndSlot(slotData.bag, slotData.slot)
    if self.db.profile.conduits and C_Item.IsItemConduit(itemLoc) then 
        return "Conduit"
    end

    local item = GetContainerItemLink(slotData.bag, slotData.slot)
    if self.db.profile.anima and C_Item.IsAnimaItemByID(item) then
        return "Anima"
	end
	

	local KyrianCraftingItems = {
		[180477] = true, -- feathers
		[180595] = true, -- steel
		[180594] = true, -- bone
		[180478] = true, -- pelt
		[178995] = true, -- shard
	}

	local NecrolordCraftingItems = {
		[178061] = true, -- mallable flesh
	}

	local item = GetContainerItemLink(slotData.bag, slotData.slot)
    if self.db.profile.covenantCrafting and (KyrianCraftingItems[slotData.itemId] or NecrolordCraftingItems[slotData.itemId]) then
        return "Covenant Crafting"
    end
end

function covenantFilter:GetOptions()
	return {
		anima = {
			name = "Anima",
			desc = "Items redeemmed at the sanctum upgrade for Reserved Anima",
			type = "toggle",
			order = 10
		},
		conduits = {
			name = "Conduits",
			desc = "Items used at the Soul Forge.",
			type = "toggle",
			order = 20
		},
		covenantCrafting = {
			name = "Covenant Crafting items",
			desc = "Items used at for specific convenant.",
			type = "toggle",
			order = 30
		}
	},
	AdiBags:GetOptionHandler(self, false, function ()
		return self:Update()
	end)
end

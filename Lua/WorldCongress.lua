
print("Initializing World Congress Lua");

-- Generic filter for world congress resolutions.
GameEvents.CanUseResolutions.Add(function(resolutions) 
	local world_religion_hash;
	local world_religion_resolution = GameInfo.Resolutions["WC_RES_WORLD_RELIGION"];
	if(world_religion_resolution) then
		world_religion_hash = world_religion_resolution.Hash
	end
	
	local diplo_victory_hash;
	local diplo_victory_resolution = GameInfo.Resolutions["WC_RES_DIPLOVICTORY"];
	if(diplo_victory_resolution) then
		diplo_victory_hash = diplo_victory_resolution.Hash
	end
	
	local luxury_ban_hash;
	local luxury_ban_resolution = GameInfo.Resolutions["WC_RES_LUXURY"];
	if(luxury_ban_resolution) then
		luxury_ban_hash = luxury_ban_resolution.Hash
	end
	
	local allowed_resolutions = {};
	for i,v in ipairs(resolutions.Resolutions) do
	
		if(world_religion_hash and v == world_religion_hash) then
			-- Check if there is at least one religion.
			local religions = Game.GetReligion():GetReligions();
			if(#religions > 0) then
				table.insert(allowed_resolutions, v);
			end
		elseif(diplo_victory_hash and v == diplo_victory_hash) then
			-- Check if the victory type is enabled
			if (Game.IsVictoryEnabled("VICTORY_DIPLOMATIC")) then
				table.insert(allowed_resolutions,v);
			end
		elseif(luxury_ban_hash and v == luxury_ban_hash) then
			-- Check if there are any luxury resources in the game
			luxuryResourcesCount = 0;
			for row in GameInfo.Resources() do
				if(row.ResourceClassType == "RESOURCECLASS_LUXURY" and (row.Frequency > 0 or row.SeaFrequency> 0)) then
					if(Map.GetResourceCount(row.Hash) > 0) then
						luxuryResourcesCount = luxuryResourcesCount + 1;
					end
				end
			end

			if (luxuryResourcesCount > 0) then
				table.insert(allowed_resolutions,v);
			end
		else
			table.insert(allowed_resolutions,v);
		end
	end
		
	resolutions.Resolutions = allowed_resolutions;
end);

-- ===========================================================================
GameEvents.WC_Validate_LuxuryBan.Add(function(resolutionType, playerId, options)
	-- Need to only determine this once.
	if(cachedLuxuryResources == nil) then
		cachedLuxuryResources = {};
		for row in GameInfo.Resources() do
			if(row.ResourceClassType == "RESOURCECLASS_LUXURY" and (row.Frequency > 0 or row.SeaFrequency> 0)) then
				if(Map.GetResourceCount(row.Hash) > 0) then
					table.insert(cachedLuxuryResources, row.Hash);
				end
			end
		end
	end
	
	-- Assign valid resources to only be luxury resources.
	options.ResolutionOptions = cachedLuxuryResources;
end);

-- ===========================================================================
GameEvents.WC_Validate_PowerResourceBan.Add(function(resolutionType, playerId, options)
	if(cachedPowerResources == nil) then
		cachedPowerResources = {};
		
		for row in GameInfo.Resource_Consumption() do
			local resource = GameInfo.Resources[row.ResourceType];
			if(resource and resource.PowerProvided ~= 0) then
				table.insert(cachedPowerResources, resource.Hash);
			end
		end
	end
	
	-- Assign valid resources to only be luxury resources.
	options.ResolutionOptions = cachedPowerResources;
end);

-- ===========================================================================
GameEvents.WC_Validate_YieldBan.Add(function(resolutionType, playerId, options)
	if(cachedUnitYieldTypes == nil) then
		cachedUnitYieldTypes = {};
		
		for row in GameInfo.Yields() do
			if(row.YieldType == "YIELD_PRODUCTION") then
				table.insert(cachedUnitYieldTypes, row.Hash);
			end
			if(row.YieldType == "YIELD_GOLD") then
				table.insert(cachedUnitYieldTypes, row.Hash);
			end
			if(row.YieldType == "YIELD_FAITH") then
				table.insert(cachedUnitYieldTypes, row.Hash);
			end
		end
	end
	
	-- Assign valid yield types to only be unit access types.
	options.ResolutionOptions = cachedUnitYieldTypes;
end);

-- ===========================================================================
GameEvents.WC_Validate_PowerBuilding.Add(function(resolutionType, playerId, options)
	if(cachedPowerBuildingTypes == nil) then
		cachedPowerBuildingTypes = {};
		
		for row in GameInfo.Buildings() do
			if(row.BuildingType == "BUILDING_COAL_POWER_PLANT") then
				table.insert(cachedPowerBuildingTypes, row.Hash);
			end
			if(row.BuildingType == "BUILDING_FOSSIL_FUEL_POWER_PLANT") then
				table.insert(cachedPowerBuildingTypes, row.Hash);
			end
			if(row.BuildingType == "BUILDING_POWER_PLANT") then
				table.insert(cachedPowerBuildingTypes, row.Hash);
			end
		end
	end
	
	-- Assign valid buildings to only be Power providing types
	options.ResolutionOptions = cachedPowerBuildingTypes;
end);

-- ===========================================================================
GameEvents.WC_ValidateGovernanceDoctrine.Add(function(resolutionType, playerId, options)
	if (cachedGovernorTypes == nil) then
		cachedGovernorTypes = {};

		for row in GameInfo.Governors() do
			if (row.TraitType == nil) then
				table.insert(cachedGovernorTypes, row.Hash);
			end
		end
	end

	-- Assign valid Governor types
	options.ResolutionOptions = cachedGovernorTypes;
end);

-- ===========================================================================
GameEvents.WC_Validate_GreatWorkObjects.Add(function(resolutionType, playerId, options)
	-- Add filtering here if necessary
end);

-- ===========================================================================
GameEvents.WC_Validate_PolicyTreaty.Add(function(resolutionType, playerId, options)
	cachedPolicyTypes = {};

	local pPlayerCulture : object = Players[playerId]:GetCulture();
	if (pPlayerCulture ~= nil) then

		for row in GameInfo.Policies() do
			if (pPlayerCulture:IsPolicyUnlocked(row.Hash) and not pPlayerCulture:IsPolicyObsolete(row.Hash)) then
				table.insert(cachedPolicyTypes, row.Hash);
			end
		end
	end

	options.ResolutionOptions = cachedPolicyTypes;
end);

-- ===========================================================================
GameEvents.WC_Validate_WorldIdeology.Add(function(resolutionType, playerId, options)
	if (cachedWildcardGovtTypes == nil) then
		cachedWildcardGovtTypes = {};

		for row in GameInfo.Governments() do
			-- Only permit governments that contain Wildcard slots by default
			local bHasWildcards : boolean = false;
			for slotsRow in GameInfo.Government_SlotCounts() do
				if (slotsRow.GovernmentType == row.GovernmentType and slotsRow.GovernmentSlotType == "SLOT_WILDCARD") then
					bHasWildcards = true;
					break;
				end
			end

			if (bHasWildcards == true) then
				table.insert(cachedWildcardGovtTypes, row.Hash);
			end
		end
	end

	options.ResolutionOptions = cachedWildcardGovtTypes;
end);

-- ===========================================================================
GameEvents.WC_Validate_UrbanDevelopment.Add(function(resolutionType, playerId, options)
	if(cachedDistrictTypes == nil) then
		cachedDistrictTypes = {};
		
		for row in GameInfo.Districts() do
			if (row.DistrictType == "DISTRICT_HOLY_SITE") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			if (row.DistrictType == "DISTRICT_CAMPUS") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			if (row.DistrictType == "DISTRICT_ENCAMPMENT") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			if (row.DistrictType == "DISTRICT_HARBOR") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			if (row.DistrictType == "DISTRICT_AERODROME") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			if (row.DistrictType == "DISTRICT_COMMERCIAL_HUB") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			if (row.DistrictType == "DISTRICT_ENTERTAINMENT_COMPLEX") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			if (row.DistrictType == "DISTRICT_THEATER") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			if (row.DistrictType == "DISTRICT_INDUSTRIAL_ZONE") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			if (row.DistrictType == "DISTRICT_GOVERNMENT") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			if (row.DistrictType == "DISTRICT_WATER_ENTERTAINMENT_COMPLEX") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			if (row.DistrictType == "DISTRICT_DIPLOMATIC_QUARTER") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			if (row.DistrictType == "DISTRICT_PRESERVE") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			-- More Maritime Support
			if (row.DistrictType == "DISTRICT_ARSENAL") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			if (row.DistrictType == "DISTRICT_WATERFRONT") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
			-- Leugi's Garden Support
			if (row.DistrictType == "DISTRICT_LEU_GARDEN") then
				table.insert(cachedDistrictTypes, row.Hash);
			end
		end
	end

	-- Build a second list including only those Districts which are applicable in the current era
	local outputDistricts:table = {};
	
	local currentEra	= Game.GetEras():GetCurrentEra();
	local kEraData		:table  = GameInfo.Eras[currentEra];
	local iEraSort		:number = kEraData.ChronologyIndex;

	for _, row in ipairs(cachedDistrictTypes) do
		local pDistrictInfo	:table = GameInfo.Districts[row];

		local allowed:boolean = true;
		if (pDistrictInfo.PrereqCivic and pDistrictInfo.PrereqCivic ~= "") then
			local kPrereq	:table = GameInfo.Civics[pDistrictInfo.PrereqCivic];
			local kEra		= kPrereq.EraType;
			local kEraDef	:table = GameInfo.Eras[kEra];
			local iOtherEraSort	:number = kEraDef.ChronologyIndex;
			if (iOtherEraSort > iEraSort) then
				allowed = false;
			end
		end

		if (pDistrictInfo.PrereqTech and pDistrictInfo.PrereqTech ~= "") then
			local kPrereq	:table = GameInfo.Technologies[pDistrictInfo.PrereqTech];
			local kEra		= kPrereq.EraType;
			local kEraDef	:table = GameInfo.Eras[kEra];
			local iOtherEraSort	:number = kEraDef.ChronologyIndex;
			if (iOtherEraSort > iEraSort) then
				allowed = false;
			end
		end

		if allowed then
			table.insert(outputDistricts, row);
		end
	end
	
	-- Assign valid options
	options.ResolutionOptions = outputDistricts;
end);

-- ===========================================================================
GameEvents.WC_Validate_BorderControl.Add(function(resolutionType, playerId, options)
	cachedPlayers = {};
		
	local aPlayers:table = PlayerManager.GetAliveMajors();
	local pDiplomacy:table = Players[playerId]:GetDiplomacy();
	for _, pPlayer in ipairs(aPlayers) do
		if(pPlayer ~= nil) then
			local loopPlayerID:number = pPlayer:GetID();
			local playerMet:boolean = pDiplomacy:HasMet(loopPlayerID);
			if playerMet then
				table.insert(cachedPlayers, loopPlayerID);
			elseif (loopPlayerID == playerId) then
				table.insert(cachedPlayers, loopPlayerID);
			end
		end
	end

	-- Assign valid options
	options.ResolutionOptions = cachedPlayers;
end);

-- ===========================================================================
GameEvents.WC_Validate_MigrationTreaty.Add(function(resolutionType, playerId, options)
	cachedPlayers = {};
		
	local aPlayers:table = PlayerManager.GetAliveMajors();
	local pDiplomacy:table = Players[playerId]:GetDiplomacy();
	for _, pPlayer in ipairs(aPlayers) do
		if(pPlayer ~= nil) then
			local loopPlayerID:number = pPlayer:GetID();
			local playerMet:boolean = pDiplomacy:HasMet(loopPlayerID);
			if playerMet then
				table.insert(cachedPlayers, loopPlayerID);
			elseif (loopPlayerID == playerId) then
				table.insert(cachedPlayers, loopPlayerID);
			end
		end
	end

	-- Assign valid options
	options.ResolutionOptions = cachedPlayers;
end);

-- ===========================================================================
GameEvents.WC_Validate_PublicWorks.Add(function(resolutionType, playerId, options)
	if(cachedProjects == nil) then
		cachedProjects = {};
		
		for row in GameInfo.Projects() do
			if (row.SpaceRace == true or row.WMD) then
				table.insert(cachedProjects, row.Hash);
			end
		end
	end
	
	-- Assign valid options
	options.ResolutionOptions = cachedProjects;
end);

-- ===========================================================================
GameEvents.WC_Validate_Patronage.Add(function(resolutionType, playerId, options)
	cachedGreatPeopleClasses = {};
		
	local pGreatPeople : table  = Game.GetGreatPeople();
	if (pGreatPeople == nil) then
		return;
	end

	for row in GameInfo.GreatPersonClasses() do
		if (pGreatPeople:IsClassAvailable(row.Index)) then
			table.insert(cachedGreatPeopleClasses, row.Hash);
		end
	end
	
	-- Assign valid options
	options.ResolutionOptions = cachedGreatPeopleClasses;
end);

-- ===========================================================================
GameEvents.WC_Validate_DeforestationFeature.Add(function(resolutionType, playerId, options)
	if(cachedFeatureTypes == nil) then
		cachedFeatureTypes = {};
		
		for row in GameInfo.Features() do
			if (row.FeatureType == "FEATURE_MARSH") then
				table.insert(cachedFeatureTypes, row.Hash);
			end
			if (row.FeatureType == "FEATURE_FOREST") then
				table.insert(cachedFeatureTypes, row.Hash);
			end
			if (row.FeatureType == "FEATURE_JUNGLE") then
				table.insert(cachedFeatureTypes, row.Hash);
			end
		end
	end
	
	-- Assign valid options
	options.ResolutionOptions = cachedFeatureTypes;
end);

-- ===========================================================================
GameEvents.WC_Validate_ArmsControlTreaty.Add(function(resolutionType, playerId, options)
	cachedPlayers = {};
		
	local aPlayers:table = PlayerManager.GetAliveMajors();
	local pDiplomacy:table = Players[playerId]:GetDiplomacy();
	for _, pPlayer in ipairs(aPlayers) do
		if(pPlayer ~= nil) then
			local loopPlayerID:number = pPlayer:GetID();
			local playerMet:boolean = pDiplomacy:HasMet(loopPlayerID);
			if playerMet then
				table.insert(cachedPlayers, loopPlayerID);
			elseif (loopPlayerID == playerId) then
				table.insert(cachedPlayers, loopPlayerID);
			end
		end
	end

	-- Assign valid options
	options.ResolutionOptions = cachedPlayers;
end);

-- ===========================================================================
GameEvents.WC_Validate_TradeTreaty.Add(function(resolutionType, playerId, options)
	cachedPlayers = {};
		
	local aPlayers:table = PlayerManager.GetAliveMajors();
	local pDiplomacy:table = Players[playerId]:GetDiplomacy();
	for _, pPlayer in ipairs(aPlayers) do
		if(pPlayer ~= nil) then
			local loopPlayerID:number = pPlayer:GetID();
			local playerMet:boolean = pDiplomacy:HasMet(loopPlayerID);
			if playerMet then
				table.insert(cachedPlayers, loopPlayerID);
			elseif (loopPlayerID == playerId) then
				table.insert(cachedPlayers, loopPlayerID);
			end
		end
	end

	-- Assign valid options
	options.ResolutionOptions = cachedPlayers;
end);

-- ===========================================================================
GameEvents.WC_Validate_DiploVictory.Add(function(resolutionType, playerId, options)
	cachedPlayers = {};
		
	local aPlayers:table = PlayerManager.GetAliveMajors();
	local pDiplomacy:table = Players[playerId]:GetDiplomacy();
	for _, pPlayer in ipairs(aPlayers) do
		if(pPlayer ~= nil) then
			local loopPlayerID:number = pPlayer:GetID();
			local playerMet:boolean = pDiplomacy:HasMet(loopPlayerID);
			if playerMet then
				table.insert(cachedPlayers, loopPlayerID);
			elseif (loopPlayerID == playerId) then
				table.insert(cachedPlayers, loopPlayerID);
			end
		end
	end

	-- Assign valid options
	options.ResolutionOptions = cachedPlayers;
end);

-- ===========================================================================
GameEvents.WC_Validate_ESPIONAGE_PACT.Add(function(resolutionType, playerId, options)
	if (cachedOperations == nil) then
		cachedOperations = {};

		for row in GameInfo.UnitOperations() do
			if (row.CategoryInUI == "OFFENSIVESPY" and row.BaseProbability > 0) then
				table.insert(cachedOperations, row.Hash);
			end
		end
	end

	-- Assign valid options
	options.ResolutionOptions = cachedOperations;
end);

-- ===========================================================================
GameEvents.WC_Validate_MILITARY_ADVISORY.Add(function(resolutionType, playerId, options)
	if (cachedUnitPromotions == nil) then
		cachedUnitPromotions = {};

		for row in GameInfo.UnitPromotionClasses() do
			if (row.PromotionClassType == "PROMOTION_CLASS_RECON") then
				table.insert(cachedUnitPromotions, row.Hash);
			elseif (row.PromotionClassType == "PROMOTION_CLASS_MELEE") then
				table.insert(cachedUnitPromotions, row.Hash);
			elseif (row.PromotionClassType == "PROMOTION_CLASS_RANGED") then
				table.insert(cachedUnitPromotions, row.Hash);
			elseif (row.PromotionClassType == "PROMOTION_CLASS_ANTI_CAVALRY") then
				table.insert(cachedUnitPromotions, row.Hash);
			elseif (row.PromotionClassType == "PROMOTION_CLASS_LIGHT_CAVALRY") then
				table.insert(cachedUnitPromotions, row.Hash);
			elseif (row.PromotionClassType == "PROMOTION_CLASS_HEAVY_CAVALRY") then
				table.insert(cachedUnitPromotions, row.Hash);
			elseif (row.PromotionClassType == "PROMOTION_CLASS_SIEGE") then
				table.insert(cachedUnitPromotions, row.Hash);
			-- Monk and Nihang are way too far back in the tech tree to still be worth it in Industrial Era+; Plus, monks get boosted by World Religion
			--elseif (row.PromotionClassType == "PROMOTION_CLASS_MONK") then
			--	table.insert(cachedUnitPromotions, row.Hash);
			--elseif (row.PromotionClassType == "PROMOTION_CLASS_NIHANG") then
			--	table.insert(cachedUnitPromotions, row.Hash);
			-- While awesome, naval carriers can only defend
			-- elseif (row.PromotionClassType == "PROMOTION_CLASS_NAVAL_CARRIER") then
			--	table.insert(cachedUnitPromotions, row.Hash);
			-- Add in all the others
			elseif (row.PromotionClassType == "PROMOTION_CLASS_NAVAL_MELEE") then
				table.insert(cachedUnitPromotions, row.Hash);
			elseif (row.PromotionClassType == "PROMOTION_CLASS_NAVAL_RANGED") then
				table.insert(cachedUnitPromotions, row.Hash);
			elseif (row.PromotionClassType == "PROMOTION_CLASS_NAVAL_RAIDER") then
				table.insert(cachedUnitPromotions, row.Hash);
			elseif (row.PromotionClassType == "PROMOTION_CLASS_AIR_FIGHTER") then
				table.insert(cachedUnitPromotions, row.Hash);
			elseif (row.PromotionClassType == "PROMOTION_CLASS_AIR_BOMBER") then
				table.insert(cachedUnitPromotions, row.Hash);
			elseif (row.PromotionClassType == "PROMOTION_CLASS_GIANT_DEATH_ROBOT") then
				table.insert(cachedUnitPromotions, row.Hash);
			-- Modern Infantry Support
			elseif (row.PromotionClassType == "PROMOTION_CLASS_RECON_HYBRID") then
				table.insert(cachedUnitPromotions, row.Hash);
			end
		end
	end

	-- Build a second list including only those Units which are applicable in the current era
	local availableUnitPromotions:table = {};
	local availableUnitHashes:table = {};
	local outputUnitPromotions:table = {};

	local currentEra	= Game.GetEras():GetCurrentEra();
	local kEraData		:table  = GameInfo.Eras[currentEra];
	local iEraSort		:number = kEraData.ChronologyIndex;

	for row in GameInfo.Units() do

		if (row.PromotionClass and row.PromotionClass ~= "") then
			--print("PromotionClass: " .. row.PromotionClass);
			
			local allowed:boolean = true;
			if (row.PrereqCivic and row.PrereqCivic ~= "") then
				--print("PrereqCivic: " .. row.PrereqCivic);
				local kPrereq	:table = GameInfo.Civics[row.PrereqCivic];
				local kEra		= kPrereq.EraType;
				local kEraDef	:table = GameInfo.Eras[kEra];
				local iOtherEraSort	:number = kEraDef.ChronologyIndex;
				if (iOtherEraSort > iEraSort) then
					allowed = false;
				end
			end

			if (row.PrereqTech and row.PrereqTech ~= "") then
				--print("PrereqTech: " .. row.PrereqTech);
				local kPrereq	:table = GameInfo.Technologies[row.PrereqTech];
				local kEra		= kPrereq.EraType;
				local kEraDef	:table = GameInfo.Eras[kEra];
				local iOtherEraSort	:number = kEraDef.ChronologyIndex;
				if (iOtherEraSort > iEraSort) then
					allowed = false;
				end
			end

			if allowed then
				table.insert(availableUnitPromotions, row.PromotionClass);
			end
		end
	end

	for _, rowPromotions in ipairs(availableUnitPromotions) do
		--print("AVAILABLE PROMOTION: " .. rowPromotions);

		for row in GameInfo.UnitPromotionClasses() do
			if (row.PromotionClassType == rowPromotions) then
				table.insert(availableUnitHashes, row.Hash);
			end
		end
	end

	for _, cachedHash in ipairs(cachedUnitPromotions) do
		--print("CASHED HASH: " .. cachedHash);
		if (outputUnitPromotions[cachedHash] == nil) then
			for _, availableHash in ipairs(availableUnitHashes) do
				--print("AVAILABLE HASH: " .. availableHash);
				if (cachedHash == availableHash) then
					--print("ITS GOOD");
					table.insert(outputUnitPromotions, cachedHash);
					break;
				end
				--print("KEEP GOING");
			end
		end
	end
	
	-- Assign valid options
	options.ResolutionOptions = outputUnitPromotions;
end);

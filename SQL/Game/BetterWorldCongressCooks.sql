-- Industrial Start for the World Congress
-- This way you've probably met the other players before it the World Congress starts.
-- Start with 4 less victory points due to the late start (in eras where this was greater than 0

UPDATE "GlobalParameters"
SET
	"Value" = 4
WHERE "Name" = 'WORLD_CONGRESS_INITIAL_ERA';

UPDATE "StartEras_XP2"
SET
	"DiploVP" = "DiploVP" - 4;

-- Diplomatic Victory seems too easy with the Better World Congress
-- Reduce the ease by: upping the points required, schedule meetings slightly less often

UPDATE "GlobalParameters"
SET
	"Value" = 30
WHERE "Name" = 'DIPLOMATIC_VICTORY_POINTS_REQUIRED'; -- Default 20

UPDATE "GlobalParameters"
SET
	"Value" = 25
WHERE "Name" = 'WORLD_CONGRESS_MAX_TIME_BETWEEN_MEETINGS'; -- Default 30, Nere's 25

UPDATE "EmergencyAlliances"
SET
	"Duration" = 24 -- Default 29, Nere's 19
WHERE "EmergencyType" IN ('EMERGENCY_NOBEL_PRIZE_LITERATURE', 'EMERGENCY_NOBEL_PRIZE_PEACE', 'EMERGENCY_NOBEL_PRIZE_PHYSICS', 'EMERGENCY_WORLDS_FAIR', 'EMERGENCY_SPACE_STATION', 'EMERGENCY_CLIMATE_ACCORDS', 'EMERGENCY_WORLD_GAMES');

UPDATE "EmergencyAlliances"
SET
	"Duration" = 25 -- Default 30, Nere's 20
WHERE "EmergencyType" IN ('EMERGENCY_SEND_AID', 'EMERGENCY_SEND_MILITARY_AID');

-- Deforestation Treaty
-- Option A
-- Replace the one-time grant with an ongoing bonus over the course of the Resolution

DELETE FROM "ResolutionEffects"
WHERE "ResolutionEffectId" IN (953, 954, 957, 958, 959 );

DELETE FROM "ModifierArguments"
WHERE "ModifierId" IN ('NERE_CONGRESS_GRANT_SCIENCE_PER_RAINFOREST', 'NERE_CONGRESS_GRANT_SCIENCE_PER_MARSH', 'NERE_CONGRESS_GRANT_SCIENCE_PER_WOODS', 
	'NERE_CONGRESS_GRANT_CULTURE_PER_RAINFOREST', 'NERE_CONGRESS_GRANT_CULTURE_PER_MARSH', 'NERE_CONGRESS_GRANT_CULTURE_PER_WOODS');

DELETE FROM "Modifiers"
WHERE "ModifierId" IN ('NERE_CONGRESS_GRANT_SCIENCE_PER_RAINFOREST', 'NERE_CONGRESS_GRANT_SCIENCE_PER_MARSH', 'NERE_CONGRESS_GRANT_SCIENCE_PER_WOODS', 
	'NERE_CONGRESS_GRANT_CULTURE_PER_RAINFOREST', 'NERE_CONGRESS_GRANT_CULTURE_PER_MARSH', 'NERE_CONGRESS_GRANT_CULTURE_PER_WOODS');

DELETE FROM "DynamicModifiers"
WHERE "ModifierType" IN ('NERE_MODIFIER_ALL_CITIES_ADJUST_CITY_YIELD', 'NERE_MODIFIER_ALL_CITIES_GRANT_YIELD_PER_FEATURE_TYPE');

DELETE FROM "Types"
WHERE "Type" IN ('NERE_MODIFIER_ALL_CITIES_ADJUST_CITY_YIELD', 'NERE_MODIFIER_ALL_CITIES_GRANT_YIELD_PER_FEATURE_TYPE');

INSERT INTO "Types"
	(	"Type",														"Kind"			)
VALUES
	(	'NERE_MODIFIER_ALL_CITIES_GRANT_YIELD_PER_FEATURE_TYPE',	'KIND_MODIFIER'	);

INSERT INTO "DynamicModifiers"
	(	"ModifierType",												"CollectionType",				"EffectType"				)
VALUES
	(	'NERE_MODIFIER_ALL_CITIES_GRANT_YIELD_PER_FEATURE_TYPE',	'COLLECTION_ALL_PLOT_YIELDS',	'EFFECT_ADJUST_PLOT_YIELD'	);

INSERT INTO "RequirementSets"
	(	"RequirementSetId",						"RequirementSetType"		)
VALUES
	(	'NERE_PLOT_IS_MARSH_RAINFOREST_WOODS',	'REQUIREMENTSET_TEST_ANY'	);

INSERT INTO "RequirementSetRequirements"
	(	"RequirementSetId",						"RequirementId"					)
VALUES
	(	'NERE_PLOT_IS_MARSH_RAINFOREST_WOODS',	'PLOT_IS_MARSH_REQUIREMENT'		),
	(	'NERE_PLOT_IS_MARSH_RAINFOREST_WOODS',	'PLOT_IS_JUNGLE_REQUIREMENT'	),
	(	'NERE_PLOT_IS_MARSH_RAINFOREST_WOODS',	'PLOT_IS_FOREST_REQUIREMENT'	);

INSERT INTO "Modifiers"
	(	"ModifierId",						"ModifierType",												"SubjectRequirementSetId"				)
VALUES
	(	'NERE_CONGRESS_GRANT_PER_FEATURE',	'NERE_MODIFIER_ALL_CITIES_GRANT_YIELD_PER_FEATURE_TYPE',	'NERE_PLOT_IS_MARSH_RAINFOREST_WOODS'	);

INSERT INTO "ModifierArguments"
	(	"ModifierId",						"Name",			"Value"													)
VALUES
	(	'NERE_CONGRESS_GRANT_PER_FEATURE',	'YieldType',	'YIELD_SCIENCE, YIELD_CULTURE, YIELD_GOLD, YIELD_FAITH'	),
	(	'NERE_CONGRESS_GRANT_PER_FEATURE',	'Amount',		3														);

UPDATE "ResolutionEffects"
SET
	"ModifierId" = 'NERE_CONGRESS_GRANT_PER_FEATURE'
WHERE "ResolutionEffectId" = 952;

-- Option B
-- Add granted Military Engineer

INSERT INTO "Modifiers"
	(	"ModifierId",									"ModifierType",								"SubjectRequirementSetId",						"RunOnce",	"Permanent"	)
VALUES
	(	'NERE_CONGRESS_APPLY_GRANT_MILITARY_ENGINEER',	'MODIFIER_MAJOR_PLAYERS_ATTACH_MODIFIER',	NULL,											0,			0			),
	(	'NERE_CONGRESS_GRANT_MILITARY_ENGINEER',		'MODIFIER_PLAYER_GRANT_UNIT_IN_CAPITAL',	'PLAYER_HAS_AT_LEAST_ONE_CITY_REQUIREMENTS',	1,			1			);

INSERT INTO "ModifierArguments"
	(	"ModifierId",									"Name",			"Value"												)
VALUES
	(	'NERE_CONGRESS_APPLY_GRANT_MILITARY_ENGINEER',	'ModifierId',				'NERE_CONGRESS_GRANT_MILITARY_ENGINEER'	),
	(	'NERE_CONGRESS_GRANT_MILITARY_ENGINEER',		'UnitType',					'UNIT_MILITARY_ENGINEER'				),
	(	'NERE_CONGRESS_GRANT_MILITARY_ENGINEER',		'Amount',					1										),
	(	'NERE_CONGRESS_GRANT_MILITARY_ENGINEER',		'AllowUniqueOverride',		1										);

INSERT INTO "ResolutionEffects"
	(	"ResolutionEffectId",	"ResolutionType",				"WhichEffect",	"ModifierId"									)
VALUES
	(	955,					'WC_RES_DEFORESTATION_TREATY',	2,				'NERE_CONGRESS_APPLY_GRANT_MILITARY_ENGINEER'	);

-- Military Advisory
-- Add new luxury debuff / buff for these choices
-- Option A

INSERT INTO "Types"
	(	"Type",												"Kind"			)
VALUES
	(	'NERE_MODIFIER_ALL_CITIES_ADJUST_POLICY_AMENITY',	'KIND_MODIFIER'	);

INSERT INTO "DynamicModifiers"
	(	"ModifierType",										"CollectionType",			"EffectType"					)
VALUES
	(	'NERE_MODIFIER_ALL_CITIES_ADJUST_POLICY_AMENITY',	'COLLECTION_ALL_CITIES',	'EFFECT_ADJUST_POLICY_AMENITY'	);

INSERT INTO "Modifiers"
	(	"ModifierId",					"ModifierType"										)
VALUES
	(	'NERE_CONGRESS_REDUCE_AMENITY',	'NERE_MODIFIER_ALL_CITIES_ADJUST_POLICY_AMENITY'	);

INSERT INTO "ModifierArguments"
	(	"ModifierId",					"Name",		"Value"	)
VALUES
	(	'NERE_CONGRESS_REDUCE_AMENITY',	'Amount',	-4		);

INSERT INTO "ResolutionEffects"
	(	"ResolutionEffectId",	"ResolutionType",			"WhichEffect",	"ModifierId"					)
VALUES
	(	931,					'WC_RES_MILITARY_ADVISORY',	1,				'NERE_CONGRESS_REDUCE_AMENITY'	);

-- Option B

INSERT INTO "Modifiers"
	(	"ModifierId",						"ModifierType"										)
VALUES
	(	'NERE_CONGRESS_INCREASE_AMENITY',	'NERE_MODIFIER_ALL_CITIES_ADJUST_POLICY_AMENITY'	);

INSERT INTO "ModifierArguments"
	(	"ModifierId",						"Name",		"Value"	)
VALUES
	(	'NERE_CONGRESS_INCREASE_AMENITY',	'Amount',	4		);

INSERT INTO "ResolutionEffects"
	(	"ResolutionEffectId",	"ResolutionType",			"WhichEffect",	"ModifierId"						)
VALUES
	(	935,					'WC_RES_MILITARY_ADVISORY',	2,				'NERE_CONGRESS_INCREASE_AMENITY'	);

-- Trade Treaty
-- Correction to how the Trade treaty works, this is actually a fix to the base game
-- Option A

UPDATE "Modifiers"
SET
	"ModifierType" = 'MODIFIER_PLAYER_CITIES_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS'
WHERE "ModifierId" = 'INCREASES_TRADE_TO_GOLD';
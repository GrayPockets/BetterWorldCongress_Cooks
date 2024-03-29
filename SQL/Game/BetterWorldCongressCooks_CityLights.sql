-- Urban Development
-- Modify to adjust Urban / Rural cities
-- Option A

DELETE FROM "ModifierArguments"
WHERE "ModifierId" = 'NERE_CONGRESS_MORE_BUILDING_PRODUCTION';

DELETE FROM "Modifiers"
WHERE "ModifierId" = 'NERE_CONGRESS_MORE_BUILDING_PRODUCTION';

INSERT INTO "RequirementSets"
	(	"RequirementSetId",		"RequirementSetType"		)
VALUES
	(	'NERE_CITY_HAS_URBAN',	'REQUIREMENTSET_TEST_ANY'	);

INSERT INTO "RequirementSetRequirements"
	(	"RequirementSetId",		"RequirementId"	)
VALUES
	(	'NERE_CITY_HAS_URBAN',	'COREX_CITY_HAS_COREXA'			),
	(	'NERE_CITY_HAS_URBAN',	'COREX_CITY_HAS_COREXB'			),
	(	'NERE_CITY_HAS_URBAN',	'COREX_CITY_HAS_COREXC'			),
	(	'NERE_CITY_HAS_URBAN',	'COREX_FRANCE_CITY_HAS_COREXC'	),
	(	'NERE_CITY_HAS_URBAN',	'COREX_SPAIN_CITY_HAS_COREXB'	),
	(	'NERE_CITY_HAS_URBAN',	'COREX_CHINA_CITY_HAS_COREXA'	),
	(	'NERE_CITY_HAS_URBAN',	'COREX_INDIA_CITY_HAS_COREXA'	);

INSERT INTO "Modifiers"
	(	"ModifierId",								"ModifierType",													"SubjectRequirementSetId"	)
VALUES
	(	'NERE_CONGRESS_URBAN_BUILDING_PRODUCTION',	'NERE_MODIFIER_ALL_CITIES_ADJUST_BUILDING_PRODUCTION_MODIFIER',	'NERE_CITY_HAS_URBAN'		);

INSERT INTO "ModifierArguments"
	(	"ModifierId",	"Name",	"Value"	)
VALUES
	(	'NERE_CONGRESS_URBAN_BUILDING_PRODUCTION',	'Amount',	25	),
	(	'NERE_CONGRESS_URBAN_BUILDING_PRODUCTION',	'IsWonder',	0	);

UPDATE "ResolutionEffects"
SET
	"ModifierId" = 'NERE_CONGRESS_URBAN_BUILDING_PRODUCTION'
WHERE "ResolutionEffectId" = 9100;

-- Option B

DELETE FROM "ModifierArguments"
WHERE "ModifierId" = 'NERE_CONGRESS_LESS_BUILDING_PRODUCTION';

DELETE FROM "Modifiers"
WHERE "ModifierId" = 'NERE_CONGRESS_LESS_BUILDING_PRODUCTION';

INSERT INTO "Types"
	(	"Type",														"Kind"			)
VALUES
	(	'NERE_MODIFIER_ALL_CITIES_ADJUST_UNIT_PRODUCTION_MODIFIER',	'KIND_MODIFIER'	);

INSERT INTO "DynamicModifiers"
	(	"ModifierType",												"CollectionType",			"EffectType"									)
VALUES
	(	'NERE_MODIFIER_ALL_CITIES_ADJUST_UNIT_PRODUCTION_MODIFIER',	'COLLECTION_ALL_CITIES',	'EFFECT_ADJUST_ALL_UNIT_PRODUCTION_MODIFIER'	);

INSERT INTO "RequirementSets"
	(	"RequirementSetId",		"RequirementSetType"		)
VALUES
	(	'NERE_CITY_HAS_RURAL',	'REQUIREMENTSET_TEST_ANY'	);

INSERT INTO "Requirements"
	(	"RequirementId",					"RequirementType",					"Likeliness",	"Impact",	"Inverse",	"Reverse",	"Persistent",	"ProgressWeight",	"Triggered"	)
VALUES
	(	'RURCOM_JAPAN_CITY_HAS_RURCOMC',	'REQUIREMENT_CITY_HAS_DISTRICT',	0,				0,			0,			0,			0,				1,					0			),
	(	'RURCOM_EGYPT_CITY_HAS_RURCOMB',	'REQUIREMENT_CITY_HAS_DISTRICT',	0,				0,			0,			0,			0,				1,					0			),
	(	'RURCOM_CANADA_CITY_HAS_RURCOMA',	'REQUIREMENT_CITY_HAS_DISTRICT',	0,				0,			0,			0,			0,				1,					0			),
	(	'RURCOM_GEORGIA_CITY_HAS_RURCOMB',	'REQUIREMENT_CITY_HAS_DISTRICT',	0,				0,			0,			0,			0,				1,					0			);

INSERT INTO "RequirementArguments"
	(	"RequirementId",	"Name",	"Type",	"Value"	)
VALUES
	(	'RURCOM_JAPAN_CITY_HAS_RURCOMC',	'DistrictType',	'ARGTYPE_IDENTITY',	'DISTRICT_COREX_GYOSON'			),
	(	'RURCOM_EGYPT_CITY_HAS_RURCOMB',	'DistrictType',	'ARGTYPE_IDENTITY',	'DISTRICT_COREX_TROYU'			),
	(	'RURCOM_CANADA_CITY_HAS_RURCOMA',	'DistrictType',	'ARGTYPE_IDENTITY',	'DISTRICT_COREX_FRONTIER_TOWN'	),
	(	'RURCOM_GEORGIA_CITY_HAS_RURCOMB',	'DistrictType',	'ARGTYPE_IDENTITY',	'DISTRICT_COREX_TSIKHE'			);

INSERT INTO "RequirementSetRequirements"
	(	"RequirementSetId",		"RequirementId"	)
VALUES
	(	'NERE_CITY_HAS_RURAL',	'RURCOM_CITY_HAS_RURCOMA'			),
	(	'NERE_CITY_HAS_RURAL',	'RURCOM_CITY_HAS_RURCOMB'			),
	(	'NERE_CITY_HAS_RURAL',	'RURCOM_CITY_HAS_RURCOMC'			),
	(	'NERE_CITY_HAS_RURAL',	'RURCOM_JAPAN_CITY_HAS_RURCOMC'		),
	(	'NERE_CITY_HAS_RURAL',	'RURCOM_EGYPT_CITY_HAS_RURCOMB'		),
	(	'NERE_CITY_HAS_RURAL',	'RURCOM_CANADA_CITY_HAS_RURCOMA'	),
	(	'NERE_CITY_HAS_RURAL',	'RURCOM_GEORGIA_CITY_HAS_RURCOMB'	);

INSERT INTO "Modifiers"
	(	"ModifierId",							"ModifierType",												"SubjectRequirementSetId"	)
VALUES
	(	'NERE_CONGRESS_RURAL_UNIT_PRODUCTION',	'NERE_MODIFIER_ALL_CITIES_ADJUST_UNIT_PRODUCTION_MODIFIER',	'NERE_CITY_HAS_RURAL'		);

INSERT INTO "ModifierArguments"
	(	"ModifierId",							"Name",		"Value"	)
VALUES
	(	'NERE_CONGRESS_RURAL_UNIT_PRODUCTION',	'Amount',	25		);

UPDATE "ResolutionEffects"
SET
	"ModifierId" = 'NERE_CONGRESS_RURAL_UNIT_PRODUCTION'
WHERE "ResolutionEffectId" = 9105;

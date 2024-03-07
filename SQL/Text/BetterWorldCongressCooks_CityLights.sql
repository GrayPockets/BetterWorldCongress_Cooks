-- Match the text to the new Resolution Effects

INSERT OR REPLACE INTO "LocalizedText"
	(	"Language",	"Tag",																"Text"																																				)
VALUES
	(	'en_US',	'LOC_WORLD_CONGRESS_DISTRICT_BUILDING_PRODUCTION_DESC',				'Double [ICON_Production] Production towards buildings in chosen District. +25% [ICON_Production] Production towards buildings in Urban cities.'	),
	(	'en_US',	'LOC_WORLD_CONGRESS_NO_DISTRICT_BUILDING_DESC',						'No buildings can be created in chosen District. +25% [ICON_Production] Production towards units in Rural cities.'									);

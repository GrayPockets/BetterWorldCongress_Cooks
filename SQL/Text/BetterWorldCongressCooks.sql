-- Match the Civilopedia entry to the new settings

INSERT OR REPLACE INTO "LocalizedText"
	(	"Language",	"Tag",																"Text"																																																																																																																																			)
VALUES
	(	'en_US',	'LOC_PEDIA_CONCEPTS_PAGE_WORLD_CONGRESS_CHAPTER_CONGRESS_PARA_1',	'The World Congress is a new system representing high-level diplomacy between civilizations, and begins meeting once the game has entered the Industrial Era.'																																																																																													),
	(	'en_US',	'LOC_PEDIA_CONCEPTS_PAGE_WORLD_CONGRESS_CHAPTER_CONGRESS_PARA_2',	'The World Congress operates in two modes. In a regular World Congress session, which happens automatically every 25 turns (on Standard Speed), all the Civilizations of the world gather to vote on Resolutions and Scored Competitions. In a Special Session, which must be requested by a player that has been affected by a trigger for an Emergency, the players who are invited to join that Emergency will vote on whether or not they wish to do so. You will use [ICON_Favor] Diplomatic Favor to interact with the World Congress.'	);

-- Match the text to the new Resolution Effects

INSERT OR REPLACE INTO "LocalizedText"
	(	"Language",	"Tag",																"Text"																																																						)
VALUES
	(	'en_US',	'LOC_WORLD_CONGRESS_DEFORESTATION_BAN_DESC',						'Prohibits removing the chosen Feature. All players receive 1 Naturalist. Forest, Marshes, and Rainforests yield +3 [ICON_Science] Science, [ICON_Culture] Culture, [ICON_GOLD] Gold, and [ICON_FAITH] Faith.'				),
	(	'en_US',	'LOC_WORLD_CONGRESS_DEFORESTATION_GOLD_DESC',						'Removing the chosen Feature yields [ICON_Gold] Gold equal to the [ICON_Production] Production and [ICON_Food] Food. All players receive 1 Military Engineer. Yields from Removing any Feature is increased thricefold.'	),
	(	'en_US',	'LOC_WORLD_CONGRESS_MILITARY_ADVISORY_BUFF_DESC',					'Units of the chosen Promotion Class gain +15 Combat Strength. All cities lose -4 [ICON_Amenities] Amenities out to fear.'																									),
	(	'en_US',	'LOC_WORLD_CONGRESS_MILITARY_ADVISORY_NERF_DESC',					'Units of the chosen Promotion Class lose -15 Combat Strength. All cities gain +4 [ICON_Amenities] Amenities from perceived safety.'																						),
	(	'en_US',	'LOC_WORLD_CONGRESS_FAVOR_FROM_TRADE_AND_ENVOYS_WITH_MINORS_DESC',	'Trade Routes sent to the chosen City-State type gain +10 yield of that City-States'' type (+20 for [ICON_Gold] Gold. Double the [ICON_Favor] Diplomatic Favor for being the Suzerain of a City-State.'						),
	(	'en_US',	'LOC_WORLD_CONGRESS_NO_SUZERAIN_BONUS_DESC',						'City-States of the chosen type do not provide their unique Suzerain bonuses. No [ICON_Favor] Diplomatic Favor for being the Suzerain of a City-State.'																		);

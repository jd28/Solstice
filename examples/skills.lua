require 'nwn.skills'

nwn.RegisterSkill(
   nwn.SKILL_ANIMAL_EMPATHY, 
   "Animal Empathy",
   "AE",
   nwn.ABILITY_CHARISMA,
   nwn.FEAT_SKILL_FOCUS_ANIMAL_EMPATHY,
   nwn.FEAT_EPIC_SKILL_FOCUS_ANIMAL_EMPATHY)

nwn.RegisterSkill(
   nwn.SKILL_CONCENTRATION,
   "Concentration",
   "Conc",
   nwn.ABILITY_CONSTITUTION,
   nwn.FEAT_SKILL_FOCUS_CONCENTRATION,
   nwn.FEAT_EPIC_SKILL_FOCUS_CONCENTRATION,
   nwn.FEAT_SKILL_AFFINITY_CONCENTRATION)
   
nwn.RegisterSkill(
   nwn.SKILL_DISABLE_TRAP,
   "Disable Trap",
   "DT",
   nwn.ABILITY_INTELLIGENCE,
   nwn.FEAT_SKILL_FOCUS_DISABLE_TRAP,
   nwn.FEAT_EPIC_SKILL_FOCUS_DISABLETRAP)

nwn.RegisterSkill(
   nwn.SKILL_DISCIPLINE,
   "Discipline",
   "Disc",
   nwn.ABILITY_STRENGTH,
   nwn.FEAT_SKILL_FOCUS_DISCIPLINE,
   nwn.FEAT_EPIC_SKILL_FOCUS_DISCIPLINE)

nwn.RegisterSkill(
   nwn.SKILL_HEAL,
   "Heal", 
   "Heal",
   nwn.ABILITY_WISDOM,
   nwn.FEAT_SKILL_FOCUS_HEAL,
   nwn.FEAT_EPIC_SKILL_FOCUS_HEAL)

nwn.RegisterSkill(
   nwn.SKILL_HIDE,
   "Hide",
   "Hide",
   nwn.ABILITY_DEXTERITY,
   nwn.FEAT_SKILL_FOCUS_HIDE,
   nwn.FEAT_EPIC_SKILL_FOCUS_HIDE,
   nil,
   nil,
   true)

nwn.RegisterSkill(
   nwn.SKILL_LISTEN,
   "Listen",
   "Lstn",
   nwn.ABILITY_WISDOM,
   nwn.FEAT_SKILL_FOCUS_LISTEN,
   nwn.FEAT_EPIC_SKILL_FOCUS_LISTEN,
   nwn.FEAT_SKILL_AFFINITY_LISTEN,
   nwn.FEAT_PARTIAL_SKILL_AFFINITY_LISTEN)

nwn.RegisterSkill(
   nwn.SKILL_LORE,
   "Lore",
   "Lore",
   nwn.ABILITY_INTELLIGENCE,
   nwn.FEAT_SKILL_FOCUS_LORE,
   nwn.FEAT_EPIC_SKILL_FOCUS_LORE,
   nwn.FEAT_SKILL_AFFINITY_LORE)

nwn.RegisterSkill(
   nwn.SKILL_MOVE_SILENTLY,
   "Move Silently",
   "MS",
   nwn.ABILITY_DEXTERITY,
   nwn.FEAT_SKILL_FOCUS_MOVE_SILENTLY,
   nwn.FEAT_EPIC_SKILL_FOCUS_MOVESILENTLY,
   nwn.FEAT_SKILL_AFFINITY_MOVE_SILENTLY,
   nil,
   true)

nwn.RegisterSkill(
   nwn.SKILL_OPEN_LOCK,
   "Open Lock", 
   "OL",
   nwn.ABILITY_DEXTERITY,
   nwn.FEAT_SKILL_FOCUS_OPEN_LOCK,
   nwn.FEAT_EPIC_SKILL_FOCUS_OPENLOCK)

nwn.RegisterSkill(
   nwn.SKILL_PARRY,
   "Parry",
   "Pry",
   nwn.ABILITY_DEXTERITY,
   nwn.FEAT_SKILL_FOCUS_PARRY,
   nwn.FEAT_EPIC_SKILL_FOCUS_PARRY,
   nil,
   nil,
   true)

nwn.RegisterSkill(
   nwn.SKILL_PERFORM,
   "Perform",
   "Perf",
   nwn.ABILITY_CHARISMA,
   nwn.FEAT_SKILL_FOCUS_PERFORM,
   nwn.FEAT_EPIC_SKILL_FOCUS_PERFORM)

nwn.RegisterSkill(
   nwn.SKILL_PERSUADE,
   "Persuade",
   "Pers",
   nwn.ABILITY_CHARISMA,
   nwn.FEAT_SKILL_FOCUS_PERSUADE,
   nwn.FEAT_EPIC_SKILL_FOCUS_PERSUADE)

nwn.RegisterSkill(
   nwn.SKILL_PICK_POCKET,
   "Pick Pocket",
   "PP",
   nwn.ABILITY_DEXTERITY,
   nwn.FEAT_SKILL_FOCUS_PICK_POCKET,
   nwn.FEAT_EPIC_SKILL_FOCUS_PICKPOCKET,
   nil,
   nil,
   true)

nwn.RegisterSkill(
   nwn.SKILL_SEARCH,
   "Search",
   "Srch",
   nwn.ABILITY_INTELLIGENCE,
   nwn.FEAT_SKILL_FOCUS_SEARCH,
   nwn.FEAT_EPIC_SKILL_FOCUS_SEARCH,
   nwn.FEAT_SKILL_AFFINITY_SEARCH,
   nwn.FEAT_PARTIAL_SKILL_AFFINITY_SEARCH)

nwn.RegisterSkill(
   nwn.SKILL_SET_TRAP,
   "Set Trap",
   "ST",
   nwn.ABILITY_DEXTERITY,
   nwn.FEAT_SKILL_FOCUS_SET_TRAP,
   nwn.FEAT_EPIC_SKILL_FOCUS_SETTRAP,
   nil,
   nil,
   true)

nwn.RegisterSkill(
   nwn.SKILL_SPELLCRAFT,
   "Spellcraft",
   "Sc",
   nwn.ABILITY_INTELLIGENCE,
   nwn.FEAT_SKILL_FOCUS_SPELLCRAFT,
   nwn.FEAT_EPIC_SKILL_FOCUS_SPELLCRAFT)

nwn.RegisterSkill(
   nwn.SKILL_SPOT,
   "Spot",
   "Spot",
   nwn.ABILITY_WISDOM,
   nwn.FEAT_SKILL_FOCUS_SPOT,
   nwn.FEAT_EPIC_SKILL_FOCUS_SPOT,
   nwn.FEAT_SKILL_AFFINITY_SPOT,
   nwn.FEAT_PARTIAL_SKILL_AFFINITY_SPOT)

nwn.RegisterSkill(
   nwn.SKILL_TAUNT,
   "Taunt",
   "Taunt",
   nwn.ABILITY_CHARISMA,
   nwn.FEAT_SKILL_FOCUS_TAUNT,
   nwn.FEAT_EPIC_SKILL_FOCUS_TAUNT)

nwn.RegisterSkill(
   nwn.SKILL_USE_MAGIC_DEVICE,
   "Use Magic Device",
   "UMD",
   nwn.ABILITY_CHARISMA,
   nwn.FEAT_SKILL_FOCUS_USE_MAGIC_DEVICE,
   nwn.FEAT_EPIC_SKILL_FOCUS_USEMAGICDEVICE)

nwn.RegisterSkill(
   nwn.SKILL_APPRAISE,
   "Appraise",
   "App",
   nwn.ABILITY_INTELLIGENCE,
   nwn.FEAT_SKILL_FOCUS_APPRAISE,
   nwn.FEAT_EPIC_SKILL_FOCUS_APPRAISE)

nwn.RegisterSkill(
   nwn.SKILL_TUMBLE,
   "Tumble",
   "Tmb",
   nwn.ABILITY_DEXTERITY,
   nwn.FEAT_SKILL_FOCUS_TUMBLE,
   nwn.FEAT_EPIC_SKILL_FOCUS_TUMBLE,
   nil,
   nil,
   true)

nwn.RegisterSkill(
   nwn.SKILL_CRAFT_TRAP,
   "Craft Trap",
   "CT",
   nwn.ABILITY_INTELLIGENCE,
   nwn.FEAT_SKILL_FOCUS_CRAFT_TRAP,
   nwn.FEAT_EPIC_SKILL_FOCUS_CRAFT_TRAP)

nwn.RegisterSkill(
   nwn.SKILL_BLUFF,
   "Bluff",
   "Bluff",
   nwn.ABILITY_CHARISMA,
   nwn.FEAT_SKILL_FOCUS_BLUFF,
   nwn.FEAT_EPIC_SKILL_FOCUS_BLUFF)

nwn.RegisterSkill(
   nwn.SKILL_INTIMIDATE,
   "Intimidate",
   "Int",
   nwn.ABILITY_CHARISMA,
   nwn.FEAT_SKILL_FOCUS_INTIMIDATE,
   nwn.FEAT_EPIC_SKILL_FOCUS_INTIMIDATE)

nwn.RegisterSkill(
   nwn.SKILL_CRAFT_ARMOR,
   "Craft Armor",
   "CA",
   nwn.ABILITY_INTELLIGENCE,
   nwn.FEAT_SKILL_FOCUS_CRAFT_ARMOR,
   nwn.FEAT_EPIC_SKILL_FOCUS_CRAFT_ARMOR)

nwn.RegisterSkill(
   nwn.SKILL_CRAFT_WEAPON,
   "Craft Weapon",
   "CW",
   nwn.ABILITY_INTELLIGENCE,
   nwn.FEAT_SKILL_FOCUS_CRAFT_WEAPON,
   nwn.FEAT_EPIC_SKILL_FOCUS_CRAFT_WEAPON)

-- Ride has no focus feats...
nwn.RegisterSkill(
   nwn.SKILL_RIDE,
   "Ride",
   "Ride",
   nwn.ABILITY_DEXTERITY)
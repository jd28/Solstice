Unlike NWScript constants are not global, but attached to the
modules that make the most sense.  For any unfamiliar with Lua these
may seem much more verbose, but modules can be aliased.  And it's very
likely that in any situation that you're using the constants you're
already importing the whole module.

Example:

    local Obj = require 'solstice.object'
	local CREATURE = require('solstice.object').CREATURE
	assert(Obj.CREATURE == CREATURE)

In the conversions below XXXX is the variable part of the constant
name.  In some cases like the ANIMATION\_* constant group these have
been split into modules based on what they can be applied to.

+ Area
  + AMBIENT\_SOUND\_XXXX => solstice.area.AMBIENT\_SOUND\_XXXX
  + AREA\_XXXX => solstice.area.XXXX
  + AREA\_TRANSITION\_XXXX => solstice.area.TRANSITION\_XXXX
  + FOG\_COLOR\_XXXX => solstice.area.FOG\_COLOR\_XXXX
  + FOG\_TYPE\_XXXX => solstice.area.FOG\_TYPE\_XXXX
  + SKYBOX\_XXXX => solstice.area.SKYBOX\_XXXX
  + TILE\_XXXX => solstice.area.TILE\_XXXX
  + TILESET\_XXXX => solstice.area.TILESET\_XXXX
  + WEATHER\_XXXX => solstice.area.WEATHER\_XXXX

+ Area of Effects:
  + AOE_XXXX => solstice.aoe.XXXX

+ Classes:
  + CLASS\_TYPE\_XXXX => solstice.class.XXXX

+ Creatures:
  + ABILITY\_XXXX => solstice.creature.ABILITY\_XXXX
  + ANIMATION\_XXXX => solstice.creature.ANIMATION\_XXXX
  + APPERANCE\_TYPE\_XXXX => solstice.creature.APPEARENCE\_XXXX
  + BODY\_NODE\_XXXX => solstice.creature.BODY\_NODE\_XXXX
  + COLOR\_CHANNEL\_XXXX => solstice.creature.COLOR\_CHANNEL\_XXXX
  + CREATURE\_SIZE\_XXXX => solstice.creature.SIZE\_XXXX
  + FOOTSTEP\_TYPE\_XXXX => solstice.creature.FOOTSTEP\_XXXX
  + GENDER\_XXXX => solstice.creature.GENDER\_XXXX
  + INVENTORY\_SLOT\_XXXX => solstice.creature.INVENTORY\_SLOT\_XXXX
  + NUM\_INVENTORY_\SLOTS => solstice.creature.INVENTORY\_SLOT\_NUM
  + MODEL\_TYPE\_ => solstice.creature.MODEL\_XXXX
  + NAME\_XXXX => solstice.creature.NAME\_XXXX
  + PART\_XXXX => solstice.creature.PART\_XXXX
  + PHENOTYPE\_XXXX => solstice.creature.PHENOTYPE\_XXXX
  + PORTRAIT\_INVALID => solstice.creature.PORTRAIT\_INVALID
  + RACIAL\_TYPE\_XXXX => solstice.creature.RACE\_XXXX
  + TAIL\_TYPE\_XXXX => solstice.creature.TAIL\_XXXX
  + WING\_TYPE\_XXXX => solstice.creature.WINGS\_XXXX

+ Diseases:
  + DISEASE\_XXXX => solstice.disease.XXXX

+ Doors:
  + ANIMATION\_DOOR\_XXXX => solstice.door.ANIMATION\_XXXX
  + DOOR\_ACTION\_XXXX => solstice.door.ACTION\_XXXX

+ Effects:
  + DURATION\_TYPE\_XXXX => solstice.effect.DURATION\_XXXX
  + EFFECT\_TYPE\_XXXX => solstice.effect.XXXX
  + IMMUNITY\_TYPE\_XXXX => solstice.effect.IMMUNITY\_TYPE\_XXXX
  + INVISIBILITY\_TYPE\_XXXX => solstice.effect.INVISIBILITY\_TYPE\_XXXX
  + MISS\_CHANCE\_TYPE\_XXXX => solstice.effect.MISS\_CHANCE\_TYPE\_XXXX
  + SUBTYPE\_XXXX => solstice.effect.SUBTYPE\_XXXX

+ Encounters:
  + ENCOUNTER\_DIFFICULTY\_XXXX => solstice.encounter.DIFFICULTY\_XXXX

+ Events:
  + EVENT\_XXXX => solstice.event.XXXX
  + REST\_EVENTTYPE\_XXXX => solstice.event.REST\_XXXX
  + INVENTORY\_DISTURB\_TYPE\_XXXX => solstice.event.INVENTORY\_ITEM\_XXXX

+ Feats:
  + FEAT\_XXXX => solstice.feat.XXXX
  
+ Items:
  + BASE\_TYPE\_XXXX => solstice.item.BASE\_XXXX
  + ITEM\_APPR\_XXXX => solstice.item.APPR\_XXXX

+ Item Properties:
  + ITEM\_PROPERTY\_XXXX => solstice.itemprop.XXXX
  + IP\_CONST\_XXXX => solstice.itemprop.const.XXXX

+ Location:
  + DIRECTION\_XXXX => solstice.location.DIRECTION\_XXXX

+ Objects:
  + OBJECT_INVALID => solstice.object.INVALID
  + OBJECT_SELF => No longer exists.
  + OBJECT\_TYPE\_XXXX => solstice.object.XXXX

+ Placeables:
  + ANIMATION\_PLACEABLE\_XXXX => solstice.placeable.ANIMATION\_XXXX
  + PLACEABLE\_ACTION\_XXXX => solstice.placeable.ACTION\_XXXX

+ Poisons:
  + POISON\_XXXX => solstice.poison.XXXX

+ Saves:
  + SAVING\_THROW\_XXXX => solstice.save.XXXX
  + SAVING\_THROW\_TYPE\_XXXX => solstice.save.VS\_XXXX

+ Skills:
  + SKILL\_XXXX => solstice.skill.XXXX
  
+ Spells:
  + METAMAGIC\_XXXX => solstice.spell.METAMAGIC\_XXXX
  + SPELL\_XXXX => solstice.spell.XXXX
  + SPELL\_SCHOOL\_XXXX => solstice.spell.SCHOOL\_XXXX
  + SPELLABILITY\_XXXX => solstice.spell.ABILITY\_XXXX

+ Traps:
  + TRAP\_TYPE\_XXXX => solstice.trap.XXXX

--- Bridge functions.

function NSLoadCombatEngine(engine)
   if engine.DoDamageAdjustments then
      NSDoDamageAdjustments = engine.DoDamageAdjustments
   end

   if engine.DoDamageRoll then
      NSDoDamageRoll = engine.DoDamageRoll
   end

   if engine.GetArmorClassVersus then
      NSGetArmorClassVersus = engine.GetArmorClassVersus
   end

   if engine.GetAttackModifierVersus then
      NSGetAttackModifierVersus = engine.GetAttackModifierVersus
   end

   if engine.GetCriticalHitMultiplier then
      NSGetCriticalHitMultiplier = engine.GetCriticalHitMultiplier
   end

   if engine.GetCriticalHitRange then
      NSGetCriticalHitRange = engine.GetCriticalHitRange
   end

   if engine.GetCriticalHitRoll then
      NSGetCriticalHitRoll = engine.GetCriticalHitRoll
   end

   if engine.GetDamageBonus then
      NSGetDamageBonus = engine.GetDamageBonus
   end

   if engine.GetDamageRoll then
      NSGetDamageRoll = engine.GetDamageRoll
   end

   if engine.InitializeNumberOfAttacks then
      NSInitializeNumberOfAttacks = engine.InitializeNumberOfAttacks
   end

   if engine.ResolveAttackRoll then
      NSResolveAttackRoll = engine.ResolveAttackRoll
   end

   if engine.ResolveMeleeAttack then
      NSResolveMeleeAttack = engine.ResolveMeleeAttack
   end

   if engine.ResolveRangedAttack then
      NSResolveRangedAttack = engine.ResolveRangedAttack
   end

   if engine.ResolveDamage then
      NSResolveDamage = engine.ResolveDamage
   end

   if engine.ResolveItemCastSpell then
      NSResolveItemCastSpell = engine.ResolveItemCastSpell
   end

   if engine.ResolveOnHitEffect then
      NSResolveOnHitEffect = engine.ResolveOnHitEffect
   end

   if engine.ResolveOnHitVisuals then
      NSResolveOnHitVisuals = engine.ResolveOnHitVisuals
   end

   if engine.ResolvePostDamage then
      NSResolvePostDamage = engine.ResolvePostDamage
   end
end

function NSDoDamageAdjustments(attacker, target, dmg_result, damage_power, attack_info)
   error "NSDoDamageAdjustments unimplemented."
end

function NSDoDamageRoll(bonus, penalty, mult)
   error "NSDoDamageRoll unimplemented."
end

function NSGetDamageBonus(attacker, target, dmg_roll)
   error "NSGetDamageBonus unimplemented."
end

function NSGetDamageRoll(attacker, target, offhand, crit, sneak, death, ki_damage, attack_info)
   error "NSGetDamageRoll unimplemented."
end

function NSGetCriticalHitMultiplier(attacker, offhand, weap_num)
   error "NSGetCriticalHitMultiplier unimplemented."
end

function NSGetCriticalHitRange(attacker, offhand, weap_num)
   error "NSGetCriticalHitRange unimplemented."
end

function NSGetCriticalHitRoll(attacker, offhand, weap_num)
   error "NSGetCriticalHitRoll unimplemented."
end

function NSInitializeNumberOfAttacks (cre, combat_round)
   error "NSInitializeNumberOfAttacks unimplemented."
end

function NSResolveAttackRoll(attacker, target, from_hook, attack_info)
   error "NSResolveAttackRoll unimplemented."
end

function NSResolveMeleeAttack(attacker, target, attack_count, anim, from_hook)
   error "NSResolveMeleeAttack unimplemented."
end

function NSResolveRangedAttack(attacker, target, attack_count, anim, from_hook)
   error "NSResolveRangedAttack unimplemented."
end

function NSGetArmorClassVersus(target, attacker, touch, from_hook, attack)
   error "NSGetArmorClassVersus unimplemented."
end

function NSGetAttackModifierVersus(attacker, target, attack_info, attack_type)
   error "NSGetAttackModifierVersus unimplemented."
end

function NSGetCriticalHitMultiplier(attacker, offhand, weap_num)
   error "NSGetCriticalHitMultiplier unimplemented."
end

function NSGetCriticalHitRange(attacker, offhand, weap_num)
   error "NSGetCriticalHitRange unimplemented."
end

function NSGetCriticalHitRoll(attacker, offhand, weap_num)
   error "NSGetCriticalHitRoll unimplemented."
end

function NSGetDamageBonus(attacker, target, dmg_roll)
   error "NSGetDamageBonus unimplemented."
end

function NSGetDamageRoll(attacker, target, offhand, crit, sneak, death, ki_damage, attack_info)
   error "NSGetDamageRoll unimplemented."
end

function NSResolveItemCastSpell(attacker, target, attack_info)
   error "NSResolveItemCastSpell unimplemented."
end

function NSResolveOnHitEffect(attacker, target, attack_info, crit)
   error "NSResolveItemCastSpell unimplemented."
end

function NSResolvePostDamage(attacker, target, attack_info, is_ranged)
   error "NSResolvePostDamage unimplemented."
end

function NSResolveOnHitVisuals(attacker, target, attack, dmg_result)
   error "NSResolveOnHitVisuals unimplemented."
end
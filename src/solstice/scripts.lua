local function sol_s_open(self)
   self.signals.OnOpenStore:notify(self)
end
Game.RegisterScript("sol_s_open", sol_s_open)

local function sol_s_close(self)
   self.signals.OnStoreClosed:notify(self)
end
Game.RegisterScript("sol_s_close", sol_s_close)

local function sol_a_enter(self)
  self.signals.OnEnter:notify(self)
end
Game.RegisterScript("sol_a_enter", sol_a_enter)

local function sol_a_exit(self)
  self.signals.OnExit:notify(self)
end
Game.RegisterScript("sol_a_exit", sol_a_exit)

local function sol_a_hb(self)
  self.signals.OnHeartbeat:notify(self)
end
Game.RegisterScript("sol_a_hb", sol_a_hb)

local function sol_a_ud(self)
  self.signals.OnUserDefined:notify(self)
end
Game.RegisterScript("sol_a_ud", sol_a_ud)

local function sol_c_conv(self)
  self.signals.OnConversation:notify(self)
end
Game.RegisterScript("sol_c_conv", sol_c_conv)

local function sol_c_blocked(self)
  self.signals.OnBlocked:notify(self)
end
Game.RegisterScript("sol_c_blocked", sol_c_blocked)

local function sol_c_disturb(self)
  self.signals.OnDisturbed:notify(self)
end
Game.RegisterScript("sol_c_disturb", sol_c_disturb)

local function sol_c_perceive(self)
  self.signals.OnPerception:notify(self)
end
Game.RegisterScript("sol_c_perceive", sol_c_perceive)

local function sol_c_cast(self)
  self.signals.OnSpellCastAt:notify(self)
end
Game.RegisterScript("sol_c_cast", sol_c_cast)

local function sol_c_cr_end(self)
  self.signals.OnCombatRoundEnd:notify(self)
end
Game.RegisterScript("sol_c_cr_end", sol_c_cr_end)

local function sol_c_damaged(self)
  self.signals.OnDamaged:notify(self)
end
Game.RegisterScript("sol_c_damaged", sol_c_damaged)

local function sol_c_attacked(self)
  self.signals.OnPhysicalAttacked:notify(self)
end
Game.RegisterScript("sol_c_attacked", sol_c_attacked)

local function sol_c_death(self)
  self.signals.OnDeath:notify(self)
end
Game.RegisterScript("sol_c_death", sol_c_death)

local function sol_c_hb(self)
  self.signals.OnHeartbeat:notify(self)
end
Game.RegisterScript("sol_c_hb", sol_c_hb)

local function sol_c_rest(self)
  self.signals.OnRested:notify(self)
end
Game.RegisterScript("sol_c_rest", sol_c_rest)

local function sol_c_spawn(self)
  self.signals.OnSpawn:notify(self)
end
Game.RegisterScript("sol_c_spawn", sol_c_spawn)

local function sol_c_ud(self)
  self.signals.OnUserDefined:notify(self)
end
Game.RegisterScript("sol_c_ud", sol_c_ud)

local function sol_m_acquire(self)
  self.signals.OnAcquireItem:notify(self)
end
Game.RegisterScript("sol_m_acquire", sol_m_acquire)

local function sol_m_unacquire(self)
  self.signals.OnUnAcquireItem:notify(self)
end
Game.RegisterScript("sol_m_unacquire", sol_m_unacquire)

local function sol_m_enter(self)
  self.signals.OnClientEnter:notify(self)
end
Game.RegisterScript("sol_m_enter", sol_m_enter)

local function sol_m_exit(self)
  self.signals.OnClientLeave:notify(self)
end
Game.RegisterScript("sol_m_exit", sol_m_exit)

local function sol_m_pc_death(self)
  self.signals.OnPlayerDeath:notify(self)
end
Game.RegisterScript("sol_m_pc_death", sol_m_pc_death)

local function sol_m_pc_dying(self)
  self.signals.OnPlayerDying:notify(self)
end
Game.RegisterScript("sol_m_pc_dying", sol_m_pc_dying)

local function sol_m_equip(self)
  self.signals.OnPlayerEquipItem:notify(self)
end
Game.RegisterScript("sol_m_equip", sol_m_equip)

local function sol_m_unequip(self)
  self.signals.OnPlayerUnEquipItem:notify(self)
end
Game.RegisterScript("sol_m_unequip", sol_m_unequip)

local function sol_m_levelup(self)
  self.signals.OnPlayerLevelUp:notify(self)
end
Game.RegisterScript("sol_m_levelup", sol_m_levelup)

local function sol_m_respawn(self)
  self.signals.OnPlayerRespawn:notify(self)
end
Game.RegisterScript("sol_m_respawn", sol_m_respawn)

local function sol_m_rest(self)
  self.signals.OnPlayerRest:notify(self)
end
Game.RegisterScript("sol_m_rest", sol_m_rest)

local function sol_m_activate(self)
  self.signals.OnActivateItem:notify(self)
end
Game.RegisterScript("sol_m_activate", sol_m_activate)

local function sol_m_hb(self)
  self.signals.OnHeartbeat:notify(self)
end
Game.RegisterScript("sol_m_hb", sol_m_hb)

local function sol_m_load(self)
  self.signals.OnModuleLoad:notify(self)
end
Game.RegisterScript("sol_m_load", sol_m_load)

local function sol_m_ud(self)
  self.signals.OnUserDefined:notify(self)
end
Game.RegisterScript("sol_m_ud", sol_m_ud)

local function sol_m_cs_abort(self)
  self.signals.OnCutsceneAbort:notify(self)
end
Game.RegisterScript("sol_m_cs_abort", sol_m_cs_abort)

local function sol_p_close(self)
  self.signals.OnClose:notify(self)
end
Game.RegisterScript("sol_p_close", sol_p_close)

local function sol_p_open(self)
  self.signals.OnOpen:notify(self)
end
Game.RegisterScript("sol_p_open", sol_p_open)

local function sol_p_disturb(self)
  self.signals.OnDisturbed:notify(self)
end
Game.RegisterScript("sol_p_disturb", sol_p_disturb)

local function sol_p_attacked(self)
  self.signals.OnPhysicalAttacked:notify(self)
end
Game.RegisterScript("sol_p_attacked", sol_p_attacked)

local function sol_p_sp_cast(self)
  self.signals.OnSpellCastAt:notify(self)
end
Game.RegisterScript("sol_p_sp_cast", sol_p_sp_cast)

local function sol_p_used(self)
  self.signals.OnUsed:notify(self)
end
Game.RegisterScript("sol_p_used", sol_p_used)

local function sol_p_damaged(self)
  self.signals.OnDamaged:notify(self)
end
Game.RegisterScript("sol_p_damaged", sol_p_damaged)

local function sol_p_death(self)
  self.signals.OnDeath:notify(self)
end
Game.RegisterScript("sol_p_death", sol_p_death)

local function sol_p_hb(self)
  self.signals.OnHeartbeat:notify(self)
end
Game.RegisterScript("sol_p_hb", sol_p_hb)

local function sol_p_ud(self)
  self.signals.OnUserDefined:notify(self)
end
Game.RegisterScript("sol_p_ud", sol_p_ud)

local function sol_p_(self)
  self.signals.OnLock:notify(self)
end
Game.RegisterScript("sol_p_", sol_p_)

local function sol_p_unlock(self)
  self.signals.OnUnlock:notify(self)
end
Game.RegisterScript("sol_p_unlock", sol_p_unlock)

local function sol_p_fail_open(self)
  self.signals.OnFailToOpen:notify(self)
end
Game.RegisterScript("sol_p_fail_open", sol_p_fail_open)

local function sol_p_disarm(self)
  self.signals.OnDisarm:notify(self)
end
Game.RegisterScript("sol_p_disarm", sol_p_disarm)

local function sol_p_trap_trig(self)
  self.signals.OnTrapTriggered:notify(self)
end
Game.RegisterScript("sol_p_trap_trig", sol_p_trap_trig)

local function sol_d_trans(self)
  self.signals.OnAreaTransitionClick:notify(self)
end
Game.RegisterScript("sol_d_trans", sol_d_trans)

local function sol_d_close(self)
  self.signals.OnClose:notify(self)
end
Game.RegisterScript("sol_d_close", sol_d_close)

local function sol_d_open(self)
  self.signals.OnOpen:notify(self)
end
Game.RegisterScript("sol_d_open", sol_d_open)

local function sol_d_damaged(self)
  self.signals.OnDamaged:notify(self)
end
Game.RegisterScript("sol_d_damaged", sol_d_damaged)

local function sol_d_death(self)
  self.signals.OnDeath:notify(self)
end
Game.RegisterScript("sol_d_death", sol_d_death)

local function sol_d_hb(self)
  self.signals.OnHeartbeat:notify(self)
end
Game.RegisterScript("sol_d_hb", sol_d_hb)

local function sol_d_attacked(self)
  self.signals.OnPhysicalAttacked:notify(self)
end
Game.RegisterScript("sol_d_attacked", sol_d_attacked)

local function sol_d_sp_cast(self)
  self.signals.OnSpellCastAt:notify(self)
end
Game.RegisterScript("sol_d_sp_cast", sol_d_sp_cast)

local function sol_d_ud(self)
  self.signals.OnUserDefined:notify(self)
end
Game.RegisterScript("sol_d_ud", sol_d_ud)

local function sol_d_fail(self)
  self.signals.OnFailToOpen:notify(self)
end
Game.RegisterScript("sol_d_fail", sol_d_fail)

local function sol_d_lock(self)
  self.signals.OnLock:notify(self)
end
Game.RegisterScript("sol_d_lock", sol_d_lock)

local function sol_d_unlock(self)
  self.signals.OnUnlock:notify(self)
end
Game.RegisterScript("sol_d_unlock", sol_d_unlock)

local function sol_d_disarm(self)
  self.signals.OnDisarm:notify(self)
end
Game.RegisterScript("sol_d_disarm", sol_d_disarm)

local function sol_d_trap(self)
  self.signals.OnTrapTriggered:notify(self)
end
Game.RegisterScript("sol_d_trap", sol_d_trap)

local function sol_t_click(self)
  self.signals.OnClick:notify(self)
end
Game.RegisterScript("sol_t_click", sol_t_click)

local function sol_t_enter(self)
  self.signals.OnEnter:notify(self)
end
Game.RegisterScript("sol_t_enter", sol_t_enter)

local function sol_t_exit(self)
  self.signals.OnExit:notify(self)
end
Game.RegisterScript("sol_t_exit", sol_t_exit)

local function sol_t_hb(self)
  self.signals.OnHeartbeat:notify(self)
end
Game.RegisterScript("sol_t_hb", sol_t_hb)

local function sol_t_ud(self)
  self.signals.OnUserDefined:notify(self)
end
Game.RegisterScript("sol_t_ud", sol_t_ud)

local function sol_e_enter(self)
  self.signals.OnEnter:notify(self)
end
Game.RegisterScript("sol_e_enter", sol_e_enter)

local function sol_e_exit(self)
  self.signals.OnExit:notify(self)
end
Game.RegisterScript("sol_e_exit", sol_e_exit)

local function sol_e_exhausted(self)
  self.signals.OnExhausted:notify(self)
end
Game.RegisterScript("sol_e_exhausted", sol_e_exhausted)

local function sol_e_hb(self)
  self.signals.OnHeartbeat:notify(self)
end
Game.RegisterScript("sol_e_hb", sol_e_hb)

local function sol_e_ud(self)
  self.signals.OnUserDefined:notify(self)
end
Game.RegisterScript("sol_e_ud", sol_e_ud)

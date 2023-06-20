/obj/effect/proc_holder/spell/targeted/area_teleport
	name = "Area teleport"
	desc = "This spell teleports you to a type of area of your selection."
	nonabstract_req = TRUE
	school = SCHOOL_TRANSLOCATION

	var/randomise_selection = FALSE //if it lets the usr choose the teleport loc or picks it from the list
	var/invocation_area = TRUE //if the invocation appends the selected area
	var/sound1 = 'sound/weapons/zapbang.ogg'
	var/sound2 = 'sound/weapons/zapbang.ogg'

	var/say_destination = TRUE

/obj/effect/proc_holder/spell/targeted/area_teleport/perform(list/targets, recharge = 1,mob/living/user = usr)
	var/thearea = before_cast(targets)
	if(!thearea || !cast_check(1))
		revert_cast()
		return
	invocation(thearea,user)
	if(charge_type == "recharge" && recharge)
		INVOKE_ASYNC(src, .proc/start_recharge)
	cast(targets,thearea,user)
	after_cast(targets)

/obj/effect/proc_holder/spell/targeted/area_teleport/before_cast(list/targets)
	var/target_area = null

	if(!randomise_selection)
		target_area = tgui_input_list(usr, "Area to teleport to", "Teleport", GLOB.teleportlocs)
	else
		target_area = pick(GLOB.teleportlocs)
	if(isnull(target_area))
		return
	if(isnull(GLOB.teleportlocs[target_area]))
		return
	var/area/thearea = GLOB.teleportlocs[target_area]

	return thearea

/obj/effect/proc_holder/spell/targeted/area_teleport/cast(list/targets,area/thearea,mob/user = usr)
	playsound(get_turf(user), sound1, 50,TRUE)
	for(var/mob/living/target in targets)
		var/list/L = list()
		for(var/turf/T in get_area_turfs(thearea.type))
			if(!T.density)
				var/clear = TRUE
				for(var/obj/O in T)
					if(O.density)
						clear = FALSE
						break
				if(clear)
					L+=T

		if(!length(L))
			to_chat(usr, span_warning("The spell matrix was unable to locate a suitable teleport destination for an unknown reason. Sorry."))
			return

		if(target?.buckled)
			target.buckled.unbuckle_mob(target, force=1)

		var/list/tempL = L
		var/attempt = null
		var/success = FALSE
		while(length(tempL))
			attempt = pick(tempL)
			do_teleport(target, attempt, channel = TELEPORT_CHANNEL_MAGIC)
			if(get_turf(target) == attempt)
				success = TRUE
				break
			else
				tempL.Remove(attempt)

		if(!success)
			do_teleport(target, L, channel = TELEPORT_CHANNEL_MAGIC)
			playsound(get_turf(user), sound2, 50,TRUE)

/obj/effect/proc_holder/spell/targeted/area_teleport/invocation(area/chosenarea = null,mob/living/user = usr)
	if(!invocation_area || !chosenarea)
		..()
	else
		var/words
		if(say_destination)
			words = "[invocation] [uppertext(chosenarea.name)]"
		else
			words = "[invocation]"

		switch(invocation_type)
			if(INVOCATION_SHOUT)
				user.say(words, forced = "spell")
				playsound(user.loc, pick('sound/misc/null.ogg','sound/misc/null.ogg'), 100, TRUE)
			if(INVOCATION_WHISPER)
				user.whisper(words, forced = "spell")

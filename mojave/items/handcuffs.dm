/obj/item/restraints/handcuffs/ms13/rope
	name = "rope"
	desc = "A length of rope. Im sure you can find some use for it."
	icon_state = "rope"
	icon = 'mojave/icons/objects/crafting/materials_world.dmi'
	worn_icon_state = "rope"
	worn_icon = 'icons/mob/clothing/hands.dmi'
	inhand_icon_state = "rope"
	lefthand_file = 'icons/mob/inhands/equipment/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/items_righthand.dmi'
	grid_width = 64
	grid_height = 64
	w_class = WEIGHT_CLASS_NORMAL
	cuffsound = 'mojave/sound/ms13effects/hogtie.ogg'
	cuff_time = 10 SECONDS

/obj/item/stack/sheet/ms13/Initialize()
	. = ..()
	AddElement(/datum/element/world_icon, null, icon, 'mojave/icons/objects/crafting/materials_inventory.dmi')
	update_icon_state()

/obj/item/restraints/legcuffs/bola/ms13
	name = "bola"
	desc = "A restraining device designed to be thrown at the target. Upon connecting with said target, it will wrap around their legs, making it difficult for them to move quickly."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "bola"
	lefthand_file = null
	righthand_file = null
	breakouttime = 35//easy to apply, easy to break out of
	gender = NEUTER
	slot_flags = ITEM_SLOT_BELT

/obj/item/restraints/handcuffs/ms13
	grid_height = 32
	grid_width = 64

/obj/item/restraints/handcuffs/ms13/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/item_scaling, 0.45, 1)

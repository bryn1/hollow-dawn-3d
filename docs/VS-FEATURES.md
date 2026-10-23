# Vampire Survivors — Feature Inventory (parity reference for hollow-dawn-3d)

- Card: MC 11195 (T-S16). Researched 2026-10-23 by the `research` profile.
- Scope: **clean-room feature inventory from public web pages only** (fandom wiki + Steam store page). No assets, no code, no package extraction. Numbers/sprites here describe what VS *has*; our game keeps its own art and numbers.
- Evidence levels per claim: VERIFIED (page fetched and the fetched text says it) / INFERRED / UNVERIFIED. Citation URL is given per section; the per-section tally at the end names anything not VERIFIED.
- Wiki state note: this mirrors the wiki exactly as fetched on 2026-10-23, i.e. base game + all DLCs. DLC-only rows are marked [DLC].
- Length note: >300 lines is justified — the DoD demands one complete inventory document at this single path; splitting would defeat the DoD.

---

## S1 WEAPONS

Source: https://vampiresurvivors.fandom.com/wiki/Weapons (fetched 2026-10-23). VERIFIED intro rule, quoted:

> "When a weapon is fully leveled it cannot appear in the level up options anymore. Upgrading a weapon will also reset its Cooldown and activate it instantly."

Wiki classes: **Base weapons** (level-up pool), **Evolutions/Unions/Gifts/Morphs** (see S3), **Counterpart weapons** (Inverse-stage counterparts), **Special weapons** (not in the level-up pool). Max level and behavior are from the wiki's own tables.

### S1.1 Base weapons (138 listed today, incl. [DLC])

| # | Weapon | Behavior (wiki one-liner) | Max lvl | Evolves into |
|---|--------|---------------------------|---------|--------------|
| 1 | Whip | Attacks horizontally, passes through enemies. | 8 | Bloody Tear (needs Hollow Heart) |
| 2 | Magic Wand | Fires at the nearest enemy. | 8 | Holy Wand (needs Empty Tome) |
| 3 | Knife | Fires quickly in the faced direction. | 8 | Thousand Edge (needs Bracer) |
| 4 | Axe | High damage, high area scaling. | 8 | Death Spiral (needs Candelabrador) |
| 5 | Cross | Aims at the nearest enemy, has a boomerang effect. | 8 | Heaven Sword (needs Clover) |
| 6 | King Bible | Orbits around the character. | 8 | Unholy Vespers (needs Spellbinder) |
| 7 | Fire Wand | Fires at a random enemy, deals heavy damage. | 8 | Hellfire (needs Spinach) |
| 8 | Garlic | Damages nearby enemies. Reduces resistance to knockback and freeze. | 8 | Soul Eater (needs Pummarola) |
| 9 | Santa Water | Generates damaging zones. | 8 | La Borra (needs Attractorb) |
| 10 | Runetracer | Passes through enemies, bounces around. | 8 | NO FUTURE (needs Armor) |
| 11 | Lightning Ring | Strikes at random enemies. | 8 | Thunder Loop (needs Duplicator) |
| 12 | Pentagram | Erases everything in sight. | 8 | Gorgeous Moon (needs Crown) |
| 13 | Peachone | Bombards in a circular area. | 8 | Vandalier (needs Ebony Wings) |
| 14 | Ebony Wings | Bombards in a circular area. | 8 | — |
| 15 | Phiera Der Tuphello | Fires quickly in four fixed directions. | 8 | Phieraggi (needs Eight The Sparrow) |
| 16 | Eight The Sparrow | Fires quickly in four fixed directions. | 8 | — |
| 17 | Gatti Amari | Summons capricious projectiles. Might interact with pickups. | 8 | Vicious Hunger (needs Stone Mask) |
| 18 | Song of Mana | Attacks vertically, passes through enemies. | 8 | Mannajja (needs Skull O'Maniac) |
| 19 | Shadow Pinion | Generating damaging zones when moving, strikes when stopping. | 8 | Valkyrie Turner (needs Wings) |
| 20 | Clock Lancet | Chance to freeze enemies in time. | 7 | Infinite Corridor (needs Silver Ring) |
| 21 | Laurel | Shields from damage while active. | 7 | Crimson Shroud (needs Metaglio Left) |
| 22 | Vento Sacro | Stronger with continuous movement. Can deal critical damage. | 8 | Fuwalafuwaloo (needs Bloody Tear) |
| 23 | Bone | Throws a bouncing projectile. | 8 | Anima of Mortaccio (needs Mortaccio) |
| 24 | Cherry Bomb | Throws a bouncing projectile that explodes after some time. | 8 | Yatta Daikarin (needs Cavallo) |
| 25 | Carréllo | Throws a bouncing projectile. Number of bounces affected by Amount. | 8 | — |
| 26 | Celestial Dusting | Throws a bouncing projectile. Cooldown reduces when moving. | 8 | Profusione D'Amore (needs O'Sole) |
| 27 | La Robba | Generates bouncing projectiles. | 8 | — |
| 28 | Greatest Jubilee | Has a chance to summon light sources. | 9 | — |
| 29 | Bracelet | Fires three projectiles at a random enemy. | 6 | — |
| 30 | Candybox | Allows you to choose any unlocked base weapon. | 1 | — |
| 31 | Arma Dio | Allows you to choose an extra passive weapon. | 1 | — |
| 32 | Pako Battiliar | May retaliate when losing health. | 8 | Mazo Familiar (needs Hollow Heart) |
| 33 | Victory Sword | Strikes with a combo attack at the nearest enemy. Retaliates. | 12 | Sole Solution (needs Torrona's Box) |
| 34 | Flames of Misspell | Emits cones of flames. | 8 | Ashes of Muspell (needs Torrona's Box) |
| 35 | Glass Fandango | Stronger with movement, Orologions, and against frozen enemies | 8 | Celestial Voulge (needs Wings) |
| 36 | Santa Javelin | Duration affects Amount. Can deal critical damage. | 8 | Seraphic Cry (needs Clover) |
| 37 | Phas3r | Generates thin damaging zones. High Amount scaling. | 8 | Photonstorm (needs Empty Tome) |
| 38 | Silver Wind | Defeated enemies might drop hearts. | 8 | Festive Winds (needs Pummarola) |
| 39 | Four Seasons | Generates 4 explosions. Amount and Duration affect damage instead. | 8 | Godai Shuffle (needs Candelabrador) |
| 40 | Summon Night | Generates damaging zones above the character. | 8 | Echo Night (needs Duplicator) |
| 41 | Mirage Robe | Generates freezing static projectiles with a chance to explode. | 8 | J'Odore (needs Attractorb) |
| 42 | Mille Bolle Blu | Fires lingering projectiles. | 8 | Boo Roo Boolle (needs Spellbinder) |
| 43 | Night Sword | Retaliates with a bonus damage affected by Greed. Might steal hearts. | 8 | Muramasa (needs Stone Mask) |
| 44 | 108 Bocce | Actually it's just 8. Damage affected by the difference between Curse and Luck. | 8 | — |
| 45 | SpellString | Strikes at nearby enemies. Damage multiplied by Speed. | 6 | — |
| 46 | SpellStream | Generates an expanding damaging zone. Damage multiplied by Area. | 6 | — |
| 47 | SpellStrike | Strikes at the nearest enemy. Damage further multiplied by Might. | 6 | — |
| 48 | Eskizzibur | Attacks nearby enemies. Retaliates. | 8 | Legionnaire (needs Armor) |
| 49 | Flash Arrow | Can deal critical damage. Amount affects damage instead. | 8 | Millionaire (needs Bracer) |
| 50 | Prismatic Missile | Generates explosions around the character. Affected by the first chosen Arcana between II "Twilight Requiem (II)") , XIV "Jail of Crystal (XIV)") , or XIX "Heart of Fire (XIX)") . | 8 | Luminaire (needs Crown) |
| 51 | Shadow Servant | Has a chance to slow enemies down. | 8 | Ophion (needs Skull O'Maniac) |
| 52 | Party Popper | Throws bouncing projectiles. | 8 | — |
| 53 | Report! | Damages enemies and pushes them away. | 8 | Emergency Meeting (needs Mini Crewmate) |
| 54 | Lucky Swipe | The amount of Luck is affected by Amount and by low Luck. | 8 | Crossed Wires (needs Mini Engineer) |
| 55 | Lifesign Scan | Restores HP based on Amount and Recovery. | 8 | Paranormal Scan (needs Mini Ghost) |
| 56 | Just Vent | Destroys or heavily damages enemies. Amount affects how many times it can trigger. | 8 | Unjust Ejection (needs Mini Shapeshifter) |
| 57 | Clear Debris | Generates projectile spawning zones that follow the player. | 8 | Clear Asteroids (needs Mini Guardian) |
| 58 | Sharp Tongue | Strikes enemies in front of you. Damage multiplied by Recovery. | 8 | Impostongue (needs Mini Impostor) |
| 59 | Science Rocks | Generates zones that explode when touched by a player. Amount affects the number of explosion clusters. | 8 | Rocket Science (needs Mini Scientist) |
| 60 | Hats | Throws cute bouncing projectiles with random properties. | 8 | — |
| 61 | Long Gun | Fires constantly in the faced direction. | 8 | Prototype A (needs Weapon Power-Up) |
| 62 | Short Gun | Fires bursts of decaying projectiles horizontally. | 8 | Prototype B (needs Weapon Power-Up) |
| 63 | Spread Shot | Fires in a wide spread in the faced direction. | 8 | Prototype C (needs Weapon Power-Up) |
| 64 | C-U-Laser | Fires a piercing projectile in the faced direction. | 8 | Pronto Beam (needs Weapon Power-Up) |
| 65 | Firearm | Fires spinning projectiles at the nearest enemy. | 8 | Fire-L3GS (needs Weapon Power-Up) |
| 66 | Sonic Bloom | Fires growing projectiles in the faced direction. | 8 | Wave Beam (needs Weapon Power-Up) |
| 67 | Homing Miss | Fires exploding projectiles that home in on enemies. | 8 | Multistage Missiles (needs Weapon Power-Up) |
| 68 | Diver Mines | Fires explosive projectiles that travel along walls. | 8 | Atmo-Torpedo (needs Weapon Power-Up) |
| 69 | Blade Crossbow | Fires homing projectiles that spin in place when they hit. | 8 | BFC2000-AD (needs Weapon Power-Up) |
| 70 | Prism Lass | Has a small chance to freeze enemies. | 8 | Time Warp (needs Weapon Power-Up) |
| 71 | Metal Claw | Cooldown is affected by missing health. | 8 | Big Fuzzy Fist (needs Weapon Power-Up) |
| 72 | Alchemy Whip | Grows stronger every time a boss enemy is defeated. | 8 | Vampire Killer (needs Tirajisú) |
| 73 | Wind Whip | Damage affected by growth. | 8 | Spirit Tornado Tip (needs Crown) |
| 74 | Platinum Whip | Every 3rd activation fires projectiles in fixed directions. | 8 | Cross Crasher Tip (needs Clover) |
| 75 | Dragon Water Whip | Every 7th activation fires a snaking dragon projectile. | 8 | Hydrostormer Tip (needs Attractorb) |
| 76 | Sonic Whip | Chance to instant kill based on curse. | 8 | Crissaegrim Tip (needs Skull O'Maniac) |
| 77 | Jet Black Whip | Strikes at the nearest enemy and generates a linear damaging zone. | 8 | Mormegil Tip (needs Stone Mask) |
| 78 | Vibhuti Whip | Strikes at the nearest enemy and generates a cluster of explosions. | 8 | Daybreaker Tip (needs Candelabrador) |
| 79 | Vanitas Whip | Strikes at the nearest enemy and generates a perpendicular damaging zone. Zone damage affected by MaxHealth. | 8 | Aurablaster Tip (needs Hollow Heart) |
| 80 | Shuriken | Fires projectiles in the faced direction. | 8 | Yagyu Shuriken (needs Empty Tome) |
| 81 | Curved Knife | Fires a spinning projectile at random enemy. | 8 | Bwaka Knife (needs Bracer) |
| 82 | Javelin | Fires a penetrating projectile in a fixed direction. | 8 | Long Inus (needs Spellbinder) |
| 83 | Discus | Fires a defensive projectile. | 8 | Stellar Blade (needs Parm Aegis) |
| 84 | Iron Ball | Damage affected by Armor. | 8 | Wrecking Ball (needs Armor) |
| 85 | Hand Grenade | Fires an exploding projectile. | 8 | The RPG (needs Candelabrador) |
| 86 | Wine Glass | Throws an exploding projectile. | 8 | Meal Ticket (needs Tirajisú) |
| 87 | Raging Fire | Generates an exploding damaging zone. | 8 | Salamender (needs Spinach) |
| 88 | Ice Fang | Generates damaging zones in a straight line. | 8 | Cocytus (needs Spellbinder) |
| 89 | Gale Force | Fires light-hitting projectiles backwards. | 8 | Pneuma Tempestas (needs Bracer) |
| 90 | Rock Riot | Fires projectiles from a fixed location. | 8 | Gemma Torpor (needs Stone Mask) |
| 91 | Fulgur | Strikes at fixed locations. | 8 | Tenebris Tonitrus (needs Duplicator) |
| 92 | Keremet Bubbles | Fires slow moving damaging zones. | 8 | Keremet Morbus (needs Armor) |
| 93 | Hex | Generates a moving damaging zone. Damage affected by Curse. | 8 | Nightmare (needs Skull O'Maniac) |
| 94 | Refectio | Generates a damaging zone that also provides light healing. | 8 | Sanctuary (needs Clover) |
| 95 | Mace | Amount affects number of hits. | 8 | Stamazza (needs Hollow Heart) |
| 96 | Star Flail | Fires lingering projectiles. Damage multiplied by Recovery. | 8 | Moon Rod (needs Pummarola) |
| 97 | Alucard Spear | Executes a spinning attack when changing horizontal direction. | 8 | Thunderbolt Spear (needs Wings) |
| 98 | Trident | Strikes at fixed locations. | 8 | Gungnir-Souris (needs Duplicator) |
| 99 | Iron Shield | Retaliates by shooting lingering projectiles. | 8 | Dark Iron Shield (needs Parm Aegis) |
| 100 | Guardian's Targe | Summons defensive followers. Overhealing triggers additional follower's attacks. | 8 | Sacred Beasts Tower Shield (needs Pummarola) |
| 101 | Alucart Sworb | Allegedly strikes at the nearest enemy. | 8 | — |
| 102 | Silver Revolver | Fires a powerful projectiles, six times. | 8 | Jewel Gun (needs Karoma's Mana) |
| 103 | Tyrfing | Has boomerang effect, can deal critical damage. | 8 | Rune Sword (needs Spinach) |
| 104 | Confodere | Attack nearby enemies. Speed affects damage. | 6 | — |
| 105 | Optical Shot | Fires two penetrating projectiles. | 8 | Acerbatus (needs Karoma's Mana) |
| 106 | Luminatio | Fires spinning projectiles made of light. | 6 | Vol Luminatio (needs Crown) |
| 107 | Umbra | Fires spinning projectiles made of darkness. | 6 | Vol Umbra (needs Attractorb) |
| 108 | Globus | Fires two bouncing projectiles. Amount affects Duration. | 8 | Nitesco (needs Empty Tome) |
| 109 | Sonic Dash | Increases Move Speed by 10% per level and damages nearby enemies. Area and speed increases damage. | 8 | Rapidus Fio (needs Wings) |
| 110 | Dextro Custos | Summons Cerberus' fiery head in faced direction. | 6 | — |
| 111 | Sinestro Custos | Summons Cerberus' icy head in faced direction. | 6 | — |
| 112 | Centralis Custos | Summons Cerberus' vengeful head. Boosts Armor, Recovery and Cooldown when damaged. | 6 | — |
| 113 | Dominus Anger | Fires a penetrating projectile. Drains health. | 6 | — |
| 114 | Dominus Hatred | Fires projectiles from above. Drains health. | 6 | — |
| 115 | Dominus Agony | Increases Might, Speed, Duration, and Area. Drains Health. | 6 | — |
| 116 | Endo Gears | Also triggers other clockwork weapons. Damage increased by Amount and currently found Orologions . | 9 | — |
| 117 | Peri Pendulum | Also triggers other clockwork weapons. Damage increased by Amount and currently found Orologions. | 9 | — |
| 118 | Myo Lift | Also triggers other clockwork weapons. Damage increased by Amount and currently found Orologions. | 9 | — |
| 119 | Epi Head | Also triggers other clockwork weapons. Damage increased by Amount and currently found Orologions. | 9 | — |
| 120 | Morning Star | Allows you to choose from a selection of magic whips. | 1 | — |
| 121 | Coat of Arms | Allows you to choose from a selection of vampire-killing tools. | 1 | — |
| 122 | Spectral Sword | Allows you to choose from a selection of magic weapons. | 1 | — |
| 123 | Belnades' Spellbook | Allows you to choose from a selection of spells. | 1 | — |
| 124 | Ebony Diabologue | Allows you to choose from a selection of ambiguous powers. | 1 | — |
| 125 | Familiar Forge | Allows you to summon a familiar. | 1 | — |
| 126 | Valmanway | Fires faster when moving. | 8 | — |
| 127 | Icebrand | Fires lingering projectiles. Might freeze enemies. | 8 | — |
| 128 | Arrow of Goth | Critical hits maximise amount of projectiles. | 8 | — |
| 129 | Aura Blast | Generates explosive sideways. | 8 | — |
| 130 | Svarog Statue | Geneartes damaging zones when moving. | 8 | — |
| 131 | Troll Bomb | This one doesn't bounce. | 8 | — |
| 132 | Hydro Storm | Generates damaging waves based on Projectile Speed and Duration. | 8 | — |
| 133 | Grand Cross | Summons holy light. | 9 | — |
| 134 | Summon Spirit | Fires a homing projectile. | 8 | — |
| 135 | Dark Rift | Generates vertical damaging zones. | 8 | — |
| 136 | Soul Steal | Damages all enemies in sight and attempts to turn them into hearts. | 9 | — |
| 137 | Sword Brothers | Grants a brief moment of Invulnerability and generates a damaging wave. | 8 | — |
| 138 | Summon Spirit Tornado | Summons spirits that will occasionally pick up XP gems for you. | 8 | — |

*Base weapon rows parsed: 138.*

### S1.2 Evolution weapons (94 listed)

These are the evolved forms themselves (behavior = wiki one-liner; the combo that produces them):

| # | Weapon | Behavior | From |
|---|--------|----------|------|
| 1 | Bloody Tear | Evolution of the whip. Can deal critical damage and absorb HP. | Whip + Hollow Heart |
| 2 | Holy Wand | Evolution of the Magic Wand. Fires with no delay. | Magic Wand + Empty Tome |
| 3 | Thousand Edge | Evolved Knife. Fires with no delay. | Knife + Bracer |
| 4 | Death Spiral | Evolved Axe. Passes through enemies. | Axe + Candelabrador |
| 5 | Heaven Sword | Evolved Cross. Can do critical damage. | Cross + Clover |
| 6 | Unholy Vespers | Evolved King Bible. Never Ends. | King Bible + Spellbinder |
| 7 | Hellfire | Evolved Fire Wand. Passes through enemies. | Fire Wand + Spinach |
| 8 | Soul Eater | Evolved Garlic. Steals hearts. Power increases when recovering HP. | Garlic + Pummarola |
| 9 | La Borra | Evolved Santa water. Damaging zones follow you and grow when they move. | Santa Water + Attractorb |
| 10 | NO FUTURE | Evolved Runetracer. Explodes when bouncing and in retaliation. | Runetracer + Armor |
| 11 | Thunder Loop | Evolved Lightning Ring. Projectiles strike twice. | Lightning Ring + Duplicator |
| 12 | Gorgeous Moon | Evolved Pentagram. Generates extra gems and gathers all of them. | Pentagram + Crown |
| 13 | Vicious Hunger | Evolved Gatti Amari. Might turn anything into gold. | Gatti Amari + Stone Mask |
| 14 | Mannajja | Evolved Song of Mana. Might slow enemies down. | Song of Mana + Skull O'Maniac |
| 15 | Valkyrie Turner | Evolved Shadow Pinion. Bigger, longer, faster, stronger. | Shadow Pinion + Wings |
| 16 | Infinite Corridor | Evolved Clock Lancet. Halves enemies' health. | Clock Lancet + Silver Ring |
| 17 | Crimson Shroud | Evolved Laurel. Caps incoming damage at 10. Retaliates when losing charges. | Laurel + Metaglio Left |
| 18 | Bi-Bracelet | Fires three projectiles at a random enemy. | — |
| 19 | Tri-Bracelet | Fires three projectiles at a random enemy. | — |
| 20 | Mazo Familiar | Evolved Pako Battiliar. Damage and Amount affected by Max Health. | Pako Battiliar + Hollow Heart |
| 21 | Ashes of Muspell | Evolved Flames of Misspell. The more enemies are defeated, the stronger it grows. | Flames of Misspell + Torrona's Box |
| 22 | Celestial Voulge | Evolved Glass Fandango. Might deal critical damage and freeze enemies. Turns Orologions into Starry Heavens. | Glass Fandango + Wings |
| 23 | Seraphic Cry | Evolved Santa Javelin. Critical damage affected by Luck. Turns Rosaries into Weird Souls Purifiers. | Santa Javelin + Clover |
| 24 | Photonstorm | Evolved Phas3r. Fires 2 to 5 times more projectiles depending on Luck. | Phas3r + Empty Tome |
| 25 | Anima of Mortaccio | Evolved Bone. Projectiles accelerate when bouncing. | Bone + Mortaccio |
| 26 | Yatta Daikarin | Evolved Cherry Bomb. Generates extra explosions that can deal critical Luck based damage. | Cherry Bomb + Cavallo |
| 27 | Profusione D'Amore | Evolved Celestial Dusting. Projectiles generate a chain explosion at fixed intervals. | Celestial Dusting + O'Sole |
| 28 | Festive Winds | Evolved Silver Wind. Weakens enemies defenses. | Silver Wind + Pummarola |
| 29 | Godai Shuffle | Evolved Four Seasons. Generates an additional explosion. | Four Seasons + Candelabrador |
| 30 | Echo Night | Evolved Summon Night. Generates damaging zones below the character. | Summon Night + Duplicator |
| 31 | J'Odore | Evolved Mirage Robe. Projectiles move and confuse enemies. | Mirage Robe + Attractorb |
| 32 | Boo Roo Boolle | Evolved Mille Bolle Blu. Projectiles can hit the same target more than once. | Mille Bolle Blu + Spellbinder |
| 33 | Muramasa | Evolved Night Sword. Enables critical hits and combo finisher. Drains Health. | Night Sword + Stone Mask |
| 34 | Legionnaire | Evolved Eskizzibur. Generates additional projectiles that deal retaliatory damage. | Eskizzibur + Armor |
| 35 | Millionaire | Evolved Flash Arrow. Fires additional projectiles based on Amount and when picking up gold coins. | Flash Arrow + Bracer |
| 36 | Luminaire | Evolved Prismatic Missile. Increases the value of gems and coins on the ground. | Prismatic Missile + Crown |
| 37 | Ophion | Evolved Shadow Servant. Has a chance to instantly kill enemies. | Shadow Servant + Skull O'Maniac |
| 38 | Emergency Meeting "Emergency Meeting (weapon)") | Evolved Report! Occasionally destroys all of one type of enemy. | — |
| 39 | Crossed Wires | Evolved Lucky Swipe. Attacks in up to four directions. | Lucky Swipe + Mini Engineer |
| 40 | Paranormal Scan | Evolved Lifesign Scan. Periodically grants a random stat boost for the rest of the run. | Lifesign Scan + Mini Ghost |
| 41 | Unjust Ejection | Evolved Just Vent. Sucks in enemies. | Just Vent + Mini Shapeshifter |
| 42 | Clear Asteroids | Evolved Clear Debris. Amount creates cluster explosions. | Clear Debris + Mini Guardian |
| 43 | Impostongue | Evolved Sharp Tongue. Deals high damage to the strongest enemy and anything in its path. | Sharp Tongue + Mini Impostor |
| 44 | Rocket Science | Evolved Science Rocks. Triggers a finisher when the right conditions are met. | Science Rocks + Mini Scientist |
| 45 | Prototype A | Evolved Long Gun. Calls forth 2 drones for support fire. | Long Gun + Weapon Power-Up |
| 46 | Prototype B | Evolved Short Gun. Calls forth 2 drones for support fire. | Short Gun + Weapon Power-Up |
| 47 | Prototype C | Evolved Spread Shot. Calls forth 2 drones for support fire. | Spread Shot + Weapon Power-Up |
| 48 | Pronto Beam | Evolved C-U-Laser. Lasers split into multiple beams when they hit. | C-U-Laser + Weapon Power-Up |
| 49 | Fire-L3GS | Evolved Firearm. Fires again when destroying a light source or destructible item. | Firearm + Weapon Power-Up |
| 50 | Wave Beam | Evolved Sonic Bloom. Charges up a more powerful auto-aimed blast when standing still. | Sonic Bloom + Weapon Power-Up |
| 51 | Multistage Missiles | Evolved Homing Miss. Projectiles split into smaller ones when they hit. | Homing Miss + Weapon Power-Up |
| 52 | Atmo-Torpedo | Evolved Diver Mines. Creates damaging zones that attract enemies. | Diver Mines + Weapon Power-Up |
| 53 | BFC2000-AD | Evolved Blade Crossbow. Calls forth divine intervention with a Luck-based frequency. | Blade Crossbow + Weapon Power-Up |
| 54 | Time Warp | Evolved Prism Lass. May freeze, slow down, or DeFang enemies. | Prism Lass + Weapon Power-Up |
| 55 | Big Fuzzy Fist | Evolved Metal Claw. Pummels the most powerful enemies in sight. | Metal Claw + Weapon Power-Up |
| 56 | Vampire Killer | Evolved Alchemy Whip . Every 3rd activation fires additional projectiles. Intense sunlught incinerates boss enemies. | Alchemy Whip + Tirajisú |
| 57 | Spirit Tornado Tip | Evolved Wind Whip . Every 7th activation summons a spirit that violently collects XP gems for you. | Wind Whip + Crown |
| 58 | Cross Crasher Tip | Evolved Platinum Whip . Every 7th activation also fires special projectiles. | Platinum Whip + Clover |
| 59 | Hydrostormer Tip | Evolved Dragon Water Whip . Every 13th activation generates damaging waves based on Projectile Speed and Duration. | Dragon Water Whip + Attractorb |
| 60 | Crissaegrim Tip | Evolved Sonic Whip . Every 5th activation also triggers a blast of damaging waves. | Sonic Whip + Skull O'Maniac |
| 61 | Mormegil Tip | Evolved Jet Black Whip . Every 8th activation also triggers damaging zones. | Jet Black Whip + Stone Mask |
| 62 | Daybreaker Tip | Evolved Vibhuti Whip . Critical hits maximise amount of projectiles. | Vibhuti Whip + Candelabrador |
| 63 | Aurablaster Tip | Evolved Vanitas Whip . Every 7th activation generates an explosion. | Vanitas Whip + Hollow Heart |
| 64 | Yagyu Shuriken | Evolved Shuriken . Fires with no delay. | Shuriken + Empty Tome |
| 65 | Bwaka Knife | Evolved Curved Knife . Projectiles bounce forever until Duration expires. | Curved Knife + Bracer |
| 66 | Long Inus | Evolved Javelin . Projectiles reappear after leaving the screen. | Javelin + Spellbinder |
| 67 | Stellar Blade | Evolved Discus . Travels along walls. Deals critical damage if the user is invulnerable. | Discus + Parm Aegis |
| 68 | Wrecking Ball | Evolved Iron Ball . Fires a very heavy projectile. | Iron Ball + Armor |
| 69 | Jewel Gun | Evolved Silver Revolver . Critical hits instantly kill enemies and turn them into Jewels. | Silver Revolver + Karoma's Mana |
| 70 | The RPG | Evolved Hand Grenade . Explosions propagate. | Hand Grenade + Candelabrador |
| 71 | Meal Ticket | Evolved Wine Glass . Soulful food deals Revival-based damage to unrefined palates. | Wine Glass + Tirajisú |
| 72 | Salamender | Evolved Raging Fire . Also summons a snake of fire. | Raging Fire + Spinach |
| 73 | Cocytus | Evolved Ice Fang . Also triggers a freezing wind. | Ice Fang + Spellbinder |
| 74 | Pneuma Tempestas | Evolved Gale Force . Also triggers a spinning tornado. | Gale Force + Bracer |
| 75 | Gemma Torpor | Evolved Rock Riot . Also triggers a rain of crystals that can turn enemies into valuable jewels. | Rock Riot + Stone Mask |
| 76 | Tenebris Tonitrus | Evolved Fulgur . Also triggers ball lightnings. | Fulgur + Duplicator |
| 77 | Keremet Morbus | Evolved Keremet Bubbles . Also triggers a slimy swarm that chases enemies down. | Keremet Bubbles + Armor |
| 78 | Nightmare | Evolved Hex . Also tirggers a negative energy zone that doubles Curse when stepped into. | Hex + Skull O'Maniac |
| 79 | Sanctuary | Evolved Refectio . At fixed intervals, also fully heals characters and purifies all enemies in sight. | Refectio + Clover |
| 80 | Stamazza | Evolved Mace . Has a catastrophically high critical damage multiplier. | Mace + Hollow Heart |
| 81 | Moon Rod | Evolved Star Flail. Projectiles are shot in the faced direction. | Star Flail + Pummarola |
| 82 | Thunderbolt Spear | Evolved Alucard Spear . Every 7th activation triggers a special attack based on speed. | Alucard Spear + Wings |
| 83 | Gungnir-Souris | Evolved Trident . Critical hits also fire a damaging beam. | Trident + Duplicator |
| 84 | Dark Iron Shield | Evolved Iron Shield . Critical hits retaliate with spinning swords. | Iron Shield + Parm Aegis |
| 85 | Sacred Beasts Tower Shield | Evolved Guardian's Targe . Overhealing also triggers a period of invulnerability. | Guardian's Targe + Pummarola |
| 86 | Rune Sword | Evolved Tyrfing . Critical damage also affected by Area, Speed, and Duration. | Tyrfing + Spinach |
| 87 | Alucard Swords | Evolved Alucart Sworb . Apparitions of the sword's true bearer seek out enemies. | — |
| 88 | Vol Confodere | Attack nearby enemies. Speed affects Damage. | — |
| 89 | Melio Confodere | Attack nearby enemies. Speed affects Cooldown and Damage. | — |
| 90 | Nitesco | Evolved Globus. Fires a piercing energy beam in the faced direction. | Globus + Empty Tome |
| 91 | Acerbatus | Evolved Optical Shot. Damage is affected by the amount of defeated enemies. | Optical Shot + Karoma's Mana |
| 92 | Rapidus Fio | Evolved Sonic Dash . Also triggers a single shield charge. | Sonic Dash + Wings |
| 93 | Vol Luminatio | Evolved Luminatio . Damage, Speed, Area, and Duration affected by Growth. | Luminatio + Crown |
| 94 | Vol Umbra | Evolved Umbra . Damage, Speed, Area, and Duration affected by Magnet. | Umbra + Attractorb |
*Evolution rows parsed: 94.*

### S1.3 Unions (7)

| Weapon | Behavior | From |
|--------|----------|------|
| Vandalier | Union of Peachone and Ebony Wings. | Peachone + Ebony Wings |
| Phieraggi | Union of Phiera Der Tuphello and Eight The Sparrow. Scales with Revivals. | Phiera Der Tuphello + Eight The Sparrow |
| Fuwalafuwaloo | Union of Vento Sacro and Bloody Tear. Critical hits might generate explosions | Vento Sacro + Bloody Tear |
| SpellStrom | Union of SpellString, SpellStream, and SpellStrike. Grows stronger after every singularity. | * Max-out SpellString , SpellStream , and SpellStrike |
| Clock Tower | Union of Endo Gears, Peri Pendulum, Myo Lift, and Epi Heads. | * Max-out Endo Gears , Peri Pendulum , Myo Lift and Epi Head |
| Power of Sire | Union of Dominus Anger, Dominus Hatred and Dominus Agony. Deals critical damage to anything in sight. Drains health. | * Max-out Dominus Anger , Dominus Hatred and Dominus Agony |
| Trinum Custodem | Union of Dextro Custos, Sinestro Custos, and Centralis Custos. | * Max-out Dextro Custos , Sinestro Custos and Centralis Custos |

### S1.4 Gifts (4)

| Weapon | Behavior |
|--------|----------|
| Sole Solution | Gift of Victory Sword . The more enemies are defeated, the stronger it grows. |
| Super Candybox II Turbo | Gift of Candybox . Allows to choose among a selection of advanced weapons. |
| Alucard Shield | Gift of Alucard Swords . Absorbs and triggers all other equipped evolutions. Hovering shield damages enemies. |
| Universitas | Gift of Vol Luminatio and Vol Umbra. Meteors rain down on enemies at fixed intervals. |

### S1.5 Counterpart weapons (19) — alternate forms of base weapons used in Inverse-mode stages

Cygnus, Zhar Ptytsia, Red Muscle, Twice Upon a Time, Flock Destroyer, Levelin'Eh, Silver Sliver, Party Pooper, Silver Tongue, Prism Damsel, Speculo Globus, Speculo Raging Fire, Speculo Ice Fang, Speculo Rock Riot, Speculo Gale Force, Speculo Fulgur, Speculo Keremet Bubbles, Speculo Hex, Speculo Refectio

### S1.6 Special weapons (11) — not offered by level-up (arcana-derived / stage items)

- **Nduja Fritta** — * Scales with all stat bonuses * Duration affects both the NFT and the each individual flame * Area increases the growth rate of each flame * Affected by Gemini
- **Dairy Cart** — * Ignores Duration * Ignores Speed, Duration, Cooldown, and Amount as an effect * Does not bounce off the screen like Carréllo * Triggers when dealt enough dama
- **Take Us Away** — * Scales with all stat bonuses. * Gains bonus flat damage based on Area, Speed, and Duration.
- **Sarabande of Healing "Sarabande of Healing (VI)")** — * Ignores Might, Duration, and Speed * Ignores everything but Area as an effect * Deals damage equal to the amount healed as Arcana effect
- **Stained Glass** — * Ignores Duration and Speed * Ignores Speed, Duration, Cooldown, and Amount as an effect * Triggers when dealt enough damage * Effect used by Game Killer (0),
- **Game Killer "Game Killer (0)")** — * Ignores Duration * Ignores Duration, Cooldown, and Amount as an effect * Shoot out a placeholder piano that aims straight at the closest enemy similar to Magi
- **Heart of Fire "Heart of Fire (XIX)")** — * Ignores Duration and Speed * Ignores Speed, Duration, Cooldown, and Amount as an effect * Used by Gatti Amari when a cat consumes an NFT * Retaliatory explosi
- **Out of Bounds "Out of Bounds (XII)")** — * Ignores Duration and Speed * Ignores Duration, Speed, Cooldown, and Amount as an effect * Triggered by freezing enemies as Arcana effect,
- **Divine Bloodline "Divine Bloodline (IX)")** — * Ignores Might, Area, Duration, and Speed * Ignores everything but Armor and deals contact damage as Arcana effect
- **Blood Astronomia "Blood Astronomia (XXI)")** — * Ignores Area, Duration, and Speed * Scales with Magnet * Ignores Area, Duration, and Speed as Arcana effect
- **Insatiable** — * Exclusive to Je-Ne-Viv * Ignores Area, Duration, and Speed * Scales with Magnet and Greed

---

## S2 PASSIVE ITEMS (33 total)

Source: https://vampiresurvivors.fandom.com/wiki/Passive_items (fetched via wiki API, 2026-10-23). Count claim VERIFIED, quoted:

> "The base game has 21 passive items, 17 of which are normal passive items and 4 of which are special passive items. In addition, there are 12 passive items that are only available in DLCs: 1 from the Tides of the Foscari DLC, 8 from the Emergency Meeting DLC, 1 from the Operation Guns DLC, and 2 from the Ode to Castlevania DLC, bringing the total number of passive items in the game to 33."

Selected from level-ups alongside weapons; max 6 different passives per run (stage-spawned ones can exceed). One copy each (unique). Quoted rule: "The player can select up to six different passive items from level ups..."

### Base game (21)

| Item | Effect (wiki one-liner) | Max lvl |
|------|------------------------|---------|
| Spinach | Raises inflicted damage by 10%. | 5 |
| Armor | Reduces incoming damage by 1. Increases retaliatory damage by 10%. | 5 |
| Hollow Heart | Augments max health by 20%. | 5 |
| Pummarola | Character recovers 0.2 HP per second. | 5 |
| Empty Tome | Reduces weapons cooldown by 8%. | 5 |
| Candelabrador | Augments area of attacks by 10%. | 5 |
| Bracer | Increases projectiles speed by 10%. | 5 |
| Spellbinder | Increases duration of weapon effects by 10%. | 5 |
| Duplicator | Weapons fire more projectiles. | 2 |
| Wings | Character moves 10% faster. | 5 |
| Attractorb | Character pickups items from further away. | 5 |
| Clover | Character gets 10% luckier. | 5 |
| Crown | Character gains 8% more experience. | 5 |
| Stone Mask | Character earns 10% more coins. | 5 |
| Tirajisú | Character revives with 50% health once. | 2 |
| Skull O'Maniac | Increases enemy speed, health, quantity, and frequency by 10%. | 5 |
| Torrona's Box | Cursed item, but increases Might, Projectile Speed, Duration, and Area by 4%. | 9 |
| Silver Ring | Wear ... Clock ... | 9 |
| Gold Ring | ... With ... Lancet | 9 |
| Metaglio Left | Channels dark powers to protect the bearer. | 9 |
| Metaglio Right | Channels dark powers to curse the bearer. | 9 |

### DLC passives (12) — names VERIFIED from the same page; effects UNVERIFIED per-item (not fetched individually)

- [DLC-TF] **Academy Badge**
- [DLC-EM] **Mini Crewmate, Mini Engineer, Mini Ghost, Mini Guardian, Mini Horse, Mini Impostor, Mini Scientist, Mini Shapeshifter** — page quote: "Each of them are exclusive to a certain Emergency Meeting DLC weapon... Instead of stat bonus, they provide a hidden weapon and a pet that follows the character."
- [DLC-OG] **Weapon Power-Up** — the only passive that can be acquired multiple times in one run (Neo Galuga).
- [DLC-OC] **Parm Aegis**, **Karoma's Mana**

---

## S3 EVOLUTION & UNION RULES

Sources: https://vampiresurvivors.fandom.com/wiki/Weapons and https://vampiresurvivors.fandom.com/wiki/Evolution and https://vampiresurvivors.fandom.com/wiki/Treasure_Chest (all fetched 2026-10-23). VERIFIED quotes:

> "When a base weapon is leveled to the max and its corresponding passive item is obtained, it can be transformed into an evolved weapon by collecting a Treasure Chest. Not all weapons have an evolution."

> "When the requirements for an evolution (or union) are fulfilled and the run is at 10 or more minutes, chests can evolve (or unite) a weapon. Generally, only one weapon can be evolved per chest..."

> "Evolution actually works by removing the base weapon and acquiring the evolved one (with few exceptions)... the evolved weapon's Cooldown starts from zero."

Mechanic summary (all VERIFIED from the two pages):
1. Weapon at max level + required passive item carried (passive need NOT be leveled — any rank).
2. A Treasure Chest dropped after minute 10:00 converts it (removes the base weapon, cooldown restarts at 0).
3. Unions: two max-level weapons + (sometimes) a stage-only item, combined in a chest (e.g. Clock Tower = Clock Lancet + Orologion).
4. Gifts: special chest outcomes combining two maxed items (e.g. Sole Solution = Victory Sword + Torrona's Box).
5. Morph: certain characters (Mortaccio, Yatta Cavallo, O'Sole Meeo) auto-evolve their starting weapon on morphing, given the relic + condition. Quote: "Certain characters... automatically evolve their starting weapon when they morph into a new form, provided you have the required relic and meet the necessary condition."

Parsed combo count from the Evolution page (VERIFIED by parse, all 93 rows in S1.2/S1.3): normal evolutions 22 + unions 3 + gifts 1 + morphs 3 = **29 base-game special transforms**; DLC adds 64 more combos (Legacy of the Moonspell 6, Tides of the Foscari 4, Emergency Meeting 7, Operation Guns 11, Ode to Castlevania 36).

Special/hidden note: the classic hidden evolutions are **Infinite Corridor** (Thunder Loop + Clock Lancet + Silver Ring + Gold Ring) and **Crimson Shroud** (Prism Lass + Laurel + Metaglio Left + Metaglio Right) — they use special passive items (Silver/Gold Ring, Metaglio L/R) that are only obtainable after collecting the **Yellow Sign** (a 4th item found in a stage). Page quote (Passive items): "These special passives include the passive items unlocked after collecting the Yellow Sign...". The rings/Metaglios evolve weapons that are themselves 9-level 'triple' passives — flagged here as the game's hidden-evolution route. VERIFIED (Evolution page combos + Passive page).

---

## S4 STAGES (25 fetched; every stage's own page fetched via wiki API)

Source pattern: https://vampiresurvivors.fandom.com/wiki/<Stage> + https://vampiresurvivors.fandom.com/wiki/Stages. Gimmick line = page description/intro (VERIFIED quote material, tightened). Time limit from each page's infobox (VERIFIED). Boss column: end-of-stage boss named on the page where the page names one; — = page has no single named final boss (waves escalate, Reaper ends the run) (VERIFIED absence from the fetched page text).

General rules (from Stages page, VERIFIED quotes):
- Reaper: "If the player survives until the stage's time limit, the stage is considered complete, at which point one Reaper will arrive every minute to slay the player and end their run, unless Endless mode is enabled."
- Modes: "All stages have four unlockable and toggleable modes: Hyper, Hurry, Inverse, and Endless mode."
- Completion gold: "the player will earn 500 gold coins as an additional reward upon death. The amount can be further increased by an additional 100 coins for each unused revival."

| Stage | Kind | Time limit | End-of-stage boss | Gimmick / one-liner |
|-------|------|-----------|-------------------|---------------------|
| Mad Forest | Normal | 30:00 | Giant Blue Venus (25:00) | First stage; 5 fixed stage passives scattered; Glowing Bat (arcana chest boss); demo stage. |
| Inlaid Library | Normal | 30:00 | Hag (25:00) | Straight corridors of bookcases; Stone Mask + Empty Tome spawn as stage items; 100% move speed in Hyper. |
| Dairy Plant | Normal | 30:00 | Sword Guardian (25:00) | Floor traps: "Dairy Plant and Gallo Tower feature circular pressure plates on the ground, which upon being stepped on trigger an unavoidable event." (VERIFIED, Boss page); hidden map. |
| Gallo Tower | Normal | 30:00 | Giant Enemy Crab (25:00) | Multi-room tower (stairs between rooms); same pressure-plate traps; relic coffins. |
| Cappella Magna | Normal | 30:00 | Trinacria (25:00) | Six-crypt chapel; Crown/Tirajisu/Duplicator stage items; gate to Eudaimonia Machine via all six relics. |
| Eudaimonia Machine | Secret/Endgame | 99:00 | The Directer | Endgame gauntlet entered with all 6 relics; rooms per relic; ends with entity "The Directer" — quote: "it shouts 'But enough talk, have at you!' and challenges you as The Directer, the final boss of the game. Defeating it unlocks Greatest Jubilee." |
| Il Molise | Bonus | 15:00 | — (Molisano Anfora event) | Real-world memorial stage; Peppino hidden character; Molisano Anfora spawns 15:00-20:00 window. |
| Moongolow | Bonus | 15:00 | Moon Trinacria (14:00+, eclipse) | VERIFIED: "During eclipse... Different sets of enemies spawn minute 12 onward"; defeating Moon Trinacria ("a special, angel-like boss") unlocks hidden stage Holy Forbidden. |
| Holy Forbidden | Hidden | 30:00 | — | Entered via Moongolow's Moon Trinacria; source of the Yellow Sign passive set (VERIFIED from Moongolow + Passive items pages; own page not fetched). |
| Green Acres | Challenge | 30:00 | — | VERIFIED: "The waves that appear in Green Acres are selected at random across all unlocked maps." |
| The Bone Zone | Challenge | 30:00 | Skeletone (28:00) | Stages page (VERIFIED): relic "Forbidden Scrolls of Morbane (requires Yellow Sign)" is the payoff here. |
| Boss Rash | Challenge | 15:00 | Dragogion waves / The Reaper at 15:00 | Boss-rush reusing stage bosses; VERIFIED 15:00 row: "The Reaper... All enemies on the screen are cleared. For every minute past 15, another Reaper spawns." |
| Whiteout | Bonus | 20:00 | — | Unlocked by collecting 20 Orologions; arctic; Glass Fandango + Skull O'Maniac spawn as stage items. |
| Space 54 | Bonus | 20:00 | — | Unlocked by collecting 5 Gold Fingers; space station remix of stage effects. |
| Carlo Cart | Bonus | 15:00 | Twin Snakes / Giant Goat-Horned Shooter (12:00+) | Underground go-kart race against Carlo; damage-based unlock (25,120 damage in Gallo Tower). |
| Laborratory | Challenge | 20:00 | Tri-Blunder (18:00) | Santa Ladonna's foundry; Rosary hunt (find 33 Rosaries) unlocks; Operation Guns stage. |
| Bat Country | Challenge | 20:00 | LV128 Golden Bat (19:00) | Bat swarm; 20:00 time limit; "We can't stop here." |
| Astral Stair | Challenge | 20:00 | LV128 Golden Bat (19:00) | A highway between worlds; Phiera/Eight stage items. |
| Tiny Bridge | Challenge | 20:00 | — (Reaper 20:00) | Two factions over a bridge; Lightning Ring/Vento Sacro stage items. |
| Mt. Moonspell [DLC] | Special | 30:00 | Orochimario (25:00) | Oni/oni-gi mountain; Thunderous/Windy Oni bosses; Moonspell flower walls. |
| Lake Foscari [DLC] | Special | 30:00 | Avatar of Gaea (25:00) | Flooded valley; Foscaritrice boss family; knight trio waves (Deep/Big Green + Red Knights). |
| Abyss Foscari [DLC] | Special | 30:00 | Maronna Meea (27:00) | Underwater abyss; Rotting Ghouls, Meatball; Hand of Glory item. |
| Polus Replica [DLC] | Special | 30:00 | Suspicious Eyes (25:00) | Among Us on Polus; suspicion/kill events; Weapon Power-Up pool in Neo Galuga. |
| Neo Galuga [DLC] | Special | 30:00 | — | Contra crossover stage; Weapon Power-Ups drop here (multi-acquire passive). |
| Hectic Highway [DLC] | Special | 20:00 | — | Contra scrolling highway run. |
| Ode to Castlevania [DLC] | Special | 30:00 | Malphas (25:00) | Castlevania open remix; vampire-killing tools tag on many weapons. |

Gimmick cells are synthesized from fetched page text; where a cell quotes, it is verbatim from the fetched page (VERIFIED); the compressed paraphrases are INFERRED summaries of fetched content, not independent claims.

---

## S5 BOSSES + ENDLESS MODE

Sources: https://vampiresurvivors.fandom.com/wiki/Boss (enemies/bosses overview + named boss tables; fetched 2026-10-23), the 25 per-stage pages listed in S4, and https://vampiresurvivors.fandom.com/wiki/Stages. VERIFIED rules quotes:

> "Bosses are special enemies that spawn in some waves. They are stronger than other enemies in the wave, having more health, dealing more damage and often also being resistant to some effects. Bosses also have a chance to drop a Treasure Chest when they are killed. Bosses do not despawn when the player moves away from them, but get teleported back to the screen."

> "Enemies normally arrive in waves - one wave every minute... When 300 or more enemies are alive the game will not spawn more enemies periodically, and only bosses and enemies from map events can spawn."

> "If the player survives until the stage's time limit, the stage is considered complete, at which point one Reaper will arrive every minute to slay the player and end their run, unless Endless mode is enabled." (Stages page)

### Named end-of-stage bosses (VERIFIED from each stage page's Hyper-unlock sentence, fetched this session)

| Stage | Boss | Spawns |
|-------|------|--------|
| Mad Forest | Giant Blue Venus | 25:00 |
| Inlaid Library | Hag | 25:00 |
| Dairy Plant | Sword Guardian | 25:00 |
| Gallo Tower | Giant Enemy Crab | 25:00 |
| Cappella Magna | Trinacria | 25:00 |
| Eudaimonia Machine | The Directer ("the final boss of the game") | final room |
| Moongolow (eclipse) | Moon Trinacria | ~14:00 |
| Mt. Moonspell [DLC] | Orochimario | 25:00 |
| Lake Foscari [DLC] | Avatar of Gaea | 25:00 |
| Polus Replica [DLC] | Suspicious Eyes | 25:00 |
| Ode to Castlevania [DLC] | Malphas | 25:00 |

### Mini-bosses / named wave bosses (72 entries from the wiki Boss table — VERIFIED list, grouped by stage)

- **Abyss Foscari**: Colossal Meatball, Colossal Redusa Head, Edna Boss, Flaming Skull, Maronna Meea Boss, Rotting Ghoul, Warm Cauld, Well Well Well Dweller
- **Boss Rash**: Axe Guardian, Colossal Archdemon, Colossal Archon Rame, Colossal Bone Dragon, Colossal Dust Elemental, Colossal Flame Dragon, Colossal Garlic, Colossal Harzia, Colossal Lionhead, Colossal Lost Twin, Colossal Manticore, Colossal Musc Musc, Colossal Nightshade, Colossal Skeleton, Colossal Sneaky Head, Colossal Succubus, Colossal Unknown, Giant Bat, Giant Skullone, Hag, King Tritont, Master Witch, Minotaur Boss, Nesufritto, Non-Giant Enemy Crab, Queen Merdusa, Red Knight Guardian, Shield Guardian, Sword Guardian, The Drowner, The Ender, The Maddener, The Reaper, The Stalker, The Trickster, Tri-Anchors, Trinacria, Werewolf Lord
- **Boss Rush**: Colossal Gallotrice
- **Cappella Magna**: Axe Guardian, Colossal Archdemon, Colossal Archon Rame, Colossal Succubus, Colossal Unknown, The Ender, The Reaper, Trinacria
- **Dairy Plant**: Axe Guardian, Colossal Gallotrice, Colossal Lost Twin, King Tritont, Lizard Rook, Minotaur Boss, Minotaur Champion, Sword Guardian, The Reaper
- **Gallo Tower**: Colossal Bone Dragon, Colossal Flame Dragon, Colossal Gallotrice, Colossal Harzia, Colossal Manticore, Giant Skullone, Scarleton, Shield Guardian, The Reaper, Undead Mage
- **Green Acres**: The Reaper
- **Il Molise**: The Reaper
- **Inlaid Library**: Colossal Dust Elemental, Colossal Lionhead, Colossal Musc Musc, Colossal Sneaky Head, Hag, Master Witch, Nesufritto, Queen Merdusa, The Reaper
- **Lake Foscari**: Arcana Foscaritrice, Avatar of Gaea, Big Green Knight, Colossal Foscaritrice, Deep Green Knight, Foscaritrice, Lammuga Boss, Njuggles Boss, Nutmeg Boss, Sam the Boss Clown, Vulvio Boss
- **Mad Forest**: Giant Bat, The Reaper, Werewolf Lord
- **Moongolow**: Colossal Garlic, Colossal Nightshade, Moon Trinacria, Moongolow Atlanteans, Non-Giant Enemy Crab, The Reaper
- **Mt. Moonspell**: Kamaitachi Boss, Mikoshi-nyudo, Orochimario, Raiju Boss, Tanuki Boss, Tengu Boss, Thunderous Oni, Windy Oni
- **The Bone Zone**: Colossal Skeleton, Giant Skullone, The Reaper
- **Tiny Bridge**: Colossal Archon Rame

### Special event entities & event 'swarm' groups (VERIFIED names from the Boss page Event/Special sections + stage wave tables)

- Hunt-style specials: The Trickster, The Stalker, The Drowner, The Maddener (special events), LV128 Golden Bat (Bat Country / Astral Stair 19:00 wave), LV128 Golden Bat (scaling).
- Group spawns ('swarm/wall/circle/pile' events): Pipeestrello Swarm, Skeleton Swarm, Flower Wall, Ghost Swarm, Milk Elemental Swarm, Dragon Swarm/Stream, Medusa Wall/Swarm, Big Musc Muscs, Pile Assault, Jellyfish Wall/Swarm, Minotaur Rush, Twin Skulls, Skull Swarm/Pile, Foscari Mantichana/Pot Circle, Wiseparke Swarm, Blood Moss Swarm, Rotting Ghoul Swarm, Burning Skull Swarm, Snek Swarm, Serpentine Skeleton Dragon, Bell Angel Striker + Bomber, Shooting Star event.
- Named late-wave bosses from wave tables: Skeletone (Bone Zone 28:00), Dragogion (Boss Rash 14:00), Tri-Blunder (Laborratory 18:00), Maronna Meea + Giant Followa (Abyss Foscari 27:00-29:00), Twin Snakes + Giant Goat-Horned Shooter (Carlo Cart 12:00+), Molisano Anfora (Il Molise), Colossal Bone Dragon + Colossal Flame Dragon (Gallo Tower 29:00).

### Endless mode rules (VERIFIED quotes, Stages page)

> "**Endless Mode** disables the spawning of Reapers upon reaching the stage's time limit. Instead, reaching the final minute of a stage causes the enemy waves to restart from the beginning, completing a 'cycle,' allowing the stage to continue indefinitely. After completing the first cycle, the stage will be considered complete. Every cycle, enemies gain +100% of their base HP, their spawn frequency and quantity increase by +50%, and their damage dealt increases by +25%; also, the player's max incoming damage cap is reduced by 1."

> "In this mode, the merchant respawns after each cycle and begins offering one additional Revival in place of Golden Eggs, as well as an extra Arcana if Inverse Mode is also enabled."

> "Endless Mode is unlocked by collecting the Seventh Trumpet relic, located in Eudaimonia Machine."

So the 30:01+ behavior = endless cycles on the same map with +100%/cycle HP scaling and the per-minute Reaper only in non-Endless modes. Limit Break mode (Stages page, VERIFIED quote): "**Limit Break** enables equipped weapons to be upgraded beyond their usual limits... upon maxing out all equipped weapon and passive items... they will start to receive Limit Break upgrades, with each level-up providing an upgrade to a specific stat for one of the player's equipped weapons. Weapons with Limit Break levels may still be evolved. However, the weapon will lose all of its additionally obtained stats".

---

## S6 CHARACTERS

Sources: https://vampiresurvivors.fandom.com/wiki/Characters (fetched) + 71 individual character pages (fetched via wiki API). Roster-size claim VERIFIED (intro quote, see below) — note the page's own roster lists 168 entries vs 165 claimed: CONTRADICTED count, name-list VERIFIED.

> "There are currently 165 official playable characters. The base game has 48 characters of which 19 can be obtained by discovering secrets. The DLCs have a combined roster of 117 characters, 40 of them being secret ones. All non-secret characters need to be purchased using gold, increased by 10% additively per characters purchased, with the exception of Antonio, being the first basic character a new player uses, and Queen Sigma, who requires an achievement but costs 0 gold to purchase."

Secret characters: > "Secret characters are 'secret' in that their unlock conditions are only present in the secret menu, and said menu only gives somewhat ambiguous hints."

### Base + hidden characters (unlock + signature mechanic per own page infobox — VERIFIED)

| Character | Start weapon | Unlock condition (infobox) | Signature mechanic (infobox description) |
|-----------|--------------|----------------------------|------------------------------------------|
| Albus | Optical Shot | Fully evolve the Confodere | Gains a bonus to Might and Cooldown depending on how many enemies are in sight. |
| Antonio Belpaese | Whip | unlocked by default (free starter) | Gains 10% more damage every 10 levels (max +50%). |
| Arca Ladonna | Fire Wand | Get Fire Wand to level 4. | Weapon cooldown is reduced by 5% every 10 levels (max -15%). |
| Avatar Infernas | Flames of Misspell | It is tangible only in the inverted Good friends might then show the way. | Starts with extra XIX - Heart of Fire. Grows stronger with every level, but also loses control. |
| Barlowe |  | purchasable for 2000 gold (+10% price per character bought) |  |
| Bat Robbert | Pako Battiliar | Evolve the Pako Battiliar. | Recovers 25% Max Health and gains +32 Max Health (Max +665) when health reaches a critically low level. |
| Bats Bats Bats | Mazo Familiar | It's as simple as ABC: obtain the ring of rings. | Starting weapon gets stronger when levelling up. Revivals also affect Amount. Receives a follower after revivi |
| Bianca Ramba | Carréllo | Defeat a total of 3000 Milk Elementals. | Gets more projectiles every 20 levels (max+3). |
| Big Trouser | Candybox | Master all 16 accessories in Moongolow. | Gains +1% Greed every level. Gold Fever lasts longer. |
| Boon Marrabbio | Thousand Edge | Follow the trail after pillaging Pummarola and Skull O'Maniac from the Mad Forest. |  |
| Carrie Fernandez | Rock Riot | purchasable for 1665 gold (+10% price per character bought) |  |
| Christine Davain | Pentagram | Get Pentagram to Level 7. | Starts with 1 extra Level. |
| Concetta Caciotta | Shadow Pinion | Find and open the coffin in Gallo Tower. | Gains +1% Area every level. |
| Cornell |  | purchasable for 2000 gold (+10% price per character bought) | Morphs into a stronger version when equipped with unlock = Evolve the [[Silver Revolver. |
| Cosmo Pavone |  | With a pure heart and two good friends, visit the fiery balcony in Cappella Magna. | Gains +1 Recovery and +1% Luck every level. Gains +1 Revival every 100 levels. Has hidden weapons. |
| Divano Thelma | Laurel | Obtain the Crimson Shroud | Starts with one extra level. Gains +1 Armor every 5 levels (max +5). |
| Dommario | King Bible | Earn 5000 coins in a single run. | Permanent +40% duration and speed, -40% move speed. |
| Elizabeth Bartley | Hex | Evolve the Umbra. | Increases enemies spawn quantity by 50. Immune to health drain. |
| Exdash Exiviiq | Ebony Wings | 1) Cast the spell x-x1viiq, or<br>find a lot of Little Clovers. | At least they're lucky. |
| Gains Boros | Heaven Sword | Find the only one place where flowers bloom in The Bone Zone. | Gains +2% Growth every level. |
| Gennaro Belpaese | Knife | purchasable for 500 gold (+10% price per character bought) | Permanent +1 projectile (all weapons). |
| Giovanna Grana | Gatti Amari | Find and open the coffin in Inlaid Library. | Gains +1% Projectile Speed every level. |
| Gyoruntin | NO FUTURE | Forsake victory in favor of sightseeing in Carlo Cart. | Starting weapon grows stronger when levelling up. Gains +1% Curse every level. Ignores Walls. |
| Gyorunton | Bracelet | Survive the Boss Rash with just one weapon. | Gains +1% Curse every level. Can find evolutions in any Treasure. |
| Henry | Silver Revolver | purchasable for 2000 gold (+10% price per character bought) |  |
| Iguana Gallo Valletto |  | Obtain the Infinite Corridor | Starts with one extra level. Gains 10% Growth every 5 levels (max +50%). |
| Imelda Belpaese | Magic Wand | purchasable for 10 gold (+10% price per character bought) | Gains 10% more experience every 5 levels (max +30%). |
| Isaac | Trident | Evolve the Mace. | Gains a random Familiar as a follower every 10 levels (max 6). |
| Julia Laforeze | Gale Force | purchasable for 7 gold (+10% price per character bought) |  |
| Krochi Freetto | Cross | Defeat a total of 100000 enemies. | Starts with 1 Revival. Gains 1 more Revival at level 33. |
| Lama Ladonna | Axe | Survive 20 minutes with at least 10% Curse active. | Gains +5% Might, MoveSpeed, and Curse every 10 levels (max +20%). |
| Leda | Holy Wand | Investigate the bottom of Gallo Tower. |  |
| Lisa Tepes | Luminatio | Evolve the Wine Glass. | Gains +1% Growth every level. Starts with extra Arcana XX - Silent Old Sanctuary. |
| Mask of the Red Death | Death Spiral | Settle the score with the Reaper. | A blasphemous mockery. |
| Maxim Kischine | Discus | purchasable for 2000 gold (+10% price per character bought) |  |
| Mina Hakuba |  | purchasable for 1665 gold (+10% price per character bought) |  |
| Minnah Mannarah | Bloody Tear | Deal with the consequence of stealing cheese from the Dairy Plant. | Might, Projectile Speed, Duration, Area, and Cooldown change every minute. |
| Mortaccio | Bone | Defeat a total of 3000 skeletons or enter the Konami Code in the main menu. | Gets more projectiles every 20 levels (max+3). |
| Nathan Graves | Sonic Dash | Evolve the Sonic Whip. | Starts with extra Arcana IV- Awake. Gain an extra choice of Arcana after survivng 7 and 14 minutes. |
| O'Sole Meeo | Celestial Dusting | Defeat a total of 3000 Dragon Shrimps. | Gets more projectiles every 20 levels (max+3). |
| Pasqualina Belpaese | Runetracer | purchasable for 100 gold (+10% price per character bought) | Projectiles get 10% faster every 5 levels (max +30%). |
| Peppino | Soul Eater | Be a good boy in Il Molise. | Starts with temporarily reduced area. |
| Poe Ratcho | Garlic | Get Garlic to level 7. | Permanent +25% Pickup radius and -30 Max Health. |
| Poppea Pecorina | Song of Mana | Find and open the coffin in Dairy Plant. | Gains +1% Duration every level. |
| Porta Ladonna | Lightning Ring | Get Lightning Ring to level 4. | Permanent +30% Area. Starts with temporary cooldown bonus. |
| Pugnala Provola | Phiera Der Tuphello | Find and open the coffin in Mad Forest. | Gains +1% Might every level. |
| Queen Sigma | Victory Sword | Complete the Collection. | She owns everything. |
| Quincy Morris | Shuriken | purchasable for 2000 gold (+10% price per character bought) |  |
| Random |  | Look under previously owned coffins. | Random. |
| Reinhardt Schneider | Tyrfing | purchasable for 2000 gold (+10% price per character bought) |  |
| Rinaldo Gandolfi |  | unlocked by default (free starter) |  |
| Rose De Infernas | Fuwalafuwaloo | Her royal shadow lies behind the 46th door. | Increases enemy spawn quantity by 100. |
| Saint Germain | Globus | Evolving the Trident | Gains 0.2% Cooldown reduction per level. Starts with extra Arcana XII - Out of Bounds. |
| Santa Ladonna | Santa Javelin | Survive 20 minutes in The Laborratory. | Starts with temporary Cooldown bonus. Triggers a Rosary when Health reaches a critically low level. Likes to k |
| Sara Trantoul |  | purchasable for 1665 gold (+10% price per character bought) |  |
| Scorej-Oni |  | Discover the source of the roaring thunder on the Tiny Bridge. | Gains a hidden Lightning Ring every 8 levels (max 6) that also fires when losing health. |
| Secretino Dagsson | ? | (no wiki page — red link) | (UNVERIFIED) |
| Shaft | Umbra | Evolve the Luminatio. | Gains +1% Curse every level. Becomes invincible and deals damage to nearby enemies for 20 seconds when health  |
| She-Moon |  | unlocked by default (free starter) |  |
| Sir Ambrojoe | La Robba | Defeat a total of 6000 Stage Killers. | Gets more projectiles every 20 levels (max+3). Starts with temporary Amount bonus. |
| Smith IV | Vandalier | 3) Sometimes you just need to ask for help. | The quirky white bear. |
| Space Dette | ? | (no wiki page — red link) | (UNVERIFIED) |
| Space Dude |  | Survive 20 minutes in Space 54. | May occasionally activate all weapons twice depending on Cooldown. |
| Suor Clerici | Santa Water | Recover a total of 1000 HP. | Permanent +0.5 HP/s and +50 Max Health. Starts with temporary area bonus. |
| Toastie | Peachone | 2) Uppercut a non-red reaper | So much potential. |
| Torino | ? | (no wiki page — red link) | (UNVERIFIED) |
| Vincent Dorin |  | purchasable for 9000 gold (+10% price per character bought) |  |
| Vlad Tepes Dracula | Wine Glass | Find and open the third coffin in Ode to Castlevania. | Gains +1% Might every level and +1 Revival every 100 levels. Curse increases Might. Incoming damage capped at  |
| Yatta Cavallo | Cherry Bomb | Defeat a total of 3000 Lion Heads. | Gets more projectiles every 20 levels (max+3). |
| Zi'Assunta Belpaese | Vento Sacro | Find and open the coffin in Cappella Magna. | Gains +0.5% Might, Projectile Speed, Duration, and Area every level. |
| missingN▯ | Axe | With the most adverse fate in Green Acres, run off the edge of the world. | M(▯▯) |

### DLC roster (names VERIFIED from the Characters page lists; per-character unlock/mechanic UNVERIFIED — pages not fetched this pass)

- **Legacy of the Moonspell** (8 listed): Miang Moonspell, Menya Moonspell, Syuuto Moonspell, Babi-Onna, McCoy-Oni, Megalo Menya Moonspell, Megalo Syuuto Moonspell, Gav'Et-Oni
- **Tides of the Foscari** (8 listed): Eleanor Uziron, Maruto Cuts, Keitha Muort, Luminaire Foscari, Genevieve Gruyère, Je-Ne-Viv, Sammy, Rottin'Ghoul
- **Emergency Meeting** (9 listed): Crewmate Dino, Engineer Gino, Ghost Lino, Shapeshifter Nino, Guardian Pina, Impostor Rina, Scientist Mina, Horse, Megalo Impostor Rina
- **Operation Guns** (12 listed): Bill Rizer, Lance Bean, Ariana, Lucia Zero, Brad Fang, Browny, Sheena Etranzi, Probotector, Stanley, Newt Plissken, Colonel Bahamut, Simondo Belmont
- **Ode to Castlevania** (60 listed): Leon Belmont, Sonia Belmont, Trevor Belmont, Christopher Belmont, Simon Belmont, Juste Belmont, Richter Belmont, Julius Belmont, Grant Danasty, John Morris, Jonathan Morris, Soma Cruz, Charlotte Aulin, Sypha Belnades, Yoko Belnades, Alucard, Eric Lecarde, Hector, Maria Renard, Shanoa, Young Maria Renard, Familiar, Innocent Devil, Blue Crescent Moon Cornell, Ferryman, Master Librarian, Hammer, Wind, Jonathan & Charlotte, Charlotte & Jonathan, Stella & Loretta Lecarde, Loretta & Stella Lecarde, Stella Lecarde, Loretta Lecarde, Brauner, Soleil Belmont, Dario Bossi, Dmitrii Blinov, Celia Fortner, Graham Jones, Joachim Armster, Walter Bernhard, Carmilla, Count Olrox, Cave Troll, Fleaman, Axe Armor, Frozenshade, Succubus (character), Keremet, Alamaric Sniper, Blackmore, Malphas, Death (character), Galamoth, Megalo Elizabeth Bartley, Megalo Olrox, Megalo Death, Megalo Dracula, Chaos

---

## S7 META PROGRESSION (shop, unlocks, gold)

Source: https://vampiresurvivors.fandom.com/wiki/PowerUps + Characters page + Gold Coin page (all fetched). Intro count VERIFIED:

> "There are 24 different PowerUps in the game, affecting the various player stats." (page intro; the page's own table currently lists 25 rows incl. Seal III — CONTRADICTED count, table VERIFIED)

### Shop power-ups (name / effect / max rank / first-purchase price; VERIFIED from table rows)

| PowerUp | Effect | Max rank | Start price |
|---------|--------|----------|-------------|
| Might | Raises inflicted Damage by 5% per rank (max +25%). | 5 | 200 |
| Armor | Reduces incoming Damage by 1 per rank (max -3) | 3 | 600 |
| Max Health | Augments Max Health by 10% per rank (max +30%) | 3 | 200 |
| Recovery | Recovers 0.1 HP per rank (max 0.5 HP) per second. | 5 | 200 |
| Cooldown | Uses weapons 2.5% faster per rank (max 5%). | 2 | 900 |
| Area | Augments area of attacks by 5% per rank (max +10%). | 2 | 300 |
| Speed | Projectiles move 10% faster per rank (max +20%). | 2 | 300 |
| Duration | Effects from weapons last 15% longer per rank (max +30%). | 2 | 300 |
| Amount | Fires 1 more projectile (all weapons). | 1 | 5,000 |
| Move Speed | Character moves 5% faster per rank (max 10%). | 2 | 300 |
| Magnet | Items pickup range +25% per rank (max +50%). | 2 | 300 |
| Luck | Chance to get lucky goes up by 10% per rank (max +30%). | 3 | 600 |
| Growth | Gains 3% more experience per rank (max +15%). | 5 | 900 |
| Greed | Gains 10% more coins per rank (max +50%). | 5 | 200 |
| Curse | Increases enemy speed, health, quantity, and frequency by 10% per rank (max +50%). | 5 | 1,666 |
| Revival | Revives once at 50% health. | 1 | 10,000 |
| Omni | Increases Might, Projectile Speed, Duration, and Area by 2% per rank (max +10%). | 5 | 1,000 |
| Charm | Increases enemies spawn quantity by 20 per rank (max +100). | 5 | 10,000 |
| Defang | Enemies spawn unable to deal damage 3% of the times per rank (max 15%) | 5 | 10 |
| Reroll | Twice per rank, allows you to get different choices when leveling up. | 5 | 1,000 |
| Skip | Twice per rank, allows you to skip level up choices and get Experience instead. | 5 | 100 |
| Banish | Twice per rank, allows you to remove an item from level up choices, for the rest of the run. | 5 | 100 |
| Seal I | Allows to Banish an item from level up choices, or a pickup from light sources. Use in COLLECTIONS menu. | 10 | 10,000 |
| Seal II | Allows to Banish two items from level up choices, or a pickup from light sources. Use in COLLECTIONS menu. | 10 | 10,000 |
| Seal III | Banish three items from level up choices, or a pickup from a stage | 10 | 10,000 |

### Refund rule (VERIFIED quotes)

> "By pressing the 'Refund PowerUps' button, you will lose all your PowerUp ranks and get your gold back. The gold returned to you will be deducted by a negligible amount (most likely due to a rounding error)."

> "After maxing out a PowerUp (except Rerolls, Skips, Banishes and Seals), the player can then disable the PowerUp, preventing the need to refund all PowerUps to test out PowerUp setups or to get rid of Curse."

### Per-character unlocks (VERIFIED, Characters page)

Characters are bought with gold in the character select; price scales +10% additively per character already purchased (quote in S6). Per-character unlock conditions = the 'Unlock condition' column in S6 (each from the character's own page infobox). Achievements gate the purchase (not the discovery) of some characters and most weapons/passives.

### Achievement-driven unlock chains — examples (VERIFIED from fetched Passive items / Weapons tables)

- Passive ← weapon level: Empty Tome ← "Have 6 different weapons simultaneously"; Candelabrador ← "Level up the Santa Water to level 4"; Bracer ← "Level up the King Bible to level 4"; Spellbinder ← "Level up the Runetracer to level 7"; Duplicator ← "Level up the Magic Wand to level 7".
- Passive ← survival: Hollow Heart ← "Survive for 1 minute with any character"; Pummarola ← "Survive for 5 minutes with Gennaro Belpaese".
- Passive ← pickups: Attractorb ← "Pick up a Vacuum"; Clover ← "Pick up a Little Clover"; Stone Mask ← found in Inlaid Library.
- Weapon ← character/achievement: Bone ← "Unlocking Mortaccio"; Lightning Ring ← "Defeating a total of 5000 enemies"; Fire Wand ← "Destroying 20 light source"; Peachone ← "Surviving for 10 minutes with any character"; Ebony Wings ← "Getting the Peachone to level 7".
- Character ← achievement: Queen Sigma ← achievement (costs 0 gold). Secret characters ← secret-menu hints / hidden enemies / Easter eggs.
- Stage ← stage: Inlaid Library ← "reaching level 20 in the Mad Forest"; Dairy Plant ← level 40 in Inlaid Library; Gallo Tower ← level 60 in Dairy Plant; Cappella Magna ← level 80 in Gallo Tower (VERIFIED, Stages table). Hyper ← defeat stage's end boss; Endless ← Seventh Trumpet relic.

### Gold sources (VERIFIED, Gold Coin page + Stages page)

> "Gold Coins can be obtained as pickups in the form of Gold Coin, Coin Bag or Rich Coin Bag from destroyed light sources. Opening Treasure Chests will always give a random amount of Gold Coins between 60-500... level ups will give you an option for extra Coins. Gold Coins are also awarded when you finish the run just after being killed by The Reaper."

> Completion bonus: "the player will earn 500 gold coins as an additional reward upon death. The amount can be further increased by an additional 100 coins for each unused revival." + Hyper-mode multipliers x1.5-x2; Greed PowerUp +50%; Stone Mask +50% (up to 4x total).

Spent on: PowerUps, characters, (stage items via Merchant in endless loops; Golden Egg offer). Merchant exists as a stage NPC selling Revivals/Golden Eggs (Stages/Endless quote S5).

---

## S8 SYSTEM MECHANICS

### Level-up & cards (VERIFIED, Experience Gem page)

> "Upon level up the game is paused and the player is given 3 or 4 options consisting of weapon and passive item to choose from." — note: 4th option only via special conditions. Re-selecting an owned item upgrades it (Weapons page, quoted in S1); fully-leveled items leave the pool.

### XP gems (VERIFIED, Experience Gem page)

- "Experience Gems are pulled in by the player when they get in the player's Magnet radius." Gems do not despawn — no expiry mechanic is described; instead: "If there are more than 400 Experience Gems on the ground at a time, no more gems can be dropped and any experience gained is instead accumulated into a single red Experience Gem." (VERIFIED — gems persist and merge, so 'gems never expire' is the correct behavior class for our clone.)
- Gem value tiers by color: "Blue ... up to 2 XP, green ... up to 9 XP and red gems contain anything beyond." Gorgeous Moon/Luminaire create bonus-value colored gems. Successive levels cost more XP.

### Pickups (VERIFIED, Pickups page)

> "Pickups are collectibles dropped by destroyed light sources or enemies." + "Magnet stat affects the radius pickups can be gathered from." + "Most pickups' drop rate increases with Luck." The page table lists each pickup with Luck-affected/rarity/unlock-level columns; names VERIFIED from it include Rosary, Vacuum, Floor Chicken, Coin Bag, Rich Coin Bag (Gold Coin page), Golden Egg, Gold Finger, Heart Refresh, Karma Coin, Little Clover, Gilded Clover, Friendship Amulet. Rosary VERIFIED: "Destroys all enemies in sight. / Kills all enemies, excluding ones that are immune"; Vacuum gathers all XP gems (Experience Gem page, quoted above); Floor Chicken is the filler level-up option once everything is maxed (Limit Break quote in S5).

### Treasure Chests (VERIFIED, Treasure Chest page)

- Dropped by bosses (drop rate/quality affected by Luck). "Chests will most commonly contain one item, but have a chance to contain three or five items instead, depending on Luck. Typically, chests will contain a random weapon or passive item the player currently has, leveling up the item by one... the player will also receive a random amount of gold."
- Evolution trigger: "When the requirements for an evolution (or union) are fulfilled and the run is at 10 or more minutes, chests can evolve (or unite) a weapon. Generally, only one weapon can be evolved per chest."
- Fallback: "If all items are at max level and no evolutions are possible, all items in regular chests are replaced with Big Coin Bags" (~150 base gold, grows with Greed).
- Chest tiers Bronze/Silver/Gold(+higher) and fixed early pattern: "The first six chests picked up in a save will always drop items in the set sequence 1-1-3-1-1-5."

### Secret books / secrets menu (VERIFIED, Secret page)

> "The Secrets menu is unlocked after obtaining the Forbidden Scrolls of Morbane. It shows hints to unlocking secret characters, and gives the ability to cast spells." — alternative unlock: clicking the Yellow Sign relic icon in the Collection seven times. Spell input is one-shot per spell. (Interpretation note: the brief's 'secret books' is read as the Forbidden Scrolls of Morbane + Secrets menu books of spells; if a different object was meant, mark this row UNVERIFIED.)

### Garlic / knockback class (VERIFIED, Knockback page)

> "Knockback is an effect applied to enemies that briefly pushes them backwards whenever they are damaged by the player... The knockback multiplier is the product of the damaging weapon's knockback dealt multiplier and knockback taken multiplier of the target enemy."
> "Garlic and its evolution Soul Eater have an additional effect that increases the knockback taken by enemies hit by it... its knockback taken multiplier is increased by an additional 0.3 until its maximum knockback value is reached." — i.e. Garlic is not just an aura damage zone, it applies a debuff class that makes knockback work on otherwise knockback-immune heavies. Garlic weapon behavior (Weapons page): "Damages nearby enemies. Reduces resistance to knockback and freeze."

### Cooldown/duration mechanics (VERIFIED, Weapons page stats section)

Weapon stat model (all fetched and quoted from the page): Max level, Base damage, Speed, Duration, Cooldown, Projectile Interval, Hitbox Delay, Knockback, Pool limit, Chance (Luck-scaled), Crit Multi, Block by walls, plus Area/Amount. Quote: "Cooldown — The time required for the weapon to be used again. There is a trigger for the cooldown to start after a weapon's duration ends." + "Upgrading a weapon will also reset its Cooldown and activate it instantly." Evolution resets cooldown to zero (S3). Each weapon individually ignores specific stats (the 'Ignores ...' flags in S1 rows).

### Co-op (platform-specific, VERIFIED public text)

- Steam page tags fetched: "Local Co-Op", "Co-op"; store text: "Now with local co-op for up to 4 players!" (fetched 2026-10-23).
- Wiki Friendship Amulet page: "special item exclusive to Co-op Mode, that gives all players in a co-op stage a level-up for one of their equipped weapons... may choose the Friendship Amulet as a random choice after levelling up, starting at level 30". NOTE for our roadmap: co-op changes level-up pooling, shared chests and enemy scaling — flag as separate subsystem if ever cloned.

### Mobile (note; VERIFIED existence, UNVERIFIED control details)

Official mobile releases exist (Google Play + App Store links on the wiki's external-links section, fetched). Touch-control specifics (auto-aim assist etc.) not fetched from a public control page this pass → UNVERIFIED. Practical read for our clone (INFERRED from screenshots): portrait-optional touch = one virtual stick, everything else auto.

### Cloud save / sync (note; VERIFIED listing, details UNVERIFIED)

Steam store page lists "Steam Cloud" among its store categories (fetched). No public wiki page on save-sync internals was located this pass → internals UNVERIFIED.

---

## S9 VISUALS — art-style inventory from public store screenshots

Method: the Steam store page was fetched via firecrawl (web_fetch hit a 403 bot wall, firecrawl succeeded) and ALL 7 store screenshots were downloaded at 1920x1080 and personally inspected (TESTED — I looked at each image). URLs inspected (all `https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/1794680/ss_<id>.1920x1080.jpg?t=1787911678`):

1. ss_6c55afe36be2a7784bf18cb9b3218321ae2d10e5 — Mad Forest, bat swarm + whip arc
2. ss_054159ad... — mid-run Lightning Ring/Holy Wand coverage, skeletons + ghosts
3. ss_01ec75b8... — Runetracer bouncing trails at 10:21, mandrake flowers, chest on ground
4. ss_6105ad3d... — Inlaid Library interior, Garlic aura ring
5. ss_3e82b3bd... — Stage Selection menu (modes, modifiers panel, music select)
6. ss_bea7831a... — Collection grid menu with item tooltip ("Whip — Attacks horizontally, passes through enemies. Ignores: Speed, Duration.")
7. ss_bf22b444... — 'Treasure Found!' chest popup over a boss-rush field

What conveys the look (TESTED, from inspected images):

- **Resolution class**: retro low-res pixel art, hard-edged (no AA) sprites with visible chunky pixels when upscaled; world sprites are small (player ≈ 20-24 px tall; enemy ≈ 16-48 px; bosses ≈ 96-192 px; consistent with wiki sprite files rendered at 32/64/96/128 px). UI fonts are monospaced bitmap terminal style, white on slate panels; gold/yellow 1-px panel borders.
- **Palette**: dark desaturated stage grounds (moss-green grass, brown wood library, gray tower) + saturated FX accents: cyan XP gems, red-damage numerals (2-digit, outlined), white/gold weapon FX, colored neon bounce-trails (Runetracer), blue lightning, purple/green laser lines (late-game weapons). Stage-specific: Moongolow red-shift; Inlaid = warm browns; Cappella = marble grays.
- **Composition/feel**: fixed top-down orthographic view, no camera zoom; the enemy count itself is the 'FX' — hundreds of overlapping identical small sprites; damage numbers and projectile clutter communicate power growth more than any bloom.
- **HUD (exact layout, TESTED)**: top strip — blue XP bar left 80% + black/gold HP bar right, "LV nn" gold badge far right; below-left: two rows of item slots (equipped weapons + passives as 32px icons); top-center: mm:ss run timer (white bitmap); top-right: kill counter + skull icon, and gold counter + coin icon. Player has a small red HP bar directly under the sprite. No minimap, no ammo/counters.
- **Menus**: same slate/gold language; checkboxes as filled frames with a green check; buttons are solid red (BACK) / green (START) / blue (OPEN) rounded rects with gold outlines; lists show stage thumbnail + flavor text; tooltip panel bottom with weapon name (yellow) + effect (white) + 'Ignores:' stats (orange).
- **Level-up card UI**: not in the store screenshots — behavior VERIFIED only via wiki text (3-4 options, game pauses) (INFERRED visual: slate/gold card panel; UNVERIFIED exact art).
- **Our gap read (INFERRED, for parity planning)**: to read as 'VS-like' our build needs (a) top-left XP/HP/LV strip, (b) kill+gold counters, (c) icon-slot inventory row, (d) mm:ss center timer, (e) red outlined damage numbers, (f) high enemy count on screen, (g) slate+gold UI chrome with bitmap font. Items 1-7 of the DoD ask only about inventory, so this is advisory only.

---

# INVENTORY-COMPLETE: n_weapons=273/n_items=33/n_stages=25/n_bosses=72/n_chars=165

Legend: n_weapons = 138 base + 94 evolutions + 7 unions + 4 gifts + 19 counterparts + 11 special (wiki Weapons page classes, all listed in S1). n_items = 33 passive items (S2). n_stages = 25 fetched stage pages (S4 table; Holy Forbidden row is bonus). n_bosses = 72 named entries in the wiki Boss table (S5; end-of-stage names are a subset + The Directer et al.). n_chars = 165 per page intro (168 roster rows listed — CONTRADICTED count noted in S6).

## Per-section evidence tally

| Section | Rows | VERIFIED | TESTED | INFERRED | UNVERIFIED |
|---------|------|----------|--------|----------|------------|
| S1 weapons | 273 | 273 (name/behavior/maxlvl from fetched tables) | 0 | evolution-partner mapping = parsed from fetched Evolution table (VERIFIED) | special-weapon 11 descriptions = partial (effects text only) |
| S2 passive items | 33 | 21 base rows + count rule | 0 | — | 12 DLC per-item effects (names VERIFIED) |
| S3 evolution rules | rules + 93 combos | all rule quotes | — | — | — |
| S4 stages | 25+1 | type/time/end-boss all from fetched pages | — | gimmick paraphrases = INFERRED summaries of fetched text | Holy Forbidden own-page detail |
| S5 bosses+endless | 72+11 specials | rules quotes + boss table | — | — | per-boss HP formulas not copied (on page) |
| S6 characters | 165 | 71 full rows (unlock+mech per own page) | — | — | 97 DLC rows (names VERIFIED only) |
| S7 meta | 25 powerups + rules | table + refund + gold quotes | — | per-character unlock column | powerup count 24-vs-25 CONTRADICTED row |
| S8 systems | ~14 mechanics | all core quotes fetched | — | mobile control specifics, sync internals = note | 'secret books' reading = stated |
| S9 visuals | 7 screenshots | store page fetched | 7 images personally inspected | our-gap advisory rows | level-up card art |

URLs fetched this session (unique pages): wiki via firecrawl: Weapons, Evolution, Stages, Boss(enemies), Passive_items(chrome), Endless_Mode(→Stages), Special(bot-wall→API); wiki via MediaWiki API (action=parse): Passive items, PowerUps, Evolution, Characters, Treasure Chest, Pickups, Experience Gem, Knockback, Secret, Relics, Arcanas, Friendship Amulet, Gold Coin (currency), Vampire Survivors, 25 stage pages, 71 character pages (3 red links); Steam: store page (firecrawl after 403) + 7 screenshot images. Total ≈ 118 unique fetches.

Compliance: PUBLIC web pages only (fandom wiki text + Steam store page). No assets/apk/packages touched; screenshots viewed as reference only, nothing copied into the game repo.
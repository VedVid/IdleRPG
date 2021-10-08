pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
function _init()
 button_chosen = 1
 game_buttons = make_game_menu()
 eq_buttons = make_eq_menu()
 game_place = "dungeon"
 game_fight = false
 game_scene = "main screen"
 player = make_player()
 enemy = make_enemy()
end

function _update()
 calc_player_eq()

 if game_scene == "main screen" then
  handle_main_screen()
 elseif game_scene == "eq" then
  handle_eq_screen()
 end
end

function _draw()
 cls()
 if (game_scene == "main screen") then
  draw_main_scene()
 elseif (game_scene == "eq") then
  draw_eq_screen()
 end
end

function handle_main_screen()
 if not game_fight then
  restart_bar(player.attack_bar)
  restart_bar(enemy.attack_bar)
 end
 
 if game_fight then
  animate_bar(player.attack_bar)
  animate_bar(enemy.attack_bar)
  fight(player, enemy)
 end

 if (btnp(4)) then
  if not game_fight then
   if button_chosen == 1 then
    game_fight = true
   elseif button_chosen == 2 then
    button_chosen = 1
    game_scene = "eq"
   end
  end
 end

 player.hp_bar.frame =
  calc_static_bar(player.current_hp,
                  player.max_hp)
 player.xp_bar.frame =
  calc_static_bar(player.current_xp,
                  player.xp_to_lvl_up)

 choose_button(game_buttons, "v")
end

function handle_eq_screen()
 if (btnp(4)) then
  if button_chosen == 1 then
   game_scene = "main screen"
  end
 end
 choose_button(eq_buttons, "h")
end

-->8
function make_progress_bar(sprites, anim_speed)
 local bar={}
 bar.sprites = sprites
 bar.anim_speed = anim_speed
 bar.tick = 0
 bar.frame = 1
 return bar
end

function animate_bar(bar)
 bar.tick = (bar.tick+1) % bar.anim_speed
 if (bar.tick==0) then
  bar.frame = (bar.frame%#bar.sprites)+1
 end
end

function restart_bar(bar)
 bar.tick = 0
 bar.frame = 1
end

function draw_bar(bar, x, y)
 spr(bar.sprites[bar.frame],
     x, y)
end

-->8
function make_player()
 local player = {}
 player.max_hp = 10
 player.current_hp = 10
 player.damage = 0
 player.attack_speed = 0
 player.defense = 0
 player.current_xp = 0
 player.xp_to_lvl_up = 100
 player.attack_bar = 
  make_progress_bar({9,10,11,12},
                    player.attack_speed)
 player.hp_bar =
  make_progress_bar({5,6,7,8},
                    0)
 player.hp_bar.frame = 4
 player.xp_bar =
  make_progress_bar({1,2,3,4},
                    0)
 player.gold = 0
 player.equipment = {}
 player.equipment.head = {
  name = "l.cap", lvl = 1,
  def = 1}
 player.equipment.torso = {
  name = "l.vest", lvl = 1,
  def = 1}
 player.equipment.arms = {
  name = "l.gauntlet", lvl = 1,
  def = 1}
 player.equipment.right_hand = {
  name = "sh.sword", lvl = 1,
  dmg = 3, as = 3}
 player.equipment.left_hand = {
  name = "nothing", lvl = 0}
 player.equipment.legs = {
  name = "cl.trousers", lvl = 1}
 player.equipment.feet = {
  name = "l.boots", lvl = 1,
  def = 1}
 return player
end

function calc_player_eq()
 local dmg = 0
 local as = 0
 local def = 0
 for k, v in pairs(player.equipment) do
  if v.dmg then
   dmg += v.dmg
  end
  if v.as then
   as += v.as
  end
  if v.def then
   def += v.def
  end
 end
 player.damage = dmg
 player.attack_speed = as
 player.defense = def
 player.attack_bar.anim_speed = player.attack_speed
end
 

function calc_static_bar(val1, val2)
 local sprite
 if (val1 < val2 * 0.25) then
  sprite = 1
 elseif (val1 < val2 * 0.5) then
  sprite = 2
 elseif (val1 < val2 * 0.75) then
  sprite = 3
 else
  sprite = 4
 end
 return sprite
end

function draw_eq(x, y, eq)
 print("equipment:", x-4, y, 6)
 print("head:   "..eq.head.name.." (lvl."..eq.head.lvl..")", x, y+8, 6)
 print("torso:  "..eq.torso.name.." (lvl."..eq.torso.lvl..")", x, y+16, 6)
 print("arms:   "..eq.arms.name.." (lvl."..eq.arms.lvl..")", x, y+24, 6)
 print("r hand: "..eq.right_hand.name.." (lvl."..eq.right_hand.lvl..")", x, y+32, 6)
 print("l hand: "..eq.left_hand.name.." (lvl."..eq.left_hand.lvl..")", x, y+40, 6)
 print("legs:   "..eq.legs.name.." (lvl."..eq.legs.lvl..")", x, y+48, 6)
 print("feet:   "..eq.feet.name.." (lvl."..eq.feet.lvl..")", x, y+56, 6)
end

function make_enemy()
 local enemy = {}
 enemy.max_hp = 5
 enemy.current_hp = 5
 enemy.damage = 2
 enemy.attack_speed = 5
 enemy.defense = 2
 enemy.xp = 50
 enemy.gold = 25
 enemy.attack_bar =
  make_progress_bar({5,6,7,8},
                    enemy.attack_speed)
 return enemy
end

function fight(player, enemy)
 local all_alive = true
 if (player.current_hp <= 0 or
     enemy.current_hp <= 0) then
  all_alive = false
 end
 if all_alive == true then
  if (player.attack_bar.frame == 1 and
      player.attack_bar.tick == 0) then
   enemy.current_hp -= flr(rnd(player.damage+1))
  end
  if (enemy.current_hp <= 0) then
   player.current_xp += enemy.xp
   player.gold += enemy.gold
   all_alive = false
  end
 end
 if all_alive == true then
  if (enemy.attack_bar.frame == 1 and
      player.attack_bar.tick == 0) then
   player.current_hp -= flr(rnd(enemy.damage+1))
  end
  if (player.current_hp <= 0) then
   all_alive = false
  end
 end
 if all_alive == false then
  game_fight = false
 end
end

-->8
function make_button(x, y, text)
 local button = {}
 button.x = x
 button.y = y
 button.text = text
 return button
end

function make_game_menu()
 local buttons = {}
 local explore_button = make_button(
  100, 104, "explore")
 add(buttons, explore_button)
 local eq_button = make_button(100,
  112, "eq")
 add(buttons, eq_button)
 return buttons
end

function draw_buttons(buttons)
 for i = 1, #buttons do
  col = 5
  if i == button_chosen then
   col = 7
  end
  print(buttons[i].text,
   buttons[i].x,
   buttons[i].y,
   col)
 end
end

function make_eq_menu()
 local buttons = {}
 local back_button = make_button(100,
  104, "go back")
 add(buttons, back_button)
 return buttons
end

function choose_button(buttons, layout)
 -- default layout is "h"orizontal
 local prev_item = 0
 local next_item = 1
 if (layout == "v") then
  prev_item = 2
  next_item = 3
 end
 if (btnp(prev_item)) then
  button_chosen -= 1
  if (button_chosen <= 0) then
   button_chosen = #buttons
  end
 elseif (btnp(next_item)) then
  button_chosen += 1
  if (button_chosen > #buttons) then
   button_chosen = 1
  end
 end
end

-->8
function draw_main_scene()
 print(game_place, 8, 4, 6)
 if game_fight then
  print("fight", 48, 4, 8)
 end
 print("p.attack:", 8, 16, 6)
 draw_bar(player.attack_bar, 48, 16)
 print("e.attack:", 64, 16, 6)
 draw_bar(enemy.attack_bar, 104, 16)
 
 print("hp: ", 8, 104, 6)
 draw_bar(player.hp_bar, 21, 104)
 print(player.current_hp.."/"..player.max_hp, 32, 104, 8)
 print("xp: ", 8, 112, 6)
 draw_bar(player.xp_bar, 21, 112)
 print(player.current_xp, 32, 112, 9)
 print("gold: ", 8, 120, 6)
 print(player.gold, 32, 120, 10) 

draw_buttons(game_buttons)
end

function draw_eq_screen()
 draw_eq(8, 32, player.equipment)
 draw_buttons(eq_buttons)
end
__gfx__
00000000999999999999999999999999999999998888888888888888888888888888888833333333333333333333333333333333000000000000000000000000
00000000900000099aa000099aaaa0099aaaaaa9800000088ee000088eeee0088eeeeee8300000033bb000033bbbb0033bbbbbb3000000000000000000000000
00700700900000099aa000099aaaa0099aaaaaa9800000088ee000088eeee0088eeeeee8300000033bb000033bbbb0033bbbbbb3000000000000000000000000
00077000900000099aa000099aaaa0099aaaaaa9800000088ee000088eeee0088eeeeee8300000033bb000033bbbb0033bbbbbb3000000000000000000000000
00077000999999999999999999999999999999998888888888888888888888888888888833333333333333333333333333333333000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c000000c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c000000c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c000000c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c000000c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c000000c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c000000c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00006060606066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00006060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00006660606066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00006060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00006060066066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000666000006660666066606660066060600000000033333333000000006660000066606660666066600660606000000000888888880000000000000000
00000000606000006060060006006060600060600600000030000003000000006000000060600600060060606000606006000000800000080000000000000000
00000000666000006660060006006660600066000000000030000003000000006600000066600600060066606000660000000000800000080000000000000000
00000000600000006060060006006060600060600600000030000003000000006000000060600600060060606000606006000000800000080000000000000000
00000000600006006060060006006060066060600000000030000003000000006660060060600600060060600660606000000000800000080000000000000000
00000000000000000000000000000000000000000000000033333333000000000000000000000000000000000000000000000000888888880000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000666000006060666000000000888888880000000066600000606066600000000099999999000000000000000000000000000000000000000000000000
000000006060000060606060060000008eeeeee80000000060600000606060600600000090000009000000000000000000000000000000000000000000000000
000000006660000066606660000000008eeeeee80000000066600000060066600000000090000009000000000000000000000000000000000000000000000000
000000006000000060606000060000008eeeeee80000000060000000606060000600000090000009000000000000000000000000000000000000000000000000
000000006000060060606000000000008eeeeee80000000060000600606060000000000090000009000000000000000000000000000000000000000000000000
00000000000000000000000000000000888888880000000000000000000000000000000099999999000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000


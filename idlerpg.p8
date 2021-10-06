pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
function _init()
 game_state = "hub"
 player = make_player()
 enemy = make_enemy()
end

function _update()
 if game_state == "hub" then
  restart_bar(player.attack_bar)
  restart_bar(enemy.attack_bar)
  if (btn(4)) game_state = "fight"
 end
 if game_state == "fight" then
  animate_bar(player.attack_bar)
  animate_bar(enemy.attack_bar)
  fight(player, enemy)
 end
 player.hp_bar.frame =
  calc_static_bar(player.current_hp,
                  player.max_hp)
 player.xp_bar.frame =
  calc_static_bar(player.current_xp,
                  player.xp_to_lvl_up)
end

function _draw()
 cls()
 print(game_state, 4, 4)
 print("p.attack:", 8, 16)
 draw_bar(player.attack_bar, 48, 16)
 print("p.hp:", 8, 64)
 draw_bar(player.hp_bar, 32, 64)
 print("p.xp:", 48, 64)
 draw_bar(player.xp_bar, 72, 64)
 print("e.attack:", 64, 16)
 draw_bar(enemy.attack_bar, 104, 16)
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
 player.damage = 3
 player.attack_speed = 3
 player.defense = 2
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
 return player
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

function make_enemy()
 local enemy = {}
 enemy.max_hp = 5
 enemy.current_hp = 5
 enemy.damage = 2
 enemy.attack_speed = 5
 enemy.defense = 2
 enemy.xp = 50
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
  game_state = "hub"
 end
end

__gfx__
00000000999999999999999999999999999999998888888888888888888888888888888833333333333333333333333333333333000000000000000000000000
00000000900000099aa000099aaaa0099aaaaaa9800000088ee000088eeee0088eeeeee8300000033bb000033bbbb0033bbbbbb3000000000000000000000000
00700700900000099aa000099aaaa0099aaaaaa9800000088ee000088eeee0088eeeeee8300000033bb000033bbbb0033bbbbbb3000000000000000000000000
00077000900000099aa000099aaaa0099aaaaaa9800000088ee000088eeee0088eeeeee8300000033bb000033bbbb0033bbbbbb3000000000000000000000000
00077000900000099aa000099aaaa0099aaaaaa9800000088ee000088eeee0088eeeeee8300000033bb000033bbbb0033bbbbbb3000000000000000000000000
00700700999999999999999999999999999999998888888888888888888888888888888833333333333333333333333333333333000000000000000000000000

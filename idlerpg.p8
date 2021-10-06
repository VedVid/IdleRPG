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
  fight(player, enemy)
 end
 player.xp_bar.frame = calc_xp_bar()
 animate_bar(player.attack_bar)
 animate_bar(enemy.attack_bar)
end

function _draw()
 cls()
 print(game_state)
 draw_bar(player.xp_bar)
 draw_bar(player.attack_bar)
 draw_bar(enemy.attack_bar)
end
-->8
function make_progress_bar(x, y, sprites, anim_speed, updates_when)
 local bar={}
 
 bar.x = x
 bar.y = y
 bar.sprites = sprites
 bar.anim_speed = anim_speed
 bar.updates_when = updates_when
 bar.tick = 0
 bar.frame = 1

 return bar
end

function animate_bar(bar)
 if game_state == bar.updates_when then
  bar.tick = (bar.tick+1) % bar.anim_speed
  if (bar.tick==0) then
   bar.frame = (bar.frame%#bar.sprites)+1
  end
 end
end

function restart_bar(bar)
 bar.tick = 0
 bar.frame = 1
end

function draw_bar(bar)
 spr(bar.sprites[bar.frame],
     bar.x, bar.y)
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
  make_progress_bar(20, 10,
                    {9,10,11,12},
                    player.attack_speed,
                    "fight")
 player.xp_bar =
  make_progress_bar(10, 100,
                    {1,2,3,4},
                    0,
                    "")
 return player
end

function calc_xp_bar()
 if (player.current_xp < player.xp_to_lvl_up * 0.25) then
  xp_sprite = 1
 elseif (player.current_xp < player.xp_to_lvl_up * 0.5) then
  xp_sprite = 2
 elseif (player.current_xp < player.xp_to_lvl_up * 0.75) then
  xp_sprite = 3
 else
  xp_sprite = 4
 end
 return xp_sprite
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
  make_progress_bar(50, 10,
                    {5,6,7,8},
                    enemy.attack_speed,
                    "fight")
 return enemy
end

function fight(player, enemy)
 if (player.attack_bar.frame == 1 and
     player.attack_bar.tick == 0) then
  enemy.current_hp -= flr(rnd(player.damage+1))
 end
 if (enemy.current_hp <= 0) then
  player.current_xp += enemy.xp
  game_state = "hub"
 end
 if (enemy.attack_bar.frame == 1 and
     player.attack_bar.tick == 0) then
  player.current_hp -= flr(rnd(enemy.damage+1))
 end
 if (player.current_hp <= 0) then
  game_state = "hub"
 end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999999999999999999999999999998888888888888888888888888888888833333333333333333333333333333333000000000000000000000000
00700700900000099aa000099aaaa0099aaaaaa9800000088ee000088eeee0088eeeeee8300000033bb000033bbbb0033bbbbbb3000000000000000000000000
00077000900000099aa000099aaaa0099aaaaaa9800000088ee000088eeee0088eeeeee8300000033bb000033bbbb0033bbbbbb3000000000000000000000000
00077000900000099aa000099aaaa0099aaaaaa9800000088ee000088eeee0088eeeeee8300000033bb000033bbbb0033bbbbbb3000000000000000000000000
00700700900000099aa000099aaaa0099aaaaaa9800000088ee000088eeee0088eeeeee8300000033bb000033bbbb0033bbbbbb3000000000000000000000000
00000000999999999999999999999999999999998888888888888888888888888888888833333333333333333333333333333333000000000000000000000000

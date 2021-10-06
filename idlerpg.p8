pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
function _init()
 game_state = "hub"
 player_xp = make_progress_bar(
             10, 100,
             {1,2,3,4},
             0, "")
 enemy_attack = make_progress_bar(
                50, 10,
                {5,6,7,8},
                7, "fight")
 player_attack = make_progress_bar(
                 20, 10,
                 {9,10,11,12},
                 3, "fight")
end

function _update()
 if (enemy_attack.frame == 1 and enemy_attack.tick == 0) then
  game_state = "hub"
  restart_bar(enemy_attack)
  restart_bar(player_attack)
 end
 if game_state == "hub" then
  if (btn(4)) game_state = "fight"
 end
 animate_bar(player_xp)
 animate_bar(player_attack)
 animate_bar(enemy_attack)
end

function _draw()
 cls()
 print(game_state)
 draw_bar(player_xp)
 draw_bar(player_attack)
 draw_bar(enemy_attack)
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
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999999999999999999999999999998888888888888888888888888888888833333333333333333333333333333333000000000000000000000000
00700700900000099aa000099aaaa0099aaaaaa9800000088ee000088eeee0088eeeeee8300000033bb000033bbbb0033bbbbbb3000000000000000000000000
00077000900000099aa000099aaaa0099aaaaaa9800000088ee000088eeee0088eeeeee8300000033bb000033bbbb0033bbbbbb3000000000000000000000000
00077000900000099aa000099aaaa0099aaaaaa9800000088ee000088eeee0088eeeeee8300000033bb000033bbbb0033bbbbbb3000000000000000000000000
00700700900000099aa000099aaaa0099aaaaaa9800000088ee000088eeee0088eeeeee8300000033bb000033bbbb0033bbbbbb3000000000000000000000000
00000000999999999999999999999999999999998888888888888888888888888888888833333333333333333333333333333333000000000000000000000000

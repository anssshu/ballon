
--This is the main script which is goin to run at the start of my game
--[[
story of the game 
------------------------------
there should be a beautiful background
backround contains life  and score
and beautiful background music

----------------------------------
there is a tank which can move with left and right key  on top of a terrain 
--------------------------------------------------------------------------
it can cahnge the angle of its canaon sooter with the help of up  and  down key
----------------------------------------------------
when space button is fired bullets are  fired.
and a firing sound comes
---------------------------------------------------------------
there are baloons flying in the sky
when the bullet collides with the bullets collides with the baloons
the baloons bust and score increases
-------------------------------------------------------------
when the baloons escapes life goes down
life goes down music comes
------------------------------------------------------------
when life becomes zero game over scene comes telling to quit or restart
-------------------------------------------------------------------

]] 
function checkCol(rec1,rec2)
	if (rec1.x ~=nil and rec2.x ~=nil) then 
		ax1,ax2,ay1,ay2=rec1.x,rec1.x+rec1.w,rec1.y,rec1.y+rec1.h
		bx1,bx2,by1,by2=rec2.x,rec2.x+rec2.w,rec2.y,rec2.y+rec2.h
		return  (ax1<bx2 and ax2 >bx1 and ay1<by2 and ay2>by1)
	
	else 
		return "no check"
	end
	
end
--create the basic framework fr game designing
--the load function
function love.load()
  --load all the images
  
  gamestate="start"
  start_btn=love.graphics.newImage("assets/start_btn.png")
  baloon_img=love.graphics.newImage("assets/baloon.png")
  bg_img=love.graphics.newImage("assets/bg.png")
  gameover_img=love.graphics.newImage("assets/gameover.png")
  sky_img=love.graphics.newImage("assets/sky.png")
  cart_img=love.graphics.newImage("assets/cart.png")
  rect_img=love.graphics.newImage("assets/rect.png")
  fire_sound=love.audio.newSource("assets/fire.ogg","stream")
  hit_sound=love.audio.newSource("assets/pop.ogg","stream")
  fire_sound:setVolume(.09)
  back_music=love.audio.newSource("assets/back.ogg","stream")
  back_music:setVolume(1)
  back_music:setLooping(true)
  back_music:play(true)
  ------------------------------
  score=0
  life=5
  speed=2
  rotation_speed=2
  bullet_speed = 5
	--your code goes here
  map={left="left",right="right",up="up",down="down"}

  --create our mainplayer
  player={}
  player.x=350
  player.y=500
  player.w=50
  player.h=40

  --create an arm
  arm={}
 -- arm.x=player.x+player.w/2-arm.w/2
  --arm.y=player.y+player.h/2
  arm.w=10
  arm.h=-40
  arm.angle=.1
  function arm:rotate()
    
    love.graphics.push()
    love.graphics.translate(player.x+player.w/2-arm.w/2,player.y+10)
    love.graphics.rotate(self.angle)
    --love.graphics.rectangle("fill",0,0,arm.w,arm.h)
    love.graphics.draw(rect_img,0,-40)
    love.graphics.pop()
    
  end
  
  --cerate a bullet
  bullet={x=100,y=300,angle=.1}
  
  --create the bullet holder
  bullets={}
  
  
  --create baloons
 --baloon holder
 
--create a dadastructure for holding and working on our baloons
 baloons={
	--baloon_holder for holding each baloon
	baloon_holder={
			{x=300,y=300,w=60,h=80,img=baloon_img},{x=350,y=400,w=60,h=80,img=baloon_img}
			},
	--function to draw each baloon on the screen
	draw=function ()
		for k,v in pairs(baloons.baloon_holder) do 
			--love.graphics.rectangle("fill",v.x,v.y,v.w,v.h)
      love.graphics.draw(baloon_img,v.x,v.y)
		end	
 	     end,
	--function to update on each frame to update baloons position and collision detection
	update=function(dt)
			--for each baloon update its position
	       	  for k,v in pairs(baloons.baloon_holder) do  
				v.y=v.y-2
		        --if they go out of the screen delete them
				if v.y<50 then 
					table.remove(baloons.baloon_holder,k) 
					--reduce life
					if life ~=0 and gamestate ~="start" then life = life - 1 end
				end
		 	
				
		
			  end
	       end
}
---------------------end of baloons data structure ------------------------------------------ 
checkColEveryFrame=function()
	for k,v in pairs(baloons.baloon_holder) do 
		for k2,v2 in pairs(bullets) do
			if checkCol(v,v2) then 
				table.remove(baloons.baloon_holder,k) 
				table.remove(bullets,k2) 
				--increase the score 
				score=score +10
        hit_sound:play()
				
			end
		end
	end


end

--------------------------------------------------------------------------------------------------
  --create a timer to generate baloons
  timer={
		time=0,
		maxTime=1,
		--call it inside the update function
		startTimer=function(dt)
			timer.time=timer.time + dt
			if timer.time>timer.maxTime then
				--reset the timer
				timer.time=0
				--add a new baloon to the baloon holder
				table.insert(baloons.baloon_holder,{x=math.random(500),y=500,w=60,h=80,img=baloon_img})
			end
			end


}
  
  
   
  

  
  
  
end

------------------------------End of the Load function--------------------------------------------------
--the draw function
function love.draw()
 --  back_music:play()
	--your code goes here
  --set the background
  love.graphics.setBackgroundColor(255,255,255,255)
  love.graphics.draw(sky_img,0,0)
  baloons.draw()
  love.graphics.draw(bg_img,0,0)
  
  
  --draw life and score
  love.graphics.print("SCORE :",220,20)
  love.graphics.print(tostring(score),270,20)
  love.graphics.print("LIFE :",20,20)
  love.graphics.print(tostring(life),55,20)
  
  --love.graphics.rectangle("fill",player.x,player.y,player.w,player.h)
  --love.graphics.draw(cart_img,player.x-30,player.y)
  arm:rotate(arm.angle)
  love.graphics.draw(cart_img,player.x-30,player.y-5)
  
  --draw bullets
  for i,v in pairs(bullets) do 
	--print(v.x) 
	love.graphics.rectangle("fill",v.x,v.y,v.w,v.h)
  
  
end
  --love.graphics.rectangle('fill',320,330,150,50)
  --love.graphics.rectangle('fill',320,385,150,45)
  if gamestate =="gameover" then
    love.graphics.draw(gameover_img,200,200)
  end
  if gamestate =="start" then
    love.graphics.draw(start_btn,300,300)
  end
end


-------------------------------------------------------------------------------------
function love.mousepressed(x,y,button)
  --local bol =(button == 1 )
  print(x,y,button,gamestate,bol)
  
  if (button == 1 and x>320 and x<470 and y > 330 and y<380 and gamestate=="gameover") then 
    love.load() 
    gamestate="play"
  end
  if (button == 1 and x>320 and x<470 and y > 385 and y<430 and gamestate=="gameover") then love.event.quit() end
  
  if (button == 1 and x>300 and x<450 and y > 300 and y<367 and gamestate=="start") then 
    
    print("game stsrted")
    --love.load()
    gamestate="play" 
  end
  
end

----------------------------------------------------------------------------------------
--fire
function love.keypressed(key)
 print(key)
 if gamestate == 'play' then
  if key == "space" then 
	--print ("space if fired")
	table.insert(bullets,{x=player.x+player.w/2-(arm.h-4)*math.sin(arm.angle),y=player.y+(arm.h+10)*math.cos(arm.angle),angle=arm.angle,w=4,h=4})
	fire_sound:play()
  end

end   
end

---------------------------------------------------------------------------

--the update function
function love.update(dt)
 if life == 0 then gamestate = "gameover" end
 print (checkColEveryFrame())
 baloons.update(dt)
 timer.startTimer(dt)
	
	--code goes here
  --fire
  for i,v in pairs(bullets) do 
	
	v.y = v.y-math.cos(v.angle)*bullet_speed
	v.x=v.x+math.sin(v.angle)*bullet_speed
	
	
	--delete them when they are out of screen
	if (v.y<40) then table.remove(bullets,i) end
  end
  
  --listen for up ,down ,left and right buttons
if gamestate == "play" then
  --when left arrow is pressed
  if love.keyboard.isDown(map.left) and player.x >150 then 
    player.x=player.x-1*speed
  end
  
  --when right arrow is pressed
  if love.keyboard.isDown(map.right) and player.x <550 then 
    player.x=player.x+1*speed
  end
  
  --when up arrow  is pressed
  if love.keyboard.isDown(map.up) then 
    if arm.angle<math.pi/3 then
      arm.angle=arm.angle+dt*rotation_speed
    end
    
  end
  --when down arrow is pressed
  if love.keyboard.isDown(map.down) then 
    if arm.angle>-math.pi/3 then
      arm.angle=arm.angle-dt*rotation_speed
    end
  end

end
end

---------------------------------------------------------------------------------------------

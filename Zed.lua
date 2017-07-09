local ver = "0.05"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "Zed" then return end


require("DamageLib")
require("OpenPredict")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/Zed/master/Zed.lua', SCRIPT_PATH .. 'Zed.lua', function() PrintChat('<font color = "#00FFFF">Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/Zed/master/Zed.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local ZedMenu = Menu("Zed", "Zed")

ZedMenu:SubMenu("Combo", "Combo")
ZedMenu.Combo:Boolean("Q", "Use Q in combo", true)
ZedMenu.Combo:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
ZedMenu.Combo:Boolean("W", "Use W in combo", true)
ZedMenu.Combo:Boolean("E", "Use E in combo", true)
ZedMenu.Combo:Boolean("R", "Use R in combo", true)
ZedMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
ZedMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
ZedMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
ZedMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
ZedMenu.Combo:Boolean("RHydra", "Use RHydra", true)
ZedMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
ZedMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
ZedMenu.Combo:Boolean("Randuins", "Use Randuins", true)


ZedMenu:SubMenu("AutoMode", "AutoMode")
ZedMenu.AutoMode:Boolean("Level", "Auto level spells", false)
ZedMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
ZedMenu.AutoMode:Boolean("Q", "Auto Q", false)
ZedMenu.AutoMode:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
ZedMenu.AutoMode:Boolean("W", "Auto W", false)
ZedMenu.AutoMode:Boolean("E", "Auto E", false)
ZedMenu.AutoMode:Boolean("R", "Auto R", false)



ZedMenu:SubMenu("LaneClear", "LaneClear")
ZedMenu.LaneClear:Boolean("Q", "Use Q", true)
ZedMenu.LaneClear:Boolean("W", "Use W", true)
ZedMenu.LaneClear:Boolean("E", "Use E", true)
ZedMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
ZedMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)


ZedMenu:SubMenu("Harass", "Harass")
ZedMenu.Harass:Boolean("Q", "Use Q", true)
ZedMenu.Harass:Boolean("W", "Use W", true)


ZedMenu:SubMenu("KillSteal", "KillSteal")
ZedMenu.KillSteal:Boolean("Q", "KS w Q", true)
ZedMenu.KillSteal:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
ZedMenu.KillSteal:Boolean("E", "KS w E", true)
ZedMenu.KillSteal:Boolean("R", "KS w R", true)



ZedMenu:SubMenu("AutoIgnite", "AutoIgnite")
ZedMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)


ZedMenu:SubMenu("Drawings", "Drawings")
ZedMenu.Drawings:Boolean("DQ", "Draw Q Range", true)


ZedMenu:SubMenu("SkinChanger", "SkinChanger")
ZedMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
ZedMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)
	local ZedQ = {delay = 0.25, range = 900, width = 50, speed = 1700}
        
		
		

	--AUTO LEVEL UP
	if ZedMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if ZedMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 825) then
				if target ~= nil then 
                                      CastTargetSpell(target, _Q)
                                end
            end

            if ZedMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 600) then
				CastSkillShot(_W, target)
            end     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
            if ZedMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if ZedMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if ZedMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if ZedMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end

            if ZedMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 600) then
			 CastSkillShot(_E, target)
	    end

            if ZedMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 900) then
                 local QPred = GetPrediction(target,ZedQ)
                 if QPred.hitChance > (ZedMenu.Combo.Qpred:Value() * 0.1) then
                           CastSkillShot(_Q, QPred.castPos)
                 end
            end	

            if ZedMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if ZedMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if ZedMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end

	    if ZedMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, GetCastRange(myHero,_W)) then
			CastSkillShot(_W, target)
	    end
	    
	    
            if ZedMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 900) then             
                CastTargetSpell(target, _R)
            end	

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if ZedMenu.KillSteal.Q:Value() and Ready(_Q) and ValidTarget(target, 900) then
                 local QPred = GetPrediction(target,ZedQ)
                    if QPred.hitChance > (ZedMenu.KillSteal.Qpred:Value() * 0.1) then
                           CastSkillShot(_Q, QPred.castPos)
                    end
                end	


                if IsReady(_E) and ValidTarget(enemy, 600) and ZedMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                      CastSkillShot(_E, target)
  
                end
			
		if ZedMenu.KillSteal.R:Value() and Ready(_R) and ValidTarget(target, 900) then                
                           CastTargetSpell(target, _R)
                  
                end	
      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if ZedMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 900) then
	        	CastTargetSpell(closeminion, _Q)
                end

                if ZedMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 600) then
	        	CastSkillShot(_W, target)
	        end

                if ZedMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 600) then
	        	CastSkillShot(_E, target)
	        end

                if ZedMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if ZedMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end
        --AutoMode
        if ZedMenu.AutoMode.Q:Value() and Ready(_Q) and ValidTarget(target, 1000) then
                 local QPred = GetPrediction(target,ZedQ)
                 if QPred.hitChance > (ZedMenu.AutoMode.Qpred:Value() * 0.1) then
                           CastSkillShot(_Q, QPred.castPos)
                 end
        end	

        if ZedMenu.AutoMode.W:Value() then        
          if Ready(_W) and ValidTarget(target, 600) then
	  	      CastSkillShot(_W, target)
          end
        end
        if ZedMenu.AutoMode.E:Value() then        
	  if Ready(_E) and ValidTarget(target, 600) then
		      CastSkillShot(_E, target)
	  end
        end
        if ZedMenu.AutoMode.R:Value() and Ready(_R) and ValidTarget(target, 900) then                
                 CastTargetSpell(target, _R)
            end	
                
	--AUTO GHOST
	if ZedMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if ZedMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 825, 0, 200, GoS.Red)
	end

end)


OnProcessSpell(function(unit, spell)
	local target = GetCurrentTarget()        
       
        if unit.isMe and spell.name:lower():find("itemtiamatcleave") then
		Mix:ResetAA()
	end	
               
        if unit.isMe and spell.name:lower():find("itemravenoushydracrescent") then
		Mix:ResetAA()
	end

end) 


local function SkinChanger()
	if ZedMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Zed</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')






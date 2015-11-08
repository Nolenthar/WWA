/*
Copyright © CD Projekt RED 2015
*/

class DynamicScaling
{	

	public var TierOneLowestLevel, TierOneHighestLevel : int;
	public var TierTwoLowestLevel, TierTwoHighestLevel : int;
	public var TierThreeLowestLevel, TierThreeHighestLevel : int;
	public var TierFourLowestLevel, TierFourHighestLevel : int;
	public var TierFiveLowestLevel : int;
	
	public var TierOneMinimumAdded, TierOneMaximumAdded : int;
	public var TierTwoMinimumAdded, TierTwoMaximumAdded : int;
	public var TierThreeMinimumAdded, TierThreeMaximumAdded : int;
	public var TierFourMinimumAdded, TierFourMaximumAdded : int;
	public var TierFiveMinimumAdded, TierFiveMaximumAdded : int;

	public var TierOneGroupMinimumAdded, TierOneGroupMaximumAdded : int;
	public var TierTwoGroupMinimumAdded, TierTwoGroupMaximumAdded : int;
	public var TierThreeGroupMinimumAdded, TierThreeGroupMaximumAdded : int;
	public var TierFourGroupMinimumAdded, TierFourGroupMaximumAdded : int;
	public var TierFiveGroupMinimumAdded, TierFiveGroupMaximumAdded : int;
	
	public var TierOneHumanMin, TierOneHumanMax : int;
	public var TierTwoHumanMin, TierTwoHumanMax : int;
	public var TierThreeHumanMin, TierThreeHumanMax : int;
	public var TierFourHumanMin, TierFourHumanMax : int;
	public var TierFiveHumanMin, TierFiveHumanMax : int;
	
	public var MaximumLevelCap : int;

	// ---- General Begin ---- //
	
	function DurabilityDamage() : bool
	{
		return theGame.GetInGameConfigWrapper().GetVarValue('SCOptionG', 'DDamage');
	}
	
	function LevelRequirement() : bool
	{
		return theGame.GetInGameConfigWrapper().GetVarValue('SCOptionG', 'LVLReq');
	}
	
	function HeavyParryAllowed() : bool
	{
		return theGame.GetInGameConfigWrapper().GetVarValue('SCOptionG', 'PCheck');
	}
	
	function HeavyCounterAllowed() : bool
	{
		return theGame.GetInGameConfigWrapper().GetVarValue('SCOptionG', 'CCheck');
	}

	function BestiaryFix() : bool
	{
		return theGame.GetInGameConfigWrapper().GetVarValue('SCOptionG', 'BFix');
	}
	
	function ShowMonsterLevel() : bool
	{
		return theGame.GetInGameConfigWrapper().GetVarValue('SCOptionG', 'MonsLVL');
	}
	
	public function HardcoreModeCheck() : bool
	{
		return theGame.GetInGameConfigWrapper().GetVarValue('SCOptionG', 'HDCMode');
	}
	
	public function VanillaScaling() : bool
	{
		return theGame.GetInGameConfigWrapper().GetVarValue('SCOptionG', 'VSMode');
	}

	public function GMaxLevel() : int
	{
		return StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionG', 'MaxLVLP') );
	}	
	
	// ---- General End ---- //

	// ---- Experience Begin ---- //
	
	public function QuestXPScaling() : bool
	{
		return theGame.GetInGameConfigWrapper().GetVarValue('SCOptionE', 'QXPScaling');
	}
	
	public function XPScalingCheck() : bool
	{
		return theGame.GetInGameConfigWrapper().GetVarValue('SCOptionE', 'XPScaling');
	}
	
	public function ExperienceModifier() : float
	{
		return StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionE', 'XPMult') );
	}	

	public function QuestXPMult() : float
	{
		return StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionE', 'QXPMult') );
	}	
	
	public function GXPMult() : float
	{
		return StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionE', 'GXPMult') );
	}	
	
	// ---- Experience End ---- //

	// ---- Health Begin ---- //
	
	public function SetNormalHealthMultHuman() : float
	{
		return StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionH', 'HumanHP') );
	}
	
	public function SetNormalHealthMultMonster() : float
	{
		return StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionH', 'MonsterHP') );
	}
	
	public function SetGroupHealthMult() : float
	{
		return StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionH', 'GMonsterHP') );
	}

	public function SetMonsterHuntHealthMult() : float
	{
		return StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionH', 'CMonsterHP') );
	}
		
	public function SetBossHealthMult() : float
	{
		return StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionH', 'BossHP') );
	}
	
	// ---- Health End ---- //
	
	// ---- Damage Begin ---- //
	
	public function PlayerDamage() : float
	{
		return StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionD', 'PDam') );
	}

	public function PlayerDOTDamage() : float
	{
		return StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionD', 'PDOT') );
	}

	public function EnemyDOTDamage() : float
	{
		return StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionD', 'EDOT') );
	}
	
	public function HumanDamage() : float
	{
		return StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionD', 'HumDam') );
	}
	
	public function MonsterDamage() : float
	{
		return StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionD', 'MonDam') );
	}

	public function BossDamage() : float
	{
		return StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionD', 'BDam') );
	}	
	
	public function ContractDamage() : float
	{
		return StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionD', 'CMonDam') );
	}	
	
	// ---- Damage End ---- //
	
	// ---- Combat Start ---- //
	
	function LockOn() : bool
	{
		return theGame.GetInGameConfigWrapper().GetVarValue('SCOptionC', 'Lockon');
	}
	
	function LockOnMode() : bool
	{
		return theGame.GetInGameConfigWrapper().GetVarValue('SCOptionC', 'LockonM');
	}
	
	function CombatState() : bool
	{
		return theGame.GetInGameConfigWrapper().GetVarValue('SCOptionC', 'Combatstate');
	}
		
	function SkillDependant() : bool
	{
		return theGame.GetInGameConfigWrapper().GetVarValue('SCOptionC', 'ASSD');
	}
			
	function ADism() : bool
	{
		return theGame.GetInGameConfigWrapper().GetVarValue('SCOptionC', 'Dism');
	}
	
	public function FAI() : float
	{
		return StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionC', 'ASFA') );
	}
	
	public function FAIMax() : float
	{
		return StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionC', 'ASFAM') );
	}
		
	public function HAI() : float
	{
		return StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionC', 'ASHA') );
	}
	
	public function HAIMax() : float
	{
		return StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionC', 'ASHAM') );
	}
		
	public function DAI() : float
	{
		return StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionC', 'ASDR') );
	}
	
	public function DAIMax() : float
	{
		return StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionC', 'ASDRM') );
	}	
		
	public function FAIN() : float
	{
		return StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionC', 'ASFAN') );
	}
		
	public function HAIN() : float
	{
		return StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionC', 'ASHAN') );
	}
		
	public function DAIN() : float
	{
		return StringToFloat( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionC', 'ASDRN') );
	}
	
	// ---- Combat End ---- //
	
	// ---- MODIFY FROM HERE ONWARD ---- //
	
	public function XPScalingModifier() : float
	{
		var currlvl : int;
		var mod, scalingvalue : float;

		currlvl = thePlayer.GetLevel();
		
		//You can set the scaling modifier here. The algorhytm is the following: 1.0 - (yourlevel * scaling value)
		//For reference, let's say you are level 40, the formula goes 1.0 - (40 * 0,0115) which yields 0.54 ~ This will be the multiplier for the original experience.
		//Let's say the original experience is 100 (so without this you get 100 xp for slaying a monster) which gets multiplied by 0.54. This yields an XP gain of 54 instead of the normal 100.
		//This stops your from leveling up insanely fast as you gain levels, because the enemies also get higher and yield a lot more experience.
		scalingvalue = 0.0115;

		mod = 1.0 - (currlvl * scalingvalue);
		
		return mod;
	}
	
	public function SetValues()
	{
	
		//The level caps for the different level tiers are set here.
		//You fall into different tiers based on what level your character is,
		//so a level 15 Geralt will fall into tier two.
		TierOneLowestLevel   =  5;		TierOneHighestLevel   = 10;
		TierTwoLowestLevel   = 10;		TierTwoHighestLevel   = 20;
		TierThreeLowestLevel = 20;		TierThreeHighestLevel = 30;
		TierFourLowestLevel  = 30;		TierFourHighestLevel  = 40;
		TierFiveLowestLevel  = 40;		MaximumLevelCap = StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionG', 'MaxLVL') );

		TierOneMinimumAdded   = StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLM', 'T1M1') );		TierOneMaximumAdded   = StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLM', 'T1M2') );
		TierTwoMinimumAdded   = StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLM', 'T2M1') );		TierTwoMaximumAdded   = StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLM', 'T2M2') );
		TierThreeMinimumAdded = StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLM', 'T3M1') );		TierThreeMaximumAdded = StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLM', 'T3M2') );
		TierFourMinimumAdded  = StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLM', 'T4M1') );		TierFourMaximumAdded  = StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLM', 'T4M2') );
		TierFiveMinimumAdded  = StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLM', 'T5M1') );		TierFiveMaximumAdded  = StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLM', 'T5M2') );

		TierOneGroupMinimumAdded   = StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLGM', 'T1GM1') );		TierOneGroupMaximumAdded   = StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLGM', 'T1GM2') );
		TierTwoGroupMinimumAdded   = StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLGM', 'T2GM1') );		TierTwoGroupMaximumAdded   = StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLGM', 'T2GM2') );
		TierThreeGroupMinimumAdded = StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLGM', 'T3GM1') );		TierThreeGroupMaximumAdded = StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLGM', 'T3GM2') );
		TierFourGroupMinimumAdded  = StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLGM', 'T4GM1') );		TierFourGroupMaximumAdded  = StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLGM', 'T4GM2') );
		TierFiveGroupMinimumAdded  = StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLGM', 'T5GM1') );		TierFiveGroupMaximumAdded  = StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLGM', 'T5GM2') );

		TierOneHumanMin   =	StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLH', 'T1H1') );					TierOneHumanMax   = StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLH', 'T1H2') );
		TierTwoHumanMin	  =	StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLH', 'T2H1') );					TierTwoHumanMax   = StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLH', 'T2H2') );
		TierThreeHumanMin =	StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLH', 'T3H1') );					TierThreeHumanMax = StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLH', 'T3H2') );
		TierFourHumanMin  =	StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLH', 'T4H1') );					TierFourHumanMax  = StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLH', 'T4H2') );
		TierFiveHumanMin  =	StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLH', 'T5H1') );					TierFiveHumanMax  = StringToInt( theGame.GetInGameConfigWrapper().GetVarValue('SCOptionLH', 'T5H2') );
		
	}

}
/////////////////////////////////////////
/////								/////
/////	Absolute Camera by pMarK	/////
/////								/////
/////////////////////////////////////////

enum ERGTSTATE {
	RGT_Exploration,
	RGT_ExplorationOFF,
	RGT_Combat,
	RGT_CombatOFF,
	RGT_CombatLocked,
	RGT_CombatLockedOFF,
	RGT_Horse,
	RGT_HorseOFF,
	RGT_HorseCombat,
	RGT_HorseCombatOFF,
	RGT_Boat,
	RGT_BoatOFF,
	RGT_Interiors,
	RGT_InteriorsOFF,
	RGT_WitcherSenses,
	RGT_WitcherSensesOFF,
	RGT_MasterOFF
}

class CRGTAbsoluteCamera {
	
	private var inGameConfigWrapper : CInGameConfigWrapper;
	
	private var rgtCamState : ERGTSTATE;
	
	private var isForceModeOn : bool;
	private var isExpCameraEnabled : bool;
	private var isCbtCameraEnabled : bool;
	private var isLockedCameraEnabled : bool;
	private var isHorseCameraEnabled : bool;
	private var isCbtHorseCameraEnabled : bool;
	private var isWsCameraEnabled : bool;
	private var isIntCameraEnabled : bool;
	private var isBoatCameraEnabled : bool;
	
	private var rgtExpOffsetX : float;
	private var rgtExpOffsetY : float;
	private var rgtExpOffsetZ : float;
	
	private var rgtCbtOffsetX : float;
	private var rgtCbtOffsetY : float;
	private var rgtCbtOffsetZ : float;
	
	private var rgtHorseOffsetX : float;
	private var rgtHorseOffsetY : float;
	private var rgtHorseOffsetZ : float;
	
	private var rgtCbtHorseOffsetX : float;
	private var rgtCbtHorseOffsetY : float;
	private var rgtCbtHorseOffsetZ : float;
	
	private var rgtBoatOffsetX : float;
	private var rgtBoatOffsetY : float;
	private var rgtBoatOffsetZ : float;
	
	private var rgtIntOffsetX : float;
	private var rgtIntOffsetY : float;
	private var rgtIntOffsetZ : float;
	
	private var rgtWsOffsetX : float;
	private var rgtWsOffsetY : float;
	private var rgtWsOffsetZ : float;
	
	private var rgtLockOffsetX : float;
	private var rgtLockOffsetY : float;
	private var rgtLockOffsetZ : float;
	
	private var rgtAmountOffsetPerHit : float;
	
	private var rgtShoulderIsToggled : bool;	    default rgtShoulderIsToggled = false;
	
	private var rgtMsgErrorForceMode : string;
	
	public function InitRGTAbsoluteCamera()
	{
		inGameConfigWrapper = theGame.GetInGameConfigWrapper();
		
		isForceModeOn = inGameConfigWrapper.GetVarValue('RGTotherSettings', 'ForceRGTmSettings');
		isExpCameraEnabled = inGameConfigWrapper.GetVarValue('RGTexp', 'ACexpEnable');
		isCbtCameraEnabled = inGameConfigWrapper.GetVarValue('RGTcbt', 'ACcbtEnable');
		isLockedCameraEnabled = inGameConfigWrapper.GetVarValue('RGTlocked', 'AClockedEnable');
		isHorseCameraEnabled = inGameConfigWrapper.GetVarValue('RGThorse', 'AChorseEnable');
		isCbtHorseCameraEnabled = inGameConfigWrapper.GetVarValue('RGTcbthorse', 'ACcbthorseEnable');
		isWsCameraEnabled = inGameConfigWrapper.GetVarValue('RGTws', 'ACwsEnable');
		isIntCameraEnabled = inGameConfigWrapper.GetVarValue('RGTint', 'ACintEnable');
		isBoatCameraEnabled = inGameConfigWrapper.GetVarValue('RGTboat', 'ACboatEnable');
		 
		
		rgtAmountOffsetPerHit = RGTGetOffsetAmmountPerHit();
		
		rgtCamState = GetCamState();
		
		RGTSetKeybinds();
		
		RGTSetExpCameraOffsetValues();
		RGTSetCbtCameraOffsetValues();
		RGTSetHorseCameraOffsetValues();
		RGTSetCbtHorseCameraOffsetValues();
		RGTSetBoatCameraOffsetValues();
		RGTSetIntCameraOffsetValues();
		RGTSetWsCameraOffsetValues();
		RGTSetLockedCameraOffsetValues();
		
		if(rgtAmountOffsetPerHit == 0)
			inGameConfigWrapper.SetVarValue('RGTotherSettings', 'RGToffsetPerHit', 0.1);
		
		rgtMsgErrorForceMode = "Can't do that with a locked camera";
	}
	
	public function rgtGetIsForceMode() : bool 
	{
		isForceModeOn = inGameConfigWrapper.GetVarValue('RGTotherSettings', 'ForceRGTmSettings'); 
		
		return isForceModeOn;
	}
	
	public function GetCamState() : ERGTSTATE
	{ 
		isExpCameraEnabled = inGameConfigWrapper.GetVarValue('RGTexp', 'ACexpEnable');
		isCbtCameraEnabled = inGameConfigWrapper.GetVarValue('RGTcbt', 'ACcbtEnable');
		isLockedCameraEnabled = inGameConfigWrapper.GetVarValue('RGTlocked', 'AClockedEnable');
		isHorseCameraEnabled = inGameConfigWrapper.GetVarValue('RGThorse', 'AChorseEnable');
		isCbtHorseCameraEnabled = inGameConfigWrapper.GetVarValue('RGTcbthorse', 'ACcbthorseEnable');
		isWsCameraEnabled = inGameConfigWrapper.GetVarValue('RGTws', 'ACwsEnable');
		isIntCameraEnabled = inGameConfigWrapper.GetVarValue('RGTint', 'ACintEnable');
		isBoatCameraEnabled = inGameConfigWrapper.GetVarValue('RGTboat', 'ACboatEnable');
		
		if(thePlayer.GetCurrentStateName() == 'Exploration')
		{
			if(theGame.IsFocusModeActive())
			{
				if(isWsCameraEnabled)
					return RGT_WitcherSenses;
				else
					return RGT_WitcherSensesOFF;
			}
			else if(thePlayer.IsInInterior())
			{
				if(isIntCameraEnabled)
					return RGT_Interiors;
				else
					return RGT_InteriorsOFF;
			}	
			else if(isExpCameraEnabled)
				return RGT_Exploration;
			else
				return RGT_ExplorationOFF;
		}
		else if(thePlayer.GetCurrentStateName() == 'CombatSteel' || thePlayer.GetCurrentStateName() == 'CombatSilver' || thePlayer.GetCurrentStateName() == 'CombatFists')
		{
			if(thePlayer.IsCameraLockedToTarget())
			{
				if(isLockedCameraEnabled)
					return RGT_CombatLocked;
				else
					return RGT_CombatLockedOFF;
			}
			else if(isCbtCameraEnabled)
				return RGT_Combat;	
			else
				return RGT_CombatOFF;
		}
		else if(thePlayer.GetCurrentStateName() == 'HorseRiding')
		{
			if(thePlayer.IsInCombat())
			{
				if(isCbtHorseCameraEnabled)
					return RGT_HorseCombat;
				else
					return RGT_HorseCombatOFF;
			}
				
			else if(isHorseCameraEnabled)
				return RGT_Horse;
			else
				return RGT_HorseOFF;
		}
		else if(thePlayer.GetCurrentStateName() == 'Sailing')
		{
			if(isBoatCameraEnabled)
				return RGT_Boat;
			else
				return RGT_BoatOFF;
		}
		else
			return RGT_MasterOFF;
	}
	
	public function RGTSetKeybinds()
	{
		theInput.RegisterListener( this, 'OnCommRGTAddOffsetX', 'RGTAddOffsetX' );
		theInput.RegisterListener( this, 'OnCommRGTAddOffsetY', 'RGTAddOffsetY' );
		theInput.RegisterListener( this, 'OnCommRGTAddOffsetZ', 'RGTAddOffsetZ' );	
		theInput.RegisterListener( this, 'OnCommRGTRemOffsetX', 'RGTRemOffsetX' );
		theInput.RegisterListener( this, 'OnCommRGTRemOffsetY', 'RGTRemOffsetY' );
		theInput.RegisterListener( this, 'OnCommRGTRemOffsetZ', 'RGTRemOffsetZ' );	
		theInput.RegisterListener( this, 'OnCommRGTcheckOffsets', 'RGTcheckOffsets' );
		theInput.RegisterListener( this, 'OnCommRGTShoulderToggle', 'RGTShoulderToggle' );
		theInput.RegisterListener( this, 'OnCommRGTresetOffsets', 'RGTreloadOffsets' );
		theInput.RegisterListener( this, 'OnCommRGTsaveCamera', 'RGTsaveCamera' );
	}
	
	public function GetisExpCameraEnabled() : bool
	{
		isExpCameraEnabled = inGameConfigWrapper.GetVarValue('RGTexp', 'ACexpEnable');
		
		return isExpCameraEnabled;
	}
	
	public function GetisCbtCameraEnabled() : bool
	{
		isCbtCameraEnabled = inGameConfigWrapper.GetVarValue('RGTcbt', 'ACcbtEnable');
		
		return isCbtCameraEnabled;
	}
	
	public function GetisLockedCameraEnabled() : bool
	{
		isLockedCameraEnabled = inGameConfigWrapper.GetVarValue('RGTlocked', 'AClockedEnable');
		
		return isLockedCameraEnabled;
	}
	
	public function GetisHorseCameraEnabled() : bool
	{
		isHorseCameraEnabled = inGameConfigWrapper.GetVarValue('RGThorse', 'AChorseEnable');
		
		return isHorseCameraEnabled;
	}
	
	public function GetisCbtHorseCameraEnabled() : bool
	{
		isCbtHorseCameraEnabled = inGameConfigWrapper.GetVarValue('RGTcbthorse', 'ACcbthorseEnable');
		
		return isCbtHorseCameraEnabled;
	}
	
	public function GetisWsCameraEnabled() : bool
	{
		isWsCameraEnabled = inGameConfigWrapper.GetVarValue('RGTws', 'ACwsEnable');
		
		return isWsCameraEnabled;
	}
	
	public function GetisIntCameraEnabled() : bool
	{
		isIntCameraEnabled = inGameConfigWrapper.GetVarValue('RGTint', 'ACintEnable');
		
		return isIntCameraEnabled;
	}
	
	public function GetisBoatCameraEnabled() : bool
	{
		isBoatCameraEnabled = inGameConfigWrapper.GetVarValue('RGTboat', 'ACboatEnable');
		
		return isBoatCameraEnabled;
	}
	
	public function RGTSetExpCameraOffsetValues()
	{
		rgtExpOffsetX = StringToFloat( inGameConfigWrapper.GetVarValue('RGTexp', 'RGTexpOffsetX') );
		rgtExpOffsetY = StringToFloat( inGameConfigWrapper.GetVarValue('RGTexp', 'RGTexpOffsetY') );
		rgtExpOffsetZ = StringToFloat( inGameConfigWrapper.GetVarValue('RGTexp', 'RGTexpOffsetZ') );
	}
	
	public function RGTSetCbtCameraOffsetValues()
	{
		rgtCbtOffsetX = StringToFloat( inGameConfigWrapper.GetVarValue('RGTcbt', 'RGTcbtOffsetX') );
		rgtCbtOffsetY = StringToFloat( inGameConfigWrapper.GetVarValue('RGTcbt', 'RGTcbtOffsetY') );
		rgtCbtOffsetZ = StringToFloat( inGameConfigWrapper.GetVarValue('RGTcbt', 'RGTcbtOffsetZ') );
	}
	
	public function RGTSetHorseCameraOffsetValues()
	{
		rgtHorseOffsetX = StringToFloat( inGameConfigWrapper.GetVarValue('RGThorse', 'RGTHorseOffsetX') );
		rgtHorseOffsetY = StringToFloat( inGameConfigWrapper.GetVarValue('RGThorse', 'RGTHorseOffsetY') );
		rgtHorseOffsetZ = StringToFloat( inGameConfigWrapper.GetVarValue('RGThorse', 'RGTHorseOffsetZ') );		
	}
	
	public function RGTSetCbtHorseCameraOffsetValues()
	{
		rgtCbtHorseOffsetX = StringToFloat( inGameConfigWrapper.GetVarValue('RGTcbthorse', 'RGTCbtHorseOffsetX') );
		rgtCbtHorseOffsetY = StringToFloat( inGameConfigWrapper.GetVarValue('RGTcbthorse', 'RGTCbtHorseOffsetY') );
		rgtCbtHorseOffsetZ = StringToFloat( inGameConfigWrapper.GetVarValue('RGTcbthorse', 'RGTCbtHorseOffsetZ') );
	}
	
	public function RGTSetBoatCameraOffsetValues()
	{
		rgtBoatOffsetX = StringToFloat( inGameConfigWrapper.GetVarValue('RGTboat', 'RGTBoatOffsetX') );
		rgtBoatOffsetY = StringToFloat( inGameConfigWrapper.GetVarValue('RGTboat', 'RGTBoatOffsetY') );
		rgtBoatOffsetZ = StringToFloat( inGameConfigWrapper.GetVarValue('RGTboat', 'RGTBoatOffsetZ') );
	}
	
	public function RGTSetIntCameraOffsetValues()
	{
		rgtIntOffsetX = StringToFloat( inGameConfigWrapper.GetVarValue('RGTint', 'RGTIntOffsetX') );
		rgtIntOffsetY = StringToFloat( inGameConfigWrapper.GetVarValue('RGTint', 'RGTIntOffsetY') );
		rgtIntOffsetZ = StringToFloat( inGameConfigWrapper.GetVarValue('RGTint', 'RGTIntOffsetZ') );
	}
	
	public function RGTSetWsCameraOffsetValues()
	{
		rgtWsOffsetX = StringToFloat( inGameConfigWrapper.GetVarValue('RGTws', 'RGTWsOffsetX') );
		rgtWsOffsetY = StringToFloat( inGameConfigWrapper.GetVarValue('RGTws', 'RGTWsOffsetY') );
		rgtWsOffsetZ = StringToFloat( inGameConfigWrapper.GetVarValue('RGTws', 'RGTWsOffsetZ') );
	}
	
	public function RGTSetLockedCameraOffsetValues()
	{
		rgtLockOffsetX = StringToFloat( inGameConfigWrapper.GetVarValue('RGTlocked', 'RGTLockedOffsetX') );
		rgtLockOffsetY = StringToFloat( inGameConfigWrapper.GetVarValue('RGTlocked', 'RGTLockedOffsetY') );
		rgtLockOffsetZ = StringToFloat( inGameConfigWrapper.GetVarValue('RGTlocked', 'RGTLockedOffsetZ') );
	}
	
	public function RGTGetOffsetAmmountPerHit() : float
	{
		rgtAmountOffsetPerHit = StringToFloat( inGameConfigWrapper.GetVarValue('RGTotherSettings', 'RGToffsetPerHit') );
		
		return rgtAmountOffsetPerHit;
	}
	
	//------------------> Get Saved Offsets
	//Exploration
	public function GetExpCameraOffsetValueX() : float 
	{
		rgtExpOffsetX = StringToFloat( inGameConfigWrapper.GetVarValue('RGTexp', 'RGTexpOffsetX') );
		
		return rgtExpOffsetX;
	}

	public function GetExpCameraOffsetValueY() : float 
	{
		rgtExpOffsetY = StringToFloat( inGameConfigWrapper.GetVarValue('RGTexp', 'RGTexpOffsetY') );
		
		return rgtExpOffsetY;
	}

	public function GetExpCameraOffsetValueZ() : float 
	{
		rgtExpOffsetZ = StringToFloat( inGameConfigWrapper.GetVarValue('RGTexp', 'RGTexpOffsetZ') );
		
		return rgtExpOffsetZ;
	}

	//Combat
	public function GetCbtCameraOffsetValueX() : float 
	{
		rgtCbtOffsetX = StringToFloat( inGameConfigWrapper.GetVarValue('RGTcbt', 'RGTcbtOffsetX') );
		
		return rgtCbtOffsetX;
	}

	public function GetCbtCameraOffsetValueY() : float 
	{
		rgtCbtOffsetY = StringToFloat( inGameConfigWrapper.GetVarValue('RGTcbt', 'RGTcbtOffsetY') );
		
		return rgtCbtOffsetY;
	}

	public function GetCbtCameraOffsetValueZ() : float 
	{
		rgtCbtOffsetZ = StringToFloat( inGameConfigWrapper.GetVarValue('RGTcbt', 'RGTcbtOffsetZ') );
		
		return rgtCbtOffsetZ;
	}

	//Horse
	public function GetHorseCameraOffsetValueX() : float 
	{
		rgtHorseOffsetX = StringToFloat( inGameConfigWrapper.GetVarValue('RGThorse', 'RGTHorseOffsetX') );
		
		return rgtHorseOffsetX;
	}

	public function GetHorseCameraOffsetValueY() : float 
	{
		rgtHorseOffsetY = StringToFloat( inGameConfigWrapper.GetVarValue('RGThorse', 'RGTHorseOffsetY') );
		
		return rgtHorseOffsetY;
	}

	public function GetHorseCameraOffsetValueZ() : float 
	{
		rgtHorseOffsetY = StringToFloat( inGameConfigWrapper.GetVarValue('RGThorse', 'RGTHorseOffsetZ') );
		
		return rgtHorseOffsetY;
	}

	//Combat Horse
	public function GetCbtHorseCameraOffsetValueX() : float 
	{
		rgtCbtHorseOffsetX = StringToFloat( inGameConfigWrapper.GetVarValue('RGTcbthorse', 'RGTCbtHorseOffsetX') );
		
		return rgtCbtHorseOffsetX;
	}

	public function GetCbtHorseCameraOffsetValueY() : float 
	{
		rgtCbtHorseOffsetY = StringToFloat( inGameConfigWrapper.GetVarValue('RGTcbthorse', 'RGTCbtHorseOffsetY') );
		
		return rgtCbtHorseOffsetY;
	}

	public function GetCbtHorseCameraOffsetValueZ() : float 
	{
		rgtCbtHorseOffsetZ = StringToFloat( inGameConfigWrapper.GetVarValue('RGTcbthorse', 'RGTCbtHorseOffsetZ') );
		
		return rgtCbtHorseOffsetZ;
	}

	//Sailing
	public function GetBoatCameraOffsetValueX() : float 
	{
		rgtBoatOffsetX = StringToFloat( inGameConfigWrapper.GetVarValue('RGTboat', 'RGTBoatOffsetX') );
		
		return rgtBoatOffsetX;
	}

	public function GetBoatCameraOffsetValueY() : float 
	{
		rgtBoatOffsetY = StringToFloat( inGameConfigWrapper.GetVarValue('RGTboat', 'RGTBoatOffsetY') );
		
		return rgtBoatOffsetY;
	}

	public function GetBoatCameraOffsetValueZ() : float 
	{
		rgtBoatOffsetZ = StringToFloat( inGameConfigWrapper.GetVarValue('RGTboat', 'RGTBoatOffsetZ') );
		
		return rgtBoatOffsetZ;
	}

	//Interiors
	public function GetIntCameraOffsetValueX() : float 
	{
		rgtIntOffsetX = StringToFloat( inGameConfigWrapper.GetVarValue('RGTint', 'RGTIntOffsetX') );
		
		return rgtIntOffsetX;
	}

	public function GetIntCameraOffsetValueY() : float 
	{
		rgtIntOffsetY = StringToFloat( inGameConfigWrapper.GetVarValue('RGTint', 'RGTIntOffsetY') );
		
		return rgtIntOffsetY;
	}

	public function GetIntCameraOffsetValueZ() : float 
	{
		rgtIntOffsetZ = StringToFloat( inGameConfigWrapper.GetVarValue('RGTint', 'RGTIntOffsetZ') );
		
		return rgtIntOffsetZ;
	}

	//Witcher Senses
	public function GetWsCameraOffsetValueX() : float 
	{
		rgtWsOffsetX = StringToFloat( inGameConfigWrapper.GetVarValue('RGTws', 'RGTWsOffsetX') );
		
		return rgtWsOffsetX;
	}

	public function GetWsCameraOffsetValueY() : float 
	{
		rgtWsOffsetY = StringToFloat( inGameConfigWrapper.GetVarValue('RGTws', 'RGTWsOffsetY') );
		
		return rgtWsOffsetY;
	}

	public function GetWsCameraOffsetValueZ() : float 
	{
		rgtWsOffsetZ = StringToFloat( inGameConfigWrapper.GetVarValue('RGTws', 'RGTWsOffsetZ') );
		
		return rgtWsOffsetZ;
	}

	//Locked to Target
	public function GetLockedCameraOffsetValueX() : float 
	{
		rgtLockOffsetX = StringToFloat( inGameConfigWrapper.GetVarValue('RGTlocked', 'RGTLockedOffsetX') );
		
		return rgtLockOffsetX;
	}

	public function GetLockedCameraOffsetValueY() : float 
	{
		rgtLockOffsetY = StringToFloat( inGameConfigWrapper.GetVarValue('RGTlocked', 'RGTLockedOffsetY') );
		
		return rgtLockOffsetY;
	}

	public function GetLockedCameraOffsetValueZ() : float 
	{
		rgtLockOffsetZ = StringToFloat( inGameConfigWrapper.GetVarValue('RGTlocked', 'RGTLockedOffsetZ') );
		
		return rgtLockOffsetZ;
	}
	
	//------------------> Hotkey Events
	//Add
	event OnCommRGTAddOffsetX( action : SInputAction )
	{
		rgtCamState = GetCamState();
		
		isForceModeOn = rgtGetIsForceMode();
		
		if(IsPressed(action) && isForceModeOn)
			thePlayer.DisplayHudMessage(rgtMsgErrorForceMode);
		else if( IsPressed(action) )
		{
			switch(rgtCamState)
			{
				case RGT_WitcherSenses :
					AddrgtWsOffsetX();
				break;
				
				case RGT_Interiors :
					AddrgtIntOffsetX();
				break;
				
				case RGT_Exploration :
					AddrgtExpOffsetX();
				break;
				
				case RGT_CombatLocked :
					AddrgtLockOffsetX();
				break;
				
				case RGT_Combat :
					AddrgtCbtOffsetX();
				break;
				
				case RGT_HorseCombat :
					AddrgtCbtHorseOffsetX();
				break;
				
				case RGT_Horse :
					AddrgtHorseOffsetX();
				break;
				
				case RGT_Boat :
					AddrgtBoatOffsetX();
				break;
				
				case RGT_WitcherSensesOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_InteriorsOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_ExplorationOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_CombatLockedOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_CombatOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_HorseCombatOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_HorseOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_BoatOFF :
					displayMSGRGTcheckOffsets();
				break;
			}
		}
	}
	
	event OnCommRGTAddOffsetY( action : SInputAction )
	{
		rgtCamState = GetCamState();
		
		isForceModeOn = rgtGetIsForceMode();
		
		if(IsPressed(action) && isForceModeOn)
			thePlayer.DisplayHudMessage(rgtMsgErrorForceMode);
		else if( IsPressed(action) )
		{
			switch(rgtCamState)
			{
				case RGT_WitcherSenses :
					AddrgtWsOffsetY();
				break;
				
				case RGT_Interiors :
					AddrgtIntOffsetY();
				break;
				
				case RGT_Exploration :
					AddrgtExpOffsetY();
				break;
				
				case RGT_CombatLocked :
					AddrgtLockOffsetY();
				break;
				
				case RGT_Combat :
					AddrgtCbtOffsetY();
				break;
				
				case RGT_HorseCombat :
					AddrgtCbtHorseOffsetY();
				break;
				
				case RGT_Horse :
					AddrgtHorseOffsetY();
				break;
				
				case RGT_Boat :
					AddrgtBoatOffsetY();
				break;
				
				case RGT_WitcherSensesOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_InteriorsOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_ExplorationOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_CombatLockedOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_CombatOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_HorseCombatOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_HorseOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_BoatOFF :
					displayMSGRGTcheckOffsets();
				break;
			}
		}
	}
	
	event OnCommRGTAddOffsetZ( action : SInputAction )
	{
		rgtCamState = GetCamState();
		
		isForceModeOn = rgtGetIsForceMode();
		
		if(IsPressed(action) && isForceModeOn)
			thePlayer.DisplayHudMessage(rgtMsgErrorForceMode);
		else if( IsPressed(action) )
		{
			switch(rgtCamState)
			{
				case RGT_WitcherSenses :
					AddrgtWsOffsetZ();
				break;
				
				case RGT_Interiors :
					AddrgtIntOffsetZ();
				break;
				
				case RGT_Exploration :
					AddrgtExpOffsetZ();
				break;
				
				case RGT_CombatLocked :
					AddrgtLockOffsetZ();
				break;
				
				case RGT_Combat :
					AddrgtCbtOffsetZ();
				break;
				
				case RGT_HorseCombat :
					AddrgtCbtHorseOffsetZ();
				break;
				
				case RGT_Horse :
					AddrgtHorseOffsetZ();
				break;
				
				case RGT_Boat :
					AddrgtBoatOffsetZ();
				break;
				
				case RGT_WitcherSensesOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_InteriorsOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_ExplorationOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_CombatLockedOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_CombatOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_HorseCombatOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_HorseOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_BoatOFF :
					displayMSGRGTcheckOffsets();
				break;
			}
		}
	}
	
	//Remove
	event OnCommRGTRemOffsetX( action : SInputAction )
	{
		rgtCamState = GetCamState();
		
		isForceModeOn = rgtGetIsForceMode();
		
		if(IsPressed(action) && isForceModeOn)
			thePlayer.DisplayHudMessage(rgtMsgErrorForceMode);
		else if( IsPressed(action) )
		{
			switch(rgtCamState)
			{
				case RGT_WitcherSenses :
					RemrgtWsOffsetX();
				break;
				
				case RGT_Interiors :
					RemrgtIntOffsetX();
				break;
				
				case RGT_Exploration :
					RemrgtExpOffsetX();
				break;
				
				case RGT_CombatLocked :
					RemrgtLockOffsetX();
				break;
				
				case RGT_Combat :
					RemrgtCbtOffsetX();
				break;
				
				case RGT_HorseCombat :
					RemrgtCbtHorseOffsetX();
				break;
				
				case RGT_Horse :
					RemrgtHorseOffsetX();
				break;
				
				case RGT_Boat :
					RemrgtBoatOffsetX();
				break;
				
				case RGT_WitcherSensesOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_InteriorsOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_ExplorationOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_CombatLockedOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_CombatOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_HorseCombatOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_HorseOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_BoatOFF :
					displayMSGRGTcheckOffsets();
				break;
			}
		}
	}
	
	event OnCommRGTRemOffsetY( action : SInputAction )
	{
		rgtCamState = GetCamState();
		
		isForceModeOn = rgtGetIsForceMode();
		
		if(IsPressed(action) && isForceModeOn)
			thePlayer.DisplayHudMessage(rgtMsgErrorForceMode);
		else if( IsPressed(action) )
		{
			switch(rgtCamState)
			{
				case RGT_WitcherSenses :
					RemrgtWsOffsetY();
				break;
				
				case RGT_Interiors :
					RemrgtIntOffsetY();
				break;
				
				case RGT_Exploration :
					RemrgtExpOffsetY();
				break;
				
				case RGT_CombatLocked :
					RemrgtLockOffsetY();
				break;
				
				case RGT_Combat :
					RemrgtCbtOffsetY();
				break;
				
				case RGT_HorseCombat :
					RemrgtCbtHorseOffsetY();
				break;
				
				case RGT_Horse :
					RemrgtHorseOffsetY();
				break;
				
				case RGT_Boat :
					RemrgtBoatOffsetY();
				break;
				
				case RGT_WitcherSensesOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_InteriorsOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_ExplorationOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_CombatLockedOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_CombatOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_HorseCombatOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_HorseOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_BoatOFF :
					displayMSGRGTcheckOffsets();
				break;
			}
		}
	}
	
	event OnCommRGTRemOffsetZ( action : SInputAction )
	{
		rgtCamState = GetCamState();
		
		isForceModeOn = rgtGetIsForceMode();
		
		if(IsPressed(action) && isForceModeOn)
			thePlayer.DisplayHudMessage(rgtMsgErrorForceMode);
		else if( IsPressed(action) )
		{
			switch(rgtCamState)
			{
				case RGT_WitcherSenses :
					RemrgtWsOffsetZ();
				break;
				
				case RGT_Interiors :
					RemrgtIntOffsetZ();
				break;
				
				case RGT_Exploration :
					RemrgtExpOffsetZ();
				break;
				
				case RGT_CombatLocked :
					RemrgtLockOffsetZ();
				break;
				
				case RGT_Combat :
					RemrgtCbtOffsetZ();
				break;
				
				case RGT_HorseCombat :
					RemrgtCbtHorseOffsetZ();
				break;
				
				case RGT_Horse :
					RemrgtHorseOffsetZ();
				break;
				
				case RGT_Boat :
					RemrgtBoatOffsetZ();
				break;
				
				case RGT_WitcherSensesOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_InteriorsOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_ExplorationOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_CombatLockedOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_CombatOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_HorseCombatOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_HorseOFF :
					displayMSGRGTcheckOffsets();
				break;
				
				case RGT_BoatOFF :
					displayMSGRGTcheckOffsets();
				break;
			}
		}
	}
	
	//Check Offsets
	event OnCommRGTcheckOffsets( action : SInputAction )
	{	
		if( IsPressed(action) )
		{
			displayMSGRGTcheckOffsets();
		}
	}
	
	//Shoulder Toggle
	event OnCommRGTShoulderToggle( action : SInputAction )
	{	
		var currShToggSt : bool;
		
		currShToggSt = GetRGTisShoulderToggled();
		
		if( IsPressed(action))
		{
			if(currShToggSt)
				SetRGTisShoulderToggled(false);
			else
				SetRGTisShoulderToggled(true);
		}
	}
	
	//Reset Offsets
	event OnCommRGTresetOffsets( action : SInputAction )
	{
		rgtCamState = GetCamState();
		
		if( IsPressed(action) )
		{
			switch(rgtCamState)
			{
				case RGT_Exploration :
					RGTSetExpCameraOffsetValues();
				break;
				
				case RGT_Combat :
					RGTSetCbtCameraOffsetValues();
				break;
				
				case RGT_CombatLocked :
					RGTSetLockedCameraOffsetValues();
				break;
				
				case RGT_Horse :
					RGTSetHorseCameraOffsetValues();
				break;
				
				case RGT_HorseCombat :
					RGTSetCbtHorseCameraOffsetValues();
				break;
				
				case RGT_Boat :
					RGTSetBoatCameraOffsetValues();
				break;
				
				case RGT_Interiors :
					RGTSetIntCameraOffsetValues();
				break;
				
				case RGT_WitcherSenses :
					RGTSetWsCameraOffsetValues();
				break;
			}
		}
	}
	
	//Save Camera
	event OnCommRGTsaveCamera( action : SInputAction )
	{
		if(IsPressed(action))
		{
			RGTSaveThisCamera();
		}
	}
	
	//------------------> Get Functions
	//Exploration
	public function GetExpRGToffsetX() : float 
	{
		if(rgtGetIsForceMode())
		{
			rgtExpOffsetX = StringToFloat( inGameConfigWrapper.GetVarValue('RGTexp', 'RGTexpOffsetX') );
			if(GetRGTisShoulderToggled())
				return rgtExpOffsetX*-1;
			else
				return rgtExpOffsetX;
		}
		else
		{
			if(GetRGTisShoulderToggled())
				return rgtExpOffsetX*-1;
			else
				return rgtExpOffsetX;
		}
	}
	public function GetExpRGToffsetY() : float 
	{ 
		if(rgtGetIsForceMode())
		{
			rgtExpOffsetY = StringToFloat( inGameConfigWrapper.GetVarValue('RGTexp', 'RGTexpOffsetY') );
			return rgtExpOffsetY;
		}
		else
			return rgtExpOffsetY; 
	}
	public function GetExpRGToffsetZ() : float 
	{ 
		if(rgtGetIsForceMode())
		{
			rgtExpOffsetZ = StringToFloat( inGameConfigWrapper.GetVarValue('RGTexp', 'RGTexpOffsetZ') );
			return rgtExpOffsetZ;
		}
		else
			return rgtExpOffsetZ; 
	}
	
	//Combat
	public function GetCbtRGToffsetX() : float 
	{
		if(rgtGetIsForceMode())
		{
			rgtCbtOffsetX = StringToFloat( inGameConfigWrapper.GetVarValue('RGTcbt', 'RGTcbtOffsetX') );
			if(GetRGTisShoulderToggled())
				return rgtCbtOffsetX*-1;
			else
				return rgtCbtOffsetX;
		}
		else
		{
			if(GetRGTisShoulderToggled())
				return rgtCbtOffsetX*-1;
			else
				return rgtCbtOffsetX; 
		}
	}
	public function GetCbtRGToffsetY() : float 
	{ 
		if(rgtGetIsForceMode())
		{
			rgtCbtOffsetY = StringToFloat( inGameConfigWrapper.GetVarValue('RGTcbt', 'RGTcbtOffsetY') );
			return rgtCbtOffsetY;
		}
		else
			return rgtCbtOffsetY; 
	}
	public function GetCbtRGToffsetZ() : float 
	{ 
		if(rgtGetIsForceMode())
		{
			rgtCbtOffsetZ = StringToFloat( inGameConfigWrapper.GetVarValue('RGTcbt', 'RGTcbtOffsetZ') );
			return rgtCbtOffsetZ;
		}
		else
			return rgtCbtOffsetZ; 
	}

	//Horse Riding
	public function GetHorseRGToffsetX() : float 
	{
		if(rgtGetIsForceMode())
		{
			rgtHorseOffsetX = StringToFloat( inGameConfigWrapper.GetVarValue('RGThorse', 'RGTHorseOffsetX') );
			if(GetRGTisShoulderToggled())
				return rgtHorseOffsetX*-1;
			else
				return rgtHorseOffsetX;
		}
		else
		{
			if(GetRGTisShoulderToggled())
				return rgtHorseOffsetX*-1;
			else
				return rgtHorseOffsetX;
		}			
	}
	public function GetHorseRGToffsetY() : float 
	{ 
		if(rgtGetIsForceMode())
		{
			rgtHorseOffsetY = StringToFloat( inGameConfigWrapper.GetVarValue('RGThorse', 'RGTHorseOffsetY') );
			return rgtHorseOffsetY;
		}
		else
			return rgtHorseOffsetY; 
	}
	public function GetHorseRGToffsetZ() : float 
	{ 
		if(rgtGetIsForceMode())
		{
			rgtHorseOffsetZ = StringToFloat( inGameConfigWrapper.GetVarValue('RGThorse', 'RGTHorseOffsetZ') );
			return rgtHorseOffsetZ;
		}
		else
			return rgtHorseOffsetZ; 
	}
	
	//Combat Horse Riding
	public function GetCbtHorseRGToffsetX() : float 
	{
		if(rgtGetIsForceMode())
		{
			rgtCbtHorseOffsetX = StringToFloat( inGameConfigWrapper.GetVarValue('RGTcbthorse', 'RGTCbtHorseOffsetX') );
			if(GetRGTisShoulderToggled())
				return rgtCbtHorseOffsetX*-1;
			else
				return rgtCbtHorseOffsetX;
		}
		else
		{
			if(GetRGTisShoulderToggled())
				return rgtCbtHorseOffsetX*-1;
			else
				return rgtCbtHorseOffsetX;
		}
	}
	public function GetCbtHorseRGToffsetY() : float 
	{ 
		if(rgtGetIsForceMode())
		{
			rgtCbtHorseOffsetY = StringToFloat( inGameConfigWrapper.GetVarValue('RGTcbthorse', 'RGTCbtHorseOffsetY') );
			return rgtCbtHorseOffsetY;
		}
		else
			return rgtCbtHorseOffsetY; 
	}
	public function GetCbtHorseRGToffsetZ() : float 
	{ 
		if(rgtGetIsForceMode())
		{
			rgtCbtHorseOffsetZ = StringToFloat( inGameConfigWrapper.GetVarValue('RGTcbthorse', 'RGTCbtHorseOffsetZ') );
			return rgtCbtHorseOffsetZ;
		}
		else
			return rgtCbtHorseOffsetZ; 
	}
	
	//Sailing
	public function GetBoatRGToffsetX() : float 
	{
		if(rgtGetIsForceMode())
		{
			rgtBoatOffsetX = StringToFloat( inGameConfigWrapper.GetVarValue('RGTboat', 'RGTBoatOffsetX') );
			if(GetRGTisShoulderToggled())
				return rgtBoatOffsetX*-1;
			else
				return rgtBoatOffsetX;
		}
		else
		{
			if(GetRGTisShoulderToggled())
				return rgtBoatOffsetX*-1;
			else
				return rgtBoatOffsetX;
		}			
	}
	public function GetBoatRGToffsetY() : float 
	{ 
		if(rgtGetIsForceMode())
		{
			rgtBoatOffsetY = StringToFloat( inGameConfigWrapper.GetVarValue('RGTboat', 'RGTBoatOffsetY') );
			return rgtBoatOffsetY;
		}
		else
			return rgtBoatOffsetY; 
	}
	public function GetBoatRGToffsetZ() : float 
	{ 
		if(rgtGetIsForceMode())
		{
			rgtBoatOffsetZ = StringToFloat( inGameConfigWrapper.GetVarValue('RGTboat', 'RGTBoatOffsetZ') );
			return rgtBoatOffsetZ;
		}
		else
			return rgtBoatOffsetZ; 
	}
	
	//Interiors Camera
	public function GetIntRGToffsetX() : float 
	{
		if(rgtGetIsForceMode())
		{
			rgtIntOffsetX = StringToFloat( inGameConfigWrapper.GetVarValue('RGTint', 'RGTIntOffsetX') );
			if(GetRGTisShoulderToggled())
				return rgtIntOffsetX*-1;
			else
				return rgtIntOffsetX;
		}
		else
		{
			if(GetRGTisShoulderToggled())
				return rgtIntOffsetX*-1;
			else
				return rgtIntOffsetX;
		}
			 
	}
	public function GetIntRGToffsetY() : float 
	{ 
		if(rgtGetIsForceMode())
		{
			rgtIntOffsetY = StringToFloat( inGameConfigWrapper.GetVarValue('RGTint', 'RGTIntOffsetY') );
			return rgtIntOffsetY;
		}
		else
			return rgtIntOffsetY; 
	}
	public function GetIntRGToffsetZ() : float 
	{ 
		if(rgtGetIsForceMode())
		{
			rgtIntOffsetZ = StringToFloat( inGameConfigWrapper.GetVarValue('RGTint', 'RGTIntOffsetZ') );
			return rgtIntOffsetZ;
		}
		else
			return rgtIntOffsetZ; 
	}
	
	//Witcher Senses
	public function GetWsRGToffsetX() : float 
	{
		if(rgtGetIsForceMode())
		{
			rgtWsOffsetX = StringToFloat( inGameConfigWrapper.GetVarValue('RGTws', 'RGTWsOffsetX') );
			if(GetRGTisShoulderToggled())
				return rgtWsOffsetX*-1;
			else
				return rgtWsOffsetX;
		}
		else
		{
			if(GetRGTisShoulderToggled())
				return rgtWsOffsetX*-1;
			else
				return rgtWsOffsetX;
		}
	}
	public function GetWsRGToffsetY() : float 
	{ 
		if(rgtGetIsForceMode())
		{
			rgtWsOffsetY = StringToFloat( inGameConfigWrapper.GetVarValue('RGTws', 'RGTWsOffsetY') );
			return rgtWsOffsetY;
		}
		else
			return rgtWsOffsetY; 
	}
	public function GetWsRGToffsetZ() : float 
	{ 
		if(rgtGetIsForceMode())
		{
			rgtWsOffsetZ = StringToFloat( inGameConfigWrapper.GetVarValue('RGTws', 'RGTWsOffsetZ') );
			return rgtWsOffsetZ;
		}
		else
			return rgtWsOffsetZ; 
	}
	
	//Locked to Target Camera
	public function GetLockedRGToffsetX() : float 
	{
		if(rgtGetIsForceMode())
		{
			rgtLockOffsetX = StringToFloat( inGameConfigWrapper.GetVarValue('RGTlocked', 'RGTLockedOffsetX') );
			if(GetRGTisShoulderToggled())
				return rgtLockOffsetX*-1;
			else
				return rgtLockOffsetX;
		}
		else
		{
			if(GetRGTisShoulderToggled())
				return rgtLockOffsetX*-1;
			else
				return rgtLockOffsetX;
		}
	}
	public function GetLockedRGToffsetY() : float 
	{ 
		if(rgtGetIsForceMode())
		{
			rgtLockOffsetY = StringToFloat( inGameConfigWrapper.GetVarValue('RGTlocked', 'RGTLockedOffsetY') );
			return rgtLockOffsetY;
		}
		else
			return rgtLockOffsetY; 
	}
	public function GetLockedRGToffsetZ() : float 
	{ 
		if(rgtGetIsForceMode())
		{
			rgtLockOffsetZ = StringToFloat( inGameConfigWrapper.GetVarValue('RGTlocked', 'RGTLockedOffsetZ') );
			return rgtLockOffsetZ;
		}
		else
			return rgtLockOffsetZ; 
	}
	
	//Shoulder Toggle
	public function GetRGTisShoulderToggled() : bool { return rgtShoulderIsToggled; }

	//Final Vector Get Functions
	public function rgtGetFinalVector() : Vector
	{
		rgtCamState = GetCamState();
		
		switch (rgtCamState)
		{
			case RGT_Exploration :
				return Vector( GetExpRGToffsetX(), GetExpRGToffsetY(), GetExpRGToffsetZ() );
			break;
			
			case RGT_Combat :
				return Vector( GetCbtRGToffsetX(), GetCbtRGToffsetY(), GetCbtRGToffsetZ() );
			break;
			
			case RGT_Horse :
				return Vector( GetHorseRGToffsetX(), GetHorseRGToffsetY(), GetHorseRGToffsetZ() );
			break;
			
			case RGT_HorseCombat :
				return Vector( GetCbtHorseRGToffsetX(), GetCbtHorseRGToffsetY(), GetCbtHorseRGToffsetZ() );
			break;
			
			case RGT_Boat :
				return Vector( GetBoatRGToffsetX(), GetBoatRGToffsetY(), GetBoatRGToffsetZ() );
			break;
			
			case RGT_Interiors :
				return Vector( GetIntRGToffsetX(), GetIntRGToffsetY(), GetIntRGToffsetZ() );
			break;
			
			case RGT_WitcherSenses :
				return Vector( GetWsRGToffsetX(), GetWsRGToffsetY(), GetWsRGToffsetZ() );
			break;
			
			case RGT_CombatLocked :
				return Vector( GetLockedRGToffsetX(), GetLockedRGToffsetY(), GetLockedRGToffsetZ() );
			break;
		}
	}
	
	
	//------------------> + Offset Functions
	//Exploration
	public function AddrgtExpOffsetX() {  rgtExpOffsetX += RGTGetOffsetAmmountPerHit(); }
	public function AddrgtExpOffsetY() {  rgtExpOffsetY += RGTGetOffsetAmmountPerHit(); }
	public function AddrgtExpOffsetZ() {  rgtExpOffsetZ += RGTGetOffsetAmmountPerHit(); }
	
	//Combat
	public function AddrgtCbtOffsetX() {  rgtCbtOffsetX += RGTGetOffsetAmmountPerHit(); }
	public function AddrgtCbtOffsetY() {  rgtCbtOffsetY += RGTGetOffsetAmmountPerHit(); }
	public function AddrgtCbtOffsetZ() {  rgtCbtOffsetZ += RGTGetOffsetAmmountPerHit(); }
	
	//Horse Riding
	public function AddrgtHorseOffsetX() {  rgtHorseOffsetX += RGTGetOffsetAmmountPerHit(); }
	public function AddrgtHorseOffsetY() {  rgtHorseOffsetY += RGTGetOffsetAmmountPerHit(); }
	public function AddrgtHorseOffsetZ() {  rgtHorseOffsetZ += RGTGetOffsetAmmountPerHit(); }
	
	//Combat Horse Riding
	public function AddrgtCbtHorseOffsetX() {  rgtCbtHorseOffsetX += RGTGetOffsetAmmountPerHit(); }
	public function AddrgtCbtHorseOffsetY() {  rgtCbtHorseOffsetY += RGTGetOffsetAmmountPerHit(); }
	public function AddrgtCbtHorseOffsetZ() {  rgtCbtHorseOffsetZ += RGTGetOffsetAmmountPerHit(); }
	
	//Sailing
	public function AddrgtBoatOffsetX() {  rgtBoatOffsetX += RGTGetOffsetAmmountPerHit(); }
	public function AddrgtBoatOffsetY() {  rgtBoatOffsetY += RGTGetOffsetAmmountPerHit(); }
	public function AddrgtBoatOffsetZ() {  rgtBoatOffsetZ += RGTGetOffsetAmmountPerHit(); }
	
	//Interiors Camera
	public function AddrgtIntOffsetX() {  rgtIntOffsetX += RGTGetOffsetAmmountPerHit(); }
	public function AddrgtIntOffsetY() {  rgtIntOffsetY += RGTGetOffsetAmmountPerHit(); }
	public function AddrgtIntOffsetZ() {  rgtIntOffsetZ += RGTGetOffsetAmmountPerHit(); }
	
	//Witcher Senses
	public function AddrgtWsOffsetX() {  rgtWsOffsetX += RGTGetOffsetAmmountPerHit(); }
	public function AddrgtWsOffsetY() {  rgtWsOffsetY += RGTGetOffsetAmmountPerHit(); }
	public function AddrgtWsOffsetZ() {  rgtWsOffsetZ += RGTGetOffsetAmmountPerHit(); }
	
	//Locked to Target Camera
	public function AddrgtLockOffsetX() {  rgtLockOffsetX += RGTGetOffsetAmmountPerHit(); }
	public function AddrgtLockOffsetY() {  rgtLockOffsetY += RGTGetOffsetAmmountPerHit(); }
	public function AddrgtLockOffsetZ() {  rgtLockOffsetZ += RGTGetOffsetAmmountPerHit(); }
	
	//------------------> - Offset Functions
	//Exploration
	public function RemrgtExpOffsetX() {  rgtExpOffsetX -= RGTGetOffsetAmmountPerHit(); }
	public function RemrgtExpOffsetY() {  rgtExpOffsetY -= RGTGetOffsetAmmountPerHit(); }
	public function RemrgtExpOffsetZ() {  rgtExpOffsetZ -= RGTGetOffsetAmmountPerHit(); }
	
	//Combat
	public function RemrgtCbtOffsetX() {  rgtCbtOffsetX -= RGTGetOffsetAmmountPerHit(); }
	public function RemrgtCbtOffsetY() {  rgtCbtOffsetY -= RGTGetOffsetAmmountPerHit(); }
	public function RemrgtCbtOffsetZ() {  rgtCbtOffsetZ -= RGTGetOffsetAmmountPerHit(); }
	
	//Horse Riding
	public function RemrgtHorseOffsetX() {  rgtHorseOffsetX -= RGTGetOffsetAmmountPerHit(); }
	public function RemrgtHorseOffsetY() {  rgtHorseOffsetY -= RGTGetOffsetAmmountPerHit(); }
	public function RemrgtHorseOffsetZ() {  rgtHorseOffsetZ -= RGTGetOffsetAmmountPerHit(); }
	
	//Combat Horse Riding
	public function RemrgtCbtHorseOffsetX() {  rgtCbtHorseOffsetX -= RGTGetOffsetAmmountPerHit(); }
	public function RemrgtCbtHorseOffsetY() {  rgtCbtHorseOffsetY -= RGTGetOffsetAmmountPerHit(); }
	public function RemrgtCbtHorseOffsetZ() {  rgtCbtHorseOffsetZ -= RGTGetOffsetAmmountPerHit(); }
	
	//Sailing
	public function RemrgtBoatOffsetX() {  rgtBoatOffsetX -= RGTGetOffsetAmmountPerHit(); }
	public function RemrgtBoatOffsetY() {  rgtBoatOffsetY -= RGTGetOffsetAmmountPerHit(); }
	public function RemrgtBoatOffsetZ() {  rgtBoatOffsetZ -= RGTGetOffsetAmmountPerHit(); }
	
	//Interiors Camera
	public function RemrgtIntOffsetX() {  rgtIntOffsetX -= RGTGetOffsetAmmountPerHit(); }
	public function RemrgtIntOffsetY() {  rgtIntOffsetY -= RGTGetOffsetAmmountPerHit(); }
	public function RemrgtIntOffsetZ() {  rgtIntOffsetZ -= RGTGetOffsetAmmountPerHit(); }
	
	//Witcher Senses
	public function RemrgtWsOffsetX() {  rgtWsOffsetX -= RGTGetOffsetAmmountPerHit(); }
	public function RemrgtWsOffsetY() {  rgtWsOffsetY -= RGTGetOffsetAmmountPerHit(); }
	public function RemrgtWsOffsetZ() {  rgtWsOffsetZ -= RGTGetOffsetAmmountPerHit(); }
	
	//Locked to Target Camera
	public function RemrgtLockOffsetX() {  rgtLockOffsetX -= RGTGetOffsetAmmountPerHit(); }
	public function RemrgtLockOffsetY() {  rgtLockOffsetY -= RGTGetOffsetAmmountPerHit(); }
	public function RemrgtLockOffsetZ() {  rgtLockOffsetZ -= RGTGetOffsetAmmountPerHit(); }
	
	//------------------> Set Functions
	//Shoulder Toggle
	public function SetRGTisShoulderToggled( flag : bool) { rgtShoulderIsToggled = flag; }
	
	public function RGTSaveThisCamera()
	{
		var msgDisableShTo : string;
		
		var msgSavedExp : string;
		var msgSavedCbt : string;
		var msgSavedHorse : string;
		var msgSavedCbtHorse : string;
		var msgSavedBoat : string;
		var msgSavedLock : string;
		var msgSavedInt : string;
		var msgSavedWs : string;
		
		var currrgtExpOffsetX : string;
		var currrgtExpOffsetY : string;
		var currrgtExpOffsetZ : string;
		
		var currrgtCbtOffsetX : string;
		var currrgtCbtOffsetY : string;
		var currrgtCbtOffsetZ : string;
		
		var currrgtHorseOffsetX : string;
		var currrgtHorseOffsetY : string;
		var currrgtHorseOffsetZ : string;
		
		var currrgtCbtHorseOffsetX : string;
		var currrgtCbtHorseOffsetY : string;
		var currrgtCbtHorseOffsetZ : string;
		
		var currrgtBoatOffsetX : string;
		var currrgtBoatOffsetY : string;
		var currrgtBoatOffsetZ : string;
		
		var currrgtIntOffsetX : string;
		var currrgtIntOffsetY : string;
		var currrgtIntOffsetZ : string;
		
		var currrgtWsOffsetX : string;
		var currrgtWsOffsetY : string;
		var currrgtWsOffsetZ : string;
		
		var currrgtLockOffsetX : string;
		var currrgtLockOffsetY : string;
		var currrgtLockOffsetZ : string;
		
		inGameConfigWrapper = theGame.GetInGameConfigWrapper();
		
		currrgtExpOffsetX = GetExpRGToffsetX();
		currrgtExpOffsetY = GetExpRGToffsetY();
		currrgtExpOffsetZ = GetExpRGToffsetZ();
		
		currrgtCbtOffsetX = GetCbtRGToffsetX();
		currrgtCbtOffsetY = GetCbtRGToffsetY();
		currrgtCbtOffsetZ = GetCbtRGToffsetZ();
		
		currrgtHorseOffsetX = GetHorseRGToffsetX();
		currrgtHorseOffsetY = GetHorseRGToffsetY();
		currrgtHorseOffsetZ = GetHorseRGToffsetZ();
		
		currrgtCbtHorseOffsetX = GetCbtHorseRGToffsetX();
		currrgtCbtHorseOffsetY = GetCbtHorseRGToffsetY();
		currrgtCbtHorseOffsetZ = GetCbtHorseRGToffsetZ();
		
		currrgtBoatOffsetX = GetBoatRGToffsetX();
		currrgtBoatOffsetY = GetBoatRGToffsetY();
		currrgtBoatOffsetZ = GetBoatRGToffsetZ();
		
		currrgtIntOffsetX = GetIntRGToffsetX();
		currrgtIntOffsetY = GetIntRGToffsetY();
		currrgtIntOffsetZ = GetIntRGToffsetZ();
		
		currrgtWsOffsetX = GetWsRGToffsetX();
		currrgtWsOffsetY = GetWsRGToffsetY();
		currrgtWsOffsetZ = GetWsRGToffsetZ();
		
		currrgtLockOffsetX = GetLockedRGToffsetX();
		currrgtLockOffsetY = GetLockedRGToffsetY();
		currrgtLockOffsetZ = GetLockedRGToffsetZ();

		msgSavedExp = "Exploration Camera Saved";
		msgSavedCbt = "Combat Camera Saved";
		msgSavedHorse = "Horse Riding Camera Saved";
		msgSavedCbtHorse = "Horse Riding - Combat Camera Saved";
		msgSavedBoat = "Sailing Camera Saved";
		msgSavedLock = "Combat - Locked to Target Camera Saved";
		msgSavedInt = "Interiors Camera Saved";
		msgSavedWs = "Witcher Senses Camera Saved";
		
		msgDisableShTo = "Before Saving Disable the Shoulder Toggle";
		
		rgtCamState = GetCamState();
		
		if(!GetRGTisShoulderToggled())
		{
			if(rgtCamState == RGT_WitcherSenses)
			{
				inGameConfigWrapper.SetVarValue('RGTws', 'RGTWsOffsetX', currrgtWsOffsetX);
				inGameConfigWrapper.SetVarValue('RGTws', 'RGTWsOffsetY', currrgtWsOffsetY);
				inGameConfigWrapper.SetVarValue('RGTws', 'RGTWsOffsetZ', currrgtWsOffsetZ);
				thePlayer.DisplayHudMessage(msgSavedWs);
			}
			else if(rgtCamState == RGT_Interiors)
			{
				inGameConfigWrapper.SetVarValue('RGTint', 'RGTIntOffsetX', currrgtIntOffsetX);
				inGameConfigWrapper.SetVarValue('RGTint', 'RGTIntOffsetY', currrgtIntOffsetY);
				inGameConfigWrapper.SetVarValue('RGTint', 'RGTIntOffsetZ', currrgtIntOffsetZ);
				thePlayer.DisplayHudMessage(msgSavedInt);
			}
			else if(rgtCamState == RGT_Exploration)
			{
				inGameConfigWrapper.SetVarValue('RGTexp', 'RGTexpOffsetX', currrgtExpOffsetX);
				inGameConfigWrapper.SetVarValue('RGTexp', 'RGTexpOffsetY', currrgtExpOffsetY);
				inGameConfigWrapper.SetVarValue('RGTexp', 'RGTexpOffsetZ', currrgtExpOffsetZ);
				thePlayer.DisplayHudMessage(msgSavedExp);
			}
			else if(rgtCamState == RGT_CombatLocked)
			{
				inGameConfigWrapper.SetVarValue('RGTlocked', 'RGTLockedOffsetX', currrgtLockOffsetX);
				inGameConfigWrapper.SetVarValue('RGTlocked', 'RGTLockedOffsetY', currrgtLockOffsetY);
				inGameConfigWrapper.SetVarValue('RGTlocked', 'RGTLockedOffsetZ', currrgtLockOffsetZ);
				thePlayer.DisplayHudMessage(msgSavedLock);
			}
			else if(rgtCamState == RGT_Combat)
			{
				inGameConfigWrapper.SetVarValue('RGTcbt', 'RGTcbtOffsetX', currrgtCbtOffsetX);
				inGameConfigWrapper.SetVarValue('RGTcbt', 'RGTcbtOffsetY', currrgtCbtOffsetY);
				inGameConfigWrapper.SetVarValue('RGTcbt', 'RGTcbtOffsetZ', currrgtCbtOffsetZ);
				thePlayer.DisplayHudMessage(msgSavedCbt);
			}
			else if(rgtCamState == RGT_HorseCombat)
			{
				inGameConfigWrapper.SetVarValue('RGTcbthorse', 'RGTCbtHorseOffsetX', currrgtCbtHorseOffsetX);
				inGameConfigWrapper.SetVarValue('RGTcbthorse', 'RGTCbtHorseOffsetY', currrgtCbtHorseOffsetY);
				inGameConfigWrapper.SetVarValue('RGTcbthorse', 'RGTCbtHorseOffsetZ', currrgtCbtHorseOffsetZ);
				thePlayer.DisplayHudMessage(msgSavedCbtHorse);
			}
			else if(rgtCamState == RGT_Horse)
			{
				inGameConfigWrapper.SetVarValue('RGThorse', 'RGTHorseOffsetX', currrgtHorseOffsetX);
				inGameConfigWrapper.SetVarValue('RGThorse', 'RGTHorseOffsetY', currrgtHorseOffsetY);
				inGameConfigWrapper.SetVarValue('RGThorse', 'RGTHorseOffsetZ', currrgtHorseOffsetZ);
				thePlayer.DisplayHudMessage(msgSavedHorse);
			}
			else if(rgtCamState == RGT_Boat)
			{
				inGameConfigWrapper.SetVarValue('RGTboat', 'RGTBoatOffsetX', currrgtBoatOffsetX);
				inGameConfigWrapper.SetVarValue('RGTboat', 'RGTBoatOffsetY', currrgtBoatOffsetY);
				inGameConfigWrapper.SetVarValue('RGTboat', 'RGTBoatOffsetZ', currrgtBoatOffsetZ);
				thePlayer.DisplayHudMessage(msgSavedBoat);
			}
		}
		else
			thePlayer.DisplayHudMessage(msgDisableShTo);
	}
	
	// Message Functions
	public function displayMSGRGTcheckOffsets() : void
	{
		var msgExp : string;
		var msgCbt : string;
		var msgHorse : string;
		var msgCbtHorse : string;
		var msgBoat : string;
		var msgInt : string;
		var msgWs : string;
		var msgLock : string;
		
		var msgExpOFF : string;
		var msgCbtOFF : string;
		var msgHorseOFF : string;
		var msgCbtHorseOFF : string;
		var msgBoatOFF : string;
		var msgIntOFF : string;
		var msgWsOFF : string;
		var msgLockOFF : string;
		
		var currrgtExpOffsetX : string;
		var currrgtExpOffsetY : string;
		var currrgtExpOffsetZ : string;
		
		var currrgtCbtOffsetX : string;
		var currrgtCbtOffsetY : string;
		var currrgtCbtOffsetZ : string;
		
		var currrgtHorseOffsetX : string;
		var currrgtHorseOffsetY : string;
		var currrgtHorseOffsetZ : string;
		
		var currrgtCbtHorseOffsetX : string;
		var currrgtCbtHorseOffsetY : string;
		var currrgtCbtHorseOffsetZ : string;
		
		var currrgtBoatOffsetX : string;
		var currrgtBoatOffsetY : string;
		var currrgtBoatOffsetZ : string;
		
		var currrgtIntOffsetX : string;
		var currrgtIntOffsetY : string;
		var currrgtIntOffsetZ : string;
		
		var currrgtWsOffsetX : string;
		var currrgtWsOffsetY : string;
		var currrgtWsOffsetZ : string;
		
		var currrgtLockOffsetX : string;
		var currrgtLockOffsetY : string;
		var currrgtLockOffsetZ : string;
		
		var currShToggSt : string;
		
		currrgtExpOffsetX = GetExpRGToffsetX();
		currrgtExpOffsetY = GetExpRGToffsetY();
		currrgtExpOffsetZ = GetExpRGToffsetZ();
		
		currrgtCbtOffsetX = GetCbtRGToffsetX();
		currrgtCbtOffsetY = GetCbtRGToffsetY();
		currrgtCbtOffsetZ = GetCbtRGToffsetZ();
		
		currrgtHorseOffsetX = GetHorseRGToffsetX();
		currrgtHorseOffsetY = GetHorseRGToffsetY();
		currrgtHorseOffsetZ = GetHorseRGToffsetZ();
		
		currrgtCbtHorseOffsetX = GetCbtHorseRGToffsetX();
		currrgtCbtHorseOffsetY = GetCbtHorseRGToffsetY();
		currrgtCbtHorseOffsetZ = GetCbtHorseRGToffsetZ();
		
		currrgtBoatOffsetX = GetBoatRGToffsetX();
		currrgtBoatOffsetY = GetBoatRGToffsetY();
		currrgtBoatOffsetZ = GetBoatRGToffsetZ();
		
		currrgtIntOffsetX = GetIntRGToffsetX();
		currrgtIntOffsetY = GetIntRGToffsetY();
		currrgtIntOffsetZ = GetIntRGToffsetZ();
		
		currrgtWsOffsetX = GetWsRGToffsetX();
		currrgtWsOffsetY = GetWsRGToffsetY();
		currrgtWsOffsetZ = GetWsRGToffsetZ();
		
		currrgtLockOffsetX = GetLockedRGToffsetX();
		currrgtLockOffsetY = GetLockedRGToffsetY();
		currrgtLockOffsetZ = GetLockedRGToffsetZ();
		
		rgtCamState = GetCamState();
		
		if(GetRGTisShoulderToggled())
			currShToggSt = "Shoulder Toggled";
		else
			currShToggSt = "Shoulder UnToggled";
		
		msgExp = "Exploring, " + currShToggSt + ", X= " + currrgtExpOffsetX + " Y= " + currrgtExpOffsetY + "," + " Z=" +  currrgtExpOffsetZ;
		msgCbt = "Combat, " + currShToggSt + ", X= " + currrgtCbtOffsetX + "," + " Y= " + currrgtCbtOffsetY + "," + " Z=" +  currrgtCbtOffsetZ;
		msgHorse = "Horse Riding, " + currShToggSt + ", X= " + currrgtHorseOffsetX + "," + " Y= " + currrgtHorseOffsetY + "," + " Z=" +  currrgtHorseOffsetZ;
		msgCbtHorse = "Horse Riding Combat, " + currShToggSt + ", X= " + currrgtCbtHorseOffsetX + "," + " Y= " + currrgtCbtHorseOffsetY + "," + " Z=" +  currrgtCbtHorseOffsetZ;
		msgBoat = "Sailing, " + currShToggSt + ", X= " + currrgtBoatOffsetX + "," + " Y= " + currrgtBoatOffsetY + "," + " Z=" +  currrgtBoatOffsetZ;
		msgInt = "Interior, " + currShToggSt + ", X= " + currrgtIntOffsetX + "," + " Y= " + currrgtIntOffsetY + "," + " Z=" +  currrgtIntOffsetZ;
		msgWs = "Witcher Senses, " + currShToggSt + ", X= " + currrgtWsOffsetX + "," + " Y= " + currrgtWsOffsetY + "," + " Z=" +  currrgtWsOffsetZ;
		msgLock = "Locked to Target, " + currShToggSt + ", X= " + currrgtLockOffsetX + "," + " Y= " + currrgtLockOffsetY + "," + " Z=" +  currrgtLockOffsetZ;
		
		msgExpOFF = "Custom Exploration Camera is OFF";
		msgCbtOFF = "Custom Combat Camera is OFF";
		msgHorseOFF = "Custom Horse Riding Camera is OFF";
		msgCbtHorseOFF = "Custom Horse Riding Combat Camera is OFF";
		msgBoatOFF = "Custom Sailing Camera is OFF";
		msgIntOFF = "Custom Interiors Camera is OFF";
		msgWsOFF = "Custom Witcher Senses Camera is OFF";
		msgLockOFF = "Custom Combat - Locked to Target Camera is OFF";
		
			switch(rgtCamState)
			{
				case RGT_Exploration :
					thePlayer.DisplayHudMessage(msgExp);
				break;
				
				case RGT_Combat :
					thePlayer.DisplayHudMessage(msgCbt);
				break;
				
				case RGT_CombatLocked :
					thePlayer.DisplayHudMessage(msgLock);
				break;
				
				case RGT_Horse :
					thePlayer.DisplayHudMessage(msgHorse);
				break;
				
				case RGT_HorseCombat :
					thePlayer.DisplayHudMessage(msgCbtHorse);
				break;
				
				case RGT_Boat :
					thePlayer.DisplayHudMessage(msgBoat);
				break;
				
				case RGT_Interiors :
					thePlayer.DisplayHudMessage(msgInt);
				break;
				
				case RGT_WitcherSenses :
					thePlayer.DisplayHudMessage(msgWs);
				break;
				
				case RGT_WitcherSensesOFF :
					thePlayer.DisplayHudMessage(msgWsOFF);
				break;
				
				case RGT_InteriorsOFF :
					thePlayer.DisplayHudMessage(msgIntOFF);
				break;
				
				case RGT_ExplorationOFF :
					thePlayer.DisplayHudMessage(msgExpOFF);
				break;
				
				case RGT_CombatLockedOFF :
					thePlayer.DisplayHudMessage(msgLockOFF);
				break;
				
				case RGT_CombatOFF :
					thePlayer.DisplayHudMessage(msgCbtOFF);
				break;
				
				case RGT_HorseCombatOFF :
					thePlayer.DisplayHudMessage(msgCbtHorseOFF);
				break;
				
				case RGT_HorseOFF :
					thePlayer.DisplayHudMessage(msgHorseOFF);
				break;
				
				case RGT_BoatOFF :
					thePlayer.DisplayHudMessage(msgBoatOFF);
				break;
			}
	}	
}	
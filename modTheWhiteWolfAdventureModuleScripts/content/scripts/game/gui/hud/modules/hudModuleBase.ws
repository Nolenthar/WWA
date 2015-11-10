class CR4HudModuleBase extends CR4HudModule
{	
	protected var m_fxSetControllerType  : CScriptedFlashFunction;
	protected var m_fxSetPlatform       : CScriptedFlashFunction;
	protected var m_fxShowElementSFF		: CScriptedFlashFunction;
	protected var m_fxSetMaxOpacitySFF		: CScriptedFlashFunction;
	protected var m_fxSetEnabledSFF			: CScriptedFlashFunction;
	protected var m_fxSetScaleFromWSSFF		: CScriptedFlashFunction;
	protected var m_fxShowTutorialHighlightSFF	: CScriptedFlashFunction;
	protected var m_anchorName				: string;							default m_anchorName = "";
	protected var curResolutionWidth		: float;							default curResolutionWidth = 1920.0;
	protected var curResolutionHeight		: float;							default curResolutionHeight = 1080.0;
	protected var m_bEnabled 				: bool; 							default m_bEnabled = true;
	
	protected var m_tickInterval			: float;							default m_tickInterval = 0.1;
	protected var m_tickCounter				: float;							default m_tickCounter = 0;

	//---=== modFriendlyHUD ===---
	protected var isEnabledTemporarily		: bool;								default isEnabledTemporarily = false;
	protected var isShownTemporarily		: bool;								default isShownTemporarily = false;
	protected var toggleReasons				: array< string >;
	
	public function IsEnabledForReason( reason : string ) : bool
	{
		return toggleReasons.Contains( reason );
	}
	
	public function IsVisibleTemporarily() : bool
	{
		return ( isEnabledTemporarily || isShownTemporarily );
	}
	
	public function ToggleEnabledTemporarily( toggle : bool, reason : string  )
	{
		if ( toggle )
		{
			ToggleOnTemporarily( reason );
		}
		else
		{
			ToggleOffTemporarily( reason );
		}
	}
	
	private function ToggleOnTemporarily( reason : string )
	{
		if ( toggleReasons.Contains( reason ) )
		{
			return;
		}
		toggleReasons.PushBack( reason );
		if ( !GetEnabled() )
		{
			isEnabledTemporarily = true;
			SetEnabled( true );
		}
		if ( !((CR4HudModuleDamagedItems)this) )
		{
			if ( !GetModuleFlash().GetVisible() )
			{
				isShownTemporarily = true;
				ShowElement( true, true );
			}
		}
	}
	
	private function ToggleOffTemporarily( reason : string )
	{
		if ( !toggleReasons.Contains( reason ) )
		{
			return;
		}
		toggleReasons.Erase( toggleReasons.FindFirst( reason ) );
		if ( toggleReasons.Size() > 0 )
		{
			return;
		}
		if ( isShownTemporarily )
		{
			isShownTemporarily = false;
			ShowElement( false, true );
		}
		if ( isEnabledTemporarily )
		{
			isEnabledTemporarily = false;
			SetEnabled( false );
		}
	}
	//---=== modFriendlyHUD ===---

	event /* flash */ OnConfigUI()


	{	
		var l_flashModule : CScriptedFlashSprite;
		
		l_flashModule 		= GetModuleFlash();	
		AddHudModuleReference( this );
		
		m_fxSetControllerType = l_flashModule.GetMemberFlashFunction( "setControllerType" );
		m_fxSetPlatform = l_flashModule.GetMemberFlashFunction( "setPlatform" );
		
		m_fxShowElementSFF	= l_flashModule.GetMemberFlashFunction( "ShowElement" );
		m_fxSetMaxOpacitySFF	= l_flashModule.GetMemberFlashFunction( "SetMaxOpacity" );
		m_fxSetEnabledSFF	= l_flashModule.GetMemberFlashFunction( "SetEnabled" );
		m_fxSetScaleFromWSSFF	= l_flashModule.GetMemberFlashFunction( "SetScaleFromWS" );
		m_fxShowTutorialHighlightSFF	= l_flashModule.GetMemberFlashFunction( "ShowTutorialHighlight" );
		
		SetControllerType(theInput.LastUsedGamepad());
		SetPlatformType(theGame.GetPlatform());
		//SetPlatformType(Platform_PS4);
		
		SnapToAnchorPosition();
	}	
	
	function AddHudModuleReference( hudModule : CR4HudModuleBase )
	{
		var hud : CR4ScriptedHud;
		hud = (CR4ScriptedHud)theGame.GetHud();
		if( hud )
		{
			hud.AddHudModuleReference( hudModule );
		}
	}
	
	function ShowElement( show : bool, optional bImmediately : bool )
	{
		//---=== modFriendlyHUD ===---
		if( !isShownTemporarily || show == true )
		{
			m_fxShowElementSFF.InvokeSelfTwoArgs( FlashArgBool( show ), FlashArgBool( bImmediately ) );
		}
		//---=== modFriendlyHUD ===---
	}	

	function SetEnabled( value : bool )
	{
		//---=== modFriendlyHUD ===---
		if( !isEnabledTemporarily || value == true )
		{
			m_bEnabled = value;
			m_fxSetEnabledSFF.InvokeSelfOneArg( FlashArgBool( m_bEnabled ) );
		}
		//---=== modFriendlyHUD ===---
	}	

	function GetEnabled() : bool
	{
		return m_bEnabled;
	}
	
	public function SnapToAnchorPosition()
	{
		var l_hud 				: CR4ScriptedHud;
		var l_hudModuleAnchors	: CR4HudModuleAnchors;
		var l_mcAnchor			: CScriptedFlashSprite;
		var l_flashModule 		: CScriptedFlashSprite;
		var l_scale 			: float;	
		var anchorX				: float;
		var anchorY				: float;
		
		if( m_anchorName == "" )
		{
			return;
		}
		
		if( m_anchorName != "ScaleOnly" )
		{		
			l_hud 				= (CR4ScriptedHud)theGame.GetHud();
			l_hudModuleAnchors	= (CR4HudModuleAnchors) l_hud.GetHudModule( "AnchorsModule" );
			
			if(! l_hudModuleAnchors )
			{		
				return;
			}
			
			l_mcAnchor 		= l_hudModuleAnchors.GetAnchorSprite( m_anchorName );
			
			anchorX = l_mcAnchor.GetX();
			anchorY = l_mcAnchor.GetY();
		}

		l_flashModule 	= GetModuleFlash();	
		
		m_fxSetMaxOpacitySFF.InvokeSelfOneArg(FlashArgNumber(theGame.GetUIOpacity() ));
		
		l_scale = theGame.GetUIScale() + theGame.GetUIGamepadScaleGain();
		if( UpdateScale( l_scale, l_flashModule) )	
		{
			UpdatePosition(anchorX, anchorY);
		}
	}
	
	protected function UpdatePosition(anchorX:float, anchorY:float) : void
	{
		var tempX				: float;
		var tempY				: float;
		var l_flashModule 		: CScriptedFlashSprite;
		
		l_flashModule 	= GetModuleFlash();
		
		tempX = ( anchorX - curResolutionWidth/2 ) *( theGame.GetUIHorizontalFrameScale() ) + curResolutionWidth/2;
		tempY = ( anchorY - curResolutionHeight/2 ) * (theGame.GetUIVerticalFrameScale() ) + curResolutionHeight/2;
		l_flashModule.SetX( tempX );
		l_flashModule.SetY( tempY );	
	}
	
	protected function UpdateScale( scale : float, flashModule : CScriptedFlashSprite ) : bool
	{
		//LogChannel('SCALE',"");
		//LogChannel('SCALE',"anchor "+m_anchorName);
		//LogChannel('SCALE',"TO SET "+scale);
		//LogChannel('SCALE',"BEFORE "+flashModule.GetXScale());
		
		m_fxSetScaleFromWSSFF.InvokeSelfOneArg(FlashArgNumber(scale));
		if( m_anchorName == "ScaleOnly" )
		{	
			//LogChannel('SCALE',"AFTER SFF "+flashModule.GetXScale());
			return false;
		}
		return true;
	}
	
	event /*flash*/ OnBreakPoint( text : string )
	{
		LogChannel('HUDBreakpoint'," text "+text);
	}
	
	public function ShowTutorialHighlight( bShow : bool, tutorialHighlightName : string )
	{
		m_fxShowTutorialHighlightSFF.InvokeSelfTwoArgs(FlashArgBool(bShow),FlashArgString(tutorialHighlightName));
	}
	
	protected function SetControllerType(isGamepad:bool):void
	{
		if (m_fxSetControllerType)	
		{
			m_fxSetControllerType.InvokeSelfOneArg( FlashArgBool(isGamepad) );
		}
	}
	
	protected function SetPlatformType(platformType:Platform):void
	{
		if (m_fxSetPlatform)
		{
			m_fxSetPlatform.InvokeSelfOneArg( FlashArgInt(platformType) );
		}
	}
	
	public function SetTickInterval( tickInterval : float )
	{
		if ( tickInterval < 0 )
		{
			tickInterval = 0;
		}
		else if ( tickInterval > 1 )
		{
			tickInterval = 1;
		}
		m_tickInterval = tickInterval;
	}

	public function CanTick( timeDelta : float ) : bool
	{
		m_tickCounter -= timeDelta;
		if ( m_tickCounter < 0 )
		{
			m_tickCounter += m_tickInterval;
			return true;
		}
		return false;
	}
	
	event OnPlaySoundEvent( soundName : string )
	{
		theSound.SoundEvent( soundName );
	}
}
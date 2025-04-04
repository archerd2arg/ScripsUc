class CommandWndScript extends UICommonAPI;


function OnClickButton( string Name )
{
	switch( Name )
	{
		case "BtnFarm": 		
			OnBtnFarm();
			break;
		
		case "BtnEnchant": 		
			OnBtnEnchant();
			break;
		
		case "BtnDeposit": 		
			OnBtnDeposit();
			break;
		
		case "BtnWithdraw": 		
			OnBtnWithdraw();
			break;
	}
}

function OnBtnFarm()
{
	local UserInfo	info;
	local int		Level;
	
	if (GetMyUserInfo(info))
		{
			Level = info.nLevel;
			if (Level < 10)
			{
				AddSystemMessageString("Function unlock lvl 10");
			}else
			{
				ExecuteCommand(".farm");
			}
		}	
}

function OnBtnEnchant()
{
	local UserInfo	info;
	local int		Level;
	
	if (GetMyUserInfo(info))
		{
			Level = info.nLevel;
			if (Level < 10)
			{
				AddSystemMessageString("Function unlock lvl 10");
			}else
			{
				ExecuteCommand(".enchant");
			}
		}	
}

function OnBtnDeposit()
{
	local UserInfo	info;
	local int		Level;
	
	if (GetMyUserInfo(info))
		{
			Level = info.nLevel;
			if (Level < 10)
			{
				AddSystemMessageString("Function unlock lvl 10");
			}else
			{
				ExecuteCommand(".deposit");
			}
		}	
}

function OnBtnWithdraw()
{
	local UserInfo	info;
	local int		Level;
	
	if (GetMyUserInfo(info))
		{
			Level = info.nLevel;
			if (Level < 10)
			{
				AddSystemMessageString("Function unlock lvl 10");
			}else
			{
				ExecuteCommand(".withdraw");
			}
		}	
}


function bool GetMyUserInfo( out UserInfo a_MyUserInfo )
{
	return GetPlayerInfo( a_MyUserInfo );
}

defaultproperties
{
}

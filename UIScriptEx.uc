class UIScriptEx extends UIScript;

//Передаю привет ебаной крысе "мне только для себя" ArtToKill

function string Int64ToString(INT64 int64Param)
{
	local string int64String;
	local string paramBuffer;
	
	ParamAddINT64(paramBuffer, "INT64buffer", int64Param);
	ParseString(paramBuffer, "INT64buffer", int64String);
	
	return int64String;
}


function INT64 StringToInt64(string int64String)
{
	local INT64 int64Param;
	local string paramBuffer;
	
	ParamAdd(paramBuffer, "INT64buffer", int64String);
	ParseINT64(paramBuffer, "INT64buffer", int64Param);
	
	return int64Param;
}

function bool Int64ToBool(INT64 int64Param)
{
	if(int64Param > IntToInt64(0))
		return true;
	else
		return false;
}
function INT64 BoolToInt64(bool flag)
{
	if(flag)
		return IntToInt64(1);
	else
		return IntToInt64(0);
}

function int Int64ToInt(INT64 int64Param)
{
	local int intParam;
	local string paramBuffer;
	
	ParamAddINT64(paramBuffer, "INT64buffer", int64Param);
	if(!ParseInt(paramBuffer, "INT64buffer", intParam))
	{
		intParam = 0;
	}
	
	return intParam;
}

function INT64 IntToInt64(int intParam)
{
	local INT64 int64Param;
	local string paramBuffer;
	
	ParamAdd(paramBuffer, "INT64buffer", string(intParam));
	ParseINT64(paramBuffer, "INT64buffer", int64Param);
	
	return int64Param;
}

simulated function string Replace(string Text, string Match, string Replacement)
{
    local int i;
    
    i = InStr(Text, Match); 

    if(i != -1)
        return Left(Text, i) $ Replacement $ Replace(Mid(Text, i+Len(Match)), Match, Replacement);
    else
        return Text;
}

defaultproperties
{
}

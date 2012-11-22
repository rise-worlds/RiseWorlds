#include "pch.h"
#include "Framework.h"
#include "ILogic.h"

Framework::Framework(void)
{
}


Framework::~Framework(void)
{
}

void Framework::regLogic( UINT logicID, ILogic* logic )
{
	LogicMap::iterator iter = logicMap.find(logicID);
	if(iter == logicMap.end())
	{
		logicMap[logicID] = logic;
	}
}

void Framework::update( float fTime )
{
	LogicMap::iterator iter = logicMap.begin();
	while (iter != logicMap.end())
	{
		ILogic* logic = iter->second;
		logic->update(fTime);
		iter++;
	}
}

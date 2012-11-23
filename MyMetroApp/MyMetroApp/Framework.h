#pragma once
#pragma once
#include <map>

using namespace std;

class ILogic;
class Framework
{
public:
	Framework(void);
	~Framework(void);

	void regLogic(unsigned int logicID, ILogic* logic);
	

	void update(float fTime);

	typedef map<UINT, ILogic*> LogicMap;
private:
	LogicMap logicMap;
};


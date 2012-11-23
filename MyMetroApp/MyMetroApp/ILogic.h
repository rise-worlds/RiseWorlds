
class ILogic
{
public:
	virtual void init() = 0;
	virtual void update(float fTime) = 0;
	virtual void shut() = 0;
};
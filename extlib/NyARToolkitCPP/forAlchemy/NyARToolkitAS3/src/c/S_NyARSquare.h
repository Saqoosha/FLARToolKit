#pragma once
#include "NyARSquare.h"

class S_NyARSquare : public AlchemyClassStub<NyARSquare>
{
private:
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARSquare* inst=new S_NyARSquare();
		//初期化
		inst->initRelStub(new NyARSquare());
		//AS3オブジェクト化
		return inst->toAS3Object();
	}
	static AS3_Val createReference(const NyARSquare* i_ref)
	{
		//参照生成はm_bufの参照もコピーすること！
		return NULL;
	}

	//自身のオブジェクトをAS3オブジェクトにする。
	void initAS3Object(AS3ObjectBuilder& i_builder)
	{
		AlchemyClassStub<NyARSquare>::initAS3Object(i_builder);
		return;
	}
	~S_NyARSquare()
	{
	}
private:
};

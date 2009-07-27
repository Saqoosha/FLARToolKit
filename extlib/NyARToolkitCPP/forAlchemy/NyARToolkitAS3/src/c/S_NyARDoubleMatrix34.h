#pragma once
#include "NyARDoubleMatrix34.h"
class S_NyARDoubleMatrix34 : public T_NyARDoubleMatrix34<NyARDoubleMatrix34>
{
public:
	//標準的なインスタンス生成関数です。
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARDoubleMatrix34* inst=new S_NyARDoubleMatrix34();
		//初期化
		inst->initRelStub(new NyARDoubleMatrix34());
		//AS3オブジェクト化
		return inst->toAS3Object();
	}
	//自身のオブジェクトをAS3オブジェクトにする。
	void initAS3Object(AS3ObjectBuilder& i_builder)
	{
		T_NyARDoubleMatrix34<NyARDoubleMatrix34>::initAS3Object(i_builder);
	}
};

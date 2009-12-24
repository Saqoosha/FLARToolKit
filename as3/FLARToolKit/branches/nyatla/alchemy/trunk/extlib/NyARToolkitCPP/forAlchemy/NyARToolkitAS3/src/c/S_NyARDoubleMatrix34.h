#pragma once
#include "NyARDoubleMatrix34.h"
class S_NyARDoubleMatrix34 : public T_NyARDoubleMatrix34<NyARDoubleMatrix34>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARDoubleMatrix34 class_builder;
		return class_builder.buildWithNativeInstance(self,args);
	}
protected:
	//自身のオブジェクトをAS3オブジェクトにする。
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,NyARDoubleMatrix34* i_native_inst)
	{
		T_NyARDoubleMatrix34<NyARDoubleMatrix34>::initAS3Member(i_builder,i_native_inst);
		return;
	}
	/*　AS3 Argument protocol
	 */
	virtual NyARDoubleMatrix34* createNativeInstance(AS3_Val args)
	{
		return new NyARDoubleMatrix34();
	}
};

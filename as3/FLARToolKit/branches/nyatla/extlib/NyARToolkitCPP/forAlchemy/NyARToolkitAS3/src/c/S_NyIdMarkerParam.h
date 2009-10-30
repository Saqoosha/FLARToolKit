#pragma once
#include "NyIdMarkerParam.h"

class S_NyIdMarkerParam: public AlchemyClassBuilder<TNyIdMarkerParam>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyIdMarkerParam class_builder;
		return class_builder.buildWithNativeInstance(self,args);
	}
protected:
	//自身のオブジェクトをAS3オブジェクトにする。
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,TNyIdMarkerParam* i_native_inst)
	{
		AlchemyClassBuilder<TNyIdMarkerParam>::initAS3Member(i_builder,i_native_inst);
		i_builder.addFunction("getValue",S_NyIdMarkerParam::getValue);
		return;
	}
	virtual TNyIdMarkerParam* createNativeInstance(AS3_Val args)
	{
		return new TNyIdMarkerParam();
	}
	/*　AS3 Argument protocol
	 * 	_native    : TNyIdMarkerParam*
	 *  v          : AS3_ByteArray as int,int
	 */
	static AS3_Val getValue(void* self, AS3_Val args)
	{
		TNyIdMarkerParam* native;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType, AS3ValType", &native,&v);
		//コピーしてセット
		int work[2];
		work[0]=native->direction;
		work[1]=native->threshold;
		AS3_ByteArray_writeBytes(v,work,sizeof(int)*2);
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}
};

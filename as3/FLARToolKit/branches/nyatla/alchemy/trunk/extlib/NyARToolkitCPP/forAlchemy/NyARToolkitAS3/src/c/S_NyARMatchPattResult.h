#pragma once
#include "TNyARMatchPattResult.h"

class S_NyARMatchPattResult: public AlchemyClassBuilder<TNyARMatchPattResult>
{
private:
	struct TDataPack{
		int direction;
		double confidence;
	};

public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARMatchPattResult class_builder;
		return class_builder.buildWithNativeInstance(self,args);
	}
protected:
	//自身のオブジェクトをAS3オブジェクトにする。
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,TNyARMatchPattResult* i_native_inst)
	{
		AlchemyClassBuilder<TNyARMatchPattResult>::initAS3Member(i_builder,i_native_inst);
		i_builder.addFunction("setValue",S_NyARMatchPattResult::setValue);
		i_builder.addFunction("getValue",S_NyARMatchPattResult::getValue);
		return;
	}
	/*　AS3 Argument protocol
	 */
	virtual TNyARMatchPattResult* createNativeInstance(AS3_Val args)
	{
		return new TNyARMatchPattResult();
	}
private:
	/*　AS3 Argument protocol
	 * 	_native    : T*
	 *  v          : AS3_ByteArray as direction:int,confidence:double
	 */
	static AS3_Val setValue(void* self, AS3_Val args)
	{
		TNyARMatchPattResult* native;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType, AS3ValType", &native,&v);
		//
		AS3_ByteArray_readBytes(&native->direction,v,sizeof(int));
		AS3_ByteArray_readBytes(&native->confidence,v,sizeof(double));
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}
	/*　AS3 Argument protocol
	 * 	_native    : T*
	 *  v          : AS3_ByteArray as direction:int,confidence:double
	 */
	static AS3_Val getValue(void* self, AS3_Val args)
	{
		TNyARMatchPattResult* native;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType, AS3ValType", &native,&v);
		//コピーしてセット
		AS3_ByteArray_writeBytes(v,&native->direction,sizeof(int));
		AS3_ByteArray_writeBytes(v,&native->confidence,sizeof(double));
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}
};

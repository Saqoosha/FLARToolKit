#pragma once
#include "NyAR_types.h"

class S_NyARIntSize: public AlchemyClassBuilder<TNyARIntSize>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARIntSize class_builder;
		return class_builder.buildWithNativeInstance(self,args);
	}
protected:
	//自身のオブジェクトをAS3オブジェクトにする。
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,TNyARIntSize* i_native_inst)
	{
		AlchemyClassBuilder<TNyARIntSize>::initAS3Member(i_builder,i_native_inst);
		i_builder.addFunction("setValue",S_NyARIntSize::setValue);
		i_builder.addFunction("getValue",S_NyARIntSize::getValue);
		return;
	}
	/*　AS3 Argument protocol
	 */
	virtual TNyARIntSize* createNativeInstance(AS3_Val args)
	{
		return new TNyARIntSize();
	}
private:
	/*　AS3 Argument protocol
	 * 	_native    : AlchemyClassStub<T>*
	 *  v          : AS3_ByteArray
	 */
	static AS3_Val setValue(void* self, AS3_Val args)
	{
		TNyARIntSize* native;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType, AS3ValType", &native,&v);
		//
		int work[2];
		AS3_ByteArray_readBytes(work,v,sizeof(int)*2);
		native->w=work[0];
		native->h=work[1];
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}
	/*　AS3 Argument protocol
	 * 	_native    : AlchemyClassStub<T>*
	 *  v          : AS3_ByteArray
	 */
	static AS3_Val getValue(void* self, AS3_Val args)
	{
		TNyARIntSize* native;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType, AS3ValType", &native,&v);
		//コピーしてセット
		int work[2];
		work[0]=native->w;
		work[1]=native->h;
		AS3_ByteArray_writeBytes(v,work,sizeof(int)*4);
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}
};

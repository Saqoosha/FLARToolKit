#pragma once
#include "NyARCameraDistortionFactor.h"
class S_NyARCameraDistortionFactor: public AlchemyClassBuilder<NyARCameraDistortionFactor>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARCameraDistortionFactor class_builder;
		return class_builder.buildWithNativeInstance(self,args);
	}
protected:
	//自身のオブジェクトをAS3オブジェクトにする。
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,NyARCameraDistortionFactor* i_native_inst)
	{
		AlchemyClassBuilder<NyARCameraDistortionFactor>::initAS3Member(i_builder,i_native_inst);
		i_builder.addFunction("setValue",S_NyARCameraDistortionFactor::setValue);
		i_builder.addFunction("getValue",S_NyARCameraDistortionFactor::getValue);
		return;
	}
	/*　AS3 Argument protocol
	 */
	virtual NyARCameraDistortionFactor* createNativeInstance(AS3_Val args)
	{
		return new NyARCameraDistortionFactor();
	}
private:
	/*　AS3 Argument protocol
	 * native  :NyARCameraDistortionFactor*
	 * v       :ByteArray as double[4]
	 */
	static AS3_Val setValue(void* self, AS3_Val args)
	{
		NyARCameraDistortionFactor* inst;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType, AS3ValType", &inst,&v);
		//
		double work[4];
		AS3_ByteArray_readBytes(work,v,sizeof(double)*4);
		//Cのアクセス制御を強引に突破する。
		inst->setValue(work);
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}
	/*　AS3 Argument protocol
	 * native  :NyARCameraDistortionFactor*
	 * v       :ByteArray as double[4]
	 */
	static AS3_Val getValue(void* self, AS3_Val args)
	{
		NyARCameraDistortionFactor* inst;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType, AS3ValType", &inst,&v);
		//コピーしてセット
		double work[4];
		inst->getValue(work);
		AS3_ByteArray_writeBytes(v,work,sizeof(double)*4);
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}
};

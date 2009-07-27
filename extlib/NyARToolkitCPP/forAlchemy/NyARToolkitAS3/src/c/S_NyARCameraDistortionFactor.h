#pragma once
#include "NyARCameraDistortionFactor.h"
class S_NyARCameraDistortionFactor: public AlchemyClassStub<NyARCameraDistortionFactor>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARCameraDistortionFactor* inst=new S_NyARCameraDistortionFactor();
		//初期化
		inst->initRelStub(new NyARCameraDistortionFactor());
		//AS3オブジェクト化
		return inst->toAS3Object();
	}
	//自身のオブジェクトをAS3オブジェクトにする。
	void initAS3Object(AS3ObjectBuilder& i_builder)
	{
		AlchemyClassStub<NyARCameraDistortionFactor>::initAS3Object(i_builder);
		i_builder.addFunction("setValue",S_NyARCameraDistortionFactor::setValue);
		i_builder.addFunction("getValue",S_NyARCameraDistortionFactor::getValue);
		return;
	}
private:
	static AS3_Val setValue(void* self, AS3_Val args)
	{
		S_NyARCameraDistortionFactor* inst;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType, AS3ValType", &inst,&v);
		//
		double work[4];
		AS3_ByteArray_readBytes(work,v,sizeof(double)*4);
		//Cのアクセス制御を強引に突破する。
		((NyARCameraDistortionFactor*)inst->m_ref)->setValue(work);
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}
	static AS3_Val getValue(void* self, AS3_Val args)
	{
		S_NyARCameraDistortionFactor* inst;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType, AS3ValType", &inst,&v);
		//コピーしてセット
		double work[4];
		inst->m_ref->getValue(work);
		AS3_ByteArray_writeBytes(v,work,sizeof(double)*4);
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}
};

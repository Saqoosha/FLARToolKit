#pragma once
#include "NyAR_types.h"

class S_NyARIntSize: public AlchemyClassStub<TNyARIntSize>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARIntSize* inst=new S_NyARIntSize();
		//初期化
		inst->initRelStub(new TNyARIntSize());
		//AS3オブジェクト化
		return inst->toAS3Object();
	}
	static AS3_Val createReference(const TNyARIntSize* i_ref)
	{
		S_NyARIntSize* inst=new S_NyARIntSize();
		//初期化
		inst->initRefStub(i_ref);
		//AS3オブジェクト化
		return inst->toAS3Object();
	}
	//自身のオブジェクトをAS3オブジェクトにする。
	void initAS3Object(AS3ObjectBuilder& i_builder)
	{
		AlchemyClassStub<TNyARIntSize>::initAS3Object(i_builder);
		i_builder.addFunction("setValue",S_NyARIntSize::setValue);
		i_builder.addFunction("getValue",S_NyARIntSize::getValue);
		return;
	}
private:
	static AS3_Val setValue(void* self, AS3_Val args)
	{
		S_NyARIntSize* inst;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType, AS3ValType", &inst,&v);
		//
		int work[2];
		AS3_ByteArray_readBytes(work,v,sizeof(int)*2);
		//Cのアクセス制御を強引に突破する。
		TNyARIntSize* s=(TNyARIntSize*)inst->m_ref;
		s->w=work[0];
		s->h=work[1];
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}
	static AS3_Val getValue(void* self, AS3_Val args)
	{
		S_NyARIntSize* inst;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType, AS3ValType", &inst,&v);
		//コピーしてセット
		int work[2];
		TNyARIntSize* s=(TNyARIntSize*)inst->m_ref;
		work[0]=s->w;
		work[1]=s->h;
		AS3_ByteArray_writeBytes(v,work,sizeof(int)*4);
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}
};

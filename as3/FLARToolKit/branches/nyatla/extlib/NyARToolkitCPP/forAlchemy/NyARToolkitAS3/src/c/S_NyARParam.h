#pragma once
#include "NyARParam.h"

class S_NyARParam : public AlchemyClassStub<NyARParam>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARParam* inst=new S_NyARParam();
		//初期化
		inst->initRelStub(new NyARParam());
		//AS3オブジェクト化
		return inst->toAS3Object();
	}
	//自身のオブジェクトをAS3オブジェクトにする。
	void initAS3Object(AS3ObjectBuilder& i_builder)
	{
		AlchemyClassStub<NyARParam>::initAS3Object(i_builder);
		i_builder.addFunction("changeScreenSize",S_NyARParam::changeScreenSize);
		i_builder.addFunction("getPerspectiveProjectionMatrix",S_NyARParam::getPerspectiveProjectionMatrix);
		i_builder.addFunction("loadARParamFile",S_NyARParam::loadARParamFile);
		i_builder.addFunction("getScreenSize",S_NyARParam::getScreenSize);

		return;
	}
	S_NyARParam()
	{
		//メンバの初期化
		this->_wrap_size.initWrapStub();
		this->_wrap_size.toHolderObject();
		this->_wrap_prjmat.initWrapStub();
		this->_wrap_prjmat.toHolderObject();
	}
private:
	S_NyARPerspectiveProjectionMatrix _wrap_prjmat;
	S_NyARIntSize _wrap_size;
private:
	static AS3_Val changeScreenSize(void* self, AS3_Val args)
	{
		S_NyARParam* inst;
		int w,h;
		AS3_ArrayValue(args, "PtrType, IntType, IntType", &inst,&w,&h);
		((NyARParam*)(inst->m_inst))->changeScreenSize(w,h);
		return AS3_Null();
	}
	static AS3_Val getPerspectiveProjectionMatrix(void* self, AS3_Val args)
	{
		S_NyARParam* inst;
		int w,h;
		AS3_ArrayValue(args, "PtrType", &inst);
		//このオブジェクトはS_NyARParamと同期したAS3オブジェクト
		inst->_wrap_prjmat.wrapRef(&((NyARParam*)(inst->m_ref))->getPerspectiveProjectionMatrix());
		return inst->_wrap_prjmat.m_as3;
	}
	static AS3_Val loadARParamFile(void* self, AS3_Val args)
	{
		S_NyARParam* inst;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType,AS3ValType", &inst,&v);
		NyARParamFileStruct work;
		AS3_ByteArray_readBytes(&work,v,sizeof(NyARParamFileStruct));
	#if AL_ENDIAN==AL_ENDIAN_LITTLE
		//byteswap（BE→LE）
		work.x=NyStdLib::byteSwap(work.x);
		work.y=NyStdLib::byteSwap(work.y);
		for(int i=0;i<12;i++){
			work.projection[i]=NyStdLib::byteSwap(work.projection[i]);
		}
		for(int i=0;i<4;i++){
			work.distortion[i]=NyStdLib::byteSwap(work.distortion[i]);
		}
	#endif
		//Cのアクセス制御を強引に突破する。
		((NyARParam*)inst->m_ref)->loadARParam(work);
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}
	static AS3_Val getScreenSize(void* self, AS3_Val args)
	{
		S_NyARParam* inst;
		int w,h;
		AS3_ArrayValue(args, "PtrType", &inst);
		//このオブジェクトはS_NyARParamと同期したAS3オブジェクト
		inst->_wrap_size.wrapRef(&((NyARParam*)(inst->m_ref))->getScreenSize());
		return inst->_wrap_size.m_as3;
	}
};

#pragma once
#include "NyARParam.h"
#include "S_NyARPerspectiveProjectionMatrix.h"
#include "S_NyARIntSize.h"
#include "S_NyARCameraDistortionFactor.h"

class S_NyARParam : public AlchemyClassBuilder<NyARParam>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARParam class_builder;
		return class_builder.buildWithNativeInstance(self,args);
	}
protected:
	//自身のオブジェクトをAS3オブジェクトにする。
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,NyARParam* i_native_inst)
	{
		AlchemyClassBuilder<NyARParam>::initAS3Member(i_builder,i_native_inst);
		i_builder.addFunction("changeScreenSize",S_NyARParam::changeScreenSize);
		i_builder.addFunction("loadARParamFile",S_NyARParam::loadARParamFile);
		//getPerspectiveProjectionMatrixはAS3側で実装
		//getScreenSizeはAS3側で実装

		//AS3ポインターオブジェクト(dispose時にGC経由で解放される（はず）)
		S_NyARIntSize size;
		S_NyARPerspectiveProjectionMatrix pmat;
		S_NyARCameraDistortionFactor distfactor;

		i_builder.addAS3Val("_screen_size",size.buildWithOutNativeInstance((TNyARIntSize*)&(i_native_inst->getScreenSize())));
		i_builder.addAS3Val("_perspective_matrix",pmat.buildWithOutNativeInstance((NyARPerspectiveProjectionMatrix*)&(i_native_inst->getPerspectiveProjectionMatrix())));
		i_builder.addAS3Val("_distortion_factor",distfactor.buildWithOutNativeInstance((NyARCameraDistortionFactor*)&(i_native_inst->getDistortionFactor())));

		return;
	}
	/*　AS3 Argument protocol
	 */
	virtual NyARParam* createNativeInstance(AS3_Val args)
	{
		return new NyARParam();
	}
private:
	/*　AS3 Argument protocol
	 * 	_native    : AlchemyClassStub<T>*
	 *  w          : int
	 *  h          : int
	 */
	static AS3_Val changeScreenSize(void* self, AS3_Val args)
	{
		NyARParam* native;
		int w,h;
		AS3_ArrayValue(args, "PtrType, IntType, IntType", &native,&w,&h);
		native->changeScreenSize(w,h);
		return AS3_Null();
	}
	/*　AS3 Argument protocol
	 * 	_native    : NyARParam*
	 *  v          : AS3_ByteArray as int[12],int[4]
	 */
	static AS3_Val loadARParamFile(void* self, AS3_Val args)
	{
		NyARParam* native;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType,AS3ValType", &native,&v);
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
		native->loadARParam(work);
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}/*
	static AS3_Val getPerspectiveProjectionMatrix(void* self, AS3_Val args)
	{
		NyARParam* native;
		int w,h;
		AS3_ArrayValue(args, "PtrType", &native);
		//このオブジェクトはS_NyARParamと同期したAS3オブジェクト
		inst->_wrap_prjmat.wrapRef(native->getPerspectiveProjectionMatrix());
		return inst->_wrap_prjmat.m_as3;
	}
	static AS3_Val getScreenSize(void* self, AS3_Val args)
	{
		S_NyARParam* inst;
		int w,h;
		AS3_ArrayValue(args, "PtrType", &inst);
		//このオブジェクトはS_NyARParamと同期したAS3オブジェクト
		inst->_wrap_size.wrapRef(&((NyARParam*)(inst->m_ref))->getScreenSize());
		return inst->_wrap_size.m_as3;
	}*/
};

#pragma once
#include "T_INyARSquareDetector.h"
#include "NyARSquareDetector_Rle.h"

class S_NyARSquareDetector_Rle : public T_INyARSquareDetector<NyARSquareDetector_Rle>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARSquareDetector_Rle class_builder;
		return class_builder.buildWithNativeInstance(self,args);
	}
protected:
	//自身のオブジェクトをAS3オブジェクトにする。
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,NyARSquareDetector_Rle* i_native_inst)
	{
		T_INyARSquareDetector<NyARSquareDetector_Rle>::initAS3Member(i_builder,i_native_inst);
		return;
	}
	/*　AS3 Argument protocol
	 * _dist       :NyARCameraDistortionFactor*;
	 * _size       :TNyARIntSize*
	 */
	virtual NyARSquareDetector_Rle* createNativeInstance(AS3_Val args)
	{
		NyARCameraDistortionFactor* dist;
		TNyARIntSize* size;
		AS3_ArrayValue(args, "PtrType,PtrType", &dist,&size);
		return new NyARSquareDetector_Rle(*dist,*size);
	}
};

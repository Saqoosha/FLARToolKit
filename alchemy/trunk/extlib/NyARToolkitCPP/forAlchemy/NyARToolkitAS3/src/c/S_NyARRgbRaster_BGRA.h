#pragma once
#include "NyARRgbRaster_BGRA.h"

//バッファを保持するタイプのNyARRgbRaster_BGRA
class NyARRgbRaster_BGRA2 :public NyARRgbRaster_BGRA
{
public:
	NyAR_BYTE_t* m_buf;
public:
	static NyARRgbRaster_BGRA2* createAttachedRaster(int i_width,int i_height)
	{
		NyAR_BYTE_t* buf= new NyAR_BYTE_t[i_width*i_height*4];
		return new NyARRgbRaster_BGRA2(buf,i_width,i_height);
	}
private:
	NyARRgbRaster_BGRA2(const NyAR_BYTE_t* i_buffer,int i_width,int i_height):NyARRgbRaster_BGRA(i_buffer,i_width,i_height)
	{
		this->m_buf=(NyAR_BYTE_t*)i_buffer;
	}
public:
	NyARRgbRaster_BGRA2::~NyARRgbRaster_BGRA2()
	{
		delete this->m_buf;
		return;
	}
};

class S_NyARRgbRaster_BGRA : public T_INyARRgbRaster<NyARRgbRaster_BGRA2>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARRgbRaster_BGRA class_builder;
		return class_builder.buildWithNativeInstance(self,args);
	}
protected:
	//自身のオブジェクトをAS3オブジェクトにする。
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,NyARRgbRaster_BGRA2* i_native_inst)
	{
		T_INyARRgbRaster<NyARRgbRaster_BGRA2>::initAS3Member(i_builder,i_native_inst);
		i_builder.addFunction("setData",S_NyARRgbRaster_BGRA::setData);
		return;
	}
	/*　AS3 Argument protocol
	 */
	virtual NyARRgbRaster_BGRA2* createNativeInstance(AS3_Val args)
	{
		int w,h;
		AS3_ArrayValue(args, "IntType,IntType", &w,&h);
		return NyARRgbRaster_BGRA2::createAttachedRaster(w,h);
	}

private:
	/*　AS3 Argument protocol
	 * 	_native    : NyARRgbRaster_BGRA2*
	 *  v          : AS3_ByteArray
	 */
	static AS3_Val setData(void* self, AS3_Val args)
	{
		NyARRgbRaster_BGRA2* native;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType,AS3ValType", &native,&v);
		//コピーサイズを決める(4*w*h)
		int w=native->getWidth();
		int h=native->getHeight();
		//BYTEデータをコピー
		AS3_ByteArray_readBytes(native->m_buf,v,w*h*4*sizeof(NyAR_BYTE_t));
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}
};

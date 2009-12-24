#pragma once
#include "NyARRgbRaster_BasicClass.h"
#include "NyARRgbPixelReader_BYTE1D_X8R8G8B8_32.h"
#include "T_INyARRgbRaster.h"
class NyARRgbRaster_XRGB32:public NyARRgbRaster_BasicClass
{
private:
	INyARRgbPixelReader* _rgb_reader;
	NyARBufferReader* _buffer_reader;
	NyAR_BYTE_t* _buf;
public:
	NyARRgbRaster_XRGB32(int i_width, int i_height):NyARRgbRaster_BasicClass(i_width,i_height)
	{
		this->_buf=new NyAR_BYTE_t[i_width*i_height*4];
		this->_rgb_reader=new NyARRgbPixelReader_BYTE1D_X8R8G8B8_32(&this->_size,this->_buf);
		this->_buffer_reader=new NyARBufferReader(this->_buf,INyARBufferReader::BUFFERFORMAT_BYTE1D_X8R8G8B8_32);
		return;
	}
	virtual ~NyARRgbRaster_XRGB32()
	{
		delete this->_rgb_reader;
		delete this->_buffer_reader;
		delete this->_buf;
		return;
	}
public:
	//byte arrayからデータをコピー
	void setBuffer(AS3_Val i_byte_array)
	{
		//BYTEデータをコピー
		AS3_ByteArray_readBytes(this->_buf,i_byte_array,this->_size.w*this->_size.h*4+sizeof(NyAR_BYTE_t));
		return;
	}
	void getBuffer(AS3_Val i_byte_array)
	{
		//BYTEデータをコピー
		AS3_ByteArray_writeBytes(i_byte_array,this->_buf,this->_size.w*this->_size.h*4+sizeof(NyAR_BYTE_t));
		return;
	}

	const INyARRgbPixelReader& getRgbPixelReader()const
	{
		return *(this->_rgb_reader);
	}
	const INyARBufferReader& getBufferReader()const
	{
		return *(this->_buffer_reader);
	}
};





class S_NyARRgbRaster_XRGB32 : public T_INyARRgbRaster<NyARRgbRaster_XRGB32>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARRgbRaster_XRGB32 class_builder;
		return class_builder.buildWithNativeInstance(self,args);
	}
protected:
	//自身のオブジェクトをAS3オブジェクトにする。
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,NyARRgbRaster_XRGB32* i_native_inst)
	{
		T_INyARRgbRaster<NyARRgbRaster_XRGB32>::initAS3Member(i_builder,i_native_inst);
		i_builder.addFunction("setData",S_NyARRgbRaster_XRGB32::setData);
		i_builder.addFunction("getData",S_NyARRgbRaster_XRGB32::getData);
		return;
	}
	/*　AS3 Argument protocol
	 */
	virtual NyARRgbRaster_XRGB32* createNativeInstance(AS3_Val args)
	{
		int w,h;
		AS3_ArrayValue(args, "IntType,IntType", &w,&h);
		return new NyARRgbRaster_XRGB32(w,h);
	}
private:
	static AS3_Val setData(void* self, AS3_Val args)
	{
		NyARRgbRaster_XRGB32* native;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType,AS3ValType", &native,&v);
		native->setBuffer(v);
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}
	static AS3_Val getData(void* self, AS3_Val args)
	{
		NyARRgbRaster_XRGB32* native;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType,AS3ValType", &native,&v);
		native->getBuffer(v);
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}
};

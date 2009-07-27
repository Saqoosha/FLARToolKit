#pragma once
#include "NyARRgbRaster_BasicClass.h"
#include "NyARRgbPixelReader_BYTE1D_X8R8G8B8_32.h"

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





class S_NyARRgbRaster_XRGB32 : public AlchemyClassStub<NyARRgbRaster_XRGB32>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARRgbRaster_XRGB32* inst=new S_NyARRgbRaster_XRGB32();
		int w,h;
		AS3_ArrayValue(args, "IntType,IntType",&w,&h);
		//初期化
		inst->initRelStub(new NyARRgbRaster_XRGB32(w,h));
		//AS3オブジェクト化
		return inst->toAS3Object();
	}
	static AS3_Val createReference(const NyARRgbRaster_XRGB32* i_ref)
	{
		//参照生成はm_bufの参照もコピーすること！
		return NULL;
	}

	//自身のオブジェクトをAS3オブジェクトにする。
	void initAS3Object(AS3ObjectBuilder& i_builder)
	{
		AlchemyClassStub<NyARRgbRaster_XRGB32>::initAS3Object(i_builder);
		i_builder.addFunction("setData",S_NyARRgbRaster_XRGB32::setData);
		i_builder.addFunction("getData",S_NyARRgbRaster_XRGB32::getData);
		i_builder.addFunction("getWidth",S_NyARRgbRaster_XRGB32::getWidth);
		i_builder.addFunction("getHeight",S_NyARRgbRaster_XRGB32::getHeight);
		return;
	}
private:
	static AS3_Val setData(void* self, AS3_Val args)
	{
		S_NyARRgbRaster_XRGB32* inst;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType,AS3ValType", &inst,&v);
		((NyARRgbRaster_XRGB32*)(inst->m_ref))->setBuffer(v);
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}
	static AS3_Val getData(void* self, AS3_Val args)
	{
		S_NyARRgbRaster_XRGB32* inst;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType,AS3ValType", &inst,&v);
		((NyARRgbRaster_XRGB32*)(inst->m_ref))->getBuffer(v);
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}
	static AS3_Val getWidth(void* self, AS3_Val args)
	{
		S_NyARRgbRaster_XRGB32* inst;
		AS3_ArrayValue(args, "PtrType", &inst);
		return AS3_Int(inst->m_ref->getWidth());
	}
	static AS3_Val getHeight(void* self, AS3_Val args)
	{
		S_NyARRgbRaster_XRGB32* inst;
		AS3_ArrayValue(args, "PtrType", &inst);
		//コピーしてセット
		return AS3_Int(inst->m_ref->getHeight());
	}
};

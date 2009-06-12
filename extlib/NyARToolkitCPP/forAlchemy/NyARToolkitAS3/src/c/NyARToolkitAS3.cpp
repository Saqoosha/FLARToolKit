/* 
 * PROJECT: NyARToolkitCPP Alchemy bind
 * --------------------------------------------------------------------------------
 * The NyARToolkitCPP Alchemy bind is stub/proxy classes for NyARToolkitCPP and Adobe Alchemy.
 * 
 * Copyright (C)2009 Ryo Iizuka
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this framework; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 * 
 * For further information please contact.
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp>
 * 
 */
#include <stdlib.h>
#include <stdio.h>


#include "AlchemyMaster.h"
#include "AS3.h"

#include "NyAR_types.h"
#include "NyStdLib.h"
#include "NyARParam.h"
#include "NyARCode.h"
#include "NyARPerspectiveProjectionMatrix.h"
#include "NyARCameraDistortionFactor.h"
#include "NyARRgbRaster_BGRA.h"
#include "NyARSingleDetectMarker.h"
#include "INyARRgbRaster.h"
#include "NyARBufferReader.h"
#include "NyARRgbPixelReader_BYTE1D_X8R8G8B8_32.h"
using namespace NyARToolkitCPP;
#define AL_ENDIAN_LITTLE 1
#define AL_ENDIAN_BIG    2
#define AL_ENDIAN       AL_ENDIAN_LITTLE

/********************************************************************************
 * 
 * 	NyARToolkitCPP拡張
 * 
 ********************************************************************************/



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

	const INyARRgbPixelReader* getRgbPixelReader()const
	{
		return this->_rgb_reader;
	}
	const INyARBufferReader* getBufferReader()const
	{
		return this->_buffer_reader;
	}
};



/*生ゴミ
#define ASSERT(e,m) if(!(e)){ assert_proc(__FILE__,__LINE__,(m));}
static void assert_proc(const char* i_file,int i_line,const char* i_message)
{
	
}
*/

/********************************************************************************
 * 
 * 	NyARToolkitスタブ
 * 
 ********************************************************************************/


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


 
/**
 * 
 * T_NyARDoubleMatrix34
 * 
 **/
 
template<class T> class T_NyARDoubleMatrix34 : public AlchemyClassStub<T>
{
public:

	//自身のオブジェクトをAS3オブジェクトにする。
	void initAS3Object(AS3ObjectBuilder& i_builder)
	{
		AlchemyClassStub<T>::initAS3Object(i_builder);		
		i_builder.addFunction("setValue",T_NyARDoubleMatrix34<T>::setValue);
		i_builder.addFunction("getValue",T_NyARDoubleMatrix34<T>::getValue);		
	}

protected:
	static AS3_Val setValue(void* self, AS3_Val args)
	{
		T_NyARDoubleMatrix34<T>* inst;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType, AS3ValType", &inst,&v);
		//
		double work[12];
		AS3_ByteArray_readBytes(work,v,sizeof(double)*12);
		//Cのアクセス制御を強引に突破する。
		((T*)inst->m_ref)->setValue(work);
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}
	static AS3_Val getValue(void* self, AS3_Val args)
	{
		T_NyARDoubleMatrix34<T>* inst;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType, AS3ValType", &inst,&v);
		//コピーしてセット
		double work[12];
		inst->m_ref->getValue(work);
		AS3_ByteArray_writeBytes(v,work,sizeof(double)*12);
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}	
};

/**
 * 
 * NyARDoubleMatrix34
 * 
 **/

class S_NyARDoubleMatrix34 : public T_NyARDoubleMatrix34<NyARDoubleMatrix34>
{
public:
	//標準的なインスタンス生成関数です。
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARDoubleMatrix34* inst=new S_NyARDoubleMatrix34();
		//初期化
		inst->initRelStub(new NyARDoubleMatrix34());
		//AS3オブジェクト化
		return inst->toAS3Object();
	}
	//自身のオブジェクトをAS3オブジェクトにする。
	void initAS3Object(AS3ObjectBuilder& i_builder)
	{
		T_NyARDoubleMatrix34<NyARDoubleMatrix34>::initAS3Object(i_builder);
	}
};

/**
 * 
 * S_NyARPerspectiveProjectionMatrix
 * 
 **/

class S_NyARPerspectiveProjectionMatrix : public T_NyARDoubleMatrix34<NyARPerspectiveProjectionMatrix>
{
public:
	//標準的なインスタンス生成関数です。
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARPerspectiveProjectionMatrix* inst=new S_NyARPerspectiveProjectionMatrix();
		//初期化
		inst->initRelStub(new NyARPerspectiveProjectionMatrix());
		//AS3オブジェクト化
		return inst->toAS3Object();
	}
	static AS3_Val createReference(const NyARPerspectiveProjectionMatrix* i_ref)
	{
		S_NyARPerspectiveProjectionMatrix* inst=new S_NyARPerspectiveProjectionMatrix();
		//初期化
		inst->initRefStub(i_ref);
		//AS3オブジェクト化
		return inst->toAS3Object();
	}

	void initAS3Object(AS3ObjectBuilder& i_builder)
	{
		T_NyARDoubleMatrix34<NyARPerspectiveProjectionMatrix>::initAS3Object(i_builder);
		i_builder.addFunction("decompMat",S_NyARPerspectiveProjectionMatrix::decompMat);		
	}
	
	static AS3_Val decompMat(void* self, AS3_Val args)
	{
		//本来はNyARMatで転送すべきだけど、ByteArrayに配列突っ込んで転送する。
		//フォーマットは、o_cpara[3][4]o_trans[3][4]
		S_NyARPerspectiveProjectionMatrix* inst;
		AS3_Val marshal;
		AS3_ArrayValue(args, "PtrType,AS3ValType", &inst,&marshal);
		NyARMat c(3,4);
		NyARMat t(3,4);
		//数値計算
		inst->m_ref->decompMat(c,t);
		//byteArrayにコピー(cpara[12],trans[12]で格納)
		AS3_ByteArray_writeBytes(marshal,c.getArray(),sizeof(double)*12);
		AS3_ByteArray_writeBytes(marshal,t.getArray(),sizeof(double)*12);
		//引数の参照カウント減算
		AS3_Release(marshal);
		return AS3_Null();
	}
	
	
};

/**
 * 
 * S_NyARTransMatResult
 * 
 **/

class S_NyARTransMatResult : public T_NyARDoubleMatrix34<NyARTransMatResult>
{
public:
	//標準的なインスタンス生成関数です。
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARTransMatResult* inst=new S_NyARTransMatResult();
		//初期化
		inst->initRelStub(new NyARTransMatResult());
		//AS3オブジェクト化
		return inst->toAS3Object();
	}
	void initAS3Object(AS3ObjectBuilder& i_builder)
	{
		T_NyARDoubleMatrix34<NyARTransMatResult>::initAS3Object(i_builder);
		i_builder.addFunction("getHasValue",S_NyARTransMatResult::getHasValue);		
	}
	static AS3_Val getHasValue(void* self, AS3_Val args)
	{
		S_NyARTransMatResult* inst;
		AS3_ArrayValue(args, "PtrType", &inst);
		return inst->m_ref->has_value?AS3_True():AS3_False();
	}	
};





/**
 * 
 * NyARParam
 * 
 **/


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
		return S_NyARPerspectiveProjectionMatrix::createReference(((NyARParam*)(inst->m_ref))->getPerspectiveProjectionMatrix());
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
		return S_NyARIntSize::createReference(((NyARParam*)(inst->m_ref))->getScreenSize());
	}	
};

/**	
 * 
 * NyARCameraDistortionFactor
 * 
 **/

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


/**
 * 
 * NyARCode
 * 
 **/


class S_NyARCode : public AlchemyClassStub<NyARCode>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARCode* inst=new S_NyARCode();
		int w,h;
		AS3_ArrayValue(args, "IntType,IntType",&w,&h);		
		//初期化		
		inst->initRelStub(new NyARCode(w,h));
		//AS3オブジェクト化
		return inst->toAS3Object();
	}
	//自身のオブジェクトをAS3オブジェクトにする。
	void initAS3Object(AS3ObjectBuilder& i_builder)
	{
		AlchemyClassStub<NyARCode>::initAS3Object(i_builder);		
		i_builder.addFunction("loadARPatt",S_NyARCode::loadARPatt);
		i_builder.addFunction("getPatPow",S_NyARCode::getPatPow);
		i_builder.addFunction("getWidth",S_NyARCode::getWidth);
		i_builder.addFunction("getHeight",S_NyARCode::getHeight);
		return;
	}
private:
	static AS3_Val loadARPatt(void* self, AS3_Val args)
	{
		S_NyARCode* inst;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType,AS3ValType", &inst,&v);
		//配列のサイズを決定
		int w=inst->m_ref->getWidth();
		int h=inst->m_ref->getHeight();
		int* work=new int[4*w*h*3];
		
		AS3_ByteArray_readBytes(work,v,4*w*h*3*sizeof(int));		
		//Cのアクセス制御を強引に突破する。
		((NyARCode*)inst->m_ref)->loadARPatt(work,w,h);
		delete work;
		//引数の参照カウント減算
		AS3_Release(v);		
		return AS3_Null();
	}
	static AS3_Val getPatPow(void* self, AS3_Val args)
	{
		S_NyARCode* inst;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType, AS3ValType", &inst,&v);
		//コピーしてセット
		AS3_ByteArray_writeBytes(v,(void*)(inst->m_ref->getPatPow()),sizeof(double)*4);
		//引数の参照カウント減算
		AS3_Release(v);		
		return AS3_Null();
	}
	static AS3_Val getWidth(void* self, AS3_Val args)
	{
		S_NyARCode* inst;
		AS3_ArrayValue(args, "PtrType", &inst);
		return AS3_Int(inst->m_ref->getWidth());
	}
	static AS3_Val getHeight(void* self, AS3_Val args)
	{
		S_NyARCode* inst;
		AS3_ArrayValue(args, "PtrType", &inst);
		//コピーしてセット
		return AS3_Int(inst->m_ref->getHeight());
	}
};

/**
 * 
 * S_NyARRgbRaster_BGRA
 * 
 **/



class S_NyARRgbRaster_BGRA : public AlchemyClassStub<NyARRgbRaster_BGRA>
{
private:
	//m_instに同期するリソース
	NyAR_BYTE_t* m_buf;
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARRgbRaster_BGRA* inst=new S_NyARRgbRaster_BGRA();
		int w,h;
		AS3_ArrayValue(args, "IntType,IntType",&w,&h);		
		//初期化
		inst->initRelStub(new NyARRgbRaster_BGRA(w,h));
		inst->m_buf=new NyAR_BYTE_t[w*h*4*sizeof(NyAR_BYTE_t)];
		inst->m_inst->setBuffer(inst->m_buf);
		//AS3オブジェクト化
		return inst->toAS3Object();
	}
	static AS3_Val createReference(const NyARRgbRaster_BGRA* i_ref)
	{
		//参照生成はm_bufの参照もコピーすること！
		return NULL;
	}
	
	//自身のオブジェクトをAS3オブジェクトにする。
	void initAS3Object(AS3ObjectBuilder& i_builder)
	{
		AlchemyClassStub<NyARRgbRaster_BGRA>::initAS3Object(i_builder);		
		i_builder.addFunction("setData",S_NyARRgbRaster_BGRA::setData);
		i_builder.addFunction("getWidth",S_NyARRgbRaster_BGRA::getWidth);
		i_builder.addFunction("getHeight",S_NyARRgbRaster_BGRA::getHeight);
		return;
	}
	~S_NyARRgbRaster_BGRA()
	{
		if(this->m_inst!=NULL){
			delete this->m_buf;
			this->m_buf=NULL;
		}
	}
private:
	static AS3_Val setData(void* self, AS3_Val args)
	{
		S_NyARRgbRaster_BGRA* inst;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType,AS3ValType", &inst,&v);
		//コピーサイズを決める(4*w*h)
		int w=inst->m_ref->getWidth();
		int h=inst->m_ref->getHeight();
		//BYTEデータをコピー
		AS3_ByteArray_readBytes(inst->m_buf,v,w*h*4*sizeof(NyAR_BYTE_t));
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}
	static AS3_Val getWidth(void* self, AS3_Val args)
	{
		S_NyARRgbRaster_BGRA* inst;
		AS3_ArrayValue(args, "PtrType", &inst);
		return AS3_Int(inst->m_ref->getWidth());
	}
	static AS3_Val getHeight(void* self, AS3_Val args)
	{
		S_NyARRgbRaster_BGRA* inst;
		AS3_ArrayValue(args, "PtrType", &inst);
		//コピーしてセット
		return AS3_Int(inst->m_ref->getHeight());
	}
};



/**
 * 
 * S_NyARRgbRaster_XRGB32
 * 
 **/



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


/**
 * 
 * S_NyARSingleDetectMarker
 * 
 **/

class S_NyARSingleDetectMarker : public AlchemyClassStub<NyARSingleDetectMarker>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		//この関数は引数codeからNyARCodeインスタンスをデタッチするので注意。
		//関数呼び出し後は、AS側で引数に渡したcodeインスタンスを確実にdisposeすること！
		S_NyARSingleDetectMarker* inst=new S_NyARSingleDetectMarker();
		S_NyARParam* param;
		S_NyARCode* code;
		double width;
		int raster_type;
		
		AS3_ArrayValue(args, "PtrType,PtrType,DoubleType,IntType",&param,&code,&width,&raster_type);		
		//インスタンスの取り外し
		NyARCode* code_inst=code->detachInst();
		if(code_inst==NULL){
			//生成失敗
			return AS3_Null();
		}
		inst->initRelStub(new NyARSingleDetectMarker(*(param->getRef()),code_inst,width,raster_type));
		//AS3オブジェクト化
		return inst->toAS3Object();
	}

	void initAS3Object(AS3ObjectBuilder& i_builder)
	{
		AlchemyClassStub<NyARSingleDetectMarker>::initAS3Object(i_builder);		
		i_builder.addFunction("detectMarkerLite",S_NyARSingleDetectMarker::detectMarkerLite);
		i_builder.addFunction("getTransmationMatrix",S_NyARSingleDetectMarker::getTransmationMatrix);
		i_builder.addFunction("getConfidence",S_NyARSingleDetectMarker::getConfidence);
		i_builder.addFunction("getDirection",S_NyARSingleDetectMarker::getDirection);
		return;
	}
private:
	static AS3_Val detectMarkerLite(void* self, AS3_Val args)
	{
		S_NyARSingleDetectMarker* inst;
		AlchemyClassStub<void*>* stub;
		int th;
		AS3_ArrayValue(args, "PtrType,PtrType,IntType", &inst,&stub,&th);
		const INyARRgbRaster* raster=(const INyARRgbRaster*)(stub->getRef());
		
		bool ret=((NyARSingleDetectMarker*)(inst->m_ref))->detectMarkerLite(*raster,th);
		return ret?AS3_True():AS3_False();
	}
	static AS3_Val getConfidence(void* self, AS3_Val args)
	{
		S_NyARSingleDetectMarker* inst;
		AS3_ArrayValue(args, "PtrType", &inst);
		return AS3_Number(inst->m_ref->getConfidence());		
	}
	static AS3_Val getDirection(void* self, AS3_Val args)
	{
		S_NyARSingleDetectMarker* inst;
		AS3_ArrayValue(args, "PtrType", &inst);
		return AS3_Int(inst->m_ref->getDirection());		
	}
	static AS3_Val getTransmationMatrix(void* self, AS3_Val args)
	{
		S_NyARSingleDetectMarker* inst;
		S_NyARTransMatResult* v;
		AS3_ArrayValue(args, "PtrType,PtrType", &inst,&v);
		((NyARSingleDetectMarker*)(inst->m_ref))->getTransmationMatrix(*((NyARTransMatResult*)(v->m_ref)));
		return AS3_Null();
	}
};

/********************************************************************************
 * 
 * Alchemy Entry point
 * --Alchemyのエントリポイント
 * 
 ********************************************************************************/
static AS3_Val getVersion(void* self, AS3_Val args)
{
	return AS3_String("NyARToolkitCPP/0.9.0");
}


//entry point for code
int main()
{
	AS3_Val result = AS3_Object("");
	AS3ObjectBuilder builder(result);
	builder.addFunction("getVersion",getVersion);
	builder.addFunction("NyARParam_createInstance",S_NyARParam::createInstance);
	builder.addFunction("NyARDoubleMatrix34_createInstance",S_NyARDoubleMatrix34::createInstance);
	builder.addFunction("NyARPerspectiveProjectionMatrix_createInstance",S_NyARPerspectiveProjectionMatrix::createInstance);
	builder.addFunction("NyARCode_createInstance",S_NyARCode::createInstance);
	builder.addFunction("NyARRgbRaster_BGRA_createInstance",S_NyARRgbRaster_BGRA::createInstance);
	builder.addFunction("NyARSingleDetectMarker_createInstance",S_NyARSingleDetectMarker::createInstance);
	builder.addFunction("NyARTransMatResult_createInstance",S_NyARTransMatResult::createInstance);
	builder.addFunction("NyARRgbRaster_XRGB32_createInstance",S_NyARRgbRaster_XRGB32::createInstance);
	builder.addFunction("NyARIntSize_createInstance",S_NyARIntSize::createInstance);
	// notify that we initialized -- THIS DOES NOT RETURN!
	AS3_LibInit( result );

	// should never get here!
	return 0;
}



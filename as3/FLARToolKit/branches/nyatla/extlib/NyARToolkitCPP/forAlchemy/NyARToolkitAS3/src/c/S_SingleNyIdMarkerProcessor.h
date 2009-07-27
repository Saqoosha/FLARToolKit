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
#pragma once
#include "S_NyIdMarkerDataEncoder_RawBit.h"
#include "S_INyIdMarkerData.h"
#include "S_NyARTransMatResult.h"
#include "S_NyARSquare.h"
#include "SingleNyIdMarkerProcessor.h"



	class MarkerProcesser : public SingleNyIdMarkerProcesser
    {
	private:
		AS3_Val _as3_this;
		S_INyIdMarkerData _wrap_data;
		S_NyARTransMatResult _wrap_transmat;
		S_NyARSquare _wrap_square;
	public:
		const NyARTransMatResult* transmat;
		int current_id;
	public:
		MarkerProcesser(AS3_Val i_as3_this,const NyARParam *i_cparam,S_INyIdMarkerDataEncoder *i_encoder, int i_raster_format)
        {
			this->_as3_this=i_as3_this;
			AS3_Acquire(this->_as3_this);
			this->transmat=NULL;
			this->current_id=-1;
			initInstance(i_cparam,i_encoder->m_ref,i_raster_format);
            //アプリケーションフレームワークの初期化

			//ラップメンバの初期化
			this->_wrap_transmat.initWrapStub();
			this->_wrap_transmat.toHolderObject();
			this->_wrap_square.initWrapStub();
			this->_wrap_square.toHolderObject();
			this->_wrap_data.initWrapStub();
			this->_wrap_data.toHolderObject();
			return;
        }
		virtual ~MarkerProcesser()
		{
			AS3_Release(this->_as3_this);
			return;
		}

        /**
         * アプリケーションフレームワークのハンドラ（マーカ出現）
         */
	protected:
		void onEnterHandler(const INyIdMarkerData &i_code)
        {
			this->_wrap_data.wrapRef(&i_code);
			AS3_Val str =AS3_CallTS("onEnterHandler", this->_as3_this, "AS3ValType", this->_wrap_data.m_as3);
			this->_wrap_data.wrapRef(NULL);
			AS3_Release(str);
        }
	protected:
		void onLeaveHandler()
        {
			//イベント通知
			AS3_Val ret =AS3_CallTS("onLeaveHandler", this->_as3_this, "");
			AS3_Release(ret);
        }
	protected:
		void onUpdateHandler(const NyARSquare &i_square, const NyARTransMatResult &result)
        {
            //イベント通知
			this->_wrap_transmat.wrapRef(&result);
			this->_wrap_square.wrapRef(&i_square);
			AS3_Val ret =AS3_CallTS("onUpdateHandler", this->_as3_this, "AS3ValType,AS3ValType",this->_wrap_square.m_as3,this->_wrap_transmat.m_as3);
			this->_wrap_transmat.wrapRef(NULL);
			this->_wrap_square.wrapRef(NULL);

			AS3_Release(ret);
        }
    };

class S_SingleNyIdMarkerProcesser : public AlchemyClassStub<MarkerProcesser>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		//param,encoderは外部参照になるので注意！
		S_SingleNyIdMarkerProcesser* inst=new S_SingleNyIdMarkerProcesser();
		AS3_Val as3_this;
		S_NyARParam* param;
		double width;
		int raster_type;
		S_NyIdMarkerDataEncoder_RawBit* encoder;

		AS3_ArrayValue(args, "AS3ValType,PtrType,PtrType,IntType",&as3_this,&param,&encoder,&raster_type);
		MarkerProcesser* proc=new MarkerProcesser(as3_this,param->m_ref,encoder,raster_type);
		inst->initRelStub(proc);
		//AS3オブジェクト化

		AS3_Release(as3_this);
		return inst->toAS3Object();
	}

	void initAS3Object(AS3ObjectBuilder& i_builder)
	{
		AlchemyClassStub<MarkerProcesser>::initAS3Object(i_builder);
		i_builder.addFunction("setMarkerWidth",S_SingleNyIdMarkerProcesser::setMarkerWidth);
		i_builder.addFunction("reset",S_SingleNyIdMarkerProcesser::reset);
		i_builder.addFunction("detectMarker",S_SingleNyIdMarkerProcesser::detectMarker);
		return;
	}
private:
	static AS3_Val setMarkerWidth(void* self, AS3_Val args)
	{
		S_NyARSingleDetectMarker* inst;
		int width;
		AS3_ArrayValue(args, "PtrType,IntType", &inst,&width);

		((MarkerProcesser*)(inst->m_ref))->setMarkerWidth(width);
		return AS3_Null();
	}
	static AS3_Val reset(void* self, AS3_Val args)
	{
		S_NyARSingleDetectMarker* inst;
		int width;
		int reset_bool;
		AS3_ArrayValue(args, "PtrType,IntType", &inst,&reset_bool);

		((MarkerProcesser*)(inst->m_ref))->reset(reset_bool!=0?true:false);
		return AS3_Null();
	}
	static AS3_Val detectMarker(void* self, AS3_Val args)
	{
		S_NyARSingleDetectMarker* inst;
		AlchemyClassStub<void*>* stub;

		AS3_ArrayValue(args, "PtrType,PtrType", &inst,&stub);
		const INyARRgbRaster* raster=(const INyARRgbRaster*)(stub->getRef());
		((MarkerProcesser*)(inst->m_ref))->detectMarker(*raster);
		return AS3_Null();
	}
};

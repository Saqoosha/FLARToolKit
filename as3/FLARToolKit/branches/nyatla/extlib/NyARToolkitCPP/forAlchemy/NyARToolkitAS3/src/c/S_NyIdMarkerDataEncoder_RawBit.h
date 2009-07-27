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
#include "S_NyIdMarkerData_RawBit.h"
#include "S_INyIdMarkerDataEncoder.h"
class S_NyIdMarkerDataEncoder_RawBit : public S_INyIdMarkerDataEncoder
{
public:
	//標準的なインスタンス生成関数です。
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyIdMarkerDataEncoder_RawBit* inst=new S_NyIdMarkerDataEncoder_RawBit();
		//初期化
		inst->initRelStub(new NyIdMarkerDataEncoder_RawBit());
		//AS3オブジェクト化
		return inst->toAS3Object();
	}
	void initAS3Object(AS3ObjectBuilder& i_builder)
	{
		S_INyIdMarkerDataEncoder::initAS3Object(i_builder);
	}
	virtual S_INyIdMarkerData* createDataInstance()const
	{
		return new S_NyIdMarkerData_RawBit();
	}
};

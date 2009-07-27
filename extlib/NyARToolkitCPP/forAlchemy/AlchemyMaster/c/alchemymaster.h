/* 
 * PROJECT: AlchemyMaster
 * --------------------------------------------------------------------------------
 * The AlchemyMaster is helper classes and templates for Adobe Alchemy.
 *
 * Copyright (C)2009 Ryo Iizuka
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as 
 * published by the Free Software Foundation; either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, 
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public 
 * License along with this program. If not, see <http://www.gnu.org/licenses/>.
 * 
 * For further information please contact.
 *	http://nyatla.jp/
 *	<airmail(at)ebony.plala.or.jp>
 */

#pragma once

#include <assert.h>
#include "AS3.h"



//	AS3オブジェクトを作成するヘルパークラス
class AS3ObjectBuilder
{
	private:
		AS3_Val m_target;	
	public:
		AS3ObjectBuilder(AS3_Val i_target)
		{
			this->m_target=i_target;
			return;
		}
		void setTarget(AS3_Val i_target)
		{
			this->m_target=i_target;
			return;
		}
		void addFunction(const char* i_name,AS3_ThunkProc i_function)
		{
			AS3_Val as3val= AS3_Function(NULL,i_function);
			AS3_SetS(this->m_target,i_name,as3val);
			AS3_Release(as3val);
			return;
		}
		void addPointer(const char* i_name,void* i_pointer)
		{
			AS3_Val as3val= AS3_Ptr(i_pointer);
			AS3_SetS(this->m_target,i_name,as3val);
			AS3_Release(as3val);
			return;	
		}
	
};






//C++クラスのスタブテンプレート
template<class T> class AlchemyClassStub
{
public:
	T* m_inst;
	const T* m_ref;
	AS3_Val m_as3;
protected:
	//初期化済みスタブオブジェクト(i_inst)をAS3オブジェクト化します。
	//AS3オブジェクトを生成するためにこの関数をオーバライドしてください。
	virtual void initAS3Object(AS3ObjectBuilder& i_builder)
	{
		i_builder.addPointer("ptr",this);
		i_builder.addFunction("dispose",AlchemyClassStub<T>::dispose);
	};
public:
	//この関数はm_instに新しいCオブジェクトを作成します。
	//新しい初期化ルールが必要な時はオーバライドしてください。
	virtual void initRelStub(T* i_inst)
	{
		this->m_inst=i_inst;
		this->m_ref=this->m_inst;
		this->m_as3=NULL;
		return;
	}
	//この関数はすでにあるCオブジェクトi_refをラップします。
	//基本的にオーバライドの必要はありません。
	virtual void initRefStub(const T* i_ref)
	{
		this->m_inst=NULL;
		this->m_ref=i_ref;
		this->m_as3=NULL;
		return;
	}
	//この関数はラッパーオブジェクトを初期化します。
	//基本的にオーバライドの必要はありません。
	virtual void initWrapStub()
	{
		this->m_inst=NULL;
		this->m_ref=NULL;
		this->m_as3=NULL;
		return;
	}

public:
	//この関数は現在所有しているインスタンスをデタッチします。
	//m_instをトリガに他のメンバ所有権を管理するクラスでは、その所有権も移譲するようにしてください。
	T* detachInst()
	{
		T* inst=this->m_inst;
		this->m_inst=NULL;
		return inst;
	}
	const T* getRef()
	{
		return this->m_ref;
	}
	virtual void wrapRef(const T* i_ref)
	{
		//assert(this->m_inst==NULL);
		this->m_ref=i_ref;
		return;
	}
public:	
	//インスタンスをAS3オブジェクトに変換します。
	//この関数は継承クラスのcreateInstanceから呼び出して下さい。
	AS3_Val toAS3Object()
	{
		assert(this->m_as3==NULL);
		AS3_Val result = AS3_Object("");
		AS3ObjectBuilder builder(result);
		this->initAS3Object(builder);
		return result;
	}
	//インスタンスをAS3ホルダオブジェクトに変換します。
	//ホルダオブジェクトは、m_as3メンバ変数が有効です。
	void toHolderObject()
	{
		this->m_as3=toAS3Object();
	}

	virtual ~AlchemyClassStub<T>()
	{
		if(this->m_inst!=NULL){
			delete this->m_inst;
			this->m_inst=NULL;
		}
		if(this->m_as3!=NULL){
			AS3_Release(this->m_as3);
		}
		return;
	}
public:
	static AS3_Val dispose(void* self, AS3_Val args)
	{
		AlchemyClassStub<T>* inst;
	    AS3_ArrayValue(args, "PtrType", &inst);
	    if(inst==NULL){
			return AS3_False();
	    }
	    assert(inst->m_as3==NULL);//HolderObjectをdisposeしてはいけない。
	    delete inst;
		return AS3_True();
	}
};





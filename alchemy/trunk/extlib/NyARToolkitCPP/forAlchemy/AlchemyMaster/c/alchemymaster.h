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

class AS3ValUtils
{

};

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
		/**
		 * 追加すると、所有権ごと移動することに注意してね
		 */
		void addAS3Val(const char* i_name,AS3_Val i_as3val)
		{
			AS3_SetS(this->m_target,i_name,i_as3val);
			AS3_Release(i_as3val);
			return;
		}
		void addInteger(const char* i_name,int i_integer)
		{
			setMember_Integer(this->m_target,i_name,i_integer);
			return;
		}
	public:
		static void setMember_Null(AS3_Val i_target,const char* i_name)
		{
			AS3_SetS(i_target,i_name,AS3_Null());
		}
		static void setMember_Integer(AS3_Val i_target,const char* i_name,int i_integer)
		{
			AS3_Val as3val= AS3_Int(i_integer);
			AS3_SetS(i_target,i_name,as3val);
			AS3_Release(as3val);
		}
};




template<class T> class AlchemyClassBuilder
{
protected:
	//初期化済みスタブオブジェクト(i_inst)をAS3オブジェクト化します。
	//AS3オブジェクトを生成するためにこの関数をオーバライドしてください。
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,T* i_native_inst)
	{
	};
	/*
	 * ネイティブインスタンスを返す関数を実装して下さい。
	 */
	virtual T* createNativeInstance(AS3_Val args)=0;
private:
	void initBasicMember(AS3ObjectBuilder& i_builder,bool i_is_disposable,T* i_native_inst=NULL)
	{
		i_builder.addInteger("_is_disposable",i_is_disposable?1:0);//nativeリソースをdisposeかのうかどうか。
		i_builder.addPointer("_native",i_native_inst);//
		i_builder.addFunction("dispose",AlchemyClassBuilder<T>::dispose);
	};
public:
	/*
	 * nativeリソースを伴うオブジェクトを作成する。
	 * この関数で作成したオブジェクトは、Alchemy領域に管理下にあるリソースを持つ。
	 * ガーベイジコレクタによって回収される前に、必ずdisposeを呼び出さなければ為らない。
	 */
	AS3_Val buildWithNativeInstance(void* self, AS3_Val args)
	{
		//返却するAS3オブジェクトを作成
		AS3_Val result = AS3_Object("");

		//ガーベイジコレクタによる破棄を防止(disposeを呼ばれるまで解除しない)
		AS3_Acquire(result);
		AS3ObjectBuilder builder(result);

		//アタッチするNativeInstanceを要求
		T* native_inst=createNativeInstance(args);

		//AS3オブジェクトに追加する標準パラメータリストを追加
		initBasicMember(builder,true,native_inst);

		//AS3オブジェクトに追加するパラメータリストを要求
		initAS3Member(builder,native_inst);
		return result;
	}
	/*
	 * nativeリソースを伴わない、参照型オブジェクトを作成する。
	 * この関数で作成したオブジェクトは、Alchemy領域に管理下にあるリソースを持たない。
	 * どんなタイミングでも、ガーベイジコレクタによって解放できなければならない。
	 */
	AS3_Val buildWithOutNativeInstance(T* i_instance)
	{
		//返却するAS3オブジェクトを作成
		AS3_Val result = AS3_Object("");
		AS3ObjectBuilder builder(result);

		//AS3オブジェクトに追加する標準パラメータリストを追加
		initBasicMember(builder,false,i_instance);

		//AS3オブジェクトに追加するパラメータリストを要求
		initAS3Member(builder,i_instance);
		return result;
	}

	virtual ~AlchemyClassBuilder<T>()
	{
		return;
	}
public:
	/*　AS3 Argument protocol
	 *  inst       : AS3_Val
	 * 	_is_disposable: int
	 * 	_native    : AlchemyClassBuilder<T>*
	 *
	 * nativeリソースを持っている場合、disposeは動作するが、それ以外の場合、特になにもしない。
	 * 参照解除も行わない。
	 */
	static AS3_Val dispose(void* self, AS3_Val args)
	{
	    //引数展開
	    int is_disposable;
		AS3_Val inst;
		T* native;
	    AS3_ArrayValue(args, "AS3ValType,IntType,PtrType",&inst,&is_disposable, &native);
		if(is_disposable==1){
			if(native!=NULL){
				AS3_Release(inst);//ガーベイジコレクタによる解放を許可
				delete native;
			}
			//値の書き換えはAS3Proxy側でやる
			//setMember_Null(inst,"_native");
		}
		AS3_Release(inst);
		return AS3_Null();
	}


};






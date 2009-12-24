#pragma once
#include "NyARCode.h"
class S_NyARCode : public AlchemyClassBuilder<NyARCode>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARCode class_builder;
		return class_builder.buildWithNativeInstance(self,args);
	}
protected:
	//自身のオブジェクトをAS3オブジェクトにする。
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,NyARCode* i_native_inst)
	{
		AlchemyClassBuilder<NyARCode>::initAS3Member(i_builder,i_native_inst);
		i_builder.addFunction("loadARPatt",S_NyARCode::loadARPatt);
		i_builder.addFunction("getWidth",S_NyARCode::getWidth);
		i_builder.addFunction("getHeight",S_NyARCode::getHeight);
		return;
	}
	/*　AS3 Argument protocol
	 * 	w    : int
	 *  h    : int
	 */
	virtual NyARCode* createNativeInstance(AS3_Val args)
	{
		int w,h;
		AS3_ArrayValue(args, "IntType,IntType",&w,&h);
		//初期化
		return new NyARCode(w,h);
	}
private:
	/*　AS3 Argument protocol
	 * 	_native    : AlchemyClassStub<T>*
	 *  v          : AS3_ByteArray
	 */
	static AS3_Val loadARPatt(void* self, AS3_Val args)
	{
		NyARCode* native;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType,AS3ValType", &native,&v);
		//配列のサイズを決定
		int w=native->getWidth();
		int h=native->getHeight();
		//Intで送信されてくるので、unsigned charに変換
		unsigned char* work=new unsigned char[4*w*h*3];
		int temp[12];
		for(int i=0;i<w*h;i++){
			AS3_ByteArray_readBytes(temp,v,12*sizeof(int));
			for(int i2=0;i2<12;i2++){
				work[(12*i)+i2]=(unsigned char)temp[i2];
			}
		}
		native->loadARPatt(work);
		delete work;
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}
	/*　AS3 Argument protocol
	 * 	_native    : AlchemyClassStub<T>*
	 */
	static AS3_Val getWidth(void* self, AS3_Val args)
	{
		NyARCode* native;
		AS3_ArrayValue(args, "PtrType", &native);
		return AS3_Int(native->getWidth());
	}
	/*　AS3 Argument protocol
	 * 	_native    : AlchemyClassStub<T>*
	 */
	static AS3_Val getHeight(void* self, AS3_Val args)
	{
		NyARCode* native;
		AS3_ArrayValue(args, "PtrType", &native);
		//コピーしてセット
		return AS3_Int(native->getHeight());
	}
};

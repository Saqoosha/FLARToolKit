#pragma once
#include "NyARSquare.h"

class S_NyARSquare : public AlchemyClassBuilder<NyARSquare>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARSquare class_builder;
		return class_builder.buildWithNativeInstance(self,args);
	}
protected:
	//自身のオブジェクトをAS3オブジェクトにする。
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,NyARSquare* i_native_inst)
	{
		AlchemyClassBuilder<NyARSquare>::initAS3Member(i_builder,i_native_inst);
		i_builder.addFunction("getValue",S_NyARSquare::getValue);
		return;
	}
	/*　AS3 Argument protocol
	 */
	virtual NyARSquare* createNativeInstance(AS3_Val args)
	{
		return new NyARSquare();
	}
	/*　AS3 Argument protocol
	 * _native	:NyARSquareStack
	 * return   :AS3_Val
	 * 					as int　dir,int impos[4,2],double[4*3] line,double sqpos[4,2]
	 */
	static AS3_Val getValue(void* self, AS3_Val args)
	{
		NyARSquare* native;
		AS3_Val marshal;
		int wi[9];
		double wd[20];
		AS3_ArrayValue(args, "PtrType,AS3ValType", &native,&marshal);
		//set int param
		wi[0]=native->direction;
		for(int i=0;i<4;i++){
			wi[1+i*2]=native->imvertex[i].x;
			wi[2+i*2]=native->imvertex[i].y;
		}
		for(int i=0;i<4;i++){
			wd[i*3]  =native->line[i].rise;
			wd[i*3+1]=native->line[i].run;
			wd[i*3+2]=native->line[i].intercept;
		}
		for(int i=0;i<4;i++){
			wd[i*2+12]=native->sqvertex[i].x;
			wd[i*2+13]=native->sqvertex[i].y;
		}
		AS3_ByteArray_writeBytes(marshal,wi,sizeof(int)*9);
		AS3_ByteArray_writeBytes(marshal,wd,sizeof(double)*20);

		return AS3_Null();
	}


};

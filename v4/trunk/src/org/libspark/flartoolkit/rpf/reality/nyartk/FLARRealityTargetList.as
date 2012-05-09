package org.libspark.flartoolkit.rpf.reality.nyartk
{

import org.libspark.flartoolkit.core.*;
import org.libspark.flartoolkit.core.types.stack.*;

public class FLARRealityTargetList extends FLARPointerStack
{
	public function FLARRealityTargetList(i_max_target:int)
	{
		super.initInstance(i_max_target);
	}
	/**
	 * RealityTargetのシリアル番号をキーに、ターゲットを探索します。
	 * @param i_serial
	 * @return
	 */
	public function  getItemBySerial(i_serial:Number):FLARRealityTarget
	{
		var items:Vector.<Object>=this._items;
		for(var i:int=this._length-1;i>=0;i--)
		{
			var item:FLARRealityTarget = FLARRealityTarget(items[i]);
			if(item._serial==i_serial){
				return item;
			}
		}
		return null;
	}
	/**
	 * シリアルIDがi_serialに一致するターゲットのインデクス番号を返します。
	 * @param i_serial
	 * @return
	 * @throws FLARException
	 */
	public function getIndexBySerial(i_serial:int):int
	{
		var items:Vector.<Object>=this._items;
		for(var i:int=this._length-1;i>=0;i--)
		{
			var item:FLARRealityTarget = FLARRealityTarget(items[i]);
			if(item._serial==i_serial){
				return i;
			}
		}
		return -1;
	}
	/**
	 * リストから特定のタイプのターゲットだけを選択して、一括でo_resultへ返します。
	 * @param i_type
	 * ターゲットタイプです。FLARRealityTarget.RT_*を指定してください。
	 * @param o_list
	 * 選択したターゲットを格納する配列です。
	 * @return
	 * 選択できたターゲットの個数です。o_resultのlengthと同じ場合、取りこぼしが発生した可能性があります。
	 */	
	public function selectTargetsByType(i_type:int,o_result:Vector.<FLARRealityTarget>):int
	{
		var num:int=0;
		for(var i:int=this._length-1;i>=0 && num<o_result.length;i--)
		{
			var item:FLARRealityTarget = FLARRealityTarget(this._items[i]);
			if(item._target_type!=i_type){
				continue;
			}
			o_result[num]=item;
			num++;
		}
		return num;
	}
	/**
	 * リストから特定のタイプのターゲットを1個選択して、返します。
	 * @param i_type
	 * ターゲットタイプです。FLARRealityTarget.RT_*を指定してください。
	 * @return
	 * 見つかるとターゲットへの参照を返します。見つからなければNULLです。
	 */
	public function selectSingleTargetByType(i_type:int):FLARRealityTarget
	{
		for(var i:int=this._length-1;i>=0;i--)
		{
			var item:FLARRealityTarget = FLARRealityTarget(this._items[i]);
			if(item._target_type!=i_type){
				continue;
			}
			return item;
		}
		return null;
	}	
}
}

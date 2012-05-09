package org.libspark.flartoolkit.rpf.sampler.lrlabel
{

	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.types.stack.*;
	import org.libspark.flartoolkit.rpf.tracker.nyartk.*;
	import org.libspark.flartoolkit.core.utils.*;
	import org.libspark.flartoolkit.rpf.sampler.lrlabel.*;

	/**
	 * LowResolutionLabelingSampler用の出力コンテナです。サンプリング結果を受け取ります。
	 * 内容には、AreaDataItemの集合を持ちます。
	 * AreaDataItemは元画像に対する、Labeling結果と元画像の情報のセットです。
	 */
	public class LowResolutionLabelingSamplerOut
	{

		/**
		 * 元
		 */
		private var _pool:AreaPool;
		private var _stack:AreaStack;

		public function LowResolutionLabelingSamplerOut(i_length:int)
		{
			this._pool=new AreaPool(i_length);
			this._stack=new AreaStack(i_length);
			return;
		}
		/**
		 * Samplerが使う関数です。ユーザは通常使用しません。
		 * SamplerOutの内容を初期状態にします。
		 * @param i_source
		 */
		public function initializeParams():void
		{
			//基準ラスタの設定
			
			var items:Vector.<Object>=this._stack.getArray();
			//スタック内容の初期化
			for (var i:int = this._stack.getLength() - 1; i >= 0; i--) {
				var item:LowResolutionLabelingSamplerOut_Item = LowResolutionLabelingSamplerOut_Item(items[i]);
				item.releaseObject();
				items[i]=null;
			}
			//スタックをクリア
			this._stack.clear();
		}
		public function prePush():LowResolutionLabelingSamplerOut_Item
		{
			var result:LowResolutionLabelingSamplerOut_Item=LowResolutionLabelingSamplerOut_Item(this._pool.newObject());
			if(result==null){
				return null;
			}
			if(this._stack.push(result)==null){
				result.releaseObject();
				return null;
			}
			return result;
			
		}
		/**
		 * 検出したエリアデータの配列を返します。配列要素は、LowResolutionLabelingSamplerOut_Itemにキャストできます。
		 * @return
		 */
		public function getArray():Vector.<Object>
		{
			return this._stack.getArray();
		}
		/**
		 * 検出したエリアデータの総数を返します。
		 * @return
		 */
		public function getLength():int
		{
			return this._stack.getLength();
		}
	}
}

import org.libspark.flartoolkit.core.utils.FLARManagedObjectPool;
import org.libspark.flartoolkit.core.utils.FLARManagedObject;
import org.libspark.flartoolkit.rpf.sampler.lrlabel.*;
import org.libspark.flartoolkit.core.types.stack.*;

/**
 * AreaのPoolクラス
 *
 */
class AreaPool extends FLARManagedObjectPool
{
	public function AreaPool(i_length:int)
	{
		super.initInstance(i_length);
		return;
	}
	protected override function createElement():FLARManagedObject
	{
		return new LowResolutionLabelingSamplerOut_Item(this._op_interface);
	}
}
/**
 * AreaのStackクラス
 *
 */
class AreaStack extends FLARPointerStack
{
	public function AreaStack(i_length:int)
	{
		super.initInstance(i_length);
	}
}

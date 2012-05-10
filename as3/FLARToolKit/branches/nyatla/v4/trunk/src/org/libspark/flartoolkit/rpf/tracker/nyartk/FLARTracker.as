/* 
 * PROJECT: FLARToolKit
 * --------------------------------------------------------------------------------
 * This work is based on the FLARToolKit developed by
 *   R.Iizuka (nyatla)
 * http://nyatla.jp/nyatoolkit/
 *
 * The FLARToolKit is ActionScript 3.0 version ARToolkit class library.
 * Copyright (C)2008 Saqoosha
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * For further information please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<saq(at)saqoosha.net>
 * 
 */
package org.libspark.flartoolkit.rpf.tracker.nyartk
{

	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.types.stack.FLARPointerStack;
	import org.libspark.flartoolkit.core.utils.FLARDistMap;
	import org.libspark.flartoolkit.rpf.sampler.lrlabel.*;
	import org.libspark.flartoolkit.rpf.tracker.nyartk.status.*;




	/**
	 * このクラスは、四角形のトラッキングクラスです。画面内にある複数の矩形を、ターゲットとして識別して、追跡します。
	 * @author nyatla
	 *
	 */
	public class FLARTracker
	{
		private var _map:DistMap;
		protected var _index:Vector.<int>;

		private var newst_pool:FLARNewTargetStatusPool;
		private var contourst_pool:FLARContourTargetStatusPool;
		private var rect_pool:FLARRectTargetStatusPool;

		private var target_pool:FLARTargetPool;
		/**
		 * ターゲットリストです。このプロパティは内部向けです。
		 * refTrackTarget関数を介してアクセスしてください。
		 */
		public var _targets:FLARTargetList;


		//環境定数
		private var MAX_NUMBER_OF_NEW:int;
		private var MAX_NUMBER_OF_CONTURE:int;
		private var MAX_NUMBER_OF_RECT:int;
		private var MAX_NUMBER_OF_TARGET:int;
		
		private var _newsource:SampleStack;
		private var _igsource:SampleStack;
		private var _coordsource:SampleStack;
		private var _rectsource:SampleStack;	
		public var _temp_targets:Vector.<FLARTargetList>;

		private var _number_of_new:int;
		private var _number_of_ignore:int;
		private var _number_of_contoure:int;
		private var _number_of_rect:int;	
		
		/**
		 * newターゲットの数を返します。
		 * @return
		 */
		public function getNumberOfNew():int
		{
			return this._number_of_new;		
		}
		/**
		 * ignoreターゲットの数を返します。
		 * @return
		 */
		public function getNumberOfIgnore():int
		{
			return this._number_of_ignore;		
		}
		/**
		 * contourターゲットの数を返します。
		 * @return
		 */
		public function getNumberOfContur():int
		{
			return this._number_of_contoure;		
		}
		/**
		 * rectターゲットの数を返します。
		 * @return
		 */
		public function getNumberOfRect():int
		{
			return this._number_of_rect;		
		}
		/**
		 * ターゲットリストの参照値を返します。
		 * @return
		 */
		public function refTrackTarget():FLARTargetList
		{
			return this._targets;
		}
		/**
		 * コンストラクタです。
		 * @param i_max_new
		 * Newトラックターゲットの最大数を指定します。
		 * @param i_max_cont
		 * Contourトラックターゲットの最大数を指定します。
		 * @param i_max_rect
		 * Rectトラックターゲットの最大数を指定します。
		 * @throws FLARException
		 */
		public function FLARTracker(i_max_new:int,i_max_cont:int,i_max_rect:int)
		{
			//環境定数の設定
			this.MAX_NUMBER_OF_NEW=i_max_new;
			this.MAX_NUMBER_OF_CONTURE=i_max_cont;
			this.MAX_NUMBER_OF_RECT=i_max_rect;		
			this.MAX_NUMBER_OF_TARGET=(i_max_new+i_max_cont+i_max_rect)*5;		


			//ターゲットマップ用の配列と、リスト。この関数はFLARTargetStatusのIDと絡んでるので、気をつけて！
			this._temp_targets=new Vector.<FLARTargetList>(FLARTargetStatus.MAX_OF_ST_KIND+1);
			this._temp_targets[FLARTargetStatus.ST_NEW]    =new FLARTargetList(i_max_new);
			this._temp_targets[FLARTargetStatus.ST_IGNORE] =new FLARTargetList(this.MAX_NUMBER_OF_TARGET);
			this._temp_targets[FLARTargetStatus.ST_CONTURE]=new FLARTargetList(i_max_cont);
			this._temp_targets[FLARTargetStatus.ST_RECT]   =new FLARRectTargetList(i_max_rect);

			//ソースリスト
			this._newsource=new SampleStack(i_max_new);
			this._igsource=new SampleStack(this.MAX_NUMBER_OF_TARGET);
			this._coordsource=new SampleStack(i_max_cont);
			this._rectsource=new SampleStack(i_max_rect);

			//ステータスプール
			this.newst_pool=new FLARNewTargetStatusPool(i_max_new*2);
			this.contourst_pool=new FLARContourTargetStatusPool(i_max_rect+i_max_cont*2);
			this.rect_pool=new FLARRectTargetStatusPool(i_max_rect*2);
			//ターゲットプール
			this.target_pool=new FLARTargetPool(this.MAX_NUMBER_OF_TARGET);
			//ターゲット
			this._targets=new FLARTargetList(this.MAX_NUMBER_OF_TARGET);		
			
			//ここ注意！マップの最大値は、ソースアイテムの個数よりおおきいこと！
			this._map=new DistMap(this.MAX_NUMBER_OF_TARGET,this.MAX_NUMBER_OF_TARGET);
			this._index=new Vector.<int>([this.MAX_NUMBER_OF_TARGET]);
			
			//定数初期化
			this._number_of_new=this._number_of_ignore=this._number_of_contoure=this._number_of_rect=0;
		}

		/**
		 * Trackerの状態を更新します。
		 * @param i_source
		 * @throws FLARException
		 */
		public function progress(i_s:FLARTrackerSource):void
		{
			var i:int;
			//SampleOutを回収
			var sample_out:LowResolutionLabelingSamplerOut=i_s.makeSampleOut();
			
			var targets:Vector.<FLARTargetList>=this._temp_targets;
			var newtr:FLARTargetList=targets[FLARTargetStatus.ST_NEW];
			var igtr:FLARTargetList=targets[FLARTargetStatus.ST_IGNORE];
			var cotr:FLARTargetList=targets[FLARTargetStatus.ST_CONTURE];
			var retw:FLARTargetList=targets[FLARTargetStatus.ST_RECT];

			var vecreader:IFLARVectorReader=i_s.getBaseVectorReader();
			//ターゲットリストの振り分け
			var target_array:Vector.<Object>=this._targets.getArray();
			newtr.clear();
			igtr.clear();
			cotr.clear();
			retw.clear();
			for(i=this._targets.getLength()-1;i>=0;i--){
				targets[target_array[i]._st_type].pushAssert(target_array[i]);
			}		
			var index:Vector.<int>=this._index;
			//サンプルをターゲット毎に振り分け
			sampleMapper(sample_out,newtr,igtr,cotr,retw,this._newsource,this._igsource,this._coordsource,this._rectsource);
			
			//ターゲットの更新		
			this._map.makePairIndexes(this._igsource,igtr,index);
			updateIgnoreStatus(igtr,this._igsource.getArray(),index);
			
			this._map.makePairIndexes(this._newsource,newtr,index);
			updateNewStatus(newtr,this.newst_pool, this._newsource.getArray(),index);

			this._map.makePairIndexes(this._rectsource,retw,index);
			updateRectStatus(retw, vecreader, this.rect_pool, this._rectsource.getArray(),index);

			this._map.makePairIndexes(this._coordsource,cotr,index);
			updateContureStatus(cotr, vecreader,this.contourst_pool,this._coordsource.getArray(),index);

			//ターゲットのアップグレード
			for(i=this._targets.getLength()-1;i>=0;i--){
				switch(target_array[i]._st_type){
				case FLARTargetStatus.ST_IGNORE:
					upgradeIgnoreTarget(i);
					continue;
				case FLARTargetStatus.ST_NEW:
					upgradeNewTarget(FLARTarget(target_array[i]),vecreader);
					continue;
				case FLARTargetStatus.ST_RECT:
					upgradeRectTarget(FLARTarget(target_array[i]));
					continue;
				case FLARTargetStatus.ST_CONTURE:
					upgradeContourTarget(FLARTarget(target_array[i]));
					continue;
				}
			}
			return;
		}
		

		
		private static const LIFE_OF_NEW:int=10;
		private static const LIFE_OF_IGNORE_FROM_NEW:int=10;
		private static const LIFE_OF_IGNORE_FROM_CONTOUR:int=50;
		private static const LIFE_OF_IGNORE_FROM_RECT:int=20;
		private static const LIFE_OF_RECT_FROM_CONTOUR:int=int.MAX_VALUE;
		private static const LIFE_OF_CONTURE_FROM_NEW:int=2;
		
		/**
		 * i_new_targetのアップグレードを試行します。
		 * アップグレードの種類は以下のにとおりです。1.一定期間経過後の破棄ルート(Ignoreへ遷移)2.正常認識ルート(Contourへ遷移)
		 * @param i_new_target
		 * @param i_base_raster
		 * @return
		 * @throws FLARException
		 */
		private function upgradeNewTarget(i_new_target:FLARTarget,i_vecreader:IFLARVectorReader):void
		{
			//assert(i_new_target._st_type==FLARTargetStatus.ST_NEW);

			//寿命を超えたらignoreへ遷移
			if(i_new_target._status_life<=0)
			{
				this.changeStatusToIgnore(i_new_target,LIFE_OF_IGNORE_FROM_NEW);
				return;
			}
			var st:FLARNewTargetStatus=(FLARNewTargetStatus)(i_new_target._ref_status);
			//このターゲットをアップグレードできるか確認
			if(st.current_sampleout==null){
				//直近のsampleoutが無い。->なにもできない。
				return;
			}
			//coordステータスを生成
			var c:FLARContourTargetStatus=FLARContourTargetStatus(this.contourst_pool.newObject());
			if(c==null){
				//ターゲットがいっぱい。(失敗して何もしない)
				//System.out.println("upgradeNewTarget:status pool full");
				return;
			}
			//ステータスの値をセット
			if(!c.setValue(i_vecreader,st.current_sampleout))
			{
				//値のセットに失敗したので、Ignoreへ遷移(この対象は輪郭認識できない)
				this.changeStatusToIgnore(i_new_target,LIFE_OF_IGNORE_FROM_NEW);
				//System.out.println("drop:new->ignore[contoure failed.]"+t.serial+":"+t.last_update);
				c.releaseObject();
				return;//失敗しようが成功しようが終了
			}
			if(this.changeStatusToCntoure(i_new_target,c)==null){
				c.releaseObject();
				return;
			}
			return;
		}
		
		/**
		 * 指定したi_ig_targetをリストから削除します。
		 * リストは詰められますが、そのルールはdeleatTarget依存です。
		 * @param i_ig_index
		 * @throws FLARException
		 */
		private function upgradeIgnoreTarget(i_ig_index:int):void
		{
			//assert(this._targets.getItem(i_ig_index)._st_type==FLARTargetStatus.ST_IGNORE);
			if(this._targets.getItem(i_ig_index)._status_life<=0)
			{
				//オブジェクトのリリース
	//System.out.println("lost:ignore:"+t.serial+":"+t.last_update);
				this.deleatTarget(i_ig_index);
			}
		}
		
		/**
		 * FLARTrackerOutのCOntourTargetについて、アップグレード処理をします。
		 * アップグレードの種類は以下のにとおりです。1.一定期間経過後の破棄ルート(Ignoreへ遷移)2.正常認識ルート(Rectへ遷移)
		 * @param i_base_raster
		 * @param i_trackdata
		 * @throws FLARException
		 */
		private function upgradeContourTarget(i_contoure_target:FLARTarget):void
		{
			//assert(i_contoure_target._st_type==FLARTargetStatus.ST_CONTURE);
			if(i_contoure_target._status_life<=0)
			{
				//一定の期間が経過したら、ignoreへ遷移
				this.changeStatusToIgnore(i_contoure_target,LIFE_OF_IGNORE_FROM_CONTOUR);
				return;
			}
			if(i_contoure_target._delay_tick>20)
			{
				this.changeStatusToIgnore(i_contoure_target,LIFE_OF_IGNORE_FROM_CONTOUR);
				return;
				//一定の期間updateができなければ、ignoreへ遷移
			}

			var st:FLARContourTargetStatus=(FLARContourTargetStatus)(i_contoure_target._ref_status);
			//coordステータスを生成
			var c:FLARRectTargetStatus=FLARRectTargetStatus(this.rect_pool.newObject());
			if(c==null){
				//ターゲットがいっぱい。
				return;
			}
			//ステータスの値をセット
			if(!c.setValueWithInitialCheck(st,i_contoure_target._sample_area)){
				//値のセットに失敗した。
				c.releaseObject();
				return;
			}
			if(this.changeStatusToRect(i_contoure_target,c)==null){
				//ターゲットいっぱい？
				c.releaseObject();
				return;
			}	
			return;
		}	
		private function upgradeRectTarget(i_rect_target:FLARTarget):void
		{
			//assert(i_rect_target._st_type==FLARTargetStatus.ST_RECT);
			if(i_rect_target._delay_tick>20)
			{
				this.changeStatusToIgnore(i_rect_target,LIFE_OF_IGNORE_FROM_RECT);
				//一定の期間updateができなければ、ignoreへ遷移
			}
		}	
		
		//
		//update
		//
		private function updateIgnoreStatus(i_igliet:FLARTargetList,source:Vector.<Object>,index:Vector.<int>):void
		{
			var d_ptr:FLARTarget;
			//マップする。
			var i_ignore_target:Vector.<Object>=i_igliet.getArray();
			//ターゲットの更新
			for(var i:int=i_igliet.getLength()-1;i>=0;i--){
				d_ptr=FLARTarget(i_ignore_target[i]);
				var sample_index:int=index[i];
				//年齢を加算
				d_ptr._status_life--;
				if(sample_index<0){
					//このターゲットに合致するアイテムは無い。
					d_ptr._delay_tick++;
					continue;
				}
				d_ptr.setSampleArea_2(LowResolutionLabelingSamplerOut_Item(source[sample_index]));
				d_ptr._delay_tick=0;
			}
		}	
			
		/**
		 * NewTargetのステータスを更新します。
		 * public static function updateNewStatus(i_list:FLARTargetList,i_pool:FLARNewTargetStatusPool,source:Vector.<LowResolutionLabelingSamplerOut_Item>,index:Vector.<int>):void 
		 * @param i_sample
		 * @throws FLARException 
		 */
		public static function updateNewStatus(i_list:FLARTargetList,i_pool:FLARNewTargetStatusPool,source:Vector.<Object>,index:Vector.<int>):void 
		{
			var d_ptr:FLARTarget;
			var i_nes:Vector.<Object>=i_list.getArray();		
			//ターゲットの更新
			for(var i:int=i_list.getLength()-1;i>=0;i--){
				d_ptr=FLARTarget(i_nes[i]);
				var sample_index:int=index[i];
				//年齢を加算
				d_ptr._status_life--;
				if(sample_index<0){
					//このターゲットに合致するアイテムは無い。
					((FLARNewTargetStatus)(d_ptr._ref_status)).setValue(null);
					d_ptr._delay_tick++;
					continue;
				}
				var s:LowResolutionLabelingSamplerOut_Item=LowResolutionLabelingSamplerOut_Item(source[sample_index]);
				//先にステータスを作成しておく
				var st:FLARNewTargetStatus=FLARNewTargetStatus(i_pool.newObject());
				if(st==null){
					//ステータスの生成に失敗
					d_ptr._delay_tick++;
	//System.out.println("updateNewStatus:status pool full");
					continue;
				}
				//新しいステータス値のセット
				st.setValue(s);
				
				//ターゲットの更新
				d_ptr.setSampleArea_2(s);
				d_ptr._delay_tick=0;

				//ref_statusのセットと切り替え(失敗時の上書き防止のためにダブルバッファ化)
				d_ptr._ref_status.releaseObject();
				d_ptr._ref_status=st;
			}
		}
		/**
		 * ContoureTargetのステータスを更新します。
		 * public static function updateContureStatus(i_list:FLARTargetList,i_vecreader:FLARVectorReader_INT1D_GRAY_8,i_stpool:FLARContourTargetStatusPool,source:Vector.<LowResolutionLabelingSamplerOut_Item>,index:Vector.<int>):void
		 * @param i_list
		 * @param i_vecreader
		 * @param i_stpool
		 * @param source
		 * @param index
		 * @throws FLARException
		 */
		public static function updateContureStatus(i_list:FLARTargetList,i_vecreader:IFLARVectorReader,i_stpool:FLARContourTargetStatusPool,source:Vector.<Object>,index:Vector.<int>):void
		{

			var crd:Vector.<Object>=i_list.getArray();		
			var d_ptr:FLARTarget;
			//ターゲットの更新
			for(var i:int=i_list.getLength()-1;i>=0;i--){

				d_ptr=FLARTarget(crd[i]);
				var sample_index:int=index[i];
				//年齢を加算
				d_ptr._status_life--;
				if(sample_index<0){
					//このターゲットに合致するアイテムは無い。
					d_ptr._delay_tick++;
					continue;
				}
				var s:LowResolutionLabelingSamplerOut_Item=LowResolutionLabelingSamplerOut_Item(source[sample_index]);
				//失敗の可能性を考慮して、Statusを先に生成しておく
				var st:FLARContourTargetStatus=FLARContourTargetStatus(i_stpool.newObject());
				if(st==null){
					//失敗（作れなかった？）
					d_ptr._delay_tick++;
					continue;
				}
				if(!st.setValue(i_vecreader,s)){
					//新しいステータスのセットに失敗？
					st.releaseObject();
					d_ptr._delay_tick++;
					continue;
				}
				d_ptr.setSampleArea_2(s);
				d_ptr._delay_tick=0;
				//ref_statusの切り替え
				d_ptr._ref_status.releaseObject();
				d_ptr._ref_status=st;
			}
		}
		/**
		 * public static function updateRectStatus(i_list:FLARTargetList,i_vecreader:FLARVectorReader_INT1D_GRAY_8,i_stpool:FLARRectTargetStatusPool,source:Vector.<LowResolutionLabelingSamplerOut_Item>,index:Vector.<int>):void
		 */
		public static function updateRectStatus(i_list:FLARTargetList,i_vecreader:IFLARVectorReader,i_stpool:FLARRectTargetStatusPool,source:Vector.<Object>,index:Vector.<int>):void
		{	
			
			var rct:Vector.<Object>=i_list.getArray();
			var d_ptr:FLARTarget;
			//ターゲットの更新
			for (var i:int = i_list.getLength() - 1; i >= 0; i--) {
				
				d_ptr=FLARTarget(rct[i]);
				//年齢を加算
				d_ptr._status_life--;
				//新しいステータスの作成
				var st:FLARRectTargetStatus=FLARRectTargetStatus(i_stpool.newObject());
				if(st==null){
					//失敗（作れなかった？）
					d_ptr._delay_tick++;
					continue;
				}
				var sample_index:int=index[i];
				var s:LowResolutionLabelingSamplerOut_Item=LowResolutionLabelingSamplerOut_Item(sample_index<0?null:source[sample_index]);		
				if(!st.setValueByAutoSelect(i_vecreader, s, (FLARRectTargetStatus)(d_ptr._ref_status))){
					st.releaseObject();
					d_ptr._delay_tick++;
					continue;
				}else{
					if(s!=null){
						d_ptr.setSampleArea_2(s);
					}
				}
				d_ptr._ref_status.releaseObject();
				d_ptr._ref_status=st;
				d_ptr._delay_tick=0;
			}		
		}

		/**
		 * ターゲットリストを参考に、sampleを振り分て、サンプルスタックに格納します。
		 * ターゲットは、rect>coord>new>ignoreの順に優先して振り分けられます。
		 * @param i_snapshot
		 * @param i_source
		 * @param i_new
		 * @param i_ig
		 * @param i_cood
		 * @param i_rect
		 * @param i_newsrc
		 * @param i_igsrc
		 * @param i_coodsrc
		 * @param i_rectsrc
		 * @throws FLARException
		 */
		private function sampleMapper(
			i_source:LowResolutionLabelingSamplerOut,
			i_new:FLARTargetList,i_ig:FLARTargetList,i_cood:FLARTargetList,i_rect:FLARTargetList,
			i_newsrc:SampleStack,i_igsrc:SampleStack,i_coodsrc:SampleStack,i_rectsrc:SampleStack):void
		{
			//スタックを初期化
			i_newsrc.clear();
			i_coodsrc.clear();
			i_igsrc.clear();
			i_rectsrc.clear();
			//
			var sample_items:Vector.<Object>=i_source.getArray();
			for(var i:int=i_source.getLength()-1;i>=0;i--)
			{
				
				//サンプラからの値を其々のターゲットのソースへ分配
				var sample_item:LowResolutionLabelingSamplerOut_Item=LowResolutionLabelingSamplerOut_Item(sample_items[i]);
				var id:int;
				id=i_rect.getMatchTargetIndex(sample_item);
				if(id>=0){
					i_rectsrc.push(sample_item);
					continue;
				}
				//coord
				id=i_cood.getMatchTargetIndex(sample_item);
				if(id>=0){
					i_coodsrc.push(sample_item);
					continue;
				}
				//newtarget
				id=i_new.getMatchTargetIndex(sample_item);
				if(id>=0){
					i_newsrc.push(sample_item);
					continue;
				}
				//ignore target
				id=i_ig.getMatchTargetIndex(sample_item);
				if(id>=0){
					i_igsrc.push(sample_item);
					continue;
				}
				//マップできなかったものは、NewTragetへ登録(種類別のListには反映しない)
				var t:FLARTarget=this.addNewTarget(sample_item);
				if(t==null){
					continue;
				}
				i_newsrc.push(sample_item);
			}
			return;
		}
		//ターゲット操作系関数
		
		//IgnoreTargetの数は、NUMBER_OF_TARGETと同じです。





		
		/**
		 * 新しいNewTargetを追加します。
		 * @param i_clock
		 * @param i_sample
		 * @return
		 * @throws FLARException
		 */
		private function addNewTarget( i_sample:LowResolutionLabelingSamplerOut_Item):FLARTarget
		{
			//個数制限
			if(this._number_of_new>=this.MAX_NUMBER_OF_NEW){
				return null;
			}
			//アイテム生成
			var t:FLARTarget=this.target_pool.newNewTarget();
			if(t==null){
				return null;
			}
			t._status_life=LIFE_OF_NEW;
			t._st_type=FLARTargetStatus.ST_NEW;
			t._delay_tick=0;
			t.setSampleArea_2(i_sample);
			t._ref_status=FLARTargetStatus(this.newst_pool.newObject());
			if(t._ref_status==null){
				t.releaseObject();
				return null;
			}
			(FLARNewTargetStatus(t._ref_status)).setValue(i_sample);
			//ターゲットリストへ追加
			this._targets.pushAssert(t);
			this._number_of_new++;
			return t;
		}
		/**
		 * 指定したインデクスのターゲットをリストから削除します。
		 * ターゲットだけを外部から参照している場合など、ターゲットのindexが不明な場合は、
		 * ターゲットをignoreステータスに設定して、trackerのprogressを経由してdeleateを実行します。
		 * @param i_index
		 * @return
		 * @throws FLARException
		 */
		private function deleatTarget(i_index:int):void
		{
			//assert(this._targets.getItem(i_index)._st_type==FLARTargetStatus.ST_IGNORE);
			var tr:FLARTarget=FLARTarget(this._targets.getItem(i_index));
			this._targets.removeIgnoreOrder(i_index);
			tr.releaseObject();
			this._number_of_ignore--;
			return;
		}
		
		/**
		 * このターゲットのステータスを、IgnoreStatusへ変更します。
		 * @throws FLARException 
		 */
		public function changeStatusToIgnore(i_target:FLARTarget,i_life:int):void
		{
			//遷移元のステータスを制限すること！
			//assert( (i_target._st_type==FLARTargetStatus.ST_NEW) || 
			//		(i_target._st_type==FLARTargetStatus.ST_CONTURE) || 
			//		(i_target._st_type==FLARTargetStatus.ST_RECT));

			//カウンタ更新
			switch(i_target._st_type)
			{
			case FLARTargetStatus.ST_NEW:
				this._number_of_new--;
				break;
			case FLARTargetStatus.ST_RECT:
				this._number_of_rect--;
				break;
			case FLARTargetStatus.ST_CONTURE:
				this._number_of_contoure--;
				break;
			default:
				return;
			}
			i_target._st_type=FLARTargetStatus.ST_IGNORE;
			i_target._ref_status.releaseObject();
			i_target._status_life=i_life;
			i_target._ref_status=null;
			this._number_of_ignore++;
			return;
		}
		/**
		 * このターゲットのステータスを、CntoureStatusへ遷移させます。
		 * @param i_c
		 */
		private function changeStatusToCntoure(i_target:FLARTarget,i_c:FLARContourTargetStatus):FLARTarget
		{
			//遷移元のステータスを制限
			//assert(i_c!=null);
			//assert(i_target._st_type==FLARTargetStatus.ST_NEW);
			//個数制限
			if(this._number_of_contoure>=this.MAX_NUMBER_OF_CONTURE){
				return null;
			}
			i_target._st_type=FLARTargetStatus.ST_CONTURE;
			i_target._ref_status.releaseObject();
			i_target._status_life=LIFE_OF_CONTURE_FROM_NEW;
			i_target._ref_status=i_c;
			//カウンタ更新
			this._number_of_new--;
			this._number_of_contoure++;
			return i_target;
		}
		/**
		 * このターゲットをRectターゲットに遷移させます。
		 * @param i_target
		 * @param i_c
		 * @return
		 */
		private function changeStatusToRect(i_target:FLARTarget,i_c:FLARRectTargetStatus):FLARTarget 
		{
			//assert(i_target._st_type==FLARTargetStatus.ST_CONTURE);
			if(this._number_of_rect>=this.MAX_NUMBER_OF_RECT){
				return null;
			}
			i_target._st_type=FLARTargetStatus.ST_RECT;
			i_target._ref_status.releaseObject();
			i_target._status_life=LIFE_OF_RECT_FROM_CONTOUR;
			i_target._ref_status=i_c;
			//カウンタ更新
			this._number_of_contoure--;
			this._number_of_rect++;
			return i_target;
		}

		
	}
}

import org.libspark.flartoolkit.core.types.stack.*;
import org.libspark.flartoolkit.core.utils.*;
import org.libspark.flartoolkit.rpf.sampler.lrlabel.*;
import org.libspark.flartoolkit.rpf.tracker.nyartk.*;
/**
 * サンプルを格納するスタックです。このクラスは、一時的なリストを作るために使います。
 */
class SampleStack extends FLARPointerStack
{
	public function SampleStack(i_size:int)
	{
		super();
		this.initInstance(i_size);
	}
}


/**
 * FLARTargetとSampleStack.Item間の、点間距離マップを作製するクラスです。
 * スーパークラスから、setPointDists関数をオーバライドします。
 *
 */
class DistMap extends FLARDistMap
{
	public function DistMap(i_max_col:int,i_max_row:int)
	{
		super(i_max_col,i_max_row);
	}
	public function makePairIndexes(igsource:SampleStack,igtr:FLARTargetList ,index:Vector.<int>):void
	{
		this.setPointDists_3(igsource.getArray(),igsource.getLength(),igtr.getArray(),igtr.getLength());
		this.getMinimumPair(index);
		return;
	}
	/**
	 * ２ペアの点間距離を計算します。
	 * getMinimumPairで求まるインデクスは、FLARTargetに最も一致するLowResolutionLabelingSamplerOut.Itemのインデックスになります。
	 * setPointDists(i_sample:Vector.<LowResolutionLabelingSamplerOut_Item>,i_smp_len:int,i_target:Vector.<FLARTarget>,i_target_len:int):void
	 * @param i_sample
	 * @param i_smp_len
	 * @param i_target
	 * @param i_target_len
	 */
	public function setPointDists_3(i_sample:Vector.<Object>,i_smp_len:int,i_target:Vector.<Object>,i_target_len:int):void
	{
		var map:Vector.<FLARDistMap_DistItem>=this._map;
		//distortionMapを作成。ついでに最小値のインデクスも取得
		var min_index:int=0;
		var min_dist:int =int.MAX_VALUE;
		var idx:int=0;
		for(var r:int=0;r<i_smp_len;r++){
			for(var c:int=0;c<i_target_len;c++){
				map[idx].col=c;
				map[idx].row=r;
				//中央座標の距離？
				var d:int=i_target[c]._sample_area.sqDiagonalPointDiff(i_sample[r].base_area);
				map[idx].dist=d;
				if(min_dist>d){
					min_index=idx;
					min_dist=d;
				}
				idx++;
			}
		}
		this._min_dist=min_dist;
		this._min_dist_index=min_index;
		this._size_col=i_smp_len;
		this._size_row=i_target_len;
		return;
	}			
}

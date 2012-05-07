package jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk
{

	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.types.stack.NyARPointerStack;
	import jp.nyatla.nyartoolkit.as3.core.utils.NyARDistMap;
	import jp.nyatla.nyartoolkit.as3.rpf.sampler.lrlabel.*;
	import jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk.status.*;




	/**
	 * このクラスは、四角形のトラッキングクラスです。画面内にある複数の矩形を、ターゲットとして識別して、追跡します。
	 * @author nyatla
	 *
	 */
	public class NyARTracker
	{
		private var _map:DistMap;
		protected var _index:Vector.<int>;

		private var newst_pool:NyARNewTargetStatusPool;
		private var contourst_pool:NyARContourTargetStatusPool;
		private var rect_pool:NyARRectTargetStatusPool;

		private var target_pool:NyARTargetPool;
		/**
		 * ターゲットリストです。このプロパティは内部向けです。
		 * refTrackTarget関数を介してアクセスしてください。
		 */
		public var _targets:NyARTargetList;


		//環境定数
		private var MAX_NUMBER_OF_NEW:int;
		private var MAX_NUMBER_OF_CONTURE:int;
		private var MAX_NUMBER_OF_RECT:int;
		private var MAX_NUMBER_OF_TARGET:int;
		
		private var _newsource:SampleStack;
		private var _igsource:SampleStack;
		private var _coordsource:SampleStack;
		private var _rectsource:SampleStack;	
		public var _temp_targets:Vector.<NyARTargetList>;

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
		public function refTrackTarget():NyARTargetList
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
		 * @throws NyARException
		 */
		public function NyARTracker(i_max_new:int,i_max_cont:int,i_max_rect:int)
		{
			//環境定数の設定
			this.MAX_NUMBER_OF_NEW=i_max_new;
			this.MAX_NUMBER_OF_CONTURE=i_max_cont;
			this.MAX_NUMBER_OF_RECT=i_max_rect;		
			this.MAX_NUMBER_OF_TARGET=(i_max_new+i_max_cont+i_max_rect)*5;		


			//ターゲットマップ用の配列と、リスト。この関数はNyARTargetStatusのIDと絡んでるので、気をつけて！
			this._temp_targets=new Vector.<NyARTargetList>(NyARTargetStatus.MAX_OF_ST_KIND+1);
			this._temp_targets[NyARTargetStatus.ST_NEW]    =new NyARTargetList(i_max_new);
			this._temp_targets[NyARTargetStatus.ST_IGNORE] =new NyARTargetList(this.MAX_NUMBER_OF_TARGET);
			this._temp_targets[NyARTargetStatus.ST_CONTURE]=new NyARTargetList(i_max_cont);
			this._temp_targets[NyARTargetStatus.ST_RECT]   =new NyARRectTargetList(i_max_rect);

			//ソースリスト
			this._newsource=new SampleStack(i_max_new);
			this._igsource=new SampleStack(this.MAX_NUMBER_OF_TARGET);
			this._coordsource=new SampleStack(i_max_cont);
			this._rectsource=new SampleStack(i_max_rect);

			//ステータスプール
			this.newst_pool=new NyARNewTargetStatusPool(i_max_new*2);
			this.contourst_pool=new NyARContourTargetStatusPool(i_max_rect+i_max_cont*2);
			this.rect_pool=new NyARRectTargetStatusPool(i_max_rect*2);
			//ターゲットプール
			this.target_pool=new NyARTargetPool(this.MAX_NUMBER_OF_TARGET);
			//ターゲット
			this._targets=new NyARTargetList(this.MAX_NUMBER_OF_TARGET);		
			
			//ここ注意！マップの最大値は、ソースアイテムの個数よりおおきいこと！
			this._map=new DistMap(this.MAX_NUMBER_OF_TARGET,this.MAX_NUMBER_OF_TARGET);
			this._index=new Vector.<int>([this.MAX_NUMBER_OF_TARGET]);
			
			//定数初期化
			this._number_of_new=this._number_of_ignore=this._number_of_contoure=this._number_of_rect=0;
		}

		/**
		 * Trackerの状態を更新します。
		 * @param i_source
		 * @throws NyARException
		 */
		public function progress(i_s:NyARTrackerSource):void
		{
			var i:int;
			//SampleOutを回収
			var sample_out:LowResolutionLabelingSamplerOut=i_s.makeSampleOut();
			
			var targets:Vector.<NyARTargetList>=this._temp_targets;
			var newtr:NyARTargetList=targets[NyARTargetStatus.ST_NEW];
			var igtr:NyARTargetList=targets[NyARTargetStatus.ST_IGNORE];
			var cotr:NyARTargetList=targets[NyARTargetStatus.ST_CONTURE];
			var retw:NyARTargetList=targets[NyARTargetStatus.ST_RECT];

			var vecreader:INyARVectorReader=i_s.getBaseVectorReader();
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
				case NyARTargetStatus.ST_IGNORE:
					upgradeIgnoreTarget(i);
					continue;
				case NyARTargetStatus.ST_NEW:
					upgradeNewTarget(NyARTarget(target_array[i]),vecreader);
					continue;
				case NyARTargetStatus.ST_RECT:
					upgradeRectTarget(NyARTarget(target_array[i]));
					continue;
				case NyARTargetStatus.ST_CONTURE:
					upgradeContourTarget(NyARTarget(target_array[i]));
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
		 * @throws NyARException
		 */
		private function upgradeNewTarget(i_new_target:NyARTarget,i_vecreader:INyARVectorReader):void
		{
			//assert(i_new_target._st_type==NyARTargetStatus.ST_NEW);

			//寿命を超えたらignoreへ遷移
			if(i_new_target._status_life<=0)
			{
				this.changeStatusToIgnore(i_new_target,LIFE_OF_IGNORE_FROM_NEW);
				return;
			}
			var st:NyARNewTargetStatus=(NyARNewTargetStatus)(i_new_target._ref_status);
			//このターゲットをアップグレードできるか確認
			if(st.current_sampleout==null){
				//直近のsampleoutが無い。->なにもできない。
				return;
			}
			//coordステータスを生成
			var c:NyARContourTargetStatus=NyARContourTargetStatus(this.contourst_pool.newObject());
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
		 * @throws NyARException
		 */
		private function upgradeIgnoreTarget(i_ig_index:int):void
		{
			//assert(this._targets.getItem(i_ig_index)._st_type==NyARTargetStatus.ST_IGNORE);
			if(this._targets.getItem(i_ig_index)._status_life<=0)
			{
				//オブジェクトのリリース
	//System.out.println("lost:ignore:"+t.serial+":"+t.last_update);
				this.deleatTarget(i_ig_index);
			}
		}
		
		/**
		 * NyARTrackerOutのCOntourTargetについて、アップグレード処理をします。
		 * アップグレードの種類は以下のにとおりです。1.一定期間経過後の破棄ルート(Ignoreへ遷移)2.正常認識ルート(Rectへ遷移)
		 * @param i_base_raster
		 * @param i_trackdata
		 * @throws NyARException
		 */
		private function upgradeContourTarget(i_contoure_target:NyARTarget):void
		{
			//assert(i_contoure_target._st_type==NyARTargetStatus.ST_CONTURE);
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

			var st:NyARContourTargetStatus=(NyARContourTargetStatus)(i_contoure_target._ref_status);
			//coordステータスを生成
			var c:NyARRectTargetStatus=NyARRectTargetStatus(this.rect_pool.newObject());
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
		private function upgradeRectTarget(i_rect_target:NyARTarget):void
		{
			//assert(i_rect_target._st_type==NyARTargetStatus.ST_RECT);
			if(i_rect_target._delay_tick>20)
			{
				this.changeStatusToIgnore(i_rect_target,LIFE_OF_IGNORE_FROM_RECT);
				//一定の期間updateができなければ、ignoreへ遷移
			}
		}	
		
		//
		//update
		//
		private function updateIgnoreStatus(i_igliet:NyARTargetList,source:Vector.<Object>,index:Vector.<int>):void
		{
			var d_ptr:NyARTarget;
			//マップする。
			var i_ignore_target:Vector.<Object>=i_igliet.getArray();
			//ターゲットの更新
			for(var i:int=i_igliet.getLength()-1;i>=0;i--){
				d_ptr=NyARTarget(i_ignore_target[i]);
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
		 * public static function updateNewStatus(i_list:NyARTargetList,i_pool:NyARNewTargetStatusPool,source:Vector.<LowResolutionLabelingSamplerOut_Item>,index:Vector.<int>):void 
		 * @param i_sample
		 * @throws NyARException 
		 */
		public static function updateNewStatus(i_list:NyARTargetList,i_pool:NyARNewTargetStatusPool,source:Vector.<Object>,index:Vector.<int>):void 
		{
			var d_ptr:NyARTarget;
			var i_nes:Vector.<Object>=i_list.getArray();		
			//ターゲットの更新
			for(var i:int=i_list.getLength()-1;i>=0;i--){
				d_ptr=NyARTarget(i_nes[i]);
				var sample_index:int=index[i];
				//年齢を加算
				d_ptr._status_life--;
				if(sample_index<0){
					//このターゲットに合致するアイテムは無い。
					((NyARNewTargetStatus)(d_ptr._ref_status)).setValue(null);
					d_ptr._delay_tick++;
					continue;
				}
				var s:LowResolutionLabelingSamplerOut_Item=LowResolutionLabelingSamplerOut_Item(source[sample_index]);
				//先にステータスを作成しておく
				var st:NyARNewTargetStatus=NyARNewTargetStatus(i_pool.newObject());
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
		 * public static function updateContureStatus(i_list:NyARTargetList,i_vecreader:NyARVectorReader_INT1D_GRAY_8,i_stpool:NyARContourTargetStatusPool,source:Vector.<LowResolutionLabelingSamplerOut_Item>,index:Vector.<int>):void
		 * @param i_list
		 * @param i_vecreader
		 * @param i_stpool
		 * @param source
		 * @param index
		 * @throws NyARException
		 */
		public static function updateContureStatus(i_list:NyARTargetList,i_vecreader:INyARVectorReader,i_stpool:NyARContourTargetStatusPool,source:Vector.<Object>,index:Vector.<int>):void
		{

			var crd:Vector.<Object>=i_list.getArray();		
			var d_ptr:NyARTarget;
			//ターゲットの更新
			for(var i:int=i_list.getLength()-1;i>=0;i--){

				d_ptr=NyARTarget(crd[i]);
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
				var st:NyARContourTargetStatus=NyARContourTargetStatus(i_stpool.newObject());
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
		 * public static function updateRectStatus(i_list:NyARTargetList,i_vecreader:NyARVectorReader_INT1D_GRAY_8,i_stpool:NyARRectTargetStatusPool,source:Vector.<LowResolutionLabelingSamplerOut_Item>,index:Vector.<int>):void
		 */
		public static function updateRectStatus(i_list:NyARTargetList,i_vecreader:INyARVectorReader,i_stpool:NyARRectTargetStatusPool,source:Vector.<Object>,index:Vector.<int>):void
		{	
			
			var rct:Vector.<Object>=i_list.getArray();
			var d_ptr:NyARTarget;
			//ターゲットの更新
			for (var i:int = i_list.getLength() - 1; i >= 0; i--) {
				
				d_ptr=NyARTarget(rct[i]);
				//年齢を加算
				d_ptr._status_life--;
				//新しいステータスの作成
				var st:NyARRectTargetStatus=NyARRectTargetStatus(i_stpool.newObject());
				if(st==null){
					//失敗（作れなかった？）
					d_ptr._delay_tick++;
					continue;
				}
				var sample_index:int=index[i];
				var s:LowResolutionLabelingSamplerOut_Item=LowResolutionLabelingSamplerOut_Item(sample_index<0?null:source[sample_index]);		
				if(!st.setValueByAutoSelect(i_vecreader, s, (NyARRectTargetStatus)(d_ptr._ref_status))){
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
		 * @throws NyARException
		 */
		private function sampleMapper(
			i_source:LowResolutionLabelingSamplerOut,
			i_new:NyARTargetList,i_ig:NyARTargetList,i_cood:NyARTargetList,i_rect:NyARTargetList,
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
				var t:NyARTarget=this.addNewTarget(sample_item);
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
		 * @throws NyARException
		 */
		private function addNewTarget( i_sample:LowResolutionLabelingSamplerOut_Item):NyARTarget
		{
			//個数制限
			if(this._number_of_new>=this.MAX_NUMBER_OF_NEW){
				return null;
			}
			//アイテム生成
			var t:NyARTarget=this.target_pool.newNewTarget();
			if(t==null){
				return null;
			}
			t._status_life=LIFE_OF_NEW;
			t._st_type=NyARTargetStatus.ST_NEW;
			t._delay_tick=0;
			t.setSampleArea_2(i_sample);
			t._ref_status=NyARTargetStatus(this.newst_pool.newObject());
			if(t._ref_status==null){
				t.releaseObject();
				return null;
			}
			(NyARNewTargetStatus(t._ref_status)).setValue(i_sample);
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
		 * @throws NyARException
		 */
		private function deleatTarget(i_index:int):void
		{
			//assert(this._targets.getItem(i_index)._st_type==NyARTargetStatus.ST_IGNORE);
			var tr:NyARTarget=NyARTarget(this._targets.getItem(i_index));
			this._targets.removeIgnoreOrder(i_index);
			tr.releaseObject();
			this._number_of_ignore--;
			return;
		}
		
		/**
		 * このターゲットのステータスを、IgnoreStatusへ変更します。
		 * @throws NyARException 
		 */
		public function changeStatusToIgnore(i_target:NyARTarget,i_life:int):void
		{
			//遷移元のステータスを制限すること！
			//assert( (i_target._st_type==NyARTargetStatus.ST_NEW) || 
			//		(i_target._st_type==NyARTargetStatus.ST_CONTURE) || 
			//		(i_target._st_type==NyARTargetStatus.ST_RECT));

			//カウンタ更新
			switch(i_target._st_type)
			{
			case NyARTargetStatus.ST_NEW:
				this._number_of_new--;
				break;
			case NyARTargetStatus.ST_RECT:
				this._number_of_rect--;
				break;
			case NyARTargetStatus.ST_CONTURE:
				this._number_of_contoure--;
				break;
			default:
				return;
			}
			i_target._st_type=NyARTargetStatus.ST_IGNORE;
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
		private function changeStatusToCntoure(i_target:NyARTarget,i_c:NyARContourTargetStatus):NyARTarget
		{
			//遷移元のステータスを制限
			//assert(i_c!=null);
			//assert(i_target._st_type==NyARTargetStatus.ST_NEW);
			//個数制限
			if(this._number_of_contoure>=this.MAX_NUMBER_OF_CONTURE){
				return null;
			}
			i_target._st_type=NyARTargetStatus.ST_CONTURE;
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
		private function changeStatusToRect(i_target:NyARTarget,i_c:NyARRectTargetStatus):NyARTarget 
		{
			//assert(i_target._st_type==NyARTargetStatus.ST_CONTURE);
			if(this._number_of_rect>=this.MAX_NUMBER_OF_RECT){
				return null;
			}
			i_target._st_type=NyARTargetStatus.ST_RECT;
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

import jp.nyatla.nyartoolkit.as3.core.types.stack.*;
import jp.nyatla.nyartoolkit.as3.core.utils.*;
import jp.nyatla.nyartoolkit.as3.rpf.sampler.lrlabel.*;
import jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk.*;
/**
 * サンプルを格納するスタックです。このクラスは、一時的なリストを作るために使います。
 */
class SampleStack extends NyARPointerStack
{
	public function SampleStack(i_size:int)
	{
		super();
		this.initInstance(i_size);
	}
}


/**
 * NyARTargetとSampleStack.Item間の、点間距離マップを作製するクラスです。
 * スーパークラスから、setPointDists関数をオーバライドします。
 *
 */
class DistMap extends NyARDistMap
{
	public function DistMap(i_max_col:int,i_max_row:int)
	{
		super(i_max_col,i_max_row);
	}
	public function makePairIndexes(igsource:SampleStack,igtr:NyARTargetList ,index:Vector.<int>):void
	{
		this.setPointDists_3(igsource.getArray(),igsource.getLength(),igtr.getArray(),igtr.getLength());
		this.getMinimumPair(index);
		return;
	}
	/**
	 * ２ペアの点間距離を計算します。
	 * getMinimumPairで求まるインデクスは、NyARTargetに最も一致するLowResolutionLabelingSamplerOut.Itemのインデックスになります。
	 * setPointDists(i_sample:Vector.<LowResolutionLabelingSamplerOut_Item>,i_smp_len:int,i_target:Vector.<NyARTarget>,i_target_len:int):void
	 * @param i_sample
	 * @param i_smp_len
	 * @param i_target
	 * @param i_target_len
	 */
	public function setPointDists_3(i_sample:Vector.<Object>,i_smp_len:int,i_target:Vector.<Object>,i_target_len:int):void
	{
		var map:Vector.<NyARDistMap_DistItem>=this._map;
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

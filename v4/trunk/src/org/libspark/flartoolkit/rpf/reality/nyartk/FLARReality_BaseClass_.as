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
package org.libspark.flartoolkit.rpf.reality.nyartk
{

	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.param.FLARCameraDistortionFactor;
	import org.libspark.flartoolkit.core.param.FLARFrustum;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.param.FLARPerspectiveProjectionMatrix;
	import org.libspark.flartoolkit.core.raster.rgb.IFLARRgbRaster;
	import org.libspark.flartoolkit.core.squaredetect.FLARSquare;
	import org.libspark.flartoolkit.core.transmat.IFLARTransMat;
	import org.libspark.flartoolkit.core.transmat.FLARTransMat;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.types.matrix.*;
	import org.libspark.flartoolkit.rpf.realitysource.nyartk.FLARRealitySource;
	import org.libspark.flartoolkit.rpf.sampler.lrlabel.LowResolutionLabelingSampler;
	import org.libspark.flartoolkit.rpf.sampler.lrlabel.LowResolutionLabelingSamplerOut;
	import org.libspark.flartoolkit.rpf.tracker.nyartk.*;
	import jp.nyatla.as3utils.*;
	import org.libspark.flartoolkit.rpf.tracker.nyartk.status.*


	/**
	 * FLARRealityモデルの駆動クラスです。
	 * Realityデータの保持と、更新を担当します。
	 * <p>FLARRealityModel</p>
	 * FLARRealityモデルは、ARToolKitのマーカー認識処理系をReality化します。
	 * FLARRealityモデルでは、空間に存在する複数のマーカをターゲットとして取り扱います。
	 * マーカは初め、Unknownターゲットとして、Realityの中に現れます。
	 * Realityは、Unknownターゲットの存在を可能な限り維持し、そのリストと内容を公開します。
	 * 
	 * UnknownターゲットはKnownターゲットへ昇格させることができます。
	 * その方法は、Unknownターゲットの具体化に必要な情報(マーカ方位と大きさ)を入力することです。
	 * 大きさと方位を調べるために、Unknownターゲットはマーカに関するいくつかのアクセス関数を提供します。
	 * ユーザは、それらの関数から得られる情報を元に値を推定し、UnknownターゲットをKnownターゲットに
	 * 昇格させる処理を行います。
	 * 
	 * 昇格したKnownターゲットからは、マーカに関するさらに詳細な情報にアクセスする関数を提供します。
	 * 
	 * ユーザが不要なUnknown/Knownターゲットは、Deadターゲットへ降格させることもできます。
	 * このターゲットは、次の処理サイクルで既知の不要ターゲットになり、しばらくの間Realityの
	 * 管理から外されます。しばらくすると、またUnknownターゲットに現れます。Deadターゲットは意図的に
	 * 発生させる場合以外に、自動的に発生してしまうことがあります。これは、マーカが視界から消えてしまったときです。
	 * 
	 * 
	 *
	 */
	public class FLARReality_BaseClass_
	{
		//視野関係のデータ
		public static const FRASTRAM_ARTK_NEAR:Number=10;
		public static const FRASTRAM_ARTK_FAR:Number=10000;
		/**frastum*/
		protected var _frustum:FLARFrustum;
		protected var _ref_prjmat:FLARPerspectiveProjectionMatrix;

		
		//Realityでーた
		/**
		 * Unknownターゲットの最大数です。
		 */
		private var MAX_LIMIT_UNKNOWN:int;
		/**
		 * Knownターゲットの最大数です。
		 */
		private var MAX_LIMIT_KNOWN:int;

		/**
		 * samplerの出力値。この変数はFLARRealityからのみ使います。
		 */
		private var  _pool:FLARRealityTargetPool;

		private var  target:FLARRealityTargetList;

		//種類ごとのターゲットの数
		
		private var _number_of_unknown:int;
		private var _number_of_known:int;
		private var _number_of_dead:int;
		//
		private var _tracker:FLARTracker;
		private var _transmat:IFLARTransMat;

		public function FLARReality_BaseClass_(...args:Array)
		{
			switch(args.length) {
			case 1:
				if (args[0] is NyAS3Const_Inherited) {
					return;
				}
				break;				
			case 5:
				if((args[0] is FLARParam) && (args[1] is Number) && (args[2] is Number) && (args[3] is int) && (args[4] is int))
				{
					override_FLARReality(FLARParam(args[0]), Number(args[1]), Number(args[2]), int(args[3]), int(args[4]));
					return;
				}
				break;
			case 7:
				if ((args[0] is FLARIntSize) && (args[1] is Number) && (args[2] is Number) && (args[3] is FLARPerspectiveProjectionMatrix) && ((args[4] is FLARCameraDistortionFactor) || (args[4] == null)) && (args[5] is int) && (args[6] is int))
				{
					override_FLARReality_2(FLARIntSize(args[0]), Number(args[1]), Number(args[2]), FLARPerspectiveProjectionMatrix(args[3]), FLARCameraDistortionFactor(args[4]), int(args[5]), int(args[6]));
					return;
				}
			default:
				break;
			}
			throw new FLARException();
		}		
		/**
		 * コンストラクタ。
		 * 樽型歪みが少ない、または補正済みの画像を入力するときには、{@link #FLARReality(FLARIntSize, double, double, FLARPerspectiveProjectionMatrix, FLARCameraDistortionFactor, int, int)}
		 * のi_dist_factorにnullを指定すると、より高速な動作が期待できます。
		 * @param i_param
		 * カメラパラメータを指定します。
		 * @param i_near
		 * 視錐体のnear-pointをmm単位で指定します。
		 * default値は{@link #FRASTRAM_ARTK_NEAR}です。
		 * @param i_far
		 * 視錐体のfar-pointをmm単位で指定します。
		 * default値は{@link #FRASTRAM_ARTK_FAR}です。
		 * @param i_max_known_target
		 * Knownターゲットの最大数を指定します。
		 * @param i_max_unknown_target
		 * UnKnownターゲットの最大数を指定します。
		 * @throws FLARException
		 */
		protected function override_FLARReality(i_param:FLARParam, i_near:Number, i_far:Number, i_max_known_target:int, i_max_unknown_target:int):void
		{
			//定数とかいろいろ
			this.MAX_LIMIT_KNOWN=i_max_known_target;
			this.MAX_LIMIT_UNKNOWN=i_max_unknown_target;
			this.initInstance(i_param.getScreenSize(),i_near,i_far,i_param.getPerspectiveProjectionMatrix(),i_param.getDistortionFactor());
			return;
		}
		/**
		 * コンストラクタ。
		 * @param i_screen
		 * スクリーン(入力画像)のサイズを指定します。
		 * @param i_near
		 * {@link #FLARReality(FLARParam i_param,double i_near,double i_far,int i_max_known_target,int i_max_unknown_target)}を参照
		 * @param i_far
		 * {@link #FLARReality(FLARParam i_param,double i_near,double i_far,int i_max_known_target,int i_max_unknown_target)}を参照
		 * @param i_prjmat
		 * ARToolKit形式の射影変換パラメータを指定します。
		 * @param i_dist_factor
		 * カメラ歪み矯正オブジェクトを指定します。歪み矯正が不要な時は、nullを指定します。
		 * @param i_max_known_target
		 * {@link #FLARReality(FLARParam i_param,double i_near,double i_far,int i_max_known_target,int i_max_unknown_target)}を参照
		 * @param i_max_unknown_target
		 * {@link #FLARReality(FLARParam i_param,double i_near,double i_far,int i_max_known_target,int i_max_unknown_target)}を参照
		 * @throws FLARException
		 */
		protected function override_FLARReality_2(i_screen:FLARIntSize,i_near:Number,i_far:Number,i_prjmat:FLARPerspectiveProjectionMatrix,i_dist_factor:FLARCameraDistortionFactor,i_max_known_target:int,i_max_unknown_target:int):void
		{
			this.MAX_LIMIT_KNOWN=i_max_known_target;
			this.MAX_LIMIT_UNKNOWN=i_max_unknown_target;
			this.initInstance(i_screen,i_near,i_far,i_prjmat,i_dist_factor);
		}
		/**
		 * コンストラクタから呼び出す共通な初期化部分です。
		 * @param i_dist_factor
		 * @param i_prjmat
		 * @throws FLARException
		 */
		protected function initInstance(i_screen:FLARIntSize,i_near:Number,i_far:Number,i_prjmat:FLARPerspectiveProjectionMatrix,i_dist_factor:FLARCameraDistortionFactor):void
		{
			var number_of_reality_target:int=this.MAX_LIMIT_KNOWN+this.MAX_LIMIT_UNKNOWN;
			//演算インスタンス
			this._transmat=new FLARTransMat(i_dist_factor,i_prjmat);

			//データインスタンス
			this._pool=new FLARRealityTargetPool(number_of_reality_target,i_prjmat);
			this.target=new FLARRealityTargetList(number_of_reality_target);
			//Trackerの特性値
			this._tracker=new FLARTracker((this.MAX_LIMIT_KNOWN+this.MAX_LIMIT_UNKNOWN)*2,1,this.MAX_LIMIT_KNOWN*2);
			//フラスタムの計算とスクリーンサイズの保存
			this._ref_prjmat=i_prjmat;
			this._frustum=new FLARFrustum(i_prjmat,i_screen.w,i_screen.h, i_near, i_far);

			//初期化
			this._number_of_dead=this._number_of_unknown=this._number_of_known=0;
			return;
		}
		/**
		 * Realityの状態を、i_inの{@link FLARRealitySource}を元に、１サイクル進めます。
		 * 現在の更新ルールは以下の通りです。
		 * 0.呼び出されるごとに、トラックターゲットからUnknownターゲットを生成する。
		 * 1.一定時間捕捉不能なKnown,Unknownターゲットは、deadターゲットへ移動する。
		 * 2.knownターゲットは最新の状態を維持する。
		 * 3.deadターゲットは（次の呼び出しで）捕捉対象から削除する。
		 * Knownターゲットが捕捉不能になった時の動作は、以下の通りです。
		 * 4.[未実装]捕捉不能なターゲットの予測と移動
		 * @param i_in
		 * @throws FLARException
		 */
		public function progress(i_in:FLARRealitySource):void
		{
			//tracker進行
			this._tracker.progress(i_in.makeTrackSource());
			
			//トラックしてないrectターゲット1個探してunknownターゲットに入力
			var tt:FLARTarget=findEmptyTagItem(this._tracker._targets);
			if(tt!=null){
				this.addUnknownTarget(tt);
			}
			//リストのアップデート
			updateLists();
			//リストのアップグレード
			upgradeLists();
			return;
		}
		/**
		 * Realityターゲットリストの全ての項目を更新します。この関数内では、リスト要素の増減はありません。
		 * {@link #progress}のサブ関数です。
		 * @throws FLARException
		 */
		private function upgradeLists():void
		{
			var rt_array:Vector.<Object>=this.target.getArray();
			for(var i:int=this.target.getLength()-1;i>=0;i--)
			{
				switch(rt_array[i]._target_type)
				{
				case FLARRealityTarget.RT_DEAD:
					//deadターゲットの削除
					this.deleteTarget(i);
					continue;
				case FLARRealityTarget.RT_KNOWN:
				case FLARRealityTarget.RT_UNKNOWN:
					//KNOWNとUNKNOWNは、生存チェックして、死んでたらdeadターゲットへ。自動死んでたの復帰機能を作るときは、この辺いじくる。
					if(!isTargetAlive(FLARRealityTarget(rt_array[i]))){
						this.changeTargetToDead(FLARRealityTarget(rt_array[i]));
					}
					continue;
				default:
					throw new FLARException();
				}
			}
		}
		/**
		 * Realityターゲットリストの全ての項目のアップグレード処理を行います。この関数内でリスト要素の加算/減算/種別変更処理を行います。
		 * {@link #progress}のサブ関数です。
		 * @throws FLARException
		 */
		private function updateLists():void
		{
			var rt_array:Vector.<Object>=this.target.getArray();
			
			for(var i:int=this.target.getLength()-1;i>=0;i--){
				var tar:FLARRealityTarget=FLARRealityTarget(rt_array[i]);
				if(tar._ref_tracktarget._delay_tick==0){
					//30fps前後で1秒間の認識率とする。
					tar.grab_rate+=3;
					if(tar.grab_rate>100){tar.grab_rate=100;}
					switch(tar._target_type)
					{
					case FLARRealityTarget.RT_DEAD:
						//何もしない
						continue;
					case FLARRealityTarget.RT_KNOWN:
						//矩形座標計算
						setSquare(((FLARRectTargetStatus)(tar._ref_tracktarget._ref_status)).vertex,tar._screen_square);
						//3d座標計算
	//					this._transmat.transMat(tar._screen_square,tar._offset,tar._transform_matrix);
						this._transmat.transMatContinue(tar._screen_square,tar._offset,tar._transform_matrix,tar._transform_matrix);
						continue;
					case FLARRealityTarget.RT_UNKNOWN:
						continue;
					default:
					}
				}else{
					//更新をパスして補足レートの再計算(混ぜて8で割る)
					tar.grab_rate=tar.grab_rate-(3*tar._ref_tracktarget._delay_tick);
					if(tar.grab_rate<0){tar.grab_rate=0;}
				}
			}
		}
		private var __tmp_l:FLARLinear =new FLARLinear();


		/**
		 * 頂点データをFLARSquareにセットする関数です。
		 * 初期位置セットには使わないこと。
		 * @param i_vx
		 * @param i_s
		 */
		private function setSquare(i_vx:Vector.<FLARDoublePoint2d>,i_s:FLARSquare):void
		{		
			var l:FLARLinear=this.__tmp_l;
			//線分を平滑化。（ノイズが多いソースを使う時は線分の平滑化。ほんとは使いたくない。）
			var i:int;
			for(i=3;i>=0;i--){
				i_s.sqvertex[i].setValue(i_vx[i]);
				l.makeLinearWithNormalize_2(i_vx[i], i_vx[(i+1)%4]);
				i_s.line[i].a=i_s.line[i].a*0.6+l.a*0.4;
				i_s.line[i].b=i_s.line[i].b*0.6+l.b*0.4;
				i_s.line[i].c=i_s.line[i].c*0.6+l.c*0.4;
			}
			
			for(i=3;i>=0;i--){
				i_s.line[i].crossPos(i_s.line[(i+3)%4],i_s.sqvertex[i]);
			}	
		}
		/**
		 * Unknown/Knownを維持できる条件を書きます。
		 * @param i_target
		 * @return
		 */
		private function isTargetAlive(i_target:FLARRealityTarget):Boolean
		{
			return i_target._ref_tracktarget._st_type==FLARTargetStatus.ST_RECT;
		}
		
		/**
		 * トラックターゲットリストから、tagがNULLの{@link FLARTargetStatus#ST_RECT}アイテムを探して返します。
		 * @return
		 */
		private static function findEmptyTagItem(i_list:FLARTargetList):FLARTarget 
		{
			var items:Vector.<Object>=i_list.getArray();
			for(var i:int=i_list.getLength()-1;i>=0;i--){
				if(items[i]._st_type!=FLARTargetStatus.ST_RECT){
					continue;
				}
				if(items[i].tag!=null){
					continue;
				}
				return FLARTarget(items[i]);
			}
			return null;
		}
		//RealityTargetの編集関数

		/**
		 * Realityターゲットリストへ新しい{@link FLARRealityTarget}を追加する。
		 * @param i_track_target
		 * UnknownTargetに関連付ける{@link FLARTarget}.このターゲットは、{@link FLARTargetStatus#ST_RECT}であること？
		 */
		private function addUnknownTarget(i_track_target:FLARTarget ):FLARRealityTarget
		{
			NyAS3Utils.assert(i_track_target._st_type==FLARTargetStatus.ST_RECT);
			var rt:FLARRealityTarget=this._pool.newNewTarget(i_track_target);
			if(rt==null){
				return null;
			}
			//個数制限
			if(this._number_of_unknown>=this.MAX_LIMIT_UNKNOWN)
			{
				return null;
			}
			rt._target_type=FLARRealityTarget.RT_UNKNOWN;
			this.target.pushAssert(rt);
			this._number_of_unknown++;
			return rt;
		}
		/**
		 * Realityターゲットリストから指定したインデクス番号のターゲットを削除します。
		 * @param i_index
		 */
		private function deleteTarget(i_index:int):void
		{
			//削除できるのはdeadターゲットだけ
			NyAS3Utils.assert(this.target.getItem(i_index)._target_type==FLARRealityTarget.RT_DEAD);
			//poolから開放してリストから削除
			this.target.getItem(i_index).releaseObject();
			this.target.removeIgnoreOrder(i_index);
			this._number_of_dead--;
		}
		
		////////////////////////////////////////////////////////////////////////////////
		//Public:
		//RealityTargetの操作関数
		//
		////////////////////////////////////////////////////////////////////////////////

		/**
		 * 指定したターゲットを、UnknownターゲットからKnownターゲットへ遷移させます。
		 * @param i_item
		 * 移動するターゲット
		 * @param i_dir
		 * ターゲットの予備知識。ARToolkitのdirectionでどの方位であるかを示す値
		 * @param i_marker_size
		 * ターゲットの予備知識。マーカーの高さ/幅がいくらであるかを示す値[mm単位]
		 * @return
		 * 成功するとtrueを返します。
		 * @throws FLARException 
		 */
		public function changeTargetToKnown(i_item:FLARRealityTarget,i_dir:int,i_marker_size:Number):Boolean
		{
			return changeTargetToKnown_2(i_item,i_dir,i_marker_size,i_marker_size);
		}
		

		/**
		 * 指定したターゲットを、UnknownターゲットからKnownターゲットへ遷移させます。
		 * @param i_item
		 * 移動するターゲット
		 * @param i_dir
		 * ターゲットの予備知識。ARToolkitのdirectionでどの方位であるかを示す値
		 * @param i_marker_width
		 * ターゲットの予備知識。マーカーの高さがいくらであるかを示す値[mm単位]
		 * @param i_marker_height
		 * ターゲットの予備知識。マーカーの幅がいくらであるかを示す値[mm単位]
		 * @return
		 * 成功するとtrueを返します。
		 * @throws FLARException 
		 */
		public function changeTargetToKnown_2(i_item:FLARRealityTarget,i_dir:int,i_marker_width:Number,i_marker_height:Number):Boolean
		{
			//遷移元制限
			if(i_item._target_type!=FLARRealityTarget.RT_UNKNOWN){
				return false;
			}
			//ステータス制限
			if(i_item._ref_tracktarget._st_type!=FLARTargetStatus.ST_RECT){
				return false;
			}
			//個数制限
			if(this._number_of_known>=this.MAX_LIMIT_KNOWN)
			{
				return false;
			}
			//ステータス制限
			i_item._target_type=FLARRealityTarget.RT_KNOWN;
			
			//マーカのサイズを決めておく。
			i_item._offset.setSquare_2(i_marker_width,i_marker_height);
			
			//directionに応じて、元矩形のrectを回転しておく。
			((FLARRectTargetStatus)(i_item._ref_tracktarget._ref_status)).shiftByArtkDirection((4-i_dir)%4);		
			//矩形セット
			var vx:Vector.<FLARDoublePoint2d>=((FLARRectTargetStatus)(i_item._ref_tracktarget._ref_status)).vertex;
			for(var i:int=3;i>=0;i--){
				i_item._screen_square.sqvertex[i].setValue(vx[i]);
				i_item._screen_square.line[i].makeLinearWithNormalize_2(vx[i],vx[(i+1)%4]);
			}
			//3d座標計算
			this._transmat.transMat(i_item._screen_square,i_item._offset,i_item._transform_matrix);
			
			//数の調整
			this._number_of_unknown--;
			this._number_of_known++;
			return true;
		}
		/**
		 * 指定したKnown,またはUnknownターゲットを、50サイクルの間Deadターゲットにします。
		 * Deadターゲットは次回のサイクルでRealityターゲットリストから削除され、一定のサイクル期間の間システムから無視されます。
		 * @param i_item
		 * @throws FLARException 
		 */	
		public function changeTargetToDead(i_item:FLARRealityTarget):void
		{
			changeTargetToDead_2(i_item,50);
		}
		
		/**
		 * 指定したKnown,またはUnknownターゲットを、Deadターゲットにします。
		 * Deadターゲットは次回のサイクルでRealityターゲットリストから削除され、一定のサイクル期間の間システムから無視されます。
		 * @param i_item
		 * @param i_dead_cycle
		 * 無視するサイクルを指定します。1サイクルは1フレームです。デフォルトは50です。
		 * @throws FLARException 
		 */
		public function changeTargetToDead_2(i_item:FLARRealityTarget, i_dead_cycle:int):void
		{
			NyAS3Utils.assert(i_item._target_type==FLARRealityTarget.RT_UNKNOWN || i_item._target_type==FLARRealityTarget.RT_KNOWN);
			//IG検出して遷移した場合
			if(i_item._ref_tracktarget._st_type!=FLARTargetStatus.ST_IGNORE){
				//所有するトラックターゲットがIGNOREに設定
				this._tracker.changeStatusToIgnore(i_item._ref_tracktarget,i_dead_cycle);
			}
			//数の調整
			if(i_item._target_type==FLARRealityTarget.RT_UNKNOWN){
				this._number_of_unknown--;
			}else{
				this._number_of_known--;
			}
			i_item._target_type=FLARRealityTarget.RT_DEAD;
			this._number_of_dead++;
			return;
		}
		/**
		 * 指定したシリアル番号のUnknownターゲットを、Knownターゲットへ移動します。
		 * @param i_serial
		 * ターゲットのシリアル番号を示す値
		 * @param i_dir
		 * ターゲットの予備知識。ARToolkitのdirectionでどの方位であるかを示す値
		 * @param i_marker_width
		 * ターゲットの予備知識。マーカーのサイズがいくらであるかを示す値[mm単位]
		 * @return
		 * 成功すると、trueを返します。
		 * @throws FLARException 
		 */
		public function changeTargetToKnownBySerial(i_serial:Number, i_dir:int, i_marker_width:Number):Boolean
		{
			var item:FLARRealityTarget=this.target.getItemBySerial(i_serial);
			if(item==null){
				return false;
			}
			return changeTargetToKnown(item,i_dir,i_marker_width);
		}
		/**
		 * 指定したシリアル番号のKnown/UnknownターゲットをDeadターゲットへ遷移します。
		 * @param i_serial
		 * @throws FLARException 
		 */
		public function changeTargetToDeadBySerial(i_serial:Number):FLARRealityTarget
		{
			var item:FLARRealityTarget=this.target.getItemBySerial(i_serial);
			if(item==null){
				return null;
			}
			changeTargetToDead(item);
			return item;
		}
		
		/**
		 * 現在のUnKnownターゲットの数を返します。
		 * @return
		 */
		public function getNumberOfUnknown():int
		{
			return this._number_of_unknown;
		}
		/**
		 * 現在のKnownターゲットの数を返します。
		 * @return
		 */
		public function getNumberOfKnown():int
		{
			return this._number_of_known;
		}
		/**
		 * 現在のDeadターゲットの数を返します。
		 * @return
		 */
		public function getNumberOfDead():int
		{
			return this._number_of_dead;
		}
		/**
		 * Realityターゲットリストへの参照値を返します。
		 * このリストは編集関数を持ちますが、直接編集してはいけません。
		 * @return
		 */
		public function refTargetList():FLARRealityTargetList
		{
			return this.target;
		}

		/**
		 * Knownターゲットを検索して、配列に返します。
		 * @param o_result
		 * 結果を格納する配列です。格納されるターゲットの最大数は、コンストラクタの設定値と同じです。
		 * 配列サイズが不足した場合は、発見した順に最大数を返します。
		 * @return
		 * 配列に格納したターゲットの数を返します。
		 */
		public function selectKnownTargets(o_result:Vector.<FLARRealityTarget>):int
		{
			return this.target.selectTargetsByType(FLARRealityTarget.RT_KNOWN, o_result);
		}
		/**
		 * Unknownターゲットを検索して、配列に返します。
		 * @param o_result
		 * 結果を格納する配列です。格納されるターゲットの最大数は、コンストラクタの設定値と同じです。
		 * 配列サイズが不足した場合は、発見した順に最大数を返します。
		 * @return
		 * 配列に格納したターゲットの数を返します。
		 */
		public function selectUnKnownTargets(o_result:Vector.<FLARRealityTarget>):int
		{
			return this.target.selectTargetsByType(FLARRealityTarget.RT_UNKNOWN, o_result);
		}
		/**
		 * Unknownターゲットを1個検索して返します。
		 * @return
		 * 一番初めに発見したターゲットを返します。見つからないときはNULLです。
		 */
		public function selectSingleUnknownTarget():FLARRealityTarget
		{
			return this.target.selectSingleTargetByType(FLARRealityTarget.RT_UNKNOWN);
		}
		/**
		 * フラスタムオブジェクトを返します。
		 * @return
		 */
		public function refFrustum():FLARFrustum
		{
			return this._frustum;
		}
		/**
		 * ARToolKitスタイルの射影変換行列を返します。
		 * @return
		 */
		public function refPerspectiveProjectionMatrix():FLARPerspectiveProjectionMatrix
		{
			return this._ref_prjmat;
		}
		/**
		 * 画面座標系の4頂点でかこまれる領域から、RGB画像をo_rasterに取得します。
		 * @param i_vertex
		 * @param i_resolution
		 * 1ピクセルあたりのサンプル数です。二乗した値が実際のサンプル数になります。
		 * @param o_raster
		 * @return
		 * @throws FLARException
		 */
		public function getRgbPatt2d(i_src:FLARRealitySource,i_vertex:Vector.<FLARIntPoint2d>,i_resolution:int,o_raster:IFLARRgbRaster):Boolean
		{
			return i_src.refPerspectiveRasterReader().copyPatt(i_vertex,0,0,i_resolution, o_raster);
		}
		/**
		 * 画面座標系の4頂点でかこまれる領域から、RGB画像をo_rasterに取得します。
		 * @param i_vertex
		 * @param i_resolution
		 * 1ピクセルあたりのサンプル数です。二乗した値が実際のサンプル数になります。
		 * @param o_raster
		 * @return
		 * @throws FLARException
		 */
		public function getRgbPatt2d_2(i_src:FLARRealitySource,i_vertex:Vector.<FLARDoublePoint2d>,i_resolution:int,o_raster:IFLARRgbRaster):Boolean
		{
			return i_src.refPerspectiveRasterReader().copyPatt_2(i_vertex,0,0,i_resolution, o_raster);
		}	
		/**
		 * カメラ座標系の4頂点でかこまれる領域から、RGB画像をo_rasterに取得します。
		 * @param i_vertex
		 * @param i_matrix
		 * i_vertexに適応する変換行列。
		 * ターゲットの姿勢行列を指定すると、ターゲット座標系になります。不要ならばnullを設定してください。
		 * @param i_resolution
		 * @param o_raster
		 * @return
		 * @throws FLARException
		 */
		public function getRgbPatt3d(i_src:FLARRealitySource,i_vertex:Vector.<FLARDoublePoint3d>,i_matrix:FLARDoubleMatrix44,i_resolution:int,o_raster:IFLARRgbRaster):Boolean
		{
			var vx:Vector.<FLARDoublePoint2d> = FLARDoublePoint2d.createArray(4);
			var i:int;
			if(i_matrix!=null){
				//姿勢変換してから射影変換
				var v3d:FLARDoublePoint3d=new FLARDoublePoint3d();
				for(i=3;i>=0;i--){
					i_matrix.transform3d_2(i_vertex[i],v3d);
					this._ref_prjmat.project(v3d,vx[i]);
				}
			}else{
				//射影変換のみ
				for(i=3;i>=0;i--){
					this._ref_prjmat.project(i_vertex[i],vx[i]);
				}
			}
			//パターンの取得
			return i_src.refPerspectiveRasterReader().copyPatt_2(vx,0,0,i_resolution, o_raster);
		}
	}
}
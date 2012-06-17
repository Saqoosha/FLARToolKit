/**
 * FlashDevelop では、サブパッケージにあるファイルを起動ファイルとして
 * 扱うことができないため、例外的にこのファイルを使います。
 * 本来は不要なので、常用することはしないでください。
 */

package
{
	import sample.away3d_4x.FLARToolKit_sample_Away3D;
	//import sample.pv3d.FLARToolKit_sample_PV3d;
	
	public class Main extends FLARToolKit_sample_Away3D //FLARToolKit_sample_PV3d
	{
		public function Main()
		{
			super();
		}
	}
}
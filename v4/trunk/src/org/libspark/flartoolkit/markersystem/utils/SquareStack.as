/* 
 * PROJECT: FLARToolkit(Extension)
 * --------------------------------------------------------------------------------
 * The FLARToolkit is Java edition ARToolKit class library.
 * Copyright (C)2008-2009 Ryo Iizuka
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
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp> or <nyatla(at)nyatla.jp>
 * 
 */
package org.libspark.flartoolkit.markersystem.utils
{

	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.squaredetect.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.types.stack.FLARObjectStack;

	/**
	 * このクラスは、拡張した{@link FLARSquare}クラスのスタックです。
	 */
	public class SquareStack extends FLARObjectStack
	{

		public function SquareStack(i_length:int)
		{
			super.initInstance(i_length);
		}
		protected override function createElement():Object 
		{
			return new SquareStack_Item();
		}		
	}
}
package org.libspark.flartoolkit.core.utils 
{
	/**
	 * このインタフェイスは、FLARManagedObjectがPoolを操作するために使います。
	 */	
	public interface IFLARManagedObjectPoolOperater
	{
		function deleteObject(i_object:FLARManagedObject):void;
	}

}
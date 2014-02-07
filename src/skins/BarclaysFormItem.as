package skins
{
	
	import spark.skins.spark.FormItemSkin;
	
	
	
	public class BarclaysFormItem extends FormItemSkin
	{
		
		public function BarclaysFormItem()
		{
			super();
			labelDisplay.clearStyle("color");
			labelDisplay.clearStyle("fontWeight");
			labelDisplay.styleName = "formItemLabelStyles";
		}
		
				
	}
}
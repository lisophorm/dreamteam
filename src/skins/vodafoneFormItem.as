package skins
{
	
	import spark.skins.spark.FormItemSkin;
	
	
	
	public class vodafoneFormItem extends FormItemSkin
	{
		
		public function vodafoneFormItem()
		{
			super();
			labelDisplay.clearStyle("color");
			labelDisplay.clearStyle("fontWeight");
			labelDisplay.styleName = "formItemLabelStyles";
		}
		
				
	}
}
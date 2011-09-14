package buttons
{
	import flash.display.Sprite;
 
	import qnx.ui.skins.SkinStates;
	import qnx.ui.skins.buttons.RoundedButtonSkinWhite;
 
	public class YellowButton extends RoundedButtonSkinWhite
	{
		/**
		 * First embed the custom image and then slice it up
		 * to where the "center" rectangle will be fixed
		 * this is best done in photoshop and just bring in
		 * the numbers here (use the guides)
		 */
		[Embed(source="../images/boton-amarillo.png",
                scaleGridTop="8", scaleGridBottom="36",
                scaleGridLeft="8", scaleGridRight="164")]
		private var YellowButtonSkin:Class;
 
		public function YellowButton()
		{
			super();
		}
 
		override protected function initializeStates():void
		{
			/**
			 * we need to do the super.initializeStates() method because
			 * we are overriding an already set up class. so all we really
			 * have to do is set the upSkin element
			 */
 
			super.initializeStates();
 
			/** set the upSkin object to your embedded image */
			upSkin = new YellowButtonSkin();
 
			/** set the skin state of the DOWN state */
			setSkinState(SkinStates.DOWN, upSkin);
			setSkinState(SkinStates.DISABLED_SELECTED, upSkin);
 
			/** now show the up skin by default */
			showSkin(upSkin);
 
		}
	}
}
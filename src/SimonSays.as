package
{	
	import MyUtilities.*;
	import buttons.*;

	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	import flash.events.TimerEvent
	import flash.text.TextFormat;

	

	
	import qnx.ui.text.Label;
	import qnx.ui.buttons.LabelButton;
	import qnx.ui.skins.SkinStates;
	import qnx.display.IowWindow;
	import qnx.dialog.DialogAlign;
	import qnx.dialog.DialogSize;
	import qnx.dialog.AlertDialog;
	
	
	
	
	
	//Establecemos los parametros de configuracion inicial
	[SWF(height="600", width="1024", frameRate="30", backgroundColor="#FFFFFF")]
	
	public class SimonSays extends Sprite
	{
		//declaramos las variablesde instancia
		private var btn_TopLeft:LabelButton;
		private var btn_TopRight:LabelButton;
		private var btn_BottomLeft:LabelButton;
		private var btn_BottomRight:LabelButton;
		private var level:int;
		private var playing:int;		
		private var numeroAleatorio:int;
		private var queueOne:Queue;
		private var queueTwo:Queue;
		private var myTimer:Timer;
		private var myTimerB:Timer;
		private var interGameTimer:Timer;
		private var firstRound:Boolean;
		private var points:Label;
		private var lblLevel:Label;
		private var lblHighScore:Label;
		private var pointsInt:int;
		private var highScoreInt:int;
		private var dao:SimonDao;
		
		
		
		
		
		public var soundChannel:SoundChannel;
		
		//incluimos en el archivo los sonidos al apretar los 4 botones y al equivocarse
		[Embed(source="./sounds/A.mp3")]private var soundA:Class;
		var sndA : Sound ;
		[Embed(source="./sounds/B.mp3")]private var soundB:Class;
		var sndB : Sound ;
		[Embed(source="./sounds/C.mp3")]private var soundC:Class;
		var sndC : Sound ;
		[Embed(source="./sounds/D.mp3")]private var soundD:Class;
		var sndD : Sound ;
		[Embed(source="./sounds/error.mp3")]private var soundX:Class;
		var sndX : Sound ;
		
		
		/*
		 * Metodo constructor
		 */
		public function SimonSays()
		{
			
			level=1;
			
			//0 juega la compu, 1 juegas tu, -1 perdiste
			playing=0;
			
			//queueTwo tiene los movimientos acumulados mientras que queueOne tiene los que se comparan con el usuario
		    queueTwo= new Queue;
			queueOne = new Queue;
			
			//tiempo entre cada movimiento.
			interGameTimer = new Timer(700,1);
			dao = new SimonDao();
			if(dao.countResults(1)>0){
				trace("entro");
				highScoreInt=dao.getResults()[0].score;	
				trace("d"+highScoreInt);
			}else{
				highScoreInt=0;
			}
			 
			initializeUI();
			initializeSounds();
			
			
			
		}
		
		/*
		 * Metodo que instancia los objetos de los sonidos
		 */
		private function initializeSounds():void{

			sndA = new soundA() as Sound;
			sndB = new soundB() as Sound;
			sndC = new soundC() as Sound;
			sndD = new soundD() as Sound;
			sndX = new soundX() as Sound;
			
		}
		
		
		
		
		/*
		 * Funcion que inicializa todos los elementos de la interfaz gráfica.
		 */
		private function initializeUI():void
		{	
			//instanciamos los botones
			btn_TopLeft = new LabelButton();
			btn_TopRight = new LabelButton();
			btn_BottomLeft = new LabelButton();
			btn_BottomRight = new LabelButton();
			
			//creamos un formato para las etiquetas en la pantalla principal
			var lblFormat:TextFormat = new TextFormat();
			lblFormat.font = "BBAlpha Sans";
			lblFormat.bold = true;
			lblFormat.size = 15;
			lblFormat.color = 0x000000;
		

			//creamos las etiquetas y le aplicamos el formato creado anteriormente
			points = new Label();
			points.format = lblFormat;
			points.htmlText ="Points:0";
			points.wordWrap = true;
			points.multiline = false;
			points.width=300;
			
			lblLevel = new Label();
			lblLevel.format = lblFormat;
			lblLevel.htmlText ="Level:1";
			
			lblHighScore = new Label();
			lblHighScore.format = lblFormat;
			lblHighScore.x=stage.stageWidth/2-20;
			lblHighScore.width=300;
			lblHighScore.htmlText="HighScore:"+highScoreInt;
			
			points.x=Constants.BTNDEFACE/2;
			points.y=20;
			lblLevel.x=stage.stageWidth-(Constants.BTNDEFACE*2);
			lblLevel.y=20;
			
			//establecemos las etiquetas y posicionamos los elementos en la pantalla inicial
			btn_TopLeft.label = "";
			btn_TopLeft.x=Constants.BTNDEFACE/2; btn_TopLeft.y=Constants.BTNDEFACE; btn_TopLeft.width=(stage.stageWidth-Constants.BTNDEFACE)/2; btn_TopLeft.height=(stage.stageHeight-Constants.BTNDEFACE)/2;
			
			btn_TopRight.label = "";
			btn_TopRight.x=(stage.stageWidth+(Constants.BTNDEFACE/4))/2; btn_TopRight.y=Constants.BTNDEFACE; btn_TopRight.width=(stage.stageWidth-Constants.BTNDEFACE)/2; btn_TopRight.height=(stage.stageHeight-Constants.BTNDEFACE)/2;
			
			btn_BottomLeft.label = "";
			btn_BottomLeft.x=Constants.BTNDEFACE/2; btn_BottomLeft.y=(stage.stageHeight+Constants.BTNDEFACE)/2; btn_BottomLeft.width=(stage.stageWidth-Constants.BTNDEFACE)/2; btn_BottomLeft.height=(stage.stageHeight-Constants.BTNDEFACE)/2;
			
			btn_BottomRight.label = "";
			btn_BottomRight.x=(stage.stageWidth+(Constants.BTNDEFACE/4))/2; btn_BottomRight.y=(stage.stageHeight+Constants.BTNDEFACE)/2; btn_BottomRight.width=(stage.stageWidth-Constants.BTNDEFACE)/2; btn_BottomRight.height=(stage.stageHeight-Constants.BTNDEFACE)/2;
			
			//aqui aplicamos el formato a cada boton
			btn_TopLeft.setSkin(RedButton);
			btn_TopRight.setSkin(GreenButton);
			btn_BottomLeft.setSkin(YellowButton);
			btn_BottomRight.setSkin(BlueButton);
		
			
			
			
			//establecemos los listenes para cada boton y con el evento clic
			btn_TopLeft.addEventListener(MouseEvent.CLICK,function(evt:MouseEvent){playerMove(evt,0)},false, 0, true);
			btn_TopRight.addEventListener(MouseEvent.CLICK,function(evt:MouseEvent){playerMove(evt,1)},false, 0, true);
			btn_BottomLeft.addEventListener(MouseEvent.CLICK,function(evt:MouseEvent){playerMove(evt,2)},false, 0, true);
			btn_BottomRight.addEventListener(MouseEvent.CLICK,function(evt:MouseEvent){playerMove(evt,3)},false, 0, true);
					
			
			addChild(btn_TopLeft);	
			addChild(btn_TopRight);	
			addChild(btn_BottomLeft);	
			addChild(btn_BottomRight);	
			addChild(points);
			addChild(lblLevel);
			addChild(lblHighScore);
			
			
			/*establecemos la variable firstRound a true, esta variable representa solo la primera pasada y evita
			 * un bug que sucedia al llenar la pila
			 */
			firstRound=true;
			
			
			//Dialogo que muestra el inicio del juego.
			var myDialog:AlertDialog = new AlertDialog();
				myDialog.title = "Instructions";
				myDialog.message = "Learn the moves, then repeat the sequence.";
				myDialog.dialogSize = DialogSize.SIZE_MEDIUM;
				myDialog.addButton("Ok");
				
				//cuando damos clic en ok el listener delescenario se ejecuta y empieza el juego
				myDialog.addEventListener(Event.SELECT, function(evt:Event){(evt.target as AlertDialog).cancel();
				
				/* anadimos un listener a nuestro escenario que se estara ejecutando
				 * y que nos permitira saber cuando es turno de la computadora o de nosotros
				 */
				stage.addEventListener(Event.ENTER_FRAME, playGame);
				
				
				},false, 0, true);
				
				myDialog.align = DialogAlign.TOP;
				myDialog.show(IowWindow.getAirWindow().group);
				
			

			
			

	
		
	
		}
	
		/*
		 * Metodo que toca un sonido en el canal de audio principal del device
		 * 
		 * @param tipo Entero que representa el sonido,0 el caso de IzqSup, 1 dereSup, 2 IzqInf ,3 DereInf, -1 Error
		 */
		private function playSound(tipo:int):void{
			try{
				switch(tipo){
					case 0:
					soundChannel = sndA.play();
					break;
					case 1:
					soundChannel = sndB.play();
					break;
					case 2:
					soundChannel = sndC.play();
					break;
					case 3:
					soundChannel = sndD.play();
					break;
					case -1:
					soundChannel = sndX.play();
					break;
				}
			}catch(ex:Error){
				trace(ex.getStackTrace());
			}
				
				
		}
		
		/*
		 * Funcion principal del juego, se ejecuta por medio de listeners
		 * 
		 * @param e evento que la mando a llamar.
		 */
		private function playGame(e:Event):void {
			try{
					//si es 0 significa que no es nuestro turno
					if(0==playing){
						
						//esta codigo sube el nivel cada multiplo de 5 vueltas.
						if(0==(queueTwo.l%5) && queueTwo.l>0){
							level++;
							lblLevel.htmlText="Level:"+level;
						}
						
						//como no estamos jugando desactivamos los botones
						btn_TopLeft.enabled=false;
						btn_TopRight.enabled=false;
						btn_BottomLeft.enabled=false;
						btn_BottomRight.enabled=false;
						
						/*creamos los dos timers que nos permitiran controlar la velocidad de los botones(espacio entre
						 * cada movimiento de la computadora)
						 */
						myTimer = new Timer(Constants.TIMER/level,1);
						myTimerB = new Timer(Constants.TIMER/level,1);
						
						
						//anadimos los listeners a los timers y removemos el del escenario ya que nosotros controlamos la accion
						myTimer.addEventListener(TimerEvent.TIMER,computerMoveB);
						myTimerB.addEventListener(TimerEvent.TIMER,computerMove);						
						stage.removeEventListener(Event.ENTER_FRAME, playGame);
						
						/*
						 * Verifica si la pila acumulada esta vacia, y genera aleatoriamente EL PRIMER MOVIMIENTO
						 */
						if(queueTwo.empty){
							numeroAleatorio = Math.floor(Math.random() * ( Constants.MAX - Constants.MIN + 1) ) + Constants.MIN;
							toggleButton(numeroAleatorio);
							queueTwo.write(numeroAleatorio);
							playSound(numeroAleatorio);	
						}
						
						//arrancamos el timer que mantendra prendido los botones
						myTimer.start();		
							
						
							
							
				}else if(1==playing){
					
					//es el turno del humano por lo que quitamos el listener del stage
					stage.removeEventListener(Event.ENTER_FRAME, playGame);
					
					//como juega un humano habilitamos los botones
					btn_TopLeft.enabled=true;
						btn_TopRight.enabled=true;
						btn_BottomLeft.enabled=true;
						btn_BottomRight.enabled=true;
						btn_TopLeft.selected=false;
						btn_TopRight.selected=false;
						btn_BottomLeft.selected=false;
						btn_BottomRight.selected=false;
						
						
						
					
				}else{
					//el ultimo caso es cuando perdemos
					stage.removeEventListener(Event.ENTER_FRAME, playGame);
				}
			}catch(ex:Error){
				trace(ex.getStackTrace());
			}
			
		}
		
		/*
		 * Funcion principal de myTimerB que se encarga de mantener prendidos los botones cierto tiempo
		 * 
		 * @e evento que mando a llamar a la funcion
		 */
		private function computerMove(e:Event){
				
				/*
				 * la computadora termino de reproducir todos los movimientos, entonces ponemos todo listo para
				 * verificar los movimientos humanos
				 */
				if(queueOne.empty){
					
					//turno del humano
					 playing=1;
					 
					 //creamos una nueva lista para verificar los movimientos humanos contra los acumulados en queueTwo
					 queueOne=queueTwo.clone();
					 
					 //anadimos el listener para que se ejecute todos los preparativos para que juegue el humano
					 stage.addEventListener(Event.ENTER_FRAME, playGame);
					 
					 //detenemos cualquier cosa que este sonando
					 soundChannel.stop();
					 
				}else{
					//leemos el elemento y la pila 1 y lo prendemos 
					var tempo:int = queueOne.read();
					toggleButton(tempo);
					
					//corremos el timer 1 que mantiene prendido el boton y cuando se ejecuta este timer lo apaga.
					myTimer.start();
				}
			
		}
		
		/*
		 * Funcion principal de myTimer
		 * 
		 * @param e evento que mando a llamar la funcion
		 */
		private function computerMoveB(e:Event){
			
				//es la primera vuelta del juego?
				if(1==queueTwo.l && firstRound){
					//la siguiente ya no lo sera la primera
					firstRound=false;
					
					//arrancamos el timer que prendera el boton.
					myTimerB.start();
					return;
				}
					
				//la computadora termino de reproducir la secuencia completa y ahora anade un elemento a la pila	
				if(queueOne.empty){	
							numeroAleatorio = Math.floor(Math.random() * ( Constants.MAX - Constants.MIN + 1) ) + Constants.MIN;
							toggleButton(numeroAleatorio);
							queueTwo.write(numeroAleatorio);
							playSound(numeroAleatorio);
							
							//terminando de calcular el nuevo movimiento es turno del usuario por lo que cuando se complete el timer establecemos todo con una queueOne vacia.		
							myTimerB.start();	
								
							
							
							
			}else{
				//la computadora no ha terminado de reproducir los movimientos por lo que prendemos el boton
						toggleButton(queueOne.spy());
						playSound(queueOne.spy());	
						
						//lo mantemos prendido y lo apagamos con timer B
						myTimerB.start();
						
						
					
			}
				
		}
		
		/*
		 * Metodo que se encarga principalmente de verificar los movimientos del usuario
		 * 
		 * @param e :evento que desencadena la funcion
		 * @param int: index que representa que boton movio empezando del 1 clockwise
		 */
		private function playerMove(e:Event,index:int):void {
							
			
			//el usuario presiono el mismo boton que esta en la pila?					
			 if(index==queueOne.read()){		
			 		//reproduce el sonido acorde al boton
					playSound(index);
					//incrementa el puntaje
					pointsInt+=(level*30);
						points.text="Points:"+pointsInt;
						
					//el usuario termino los movimientos correctamente?	
					if(queueOne.empty){
						
						//turno de la computadora
						playing=0;
						//clonamos el queque Acumlado (queueTwo)
						queueOne=queueTwo.clone();	
						
						stage.addEventListener(Event.ENTER_FRAME, playGame);
					}
					
			}else{
				//el usuario se equivoco, reproduce un error
				playSound(-1);
				
				//se acabo el juego
				playing=-1;
				var myDialog:AlertDialog = new AlertDialog();
				myDialog.title = "GAME OVER";
				myDialog.message = "Total moves:"+queueTwo.l+"\nYour Score:"+pointsInt+"\nYour level:"+level+"\nPlay Again?";
				myDialog.dialogSize = DialogSize.SIZE_MEDIUM;
				myDialog.addButton("Yes");
				myDialog.addButton("No");
				if(pointsInt>highScoreInt){
					dao.emptyTable();
					dao.insertRecord("aaa",pointsInt);
				}
				
				myDialog.addEventListener(Event.SELECT, function(evt:Event){
						var pressed:int = (evt.target as AlertDialog).selectedIndex;
						
						//si quiero volver a jugar
						if(0==pressed){
							
							//turno de la computadora	
							btn_TopLeft.enabled=false;
							btn_TopRight.enabled=false;
							btn_BottomLeft.enabled=false;
							btn_BottomRight.enabled=false;
							
							//establecemos un tiempo entre los juegos para que el usuario se acomode de nuevo
							interGameTimer.addEventListener(TimerEvent.TIMER,function(evt:Event){
								
									
								//reiniciamos todos los parametros		
								pointsInt=0;
								queueOne=new Queue();
								queueTwo=new Queue();
								stage.addEventListener(Event.ENTER_FRAME, playGame);
								firstRound=true;
								trace(dao.getResults()[0].score);
								highScoreInt=dao.getResults()[0].score;
								playing=0;
								points.text="Points:"+pointsInt;
								level=1;
								soundChannel.stop();
								lblHighScore.htmlText="HighScore:"+highScoreInt;
								lblLevel.htmlText="Level:"+level;
									//(evt.target as AlertDialog).cancel();
										},false, 0, true);
							
									interGameTimer.start();
							
							
						}else{
							//no quiero volver a jugar, cierro la ventana
							stage.nativeWindow.close();
						}
						
						
					},false, 0, true);
				
				myDialog.align = DialogAlign.TOP;
				myDialog.show(IowWindow.getAirWindow().group);
				
			}
		}
		
		/*
		 * Funcion que se encarga de prender y apagar un boton en base a un indice a partir del 1 clockwise
		 * 
		 * @param index : entero que representa que boton se oprimio
		 */
		private function toggleButton( index:int ):void {
		
			switch(index){
					case 0:
					 btn_TopLeft.selected = btn_TopLeft.selected ? false : true;
					 break;
					case 1:
					 btn_TopRight.selected = btn_TopRight.selected ? false : true;
					 break;
					case 2:
					 btn_BottomLeft.selected = btn_BottomLeft.selected ? false : true;
					 break;
					case 3:
					 btn_BottomRight.selected = btn_BottomRight.selected ? false : true;
					 break;
					
			}

			
			
		}
		
		
		
		}
		
	}


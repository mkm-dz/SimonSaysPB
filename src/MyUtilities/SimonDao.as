package MyUtilities 
{
	
	import flash.filesystem.File;
	import flash.data.*;
	
	public class SimonDao {
		
		private var myDB:File;
		private var sqlConn:SQLConnection;
		private var sqlStatement:SQLStatement;
			
		public function SimonDao() {
			//inicializamos la conexion a la base de datos que guardara los records.
			myDB= File.applicationStorageDirectory.resolvePath("SimonSaysUltra.db");
			sqlConn = new SQLConnection();
			sqlStatement = new SQLStatement();
			
			
		}
		
		public function getResults():Array{
			sqlConn.open(myDB);
			sqlStatement.sqlConnection = sqlConn;
			sqlStatement.text = "SELECT * FROM high_records ";
			sqlStatement.execute();
			var result:Array = sqlStatement.getResult().data;
			 sqlConn.close();
			 return result;
			
		}
		
		public function countResults( max:int):int{
			sqlConn.open(myDB);
			
			sqlStatement.sqlConnection = sqlConn;
			sqlStatement.text = "CREATE TABLE IF NOT EXISTS high_records(uid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, username CHAR(100) , score INTEGER )";
			sqlStatement.execute();
			
			
			
			sqlStatement.text = "SELECT COUNT(score) AS conteo FROM high_records LIMIT "+max;
			sqlStatement.execute();
			var result:Array = sqlStatement.getResult().data;
			 sqlConn.close();
			return parseInt(result[0].conteo);
				
			
		}
		
		public function emptyTable():void{
			
			sqlConn.open(myDB);
			sqlStatement.sqlConnection = sqlConn;
			sqlStatement.text = "DELETE FROM high_records";
			sqlStatement.execute();
			sqlConn.close();
		}
		
		public function insertRecord( record:String,  score:int):void{
			sqlConn.open(myDB);
			trace(score);
			sqlStatement.text = "INSERT INTO high_records(uid,username,score) VALUES(0,'"+record+"',"+score+")";
			sqlStatement.execute();
			sqlConn.close();
		}
	}

}
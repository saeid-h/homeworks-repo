
import java.sql.*;


public class GroupProject3 {
	public static void main(String[] args) {
		try { 
			Class.forName("oracle.jdbc.OracleDriver"); 
		} 
		catch(Exception x){ 
			System.out.println("Unable to load the driver class!"); 
		}
		
		try{ 
			Connection dbConnection = DriverManager.getConnection 
					("jdbc:oracle:thin:@//oracle.cs.ou.edu:1521/pdborcl.cs.ou.edu", 
							"hoss5825","GLnn0Em9"); 
			Statement stmt = dbConnection.createStatement();
			// System.out.println("OK");
			
			boolean myFlag = true;
			while(myFlag){
				System.out.println("Please select one of the following options(1-4):");
				System.out.println("1. Insert a new record with ID, name, and age of a performer.");
				System.out.println("2. Insert a new record with ID, name, age of a performer and Director's ID.");
				System.out.println("3. Display the complete information of all performers.");
				System.out.println("4. Quit (exit program):");
				myFlag = !myFlag;
			}
			
			
			dbConnection.close();
		} 
		catch(SQLException x ){ 
			System.out.println("Couldn’t get connection!"); 
		}
	}

}
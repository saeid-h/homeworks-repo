// This java application is provided for the group project #3 in DBS course.
// It shows a menu with 4 options. Two options ask for information to insert into a database.
// Third option shows all the available records. Forth option is exit program.


// imports required library
import java.sql.*;
import java.util.Scanner;


// The main class
public class GrPrj3 {
	
	// A method to establish a connection to our database containing user information
	public static Connection dbConnect(){
		try { 
			// loads JDBC driver
			Class.forName("oracle.jdbc.OracleDriver"); 
		} 
		catch(Exception x){ 
			System.out.println("Unable to load the driver class!"); 
		}
		
		Connection dbConnection = null;
		
		try { 
			// Login information to connect
			dbConnection = DriverManager.getConnection 
					("jdbc:oracle:thin:@//oracle.cs.ou.edu:1521/pdborcl.cs.ou.edu", 
							"hoss5825","GLnn0Em9"); 
			}
		
		catch(SQLException x ){ 
			System.out.println("Couldn't get connection!"); 
		}
		// return the connection
		return dbConnection;
	}
	
	
	// This method take information from the user, then call a PL/SQL to insert data into the database.
	public void option1 (){
		Connection dbConnection = dbConnect();  			// Establish the connection          
		Scanner scanFeilds = new Scanner(System.in);		// Open a new scanner to take information fron user
		
		try {
            // Reads data from console. User must provides the input.
            System.out.print("\nEnter the performer's ID: ");
            int pid = scanFeilds.nextInt();
            System.out.print("Enter the performer's name: ");
            String pname = scanFeilds.next();
            System.out.print("Enter the performer's age: ");
            int age = scanFeilds.nextInt();
            
            // Call the PL/SQL procedure stored in the database.
            CallableStatement oracleProcedure = dbConnection.prepareCall("call INSERT_OPTION_1(?,?,?)");
            
            // Setting the input parameters for called PL/SQL procedure.
            oracleProcedure.setInt(1, pid); 
            oracleProcedure.setString(2, pname);
            oracleProcedure.setInt(3, age);

            // Executing the PL/SQL procedure.
            oracleProcedure.execute(); 
            
            // Shows that the operation was done.
            System.out.println("The performer record added to the database."); 
    		dbConnection.close();							// Disconnected from the database
		}
		catch (Exception e) {
			System.out.println(e.getMessage());				// Shows exception message. 
		}
	}
	
	
	// This method take information from the user, then call a PL/SQL to insert data into the database.
	public void option2 (){
		Connection dbConnection = dbConnect();  			// Establish the connection          
		Scanner scanFeilds = new Scanner(System.in);		// Open a new scanner to take information fron user
		
		try {
            // Reads data from console. User must provides the input.
            System.out.print("\nEnter the performer's ID: ");
            int pid = scanFeilds.nextInt();
            System.out.print("Enter the performer's name: ");
            String pname = scanFeilds.next();
            System.out.print("Enter the performer's age: ");
            int age = scanFeilds.nextInt();
            System.out.print("Enter the director's ID: ");
            int did = scanFeilds.nextInt();
            
            // Call the PL/SQL procedure stored in the database.
            CallableStatement oracleProcedure = dbConnection.prepareCall("call INSERT_OPTION_2(?,?,?,?)");
            
            // Setting the input parameters for called PL/SQL procedure.
            oracleProcedure.setInt(1, pid); 
            oracleProcedure.setString(2, pname);
            oracleProcedure.setInt(3, age);
            oracleProcedure.setInt(4, did);

            // Executing the PL/SQL procedure.
            oracleProcedure.execute(); 
            
            // Shows that the operation was done.
            System.out.println("The performer record added to the database."); 
    		dbConnection.close();							// Disconnected from the database
		}
		catch (Exception e) {
			System.out.println(e.getMessage());				// Shows exception message. 
		}
	}
	
	
	// This method shows the whole table.
	public void option3 (){
		Connection dbConnection = dbConnect();  			// Establish the connection          
		
		try {
			Statement stmt = dbConnection.createStatement();					// Makes a SQL statement.
			ResultSet result = stmt.executeQuery("select * from Performer");	// Sends a SQL query.
            System.out.println("\n\nPID\tPNAME\tEXPERIENCE\tAGE");				// Prints table headers.
            System.out.println("----------------------------------------");		// Prints a divider line.
            while(result.next()) 												// Prints the retrieved data.
                System.out.print(result.getInt(1)+"\t"+result.getString(2)+"\t\t"+result.getInt(3)+"\t"+result.getInt(4)+"\n"); 
            System.out.println("----------------------------------------\n");	// Prints a divider line.
		}
		catch (Exception e) {
			System.out.println(e.getMessage());				// Shows exception message. 
		}
	}
	
	
	public static void main(String[] args) {
		
		GrPrj3 query = new GrPrj3();						// Creates an object in same class.
			
			boolean myFlag = true;							// Sets flag if we still need to run the program.
			Scanner scanOption = new Scanner(System.in);	// Open a new scanner to read data.
			int option;										// Variable declaration for options.
			while(myFlag){
				// Prints the menu.
				System.out.println("\nPlease select one of the following options(1-4):");
				System.out.println("1. Insert a new record with ID, name, and age of a performer.");
				System.out.println("2. Insert a new record with ID, name, age of a performer and Director's ID.");
				System.out.println("3. Display the complete information of all performers.");
				System.out.println("4. Quit (exit program)");
				
				// Prompts for input option and reads it.
				System.out.print("Enter your option (1-4): ");
				option =  scanOption.nextInt();
	            
	            switch (option){
	            case 1:
	            	query.option1();						// Runs option 1 method.
	            	break;
	            case 2:
	            	query.option2();						// Runs option 2 method.
	            	break;
	            case 3:
	            	query.option3();						// Runs option 3 method.
	            	break;
	            case 4:
	            	System.out.println("\nProgram is terminated due to your command. Thank you for using the application.");
					myFlag = !myFlag;						// Set flag to exit the program.
	            	break;
				default:									// Options other than offered by menu. Prints a message and back to menu.
					System.out.print("\nPlease choose a number between 1 and 4.");
					break;
	            }
			}
            scanOption.close();	            
	}

}
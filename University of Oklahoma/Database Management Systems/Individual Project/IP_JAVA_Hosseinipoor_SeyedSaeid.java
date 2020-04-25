
	// This java application is provided for the individual project in DBMS course.
	// It shows a menu with 4 options. Two options ask for information to insert into a database.
	// Third option shows all the available records. Forth option is exit program.
	
	// @author Saeid Hosseinipoor <saied@ou.edu>

	// imports required library
	import java.sql.*;
	import java.util.*;
    import com.opencsv.*;
    import java.io.*;


	// The main class
	public class idividualProject {
	
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
	
		
//-------------------------------------------- test ----------------------------------------------

		// This is a test method using for debugging purposes.
		public void test(Connection dbConnection){
			Scanner scanFeilds = new Scanner(System.in);	
			
			try {
	
	        System.out.print("\nThis is test ");
	        
	        
	        	        
			} catch (Exception e) {
				System.out.println("Exception here ...");
			}
		}
			
// -------------------------------------------- Option 1 ----------------------------------------------

		// Enter a new employee
		public void option1(Connection dbConnection){
			Scanner scanFeilds = new Scanner(System.in);		// Open a new scanner to take information fron user
			
			try {
				int employeeType;
				
	            System.out.println("\nChoose type of employee: ");
	            System.out.println("1. Worker");
				System.out.println("2. Quality Controller");
				System.out.println("3. Technical Staff");
				System.out.print("\nEnter your choice (1-3): ");
				employeeType = Integer.parseInt(scanFeilds.nextLine());
				
				Statement stmt = dbConnection.createStatement();
				String eName = "";

				if (employeeType <= 3 && employeeType >= 1) {
					System.out.print("Enter the employee's name: ");
		            eName = scanFeilds.nextLine();
		            System.out.print("Enter the employee's address: ");
		            String eAddress = scanFeilds.nextLine();
		            stmt.executeQuery("INSERT INTO Employee(E_NAME, Address) VALUES ('" 
		            + eName + "', '" +  eAddress + "')");
				}
				
				switch (employeeType){
	            case 1:
	            	System.out.print("Enter the worker's maximum production per day: ");
	            	int max_production = Integer.parseInt(scanFeilds.nextLine());
	            	stmt.executeQuery("INSERT INTO Worker (E_NAME, max_production) VALUES ('" 
				            + eName + "', '" +  max_production + "')");
	            	break;
	            case 2:
	            	System.out.print("Enter type of the products checked by this employee. Enter 1, 2, or 3: ");
	            	int Prod_Type = Integer.parseInt(scanFeilds.nextLine());
	            	stmt.executeQuery("INSERT INTO QC_Staff (E_NAME, Type_Check) VALUES ('" 
				            + eName + "', '" +  Prod_Type + "')");
	            	break;
	            case 3:
	            	System.out.println("Choose the education: ");
	            	System.out.println("1. BS (Default)");
					System.out.println("2. MS");
					System.out.println("3. PhD");
					System.out.print("Enter your choice (1-3): ");
					int education_code = Integer.parseInt(scanFeilds.nextLine());
					String education = "BS";
					if (education_code == 2) education = "MS";
					if (education_code == 3) education = "PhD";
	            	System.out.print("Enter technical position: ");
		            String tech_pos = scanFeilds.nextLine();

	            	stmt.executeQuery("INSERT INTO Tech_Staff (E_NAME, Education, Position) VALUES ('" 
				            + eName + "', '" +  education + "', '" +  tech_pos + "')");
	            	break;
				default:									
					System.out.print("\nError! The employee type is not available!");
					break;
	            }
	           
	            // Shows that the operation was done.
	            System.out.println("\nThe employee record added to the database."); 
			}
			catch (Exception e) {
				System.out.println(e.getMessage());				// Shows exception message. 
			}
		}
			
	
			
// -------------------------------------------- Option 2 ----------------------------------------------
			
		// Enter a new product
		public void option2 (Connection dbConnection){
			Scanner scanFeilds = new Scanner(System.in);		// Open a new scanner to take information from user
			
			try {
				
	            System.out.println("\nTo compelte entering new product, you need to have product ID, "
	            		+ "Production date, time spent to make a product, person name who produced the product, "
	            		+ "person name who controlled the quality of the product, and the person name who repaired "
	            		+ "the product if has been repaired.");
	            
	            System.out.print("Enter the product ID: ");
				long pID = Long.parseLong (scanFeilds.nextLine());
				
				System.out.print("Enter the production date in format of yyyy-mm-dd: ");
				String pDate = scanFeilds.nextLine();
				
				System.out.print("Enter the production time spent (hours): ");
				int pTime = Integer.parseInt(scanFeilds.nextLine());
				
				System.out.print("Enter the production type. Choose 1-3: ");
				int pType = Integer.parseInt(scanFeilds.nextLine());
				if (pType < 1 || pType > 3) {
					System.out.println("Product type is considered as 3.");
					pType = 3;
				}
				
				System.out.println("\nChoose size of the product: ");
	            System.out.println("1. Small");
				System.out.println("2. Medium");
				System.out.println("3. Large");
				System.out.print("\nEnter your choice (1-3): ");
				int pSizen = Integer.parseInt(scanFeilds.nextLine());
				if (pSizen < 1 || pSizen > 3) {
					System.out.println("Product size is considered as small.");
					pSizen = 1;
				}
				String pSize = "Small";
				if (pSizen == 2) {pSize = "Medium";}
				if (pSizen == 3) {pSize = "Large";}
				
				String pSoft = "";
				String pColor = "";
				double pWeight = 0.0; 
					switch (pType){
	            case 1:
	            	System.out.print("Enter the software name: ");
					pSoft = scanFeilds.nextLine();
	            	break;
	            case 2:
	            	System.out.print("Enter the color: ");
					pColor = scanFeilds.nextLine();
	            	break;
	            case 3:
	            	System.out.print("Enter the weight: ");
					pWeight = Double.parseDouble(scanFeilds.nextLine());
	            	break;
				default:									
					System.out.print("\nError!");
					break;
	            }
					
				// Ask for worker's name
				System.out.print("Enter the producer's name: ");
				String pWorker = scanFeilds.nextLine();
											
				Statement SQLstmt = dbConnection.createStatement();
				ResultSet SQLresult = SQLstmt.executeQuery("select E_Name From Worker" 
						+ " Where E_Name = '" + pWorker + "'");	
				
				if (!SQLresult.next()) {
					System.out.println("Error! The worker name is not existed in database.");								
					System.out.println("Press enter to countinue ...");
					scanFeilds.nextLine();
					Exception e = null;
					throw  e;
				}
				
				// Ask for QC staff's name
				System.out.print("Enter the quality controller's name: ");
				String pQC = scanFeilds.nextLine();
				
				SQLstmt = dbConnection.createStatement();
				SQLresult = SQLstmt.executeQuery("select E_Name From QC_Staff" 
						+ " Where E_Name = '" + pQC + "'");	
				
				if (!SQLresult.next()) {
					System.out.println("Error! The quality controller's name is not existed in database.");								
					System.out.println("Press enter to continue ...");
					scanFeilds.nextLine();
					Exception e = null;
					throw  e;
				}
				
				// Ask for technical staff's name
				System.out.print("Is the product repaired (Y/N)? ");
				String repairedAnswer = scanFeilds.nextLine();
				
				boolean repaired = false;
				String pTech = "";
				String repDate = "";
				if (repairedAnswer.equalsIgnoreCase("Y")  || repairedAnswer.equalsIgnoreCase("Yes")){
					repaired = true;
					
					System.out.print("Enter the technical staff's name: ");
					pTech = scanFeilds.nextLine();
					
					SQLstmt = dbConnection.createStatement();
					SQLresult = SQLstmt.executeQuery("select E_Name From Tech_Staff" 
							+ " Where E_Name = '" + pTech + "'");	
					
					if (!SQLresult.next()) {
						System.out.println("Error! The technical staff's name is not existed in database.");								
						System.out.println("Press enter to countinue ...");
						scanFeilds.nextLine();
						Exception e = null;
						throw  e;
					}
					
					if (pType == 1) {
						SQLstmt = dbConnection.createStatement();
						SQLresult = SQLstmt.executeQuery("Select Education from tech_staff where e_name = '" + pTech + "'");
						if (!SQLresult.next() || SQLresult.getString(1).equalsIgnoreCase("BS")){
							System.out.println("Error! The technical staff's name is not eligible to repair this product.");								
							System.out.println("Press enter to countinue ...");
							scanFeilds.nextLine();
							Exception e = null;
							throw  e;
						}
					}
					
					System.out.print("Enter the repairment date in format of yyyy-mm-dd: ");
					repDate = scanFeilds.nextLine();
				}
				
				// Inserts data to appropriate tables
				SQLstmt = dbConnection.createStatement();
				SQLstmt.executeQuery("INSERT INTO PRODUCT (PID, PRODUCTION_DATE, SPENT_TIME)" + 
						"VALUES ('" + pID + "', TO_DATE('" + pDate + "', 'YYYY-MM-DD'), '" + pTime + "')");

				SQLstmt.executeQuery("INSERT INTO PRODUCE (PID, E_NAME)" + 
						"VALUES ('" + pID + "', '" + pWorker + "')");

				SQLstmt.executeQuery("INSERT INTO QC_CHECK (PID, E_NAME) VALUES ('" + pID + 
						"', '" + pQC + "')");
				
				if (repairedAnswer.equalsIgnoreCase("Y")  || repairedAnswer.equalsIgnoreCase("Yes")){
					SQLstmt.executeQuery("INSERT INTO REPAIR (PID, E_NAME, R_DATE) VALUES ('"
						+ pID + "', '" + pTech + "', TO_DATE('" + repDate + "', 'YYYY-MM-DD'))");
				}
				
				switch (pType){
	            case 1:
	            	SQLstmt.executeQuery("INSERT INTO PRODUCT1 (PID, P_SIZE, SOFTWARE) VALUES ('"
	            			+ pID + "', '" + pSize + "', '" + pSoft + "')");
	            	break;
	            case 2:
	            	SQLstmt.executeQuery("INSERT INTO PRODUCT2 (PID, P_SIZE, COLOR) VALUES ('"
	            			+ pID + "', '" + pSize + "', '" + pColor + "')");
	            	break;
	            case 3:
	            	SQLstmt.executeQuery("INSERT INTO PRODUCT3 (PID, P_SIZE, WEIGHT) VALUES ('"
	            			+ pID + "', '" + pSize + "', '" + pWeight + "')");
	            	break;
				default:									
					System.out.print("\nError!");
					break;
	            }

	            // Shows that the operation was done.
	            System.out.println("\nThe product record was added to the database."); 
			}
			catch (Exception e) {
				System.out.println(e.getMessage());				// Shows exception message. 
			}
		}
		
			
					
// -------------------------------------------- Option 3 ----------------------------------------------
		
		// Enter new customer
		public void option3 (Connection dbConnection){
			Scanner scanFeilds = new Scanner(System.in);		// Open a new scanner to take information fron user
			
			try {
				
				Statement SQLstmt = dbConnection.createStatement();

	            System.out.print("Enter the customer's name: ");
	            String cName = scanFeilds.nextLine();
	            
	            ResultSet SQLresult = SQLstmt.executeQuery("SELECT C_NAME FROM CUSTOMER WHERE C_NAME = '" 
	            											+ cName + "'");
				boolean customerIsAvailable = false;
				String cAddress = "";
	            if (SQLresult.next()) {
	            	customerIsAvailable = true;
	            } else {
	                System.out.print("Enter the customer's address: ");
		            cAddress = scanFeilds.nextLine();
	            }

	            System.out.print("Enter the product ID: ");
				long pID = Long.parseLong (scanFeilds.nextLine());
				SQLresult = SQLstmt.executeQuery("SELECT PID FROM PRODUCT WHERE PID = '" + pID + "'");
				boolean productIsAvailable = false;
				if (SQLresult.next()) {
					productIsAvailable = true;
				} else {
					System.out.print("There is no product available with this ID.");
		            Exception e = null;
					throw  e;
				}
	            
	            if (!customerIsAvailable)
	            	SQLstmt.executeQuery("INSERT INTO CUSTOMER (C_NAME, ADDRESS) VALUES ('"
	            		+ cName + "', '" + cAddress + "')");
	            
	            SQLstmt.executeQuery("INSERT INTO PURCHASE (C_NAME, PID) VALUES ('"
	            		+ cName + "', '" + pID + "')");
	            
	            // Shows that the operation was done.
	            System.out.println("\nThe purchase was added to the database."); 
			}
			catch (Exception e) {
				System.out.println(e.getMessage());				// Shows exception message. 
			}
		}
		

					
// -------------------------------------------- Option 4 ----------------------------------------------
		
		// Create a new account
		public void option4 (Connection dbConnection){
			Scanner scanFeilds = new Scanner(System.in);		// Open a new scanner to take information fron user
			
			try {
				
				long accNo = 0;
				int pType = 0;
				Statement SQLstmt = dbConnection.createStatement();
				ResultSet SQLresult;


				System.out.print("Enter the product ID: ");
				long pID = Long.parseLong (scanFeilds.nextLine());
				SQLresult = SQLstmt.executeQuery("SELECT * FROM  PRODUCT WHERE PID = " + pID);
				if (!SQLresult.next()) {
					System.out.println("\nProduct with ID of " + pID + " is not available!");
					Exception e = null;
					throw  e;
				}
				
				SQLresult = SQLstmt.executeQuery("SELECT * FROM  PRODUCT NATURAL JOIN PRODUCT1 WHERE PID = " + pID);
				if (SQLresult.next()) {pType = 1;}
				SQLresult = SQLstmt.executeQuery("SELECT * FROM  PRODUCT NATURAL JOIN PRODUCT2 WHERE PID = " + pID);
				if (SQLresult.next()) {pType = 2;}
				SQLresult = SQLstmt.executeQuery("SELECT * FROM  PRODUCT NATURAL JOIN PRODUCT3 WHERE PID = " + pID);
				if (SQLresult.next()) {pType = 3;}
	            
	            if (pType == 0) {
	            	System.out.println("\nThe product type is not defined in database."
	            			+ "Please contact DBMS administrator.");
					Exception e = null;
					throw  e;
	            }
	            
	            SQLresult = SQLstmt.executeQuery("SELECT ACNT_NO FROM  PRODUCT" + pType + " NATURAL JOIN P"
	            		+ pType + "_ACCOUNT WHERE PID = " + pID);
	            if (SQLresult.next()) {
		            accNo = SQLresult.getLong(1);
		            System.out.println("\nAccount number " + accNo + " already exists associated with Product " + pID);
					Exception e = null;
					throw  e;
	            } 
	            
            	SQLresult = SQLstmt.executeQuery("SELECT MAX(ACNT_NO) FROM ACCOUNTS");
				if (SQLresult.next()) {accNo =  SQLresult.getInt(1) + 1;} else {accNo = 1111111;}
				System.out.print("Enter the product cost: ");
				double pCost = Double.parseDouble (scanFeilds.nextLine());
				
				SQLstmt.executeQuery("INSERT INTO ACCOUNTS (ACNT_NO, ACNT_DATE, COST) VALUES ('"
						+ accNo + "', SYSDATE-1, '" + pCost + "')");
				
				SQLstmt.executeQuery("INSERT INTO P" + pType + "_ACCOUNT (ACNT_NO, PID) VALUES ('"
						+ accNo + "', '" + pID + "')");
				
	            // Shows that the operation was done.
	            System.out.println("\nNew account number " + accNo + " has been created for product ID " + pID); 
			}
			catch (Exception e) {
				System.out.println(e.getMessage());				// Shows exception message. 
			}
		}

					
					
// -------------------------------------------- Option 5 ----------------------------------------------
					
		
		// Enter a complain
		public void option5 (Connection dbConnection){
			Scanner scanFeilds = new Scanner(System.in);		// Open a new scanner to take information fron user
			
			try {
				
				System.out.print("Enter the customer's name: ");
	            String cName = scanFeilds.nextLine();
	            
				Statement SQLstmt = dbConnection.createStatement();
				ResultSet SQLresult;

				SQLresult = SQLstmt.executeQuery ("SELECT * FROM CUSTOMER WHERE C_NAME = '" + cName + "'");
	            if (!SQLresult.next()) {
					System.out.print("The customer information is not available in database.");
		            Exception e = null;
					throw  e;
	            } 
	            
	            System.out.print("Enter the product ID: ");
				long pID = Long.parseLong (scanFeilds.nextLine());
				
				SQLresult = SQLstmt.executeQuery("SELECT * FROM PURCHASE WHERE PID = '"
						+ pID + "' AND C_NAME = '" + cName + "'");
				if (!SQLresult.next()) {
					System.out.print("This customer didn't purchase this item.");
		            Exception e = null;
					throw  e;				
				}
				
				int cmpID = 1111;
				SQLresult = SQLstmt.executeQuery("SELECT MAX(COMP_ID) FROM COMPLAINT_LIST");
				if (SQLresult.next()) {cmpID =  SQLresult.getInt(1) + 1;} 
				
				System.out.print("Enter complain description: ");
	            String cmpDescription = scanFeilds.nextLine();
	            
	            String cmpTreatment = "Money Back";
	            System.out.println("\nChoose type of treatment: ");
	            System.out.println("1. Get money back");
				System.out.println("2. Exchange for another product");
				System.out.print("\nEnter your choice (1-2): ");
				int cmpTreatNo = Integer.parseInt(scanFeilds.nextLine());
				if (cmpTreatNo == 2) {cmpTreatment = "Exchange";}
				
				SQLstmt.executeQuery("INSERT INTO COMPLAINT_LIST (COMP_ID, COMP_DATE, DESCRIPTION, TREATMENT) VALUES ("
						+ cmpID + ", SYSDATE-1, '" + cmpDescription + "', '" + cmpTreatment + "')");
				
				SQLstmt.executeQuery("INSERT INTO COMPLAINT (COMP_ID, PID) VALUES ("
						+ cmpID + ", " + pID + ")");
				
	            // Shows that the operation was done.
	            System.out.println("\nA complain has been recorded."); 
			}
			catch (Exception e) {
				System.out.println(e.getMessage());				// Shows exception message. 
			}
		}

					
// -------------------------------------------- Option 6 ----------------------------------------------


		// Enter an accident
		public void option6 (Connection dbConnection){
			Scanner scanFeilds = new Scanner(System.in);		// Open a new scanner to take information fron user
			
			try {
	            
	            Statement SQLstmt = dbConnection.createStatement();
				ResultSet SQLresult;

				System.out.print("Enter the product ID: ");
				long pID = Long.parseLong (scanFeilds.nextLine());
				
				SQLresult = SQLstmt.executeQuery ("SELECT * FROM PRODUCT WHERE PID = " + pID);
	            if (!SQLresult.next()) {
					System.out.print("There is no product available with this ID.");
		            Exception e = null;
					throw  e;
	            }
	            
	            System.out.println("\nChoose type of accident: ");
	            System.out.println("1. Repair accident");
				System.out.println("2. Production accident");
				System.out.print("\nEnter your choice (1-2): ");
				int accType = Integer.parseInt(scanFeilds.nextLine());
				if (accType != 1 && accType != 2) {
					System.out.print("Type is wrong!");
		            Exception e = null;
					throw  e;
				}
				
				System.out.print("Enter the work days lost: ");
				int accDays = Integer.parseInt (scanFeilds.nextLine());
				
				 int accID = 11111;
				SQLresult = SQLstmt.executeQuery("SELECT MAX(ACCIDENT_ID) FROM ACCIDENT_RECORD");
				if (SQLresult.next()) {accID =  SQLresult.getInt(1) + 1;} 
			
				SQLstmt.executeQuery ("INSERT INTO ACCIDENT_RECORD (ACCIDENT_ID, ACCIDENT_DATE, WORK_DAYS) VALUES ("
	            		+ accID + ", SYSDATE-1, " + accDays + ")");
				
				String eName = "";
				if(accType == 1){
		            SQLresult = SQLstmt.executeQuery ("SELECT E_NAME FROM REPAIR WHERE PID = " + pID);
		            if (!SQLresult.next()) {
						System.out.print("There is no repair record available associated with this product.");
			            Exception e = null;
						throw  e;
		            } 
		            eName = SQLresult.getString(1);
		            SQLstmt.executeQuery ("INSERT INTO ACCIDENT_REPAIR (ACCIDENT_ID, PID, T_NAME) VALUES ("
		            		+ accID + ", " + pID + ", '" + eName + "')");
				} else {
					SQLresult = SQLstmt.executeQuery ("SELECT E_NAME FROM PRODUCE WHERE PID = " + pID);
		            if (!SQLresult.next()) {
						System.out.print("There is no production record available associated with this product.");
			            Exception e = null;
						throw  e;
		            } 
		            eName = SQLresult.getString(1);
		            SQLstmt.executeQuery ("INSERT INTO ACCIDENT_PRODUCTION (ACCIDENT_ID, PID, W_NAME) VALUES ("
		            		+ accID + ", " + pID + ", '" + eName + "')");
				}
				 
	            // Shows that the operation was done.
	            System.out.println("\nThe accident record added to the database."); 
			}
			catch (Exception e) {
				System.out.println(e.getMessage());				// Shows exception message. 
			}
		}

		
// -------------------------------------------- Option 7 ----------------------------------------------


		// Retrieve production information
		public void option7 (Connection dbConnection){
			Scanner scanFeilds = new Scanner(System.in);		// Open a new scanner to take information fron user
			
			try {
				
	            Statement SQLstmt = dbConnection.createStatement();

				System.out.print("Enter the product ID: ");
				long pID = Long.parseLong (scanFeilds.nextLine());
				
				ResultSet SQLresult = SQLstmt.executeQuery ("SELECT * FROM PRODUCT WHERE PID = " + pID);
	            if (!SQLresult.next()) {
					System.out.print("There is no product available with this ID.");
		            Exception e = null;
					throw  e;
	            }
	            
	            SQLresult = SQLstmt.executeQuery ("SELECT PRODUCTION_DATE, SPENT_TIME FROM PRODUCT WHERE PID = " + pID);
	            if (SQLresult.next()) {
					System.out.println ("\nThis product is produced on " + SQLresult.getDate(1));
					System.out.println ("The spent time for this product is " + SQLresult.getInt(2));
	            }
			}
			catch (Exception e) {
				System.out.println(e.getMessage());				// Shows exception message. 
			}
		}

	

// -------------------------------------------- Option 8 ----------------------------------------------


		// Retrieve product
		public void option8 (Connection dbConnection){
			Scanner scanFeilds = new Scanner(System.in);		// Open a new scanner to take information fron user
			
			try {
	            
	            Statement SQLstmt = dbConnection.createStatement();
				ResultSet SQLresult;
				
				System.out.print("Enter the worker's name: ");
				String wName = scanFeilds.nextLine();
				
				SQLresult = SQLstmt.executeQuery ("SELECT * FROM PRODUCT NATURAL JOIN PRODUCE WHERE E_NAME = '" + wName + "'");
	            
				System.out.println ("The product's information produced by " + wName + " is:\n");
				ResultSetMetaData rsmd = SQLresult.getMetaData();
            	int columnsNumber = rsmd.getColumnCount();
            	for (int i = 1; i <= columnsNumber; i++) {
            		System.out.println (rsmd.getColumnName(i) + "\t\t");
            	}
            	System.out.println ("----------------------------------------------------------------------");
            	while (SQLresult.next()) {
            		for (int i = 1; i <= columnsNumber; i++) {
            			if (i == 2) System.out.print (SQLresult.getDate(i) + "\t\t");
            			else System.out.print (SQLresult.getString(i) + "\t\t");
            		}
	            	System.out.print ("\n");
            	}
			}
			catch (Exception e) {
				System.out.println(e.getMessage());				// Shows exception message. 
			}
		}


// -------------------------------------------- Option 9 ----------------------------------------------


		// Retrieve QC error
		public void option9 (Connection dbConnection){
			Scanner scanFeilds = new Scanner(System.in);		// Open a new scanner to take information from user
			
			try {
				
	            Statement SQLstmt = dbConnection.createStatement();
				ResultSet SQLresult;
				
				System.out.print("Enter the quality controller's name: ");
				String qcName = scanFeilds.nextLine();
				
				SQLresult = SQLstmt.executeQuery("SELECT COUNT(PID) FROM (SELECT * FROM PRODUCT NATURAL JOIN QC_CHECK WHERE E_NAME = '"
						+ qcName + "') WHERE PID IN (SELECT PID FROM COMPLAINT)");
				int mistakes = 0;
				if (SQLresult.next()) 
					mistakes = SQLresult.getInt(1);
				
				System.out.print("\n" + qcName + " made " + mistakes + " error(s)!");
			}
			catch (Exception e) {
				System.out.println(e.getMessage());				// Shows exception message. 
			}
		}


	
// -------------------------------------------- Option 10 ----------------------------------------------


		// Retrieve total cost of product 3 reported by QC
		public void option10 (Connection dbConnection){
			Scanner scanFeilds = new Scanner(System.in);		// Open a new scanner to take information fron user
			
			try {
				
	            Statement SQLstmt = dbConnection.createStatement();
				ResultSet SQLresult = SQLstmt.executeQuery("ALTER SESSION SET NLS_COMP=LINGUISTIC");
				SQLresult = SQLstmt.executeQuery("ALTER SESSION SET NLS_SORT=BINARY_CI");
				
				System.out.print("Enter the quality controller's name: ");
				String qcName = scanFeilds.nextLine();
				
				SQLresult = SQLstmt.executeQuery("SELECT SUM(COST) FROM ACCOUNTS NATURAL JOIN P3_ACCOUNT "
						+ "WHERE PID IN (SELECT PID FROM QC_REP_REQ WHERE QC_NAME = '"
						+ qcName + "')");
				double cost = 0.00;
				if (SQLresult.next())
					cost = SQLresult.getInt(1);
				System.out.println("Total cost is $" + cost);
			}
			catch (Exception e) {
				System.out.println(e.getMessage());				// Shows exception message. 
			}
		}



// -------------------------------------------- Option 11 ----------------------------------------------


		// Retrieve customers bought color products
		public void option11 (Connection dbConnection){
			Scanner scanFeilds = new Scanner(System.in);		// Open a new scanner to take information fron user
			
			try {
				
	            Statement SQLstmt = dbConnection.createStatement();
	            ResultSet SQLresult = SQLstmt.executeQuery("ALTER SESSION SET NLS_COMP=LINGUISTIC");
				SQLstmt.executeQuery("ALTER SESSION SET NLS_SORT=BINARY_CI");
				
				//System.out.print("Enter the customer's name: ");
				//String cName = scanFeilds.nextLine();
				
				System.out.print("Enter the product's color: ");
				String pColor = scanFeilds.nextLine();
				
				SQLresult = SQLstmt.executeQuery("SELECT C_NAME FROM PURCHASE NATURAL JOIN "
						+ "PRODUCT2 WHERE COLOR = '" + pColor + "'");
				
				System.out.println("\nThe following customer(s) bought " + pColor + " product(s): ");
				while (SQLresult.next()) System.out.println(SQLresult.getString(1));
				
				
			}
			catch (Exception e) {
				System.out.println(e.getMessage());				// Shows exception message. 
			}
		}



// -------------------------------------------- Option 12 ----------------------------------------------


		// Retrieve total work days due to complaints
		public void option12 (Connection dbConnection){
			Scanner scanFeilds = new Scanner(System.in);		// Open a new scanner to take information fron user
			
			try {
				
	            Statement SQLstmt = dbConnection.createStatement();
	            ResultSet SQLresult = SQLstmt.executeQuery("SELECT SUM(WORK_DAYS) FROM "
	            		+ "(ACCIDENT_REPAIR NATURAL JOIN COMP_REP_REQ) NATURAL JOIN ACCIDENT_RECORD");
				
	            int lostDays = 0;
				while (SQLresult.next()) lostDays = SQLresult.getInt(1);
				System.out.print("\nTotal days of work lost due to complaint(s) is: " + lostDays);
			}
			catch (Exception e) {
				System.out.println(e.getMessage());				// Shows exception message. 
			}
		}

// -------------------------------------------- Option13  ----------------------------------------------


		// Retrieve customers who are also workers
		public void option13 (Connection dbConnection){
			Scanner scanFeilds = new Scanner(System.in);		// Open a new scanner to take information fron user
			
			try {
				
	            Statement SQLstmt = dbConnection.createStatement();
	            ResultSet SQLresult = SQLstmt.executeQuery("ALTER SESSION SET NLS_COMP=LINGUISTIC");
				SQLstmt.executeQuery("ALTER SESSION SET NLS_SORT=BINARY_CI");
				
				SQLresult = SQLstmt.executeQuery("SELECT C_NAME FROM CUSTOMER WHERE "
						+ "C_NAME IN (SELECT E_NAME FROM WORKER)");
				
				System.out.println("The following customer(s) are also worker(s): ");
				while (SQLresult.next()) System.out.println(SQLresult.getString(1));
				
			}
			catch (Exception e) {
				System.out.println(e.getMessage());				// Shows exception message. 
			}
		}


// -------------------------------------------- Option 14 ----------------------------------------------


		// Retrieve customers who have bought their worked products
		public void option14 (Connection dbConnection){
			Scanner scanFeilds = new Scanner(System.in);		// Open a new scanner to take information fron user
			
			try {
				
	            Statement SQLstmt = dbConnection.createStatement();
	            ResultSet SQLresult = SQLstmt.executeQuery("ALTER SESSION SET NLS_COMP=LINGUISTIC");
				SQLstmt.executeQuery("ALTER SESSION SET NLS_SORT=BINARY_CI");
				
				System.out.println("\nThe following customer(s) have bought their own work(s): ");
				
				SQLresult = SQLstmt.executeQuery("SELECT C_NAME FROM PURCHASE "
						+ "NATURAL JOIN PRODUCE WHERE C_NAME = E_NAME");
				while (SQLresult.next()) System.out.println(SQLresult.getString(1));
				
				SQLresult = SQLstmt.executeQuery("SELECT C_NAME FROM PURCHASE "
						+ "NATURAL JOIN QC_CHECK WHERE C_NAME = E_NAME");
				while (SQLresult.next()) System.out.println(SQLresult.getString(1));
				
				SQLresult = SQLstmt.executeQuery("SELECT C_NAME FROM PURCHASE "
						+ "NATURAL JOIN REPAIR WHERE C_NAME = E_NAME");
				while (SQLresult.next()) System.out.println(SQLresult.getString(1));
				
			}
			catch (Exception e) {
				System.out.println(e.getMessage());				// Shows exception message. 
			}
		}


		
// -------------------------------------------- Option 15 ----------------------------------------------


		// Retrieve average cost of all products made in particular year
		public void option15 (Connection dbConnection){
			Scanner scanFeilds = new Scanner(System.in);		// Open a new scanner to take information fron user
			
			try {
				
	            Statement SQLstmt = dbConnection.createStatement();
	            ResultSet SQLresult = SQLstmt.executeQuery("ALTER SESSION SET NLS_COMP=LINGUISTIC");
				SQLstmt.executeQuery("ALTER SESSION SET NLS_SORT=BINARY_CI");
				
				System.out.print("Enter the year: ");
				int pYear = scanFeilds.nextInt();
				
				SQLresult = SQLstmt.executeQuery("SELECT AVG(COST) FROM "
						+ "(SELECT * FROM PRODUCT WHERE PRODUCTION_DATE BETWEEN "
						+ "'01-JAN-" + pYear + "' AND '31-DEC-" + pYear + "')"
						+ "NATURAL JOIN "
						+ "(SELECT * FROM P1_ACCOUNT UNION (SELECT * FROM P2_ACCOUNT UNION (SELECT * FROM P3_ACCOUNT))) "
						+ "NATURAL JOIN ACCOUNTS");
	
				double avgCost = 0.0;
				while (SQLresult.next()) avgCost = SQLresult.getDouble(1);
				System.out.println("\nThe average cost of all products maid in " 
						+ pYear + " is $%.2f" + Math.round(avgCost*100)/100);
				
			}
			catch (Exception e) {
				System.out.println(e.getMessage());				// Shows exception message. 
			}
		}


// -------------------------------------------- Option 16 ----------------------------------------------


		// Switch the position between a technical staff and a quality controller
		public void option16 (Connection dbConnection){
			Scanner scanFeilds = new Scanner(System.in);		// Open a new scanner to take information fron user
			
			try {
				
	            Statement SQLstmt = dbConnection.createStatement();
	            ResultSet SQLresult = SQLstmt.executeQuery("ALTER SESSION SET NLS_COMP=LINGUISTIC");
				SQLstmt.executeQuery("ALTER SESSION SET NLS_SORT=BINARY_CI");
				
				System.out.print("Enter the quality controller's name: ");
				String qcName = scanFeilds.nextLine();
				
				System.out.print("Enter the technical staff's name: ");
				String tsName = scanFeilds.nextLine();
				
				SQLstmt.executeQuery("INSERT INTO TECH_STAFF (E_NAME, EDUCATION, POSITION) "
						+ "VALUES((SELECT E_NAME FROM EMPLOYEE WHERE E_NAME = '" + qcName + "'), "
						+ " (SELECT EDUCATION FROM TECH_STAFF WHERE E_NAME = '" + tsName + "'), "
						+ "(SELECT POSITION FROM TECH_STAFF WHERE E_NAME = '" + tsName + "'))");
				
				SQLstmt.executeQuery("INSERT INTO QC_STAFF (E_NAME, TYPE_CHECK) "
						+ "VALUES((SELECT E_NAME FROM EMPLOYEE WHERE E_NAME = '" + tsName + "'), "
						+ " (SELECT TYPE_CHECK FROM QC_STAFF WHERE E_NAME = '" + qcName + "'))");
				
				SQLstmt.executeQuery("UPDATE REPAIR "
						+ "SET E_NAME = (SELECT E_NAME FROM EMPLOYEE WHERE E_NAME = '" + qcName + "') "
						+ "WHERE E_NAME = '" + tsName + "'");
				
				SQLstmt.executeQuery("UPDATE ACCIDENT_REPAIR "
						+ "SET T_NAME = (SELECT E_NAME FROM EMPLOYEE WHERE E_NAME = '" + qcName + "') "
						+ "WHERE T_NAME = '" + tsName + "'");
				
				SQLstmt.executeQuery("DELETE FROM TECH_STAFF "
						+ "WHERE E_NAME = (SELECT E_NAME FROM EMPLOYEE WHERE E_NAME = '" + tsName + "')");
				
				SQLstmt.executeQuery("UPDATE QC_CHECK "
						+ "SET E_NAME = (SELECT E_NAME FROM EMPLOYEE WHERE E_NAME = '" + tsName + "') "
						+ "WHERE E_NAME = '" + qcName + "'");
				
				SQLstmt.executeQuery("UPDATE QC_REP_REQ "
						+ "SET QC_NAME = (SELECT E_NAME FROM EMPLOYEE WHERE E_NAME = '" + tsName + "') "
						+ "WHERE QC_NAME = '" + qcName + "'");
				
				SQLstmt.executeQuery("DELETE FROM QC_STAFF "
						+ "WHERE E_NAME = (SELECT E_NAME FROM EMPLOYEE WHERE E_NAME = '" + qcName + "')");
				
				System.out.println("\nDatabase has been updated.");

			}
			catch (Exception e) {
				System.out.println(e.getMessage());				// Shows exception message. 
			}
		}

		
// -------------------------------------------- Option 17 ----------------------------------------------


		// Delete all the accident between given dates
		public void option17 (Connection dbConnection){
			Scanner scanFeilds = new Scanner(System.in);		// Open a new scanner to take information fron user
			
			try {
				
	            Statement SQLstmt = dbConnection.createStatement();
	            ResultSet SQLresult = SQLstmt.executeQuery("ALTER SESSION SET NLS_COMP=LINGUISTIC");
				SQLstmt.executeQuery("ALTER SESSION SET NLS_SORT=BINARY_CI");
				
				System.out.print("Enter the beginning date in format of (yyyy-mm-dd): ");
				String begDate = scanFeilds.nextLine();
				
				System.out.print("Enter the end date in format of (yyyy-mm-dd): ");
				String endDate = scanFeilds.nextLine();
				
				String tempStmt = "(SELECT ACCIDENT_ID FROM ACCIDENT_RECORD WHERE ACCIDENT_DATE BETWEEN TO_DATE('"
						+ begDate + "', 'YYYY-MM-DD') AND TO_DATE('" + endDate + "', 'YYYY-MM-DD'))";
				
				SQLstmt.executeQuery("DELETE FROM ACCIDENT_PRODUCTION WHERE ACCIDENT_ID IN " + tempStmt);
				
				SQLstmt.executeQuery("DELETE FROM ACCIDENT_REPAIR WHERE ACCIDENT_ID IN " + tempStmt);

				SQLstmt.executeQuery("DELETE FROM ACCIDENT_RECORD WHERE ACCIDENT_ID IN " + tempStmt);
				
				System.out.println("Database has been updated.");
				
			}
			catch (Exception e) {
				System.out.println(e.getMessage());				// Shows exception message. 
			}
		}


// -------------------------------------------- Option 18 ----------------------------------------------


		// Import new customers from a data file
		public void option18 (Connection dbConnection){
			Scanner scanFeilds = new Scanner(System.in);		// Open a new scanner to take information fron user
			
			try {
				
				System.out.print("Please enter input filename: ");
		        String fileName = scanFeilds.nextLine();
		        if (fileName == null) {
		        	System.out.println ("The filename set to default name 'import customers.csv'.");
		        	fileName = "import customers.csv";
		        }
		        
		        Statement SQLstmt = dbConnection.createStatement();
		        ResultSet myResultSet;
		        
		        String[] row = null;

		        CSVReader csvReader = new CSVReader(new FileReader(fileName));
		        List content = csvReader.readAll();

		        int countNew = 0;
		        int countOld = 0;
		        for (Object object : content) {
		        	row = (String[]) object;
		        	myResultSet = SQLstmt.executeQuery("SELECT C_NAME FROM CUSTOMER WHERE C_NAME = '" + row[0] + "'");
		        	if (!myResultSet.next()) {
			        	SQLstmt.executeQuery("INSERT INTO CUSTOMER (C_NAME, ADDRESS) VALUES ('"
			        			+ row[0] + "', '" + row[1] + "')");
			        	countNew++;
		        	} else {
		        		countOld++;
		        	}
		        }
		        SQLstmt.executeQuery("DELETE FROM CUSTOMER WHERE C_NAME = 'C_NAME'");
		        
		        System.out.println (countNew + " new customer(s) were added to the database. "
		        		+ countOld + " of given custemr(s) were already in the list.");
		        
		        csvReader.close();
			}
			catch (Exception e) {
				System.out.println(e.getMessage());				// Shows exception message. 
			}
		}

		
		
// -------------------------------------------- Option 19 ----------------------------------------------


		// Exports customer's information to a data file
		public void option19 (Connection dbConnection){
			Scanner scanFeilds = new Scanner(System.in);		// Open a new scanner to take information fron user
			
			try {
				
				System.out.print("Please enter output filename: ");
		        String fileName = scanFeilds.nextLine();
		        if (fileName == null) {
		        	System.out.println ("The filename set to default name 'export customers'.");
		        	fileName = "export customers.csv";
		        }
		        
		        CSVWriter writer = new CSVWriter(new FileWriter(fileName));
		        
		        Statement SQLstmt = dbConnection.createStatement();
		        ResultSet myResultSet = SQLstmt.executeQuery("SELECT * FROM CUSTOMER ORDER BY C_NAME");
		        
		        writer.writeAll(myResultSet, true);
		        writer.close();
		        
		        System.out.println("\nCustomers information imported into '" + fileName + "' file.");
				
			}
			catch (Exception e) {
				System.out.println(e.getMessage());				// Shows exception message. 
			}
		}

		
		
				
// -------------------------------------------------------- Main -----------------------------------------------				
// -------------------------------------------------------- Main -----------------------------------------------				
// -------------------------------------------------------- Main -----------------------------------------------				
				
				
		public static void main(String[] args) {
			
			idividualProject query = new idividualProject();						// Creates an object in same class.
			Connection dbConnection = query.dbConnect();  			// Establish the connection          

				boolean myFlag = true;							// Sets flag if we still need to run the program.
				Scanner scanOption = new Scanner(System.in);	// Open a new scanner to read data.
				int option;										// Variable declaration for options.
				while(myFlag){
					// Prints the menu.
					System.out.println("\n\nWelcome to the database system of Future Inc.");
					System.out.println("Please select one of the following options (1-20):\n");
					System.out.println(" 1. Enter a new employee.");
					System.out.println(" 2. Enter a new product associated with the person who made the product, repaired the product if it is repaired, or checked the product.");
					System.out.println(" 3. Enter a customer associated with some products.");
					System.out.println(" 4. Create a new account associated a product.");
					System.out.println(" 5. Enter a complain associated with a customer and product.");
					System.out.println(" 6. Enter an accident associated with appropriate employee and product.");
					System.out.println(" 7. Retrieve the date produced and time spent to produce a particular product.");
					System.out.println(" 8. Retrieve all products made by a particular worker.");
					System.out.println(" 9. Retrieve the total number of errors a particular quality control made. This is the total number of products certified by this controller and got some  complaints.");
					System.out.println("10. Retrieve the total cost of the products in the product3 category which were repaired at the request of a particular quality controller.");
					System.out.println("11. Retrieve all customers who purchased all products of a particular color.");
					System.out.println("12. Retrieve the number of work days lost due to accidents in repairing the products which got complaints.");
					System.out.println("13. Retrieve all customers who are also workers.");
					System.out.println("14. Retrieve all the customers who have purchased the products made or certified or repaired by themselves.");
					System.out.println("15. Retrieve the average cost of all products made in a particular year.");
					System.out.println("16. Switch the position between a technical staff and quality controller.");
					System.out.println("17. Delete all accidents whose dates are in some range.");
					System.out.println("18. Import: Enter new customers from a data file until the file is empty.");
					System.out.println("19. Export: Retrieve all customers (in name order) and output them into a data file instead of screen.");
					System.out.println("20. Quit (exit program).");
					
					// Prompts for input option and reads it.
					System.out.print("\nEnter your option (1-20): ");
					option =  scanOption.nextInt();
		            
		            switch (option){
		            case 1:
		            	query.option1(dbConnection);						// Runs option 1 method.
		            	break;
		            case 2:
		            	query.option2(dbConnection);						// Runs option 2 method.
		            	break;
		            case 3:
		            	query.option3(dbConnection);						// Runs option 3 method.
		            	break;
		            case 4:
		            	query.option4(dbConnection);						// Runs option 4 method.
		            	break;
		            case 5:
		            	query.option5(dbConnection);						// Runs option 5 method.
		            	break;
		            case 6:
		            	query.option6(dbConnection);						// Runs option 6 method.
		            	break;
		            case 7:
		            	query.option7(dbConnection);						// Runs option 7 method.
		            	break;
		            case 8:
		            	query.option8(dbConnection);						// Runs option 8 method.
		            	break;
		            case 9:
		            	query.option9(dbConnection);						// Runs option 9 method.
		            	break;
		            case 10:
		            	query.option10(dbConnection);						// Runs option 10 method.
		            	break;
		            case 11:
		            	query.option11(dbConnection);						// Runs option 11 method.
		            	break;
		            case 12:
		            	query.option12(dbConnection);						// Runs option 12 method.
		            	break;
		            case 13:
		            	query.option13(dbConnection);						// Runs option 13 method.
		            	break;
		            case 14:
		            	query.option14(dbConnection);						// Runs option 14 method.
		            	break;
		            case 15:
		            	query.option15(dbConnection);						// Runs option 15 method.
		            	break;
		            case 16:
		            	query.option16(dbConnection);						// Runs option 16 method.
		            	break;
		            case 17:
		            	query.option17(dbConnection);						// Runs option 17 method.
		            	break;
		            case 18:
		            	query.option18(dbConnection);						// Runs option 18 method.
		            	break;
		            case 19:
		            	query.option19(dbConnection);						// Runs option 19 method.
		            	break;
		            case 20:
		            	System.out.println("\nProgram is terminated due to your command. Thank you for using the application.");
						myFlag = !myFlag;						// Set flag to exit the program.
		            	break;
					default:									// Options other than offered by menu. Prints a message and back to menu.
						System.out.print("\nPlease choose a number between 1 and 20.");
						break;
		            }
				}
	            scanOption.close();
	            //dbConnection.close();
		}
}

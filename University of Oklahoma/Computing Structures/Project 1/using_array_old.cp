//
//  main.cpp
//  Project 1
//
//  Created by Saeid Hosseinipoor on 6/19/16.
//  Copyright © 2016 Saeid Hosseinipoor. All rights reserved.
//


#include <iostream>
#include <fstream>
#include <string>
//#include <windows.h>

using namespace std;

typedef double USD;



//--------------------- Product Class ----------------

class Product{      // The basic class of products
public:
    string ID;
    string Category;
    string Condition;
};



//-------------------- Item Class ----------------------

class Item: public Product{     // The class of items which is child of Product class
public:
    string Title;
    string Availability;
    string Color;
    USD Price;
};



//----------------- Item Set Class ------------------------

class Item_Set: public Item{        // This is class of items which makes a set of items to work with
protected:
    const static int _array_length = 1000;  // The total number of items available in class of Item_Set
public:
    Item item[_array_length];
    Item_Set();                             // Defaul constructor
    Item_Set(int max_length);
    int get_total();                        // Get the total number of items available in the set
    Item get_lowest_price();                // Finds and reports the lowest price in the set
    Item get_highest_price();               // Finds and reports the highest price in the set
    int insert(Item adding_item, int item_no); // Inserts an item into the set at the specific location
    USD get_avg_price();                    // Calculates the average price for the set
    int add(Item adding_item);              // Adds a item to the end of the rows of items in the set
    int delete_item(int item_no);           // Deletes the item at a specific position
    Item_Set get_new_items();               // Gets the items in new condition
    Item_Set get_used_items();              // Gets the items in used condition
    Item_Set get_refurbished_items();       // Gets the items in refurbished condition
private:
    int _max_length = _array_length;        // Maximum avialable of the set
    int _total_items = 0;                   // The total items avialable in the set
    int shift_right(int index, int shift);  // Shifts the items to the right from "index" position with "shift" steps
    int shift_left(int index, int shift);   // Shifts the items to the left from "index" position with "shift" steps
    USD _a_very_high_price = 1e20;          // Used to find the minimum price. This a very high price taht cannot be min price.
};


// Default constructor: set the maximum length of the array as 1000.
// The constant array length is 1000.
Item_Set::Item_Set(){
    _max_length = _array_length;
}

// This constor method take the max_legth as the maximum length for array.
// The default value for the maximum length is 1000.
// This constructor may make the array with different size instead of default size.
Item_Set::Item_Set(int max_length){
    if (max_length < _array_length)
        _max_length = max_length;
    else
        _max_length = _array_length;
}

// This method calculate the total item available in the set.
int Item_Set::get_total(){
    return _total_items;
}

// This method searches into a item set and finds the item with the least price.
Item Item_Set::get_lowest_price(){
    Item least_expensive;                           // Defines an item object
    USD min_price = _a_very_high_price;             // Initializes the minimum price
    for(int i = 0; i < get_total(); i++){           // searches on the item set to find the minimum price
        if (item[i].Price < min_price){
            least_expensive = item[i];
            min_price = least_expensive.Price;
        }
    }
    return least_expensive;                         // Returns the item with the minimum price.
}

// This method searches into a item set and finds the item with the highest price.
Item Item_Set::get_highest_price(){
    Item most_expensive;                            // Defines an item object
    int max_price = 0;                              // Initialing maximum price.
    for(int i = 0; i < get_total(); i++){           // Searches in the item set to find the maximum price
        if (item[i].Price > max_price){
            most_expensive = item[i];
            max_price = most_expensive.Price;
        }
    }
    return most_expensive;                          // Returns the item with the maximum price
}

// This method calculates the average price fot items within a set
USD Item_Set::get_avg_price(){
    USD avg_price = 0;                              // Initializes the average price
    USD total_price = 0;                            // Initializes the total price
    for(int i = 0; i < get_total() - 1; i++){       // Calculates the summation of prices of the all items in the set
        total_price += item[i].Price;
    }
    avg_price = total_price / get_total();          // Calculates the average price
    return avg_price;                               // Returns the average price
}

// This methods adds an item at the end of the items in a set of items
int Item_Set::add(Item adding_item){
    if (get_total() < _max_length){                 // Checks if any space is available in the set
        item[_total_items] = adding_item;           // Puts the item at the end of the items
        _total_items++;                             // Increases the total number of the items in the set
        return 1;                                   // Returns 1 when the opration was successful
    } else{
        return 0;                                   // Returns 0 when there was not enough space to add the item
    }
}

// This method deletes an item no "index" from an item set
int Item_Set::delete_item(int index){
    return shift_left(index, 1);                    // To delete an item it just shifts left the items
}

// This method shifts the items to the left begining from "item no" by step of "shift"
int Item_Set::shift_left(int item_no, int shift){
    if (shift > item_no)                            // checks if enough spaces are availabe to shift
        shift = item_no;                            // Changes the parameter "shift" to amount of available space
    if (item_no <= 0)
        return 0;                                   // There is no meaning for left shifiting the array from the begining
    else if (item_no <= _total_items){              // Checks if the shifting position is correct
        for (int i = item_no; i < _total_items - shift + 1; i++)
            item[i - shift] = item[i];              // Shifts the items
        _total_items -= shift;                      // Adjusts the total numbers of the items in the set
       // item[_total_items].ID = "";
        return 1;
    } else{
        return 0;
    }
}

// This method shifts the items to the right from "item no" by step of "shift"
int Item_Set::shift_right(int item_no, int shift){
    if (shift > _total_items - item_no)             // Checks if enough spaces are available to shift
        shift = _total_items - item_no;             // Changes the parameter "shift" to amount of available space
    if (_total_items + shift > 1000)                // Checks if enough spaces are available to shift
        shift = 1000 - _total_items;                // Changes the parameter "shift" to amount of available space
    if (item_no >= _total_items - 1)
        return 0;
    else if (item_no >= 1){
        for (int i = _total_items + shift -1; i > item_no; i-- ){
            item[i] = item[i - shift];              // Shifts the items
        }
        _total_items += shift;                      // Adjusts the total numbers of the items in the set
        return 1;
    } else {
        return  0;
    }
}

// This methods get the set of items which has new condition
Item_Set Item_Set::get_new_items(){
    Item_Set New_items;
    int j = 0;
    for (int i = 0; i < _total_items; i++){
        if (item[i].Condition == "new"){
            New_items.item[j++] = item[i];
        }
    }
    New_items._total_items = j;
    return New_items;
}


// This methods get the set of items which has used condition
Item_Set Item_Set::get_used_items(){
    Item_Set Used_items;
    int j = 0;
    for (int i = 0; i < _total_items; i++){
        if (item[i].Condition == "used"){
            Used_items.item[j++] = item[i];
        }
    }
    Used_items._total_items = j;
    return Used_items;
}


// This methods get the set of items which has refurbished condition
Item_Set Item_Set::get_refurbished_items(){
    Item_Set Refurbished_items;
    int j = 0;
    for (int i = 0; i < _total_items; i++){
        if (item[i].Condition == "refurbished"){
            Refurbished_items.item[j++] = item[i];
        }
    }
    Refurbished_items._total_items = j;
    return Refurbished_items;
}

//-------------------------------------------------------

// If the program is not executed from command line or doesn't have input argument
// It tries to get a valid input file name to handle
int get_file_name(string &_file_name){
    ifstream myFile(_file_name);
    string input_file;
    do{
        cout << "default file name is: \n" << _file_name << endl;
        cout << "if you want to change the target file, \n";
        cout << "enter 1 to accept the current filename (This is default option).\n";
        cout << "enter the filename.\n";
    
        cout << "enter your filename:";
        cin >> input_file;
        if (input_file == "1" || input_file == "")
            input_file = _file_name;
    
        ifstream myFile (input_file);
    
        } while (!myFile.is_open());
    return 1;
}

// ------------------------ Read items from a file -----------------------------

// This function get a valid file and reads the records and keeps them in a item set object
int read_items_from_file(string _file_name, Item_Set &_item_set){
    Item AnItem;
    string line;
    ifstream myFile(_file_name);                        // Opens the input file
    const string end_of_record = "**\r\r";              // This is end of the records


    // Always check to see if file opening succeeded
    if ( !myFile.is_open() ){
        cout << "Could not open the file!\n";
        }else {
            int field_counter = 1;
            while ( getline (myFile,line))
            {
                if (line != end_of_record){
                    line.erase( line.length() - 1, 1);
                    switch (field_counter) {
                        case 1:
                            AnItem.ID = line;
                            break;
                        
                        case 2:
                            AnItem.Category = line;
                            break;
                        
                        case 3:
                            AnItem.Condition = line;
                            break;
                        
                        case 4:
                            AnItem.Title= line;
                        break;
                        
                        case 5:
                            AnItem.Availability = line;
                            break;
                        
                        case 6:
                            AnItem.Color = line;
                            break;
                        
                        case 7:
                            AnItem.Price = stod(line);  //catch the exeption here
                            _item_set.add(AnItem);
                        break;
                        
                        default:
                            cout << "There was an unexpected field reading the item." << endl;
                            while (getline (myFile,line) && line != end_of_record) {}
                            field_counter = 0;
                            break;
                    }
                    field_counter++;
                }else {
                    if (field_counter < 8){
                        cout << "There was an error reading the item. The item ignored" << endl;
                    }else {
                        field_counter = 1;
                    }
                }
            }
        }
    return 1;
}


//---------------------- Export to CSV file ------------------------------

int export_to_csv (string _file_name, Item_Set &_set){
    ofstream myExportFile(_file_name);
    myExportFile << "ID" << ";";
    myExportFile << "Category" << ";";
    myExportFile << "Condition" << ";";
    myExportFile << "Title" << ";";
    myExportFile << "Availability" << ";";
    myExportFile << "Color" << ";";
    myExportFile << "Price" << ";" << endl;
    for (int i = 0; i < _set.get_total(); i++){
        myExportFile << _set.item[i].ID << ";";
        myExportFile << _set.item[i].Category << ";";
        myExportFile << _set.item[i].Condition << ";";
        myExportFile << _set.item[i].Title << ";";
        myExportFile << _set.item[i].Availability << ";";
        myExportFile << _set.item[i].Color << ";";
        myExportFile << _set.item[i].Price << ";" << endl;
    }
    myExportFile.close();
    return 1;
}



//-------------------------------- Main ---------------------


int main(int argc, const char *argv[]) {
    
    string file_name = "/Users/saeidhosseinipoor/Google Drive/Courses/02 OU/12 Computing Structures/02 Projects/Project 1/Project 1/InputP1.txt";
    
    ifstream myFile(file_name);
 
    if (argc == 2)
        file_name = argv[1];
    else
        get_file_name(file_name);
    
    // handle an exception here
    
    //QueryPerformanceFrequency;
    
    Item_Set My_Set;
    read_items_from_file(file_name, My_Set);
    
    cout << "Number of all the vailable products is: " << My_Set.get_total() << ".\n";
    
    Item_Set New_items;
    New_items = My_Set.get_new_items();
    cout << "Number of avilable new products is: " << New_items.get_total() << ".\n";
   
    
    Item_Set Used_items;
    Used_items = My_Set.get_used_items();
    cout << "Number of avilable used products is: " << Used_items.get_total() << ".\n";
    
    
    Item_Set Refurbished_items;
    Refurbished_items = My_Set.get_refurbished_items();
    cout << "Number of avilable refurbished products is: " << Refurbished_items.get_total() << ".\n";
    
    
    Item most_expensive_new;
    most_expensive_new = New_items.get_highest_price();
    cout << "The most expensive new item is: '" << most_expensive_new.Title << "' with price of $" << most_expensive_new.Price << "." << endl;
    
    
    Item most_expensive_used;
    most_expensive_used = Used_items.get_highest_price();
    cout << "The most expensive used item is: '" << most_expensive_used.Title << "' with price of $" << most_expensive_used.Price << "." << endl;

    
    Item most_expensive_refurbished;
    most_expensive_refurbished = Refurbished_items.get_highest_price();
    cout << "The most expensive refurbished item is: '" << most_expensive_refurbished.Title << "' with price of $" << most_expensive_refurbished.Price << "." << endl;
    
    Item least_expensive_new;
    least_expensive_new = New_items.get_lowest_price();
    cout << "The least expensive new item is: '" << least_expensive_new.Title << "' with price of $" << least_expensive_new.Price << "." << endl;
    
    
    Item least_expensive_used;
    least_expensive_used = Used_items.get_lowest_price();
    cout << "The least expensive used item is: '" << least_expensive_used.Title << "' with price of $" << least_expensive_used.Price << "." << endl;
    
    
    Item least_expensive_refurbished;
    least_expensive_refurbished = Refurbished_items.get_lowest_price();
    cout << "The least expensive refurbished item is: '" << least_expensive_refurbished.Title << "' with price of $" << least_expensive_refurbished.Price << "." << endl;
    
    cout << "The average price for all the items is: $" << My_Set.get_avg_price() << ".\n";
    
    //QueryPerformanceCounter;
    
    string myExportFileName ="/Users/saeidhosseinipoor/Google Drive/Courses/02 OU/12 Computing Structures/02 Projects/Project 1/Project 1/out1.txt";
    
    //export_to_csv (myExportFileName, My_Set);
    
    
    return 1;
}

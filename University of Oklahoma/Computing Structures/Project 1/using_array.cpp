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
#include <sys/time.h>

using namespace std;

typedef double USD;


class File_Read_Error_Execption {
public:
    int _tries = 0;
};



//----------------------------------------------- Product Class Definition Section --------------------------------------
//----------------------------------------------- Product Class Definition Section --------------------------------------
//----------------------------------------------- Product Class Definition Section --------------------------------------


class Product{      // The basic class of products
public:
    string ID;
    string Category;
    string Condition;
};




//----------------------------------------------- Item Class Definition Section -----------------------------------------
//----------------------------------------------- Item Class Definition Section -----------------------------------------
//----------------------------------------------- Item Class Definition Section -----------------------------------------


class Item: public Product{     // The class of items which is child of Product class
public:
    string Title;
    string Availability;
    string Color;
    USD Price;
    
    int get_total();                            // Gets the total number of the items
    void get_new_items(Item* _items);           // Makes a set of new items from the original set of the items
    void get_used_items(Item* _items);          // Makes a set of used items from the original set of the items
    void get_refurbished_items(Item* _items);   // Makes a set of refurbished items from the original set of the items
    Item get_highest_price();                   // Finds the highest price amoungt the item set
    Item get_lowest_price();                    // Finds the lowest price amoungt the item set
    USD get_average_price();                    // Calculates the average price for a set of items
private:
    USD _a_very_high_price = 1e20;              // Hypothetical very high price assumed for minimum price calculations

};

// --------------------------------------- Methods definitions for Item class -------------------------------------------
// --------------------------------------- Methods definitions for Item class -------------------------------------------

// Gets the total number of the items
int Item::get_total(){
    int _number_of_items = 0;
    for (int i = 0; i < 1000; i++){
        if (this[i].ID != "")                   // Counts the non-empty items
            _number_of_items++;
    }
    return _number_of_items;
}

// Makes a set of new items from the original set of the items
void Item::get_new_items(Item* _items){
    int j = 0;
    for (int i = 0; i < 1000; i++){
        if (_items[i].Condition == "new")       // Collectcs the item with new Condition
            this[j++] = _items[i];
    }
}

// Makes a set of used items from the original set of the items
void Item::get_used_items(Item* _items){
    int j = 0;
    for (int i = 0; i < 1000; i++){
        if (_items[i].Condition == "used")      // Collectcs the item with used Condition
            this[j++] = _items[i];
    }
}

// Makes a set of refurbished items from the original set of the items
void Item::get_refurbished_items(Item* _items){
    int j = 0;
    for (int i = 0; i < 1000; i++){
        if (_items[i].Condition == "refurbished")   // Collectcs the item with refurbished Condition
            this[j++] = _items[i];
    }
}

// This method searches into a item set and finds the item with the least price.
Item Item::get_lowest_price(){
    Item least_expensive;                           // Defines an item object
    USD min_price = _a_very_high_price;             // Initializes the minimum price
    for(int i = 0; i < get_total(); i++){           // searches on the item set to find the minimum price
        if (this[i].Price < min_price){
            least_expensive = this[i];
            min_price = least_expensive.Price;
        }
    }
    return least_expensive;                         // Returns the item with the minimum price.
}

// This method searches into a item set and finds the item with the highest price.
Item Item::get_highest_price(){
    Item most_expensive;                            // Defines an item object
    int max_price = 0;                              // Initialing maximum price.
    for(int i = 0; i < get_total(); i++){           // Searches in the item set to find the maximum price
        if (this[i].Price > max_price){
            most_expensive = this[i];
            max_price = most_expensive.Price;
        }
    }
    return most_expensive;                          // Returns the item with the maximum price
}

// This method calculates the average price fot items within a set
USD Item::get_average_price(){
    USD avg_price = 0;                              // Initializes the average price
    USD total_price = 0;                            // Initializes the total price
    for(int i = 0; i < this->get_total() - 1; i++){ // Calculates the summation of prices of the all items in the set
        total_price += this[i].Price;
    }
    avg_price = total_price / this->get_total();    // Calculates the average price
    return avg_price;                               // Returns the average price
}



//--------------------------------------------- The Modules Section --------------------------------------------------
//--------------------------------------------- The Modules Section --------------------------------------------------
//--------------------------------------------- The Modules Section --------------------------------------------------


// ------------------------------------------ Get a filename to read data --------------------------------------------

// If the program is not executed from command line or doesn't have input argument
// It tries to get a valid input file name to handle
int get_file_name(string &_file_name){
    
    string input_file;

    cout << "default file name is: '" << _file_name << "'\n";
    cout << "if you want to change the target file, \n";
    cout << "enter 1 to accept the current filename (This is default option).\n";
    cout << "enter a filename.\n\n";
    
    cout << "enter your input:";
    cin >> input_file;                                  // Reads the filename
    if (input_file != "1" && input_file != "")
        _file_name = input_file;
    
    return 1;
}



// ------------------------------------------- Read items from a file -----------------------------------------------

// This function get a valid file and reads the records and keeps them in a item set object
int read_items_from_file(string _file_name, Item* _item_set){
    Item* AnItem = new Item();
    string line;
    ifstream myFile(_file_name);                        // Opens the input file
    const string end_of_record = "**\r\r";              // This is end of the records
    
    
    // Always check to see if file opening succeeded
    if ( !myFile.is_open() ){
        cout << "Could not open the file!\n";
    }else {
        int field_counter = 1;
        int item_counter = 0;
        while ( getline (myFile,line))
        {
            if (line != end_of_record){
                line.erase( line.length() - 1, 1);
                switch (field_counter) {                // Put the read data into proper field of the object
                    case 1:
                        (*AnItem).ID = line;
                        break;
                        
                    case 2:
                        (*AnItem).Category = line;
                        break;
                        
                    case 3:
                        (*AnItem).Condition = line;
                        break;
                        
                    case 4:
                        (*AnItem).Title= line;
                        break;
                        
                    case 5:
                        (*AnItem).Availability = line;
                        break;
                        
                    case 6:
                        (*AnItem).Color = line;
                        break;
                        
                    case 7:
                        (*AnItem).Price = stod(line);  //catch the exeption here
                        _item_set[item_counter++] = *AnItem;
                        break;
                        
                    default:
                        cout << "There was an unexpected field reading the item." << endl;
                        while (getline (myFile,line) && line != end_of_record) {} // pass the invalid fields
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
    myFile.close();
    return 1;
}


//-------------------------------------------------------- Main ---------------------------------------------------------
//-------------------------------------------------------- Main ---------------------------------------------------------
//-------------------------------------------------------- Main ---------------------------------------------------------


int main(int argc, const char *argv[]) {
    
    string file_name = "/Users/saeidhosseinipoor/Google Drive/Courses/02 OU/12 Computing Structures/02 Projects/Project 1/Project 1/InputP1.txt";
    
    if (argc == 2)
        file_name = argv[1];
    else
        get_file_name(file_name);
    
    struct timeval time;
    gettimeofday(&time, NULL);
    long start_time = ((unsigned long long ) time.tv_sec * CLOCKS_PER_SEC) + time.tv_usec;

    
    try {
        ifstream myFile(file_name);
        if (!myFile.is_open()) throw File_Read_Error_Execption();
        
        Item* MyItems = new Item [1000]; //MyItems in pointing to an array of Item pointers
        read_items_from_file(file_name, MyItems);
    
        cout << "Number of all the avilable products is: " << MyItems->get_total() << ".\n";
    
        Item* New_items = new Item[1000];
        New_items->get_new_items(MyItems);
        cout << "Number of avilable new products is: " << New_items->get_total() << ".\n";
   
    
        Item* Used_items = new Item[1000];
        Used_items -> get_used_items(MyItems);
        cout << "Number of avilable used products is: " << Used_items->get_total() << ".\n";
    
    
        Item* Refurbished_items = new Item[1000];
        Refurbished_items -> get_refurbished_items(MyItems);
        cout << "Number of avilable refurbished products is: " << Refurbished_items->get_total() << ".\n";
    
    
        Item most_expensive_new;
        most_expensive_new = New_items->get_highest_price();
        cout << "The most expensive new item is: '" << most_expensive_new.Title << "' with price of $" << most_expensive_new.Price << "." << endl;
    
    
        Item most_expensive_used;
        most_expensive_used = Used_items->get_highest_price();
        cout << "The most expensive used item is: '" << most_expensive_used.Title << "' with price of $" << most_expensive_used.Price << "." << endl;

    
        Item most_expensive_refurbished;
        most_expensive_refurbished = Refurbished_items->get_highest_price();
        cout << "The most expensive refurbished item is: '" << most_expensive_refurbished.Title << "' with price of $" << most_expensive_refurbished.Price << "." << endl;
    
        Item least_expensive_new;
        least_expensive_new = New_items->get_lowest_price();
        cout << "The least expensive new item is: '" << least_expensive_new.Title << "' with price of $" << least_expensive_new.Price << "." << endl;
    
    
        Item least_expensive_used;
        least_expensive_used = Used_items->get_lowest_price();
        cout << "The least expensive used item is: '" << least_expensive_used.Title << "' with price of $" << least_expensive_used.Price << "." << endl;
    
    
        Item least_expensive_refurbished;
        least_expensive_refurbished = Refurbished_items->get_lowest_price();
        cout << "The least expensive refurbished item is: '" << least_expensive_refurbished.Title << "' with price of $" << least_expensive_refurbished.Price << "." << endl;
    
        cout << "The average price for all the items is: $" << MyItems->get_average_price() << ".\n";
        
    } catch(File_Read_Error_Execption ex){
        
        cout << "your file can not be open." << endl;
    };

    
    gettimeofday(&time, NULL);
    long end_time = (time.tv_sec * CLOCKS_PER_SEC) + time.tv_usec;
    
    cout << "The execution time for this program is: " << (end_time - start_time) / 1000 << " milli seconds." << endl;
    
    return 1;
}

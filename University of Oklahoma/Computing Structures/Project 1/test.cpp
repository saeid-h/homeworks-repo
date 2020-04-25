//
//  test.cpp
//  Project 1
//
//  Created by Saeid Hosseinipoor on 6/19/16.
//  Copyright © 2016 Saeid Hosseinipoor. All rights reserved.
//

#include "test.hpp"

int main ( int argc, char *argv[] ) {
    // reading a text file
#include <iostream>
#include <fstream>
#include <string>
    using namespace std;
    
    string line;
    if ( argc != 2 ) // argc should be 2 for correct execution
        // We print argv[0] assuming it is the program name
        cout<<"usage: "<< argv[0] <<" <filename>\n";
    else {
        // We assume argv[1] is a filename to open
        ifstream myFile ( argv[1] );
        // Always check to see if file opening succeeded
        if ( !myFile.is_open() )
            cout<<"Could not open file\n";
        else {
            while ( getline (myFile,line) )
            {
                cout << line << '\n';
            }
        }
        myFile.close();
    }
}
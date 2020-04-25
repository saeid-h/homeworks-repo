//
//  main.cpp
//  Project 3
//
//  Created by Saeid Hosseinipoor on 8/6/16.
//  Copyright © 2016 Saeid Hosseinipoor. All rights reserved.
//

#include <iostream>
#include <vector>
#include "HashingTable.h"

using namespace std;


int main() /* A sample main program */
{

    HashingTable<char*>* myHashTable;
    
    char* Names[25] = {"Andy B", "Amy Dean", "Antonio G", "Andy Roberts", "Brian W","Bob Macy", "Brent James", "Buck Muck", "Cannon James", "Cart Wright", "Catherine Zeta", "Carl Lewis", "David Johnson", "Dowd Peter", "Daniel Fauchier", "Dawn Smith", "Yarda Varda", "Yami Jacob", "Yester Louis", "Yukon Oklahoma", "Zandi Rich", "Zea John", "Zelby Leon", "Ziert Paul", "Zanola Helen"};
    
    int i;
    myHashTable = new HashingTable<char*>(26);
    for (i=0; i < 25; i++)
        (*myHashTable).insert(Names[i]);
    
    cout << "\n\nPrinting the hash table after inserting....\n" << endl;
    cout << myHashTable << endl;
    
    
    HashingTable<char*>* myHashTablecopy;
    myHashTablecopy = new HashingTable<char*>;
    *myHashTablecopy = *myHashTable;
    cout << "\n\nPrinting the copied hash table by '=' operator....\n" << endl;
    cout << myHashTablecopy << endl;
    
    
    
    if ((*myHashTable).find("Zandi Rich"))
        cout << "Zandi Rich is in the list" << endl;
    else
        cout << "Zandi Rich is not in the list" << endl;
    
    (*myHashTable).remove("Zea John");
    if ((*myHashTable).find("Zea John"))
        cout << "Zea John is in the list" << endl;
        else
            cout << "Zea John is not in the list" << endl;
    
    for (i=0; i < 26; i++) (*myHashTable).split(i,2);
    cout << "\n\nPrinting the hash table after splitting....\n" << endl;
    cout << myHashTable << endl;
    
    
    if ((*myHashTable).find("Ziert Paul"))
        cout << "Ziert Paul is in the list" << endl;
        else
            cout << "Ziert Paul is not in the list" << endl;
            
            (*myHashTable).insert("Zea John");
    if ((*myHashTable).find("Zea John"))
        cout << "Zea John is in the list" << endl;
        else
            cout << "Zea John is not in the list" << endl;
    
    delete myHashTable;
    
    return 0;

}
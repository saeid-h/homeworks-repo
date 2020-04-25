//
//  AbstractHashTable.h
//  Project 3
//
//  Created by Saeid Hosseinipoor on 8/6/16.
//  Copyright © 2016 Saeid Hosseinipoor. All rights reserved.
//

#ifndef AbstractHashTable_h
#define AbstractHashTable_h

#include "Exception.h"

using namespace std;

class HashTableException : public Exception { };
class HashTableBounds : public HashTableException { };
class HashTableElementNotFound:public HashTableException { };
class HashTableMemory : public HashTableException { };



template <class DataType>
class AbstractHashTable /* AbstractHashTable_h */
{
public:
    void create ();      // creates an empty hash table
    bool isEmpty ();      // returns true if there are no elements in the hash table, otherwise false
    int size ();         // returns the number of items stored in the table
    int capacity ();   // returns the maximum number of items that can be stored on the hash table
    void insert (const DataType& item);   // inserts a new item into the hash table
    void remove (DataType item);   // removes the item from the hash table
    DataType find (const DataType& item);     // returns the items if found on the hash table, otherwise returns NULL
    DataType hash (DataType item);     // computes the hash value for the item based on the hash function and returns an integer that is the index position in the hash table
    
    bool collision (int Pos);
};

#endif

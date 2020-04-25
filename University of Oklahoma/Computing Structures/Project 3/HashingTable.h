//
//  HashingTable.h
//  Project 3
//
//  Created by Saeid Hosseinipoor on 8/6/16.
//  Copyright © 2016 Saeid Hosseinipoor. All rights reserved.
//

#ifndef HashingTable_h
#define HashingTable_h


#include <vector>
#include <list>
#include <iostream>

#include "AbstractHashTable.h"

using namespace std;



class MemoryException: public Exception {};



template <class DataType>
class HashingTable : public AbstractHashTable<DataType>
{
protected:
    vector<list<DataType>>* Table;

public:
    HashingTable ();
    HashingTable (int n);
    HashingTable (const HashingTable<DataType>& HT);
    virtual ~HashingTable();
    bool collision (int Pos);
    //int capacity ();
    //bool isEmpty();
    DataType find(const DataType& key);
    int size () const;
    void insert (const DataType& data);
    void remove (const DataType& key);
    void split(int i, int p);
    
    list<DataType> operator [] (int k);
    HashingTable<DataType>& operator = (HashingTable<DataType>& Table);
    //friend ostream& operator << (ostream& s, HashingTable<DataType>& Table);


private:
    int hash (const DataType& data);
    int Find(const DataType& key);
    void copy (const HashingTable<DataType>& HT);
    
};


template <class DataType>
HashingTable<DataType>:: HashingTable ()
{
    Table = NULL;
    //_size = 0;
}


template <class DataType>
HashingTable<DataType>:: HashingTable (int n)
{
    try
    {
        Table = new vector<list<DataType>>(n);
        list<DataType> a;
        for (int i = 0; i < n; i++)
            (*Table)[i] = a;
       // (*Table)[i] = NULL;

      //  _size = 0;
    }
    catch (MemoryException e)
    {
        Table = NULL;
        throw HashTableMemory();
    }
}


template <class DataType>
HashingTable<DataType>:: HashingTable (const HashingTable<DataType>& HT)
{
    copy(HT);
}


template <class DataType>
HashingTable<DataType>::~HashingTable()
{
    if( Table != NULL)
    {
        delete Table;
     //   _size = 0;
    }
}


template <class DataType>
void HashingTable<DataType>::copy (const HashingTable<DataType>& HT)
{
    int _size = HT.size();
    Table = new vector<list<DataType>>(_size);
    if (Table == NULL)
        throw HashTableMemory();
    
    Table = HT.Table;
}


template <class DataType>
bool HashingTable<DataType>::collision (int Pos)
{
    return(!(*Table)[Pos].empty());
    //return((*Table)[Pos]!=NULL);
}

/*
template <class DataType>
int HashingTable<DataType>::capacity ()
// returns the size of the hash table
{
    if (Table == NULL) return 0;
    return((*Table).size());
}
*/


template <class DataType>
int HashingTable<DataType>::size () const
//returns the number of items stored in the hash table
{
    return ((*Table).size());
}


/*
template <class DataType>
bool HashingTable<DataType>::isEmpty()
//returns true if the number of items stored in the hash table is 0,
//false otherwise
{
    return(size() == 0);
    //return(_size==0);
}
*/

template <class DataType>
DataType HashingTable<DataType>::find(const DataType& key)
//returns the item stored in location hash(key)
{
    int i ;
    i = hash(key);
	if (i < 0) return NULL;
	
    list<DataType> abc;
    bool found = false;
	
    while (!found && i < (*Table).size())
    {
        abc = (*Table)[i];
        for ( auto it = abc.begin(); it != abc.end(); ++it )
            if (*it == key)
                found = true;
        i++;
    }
    
    if (found)
        return key;
    else
        return NULL;
}


template <class DataType>
int HashingTable<DataType>::Find(const DataType& key)
//returns the item stored in location hash(key)
{
    int i ;
    i = hash(key);
	if (i < 0) return NULL;
	
    list<DataType> abc;
    bool found = false;
	
    while (!found && i < (*Table).size())
    {
        abc = (*Table)[i];
        for ( auto it = abc.begin(); it != abc.end(); ++it )
            if (*it == key)
                found = true;
        i++;
    }
    
    if (found)
        return i-1;
    else
        return -1;
}


template <class DataType>
void HashingTable<DataType>::remove(const DataType& key)
//returns the item stored in location hash(key)
{
    int i ;
    i = Find(key);
    //forward_list<DataType> abc;
    //abc = (*Table)[i];
    if (i != -1)
        (*Table)[i].remove(key);
}


template <class DataType>
void HashingTable<DataType>::insert (const DataType& data)
{
    int i ;
    i = Find(data);
	if (i != -1) return;
	
	int k;
    k = hash(data);
	
    if ((k < 0))
        throw HashTableBounds();
	
	list<DataType> a;
	a.clear();
    int _size = (*Table).size();
    if (k > _size-1)
        for (int i = 0; i < k - _size+1; i++)
            (*Table).push_back(a);
    
    if (!collision(k)) //no collisions
        (*Table)[k] = a;
    
    (*Table)[k].push_front(data);
}



template <class DataType>
void HashingTable<DataType>:: split(int i, int p)
{
    if ((*Table)[i].size() < p) return;
    
    list<DataType> a;
	a.clear();
    
    int _size = (*Table)[i].size();

    int k = 1;
    for (int j = p; j < _size; j++)
    {
        while ((*Table)[i+k].size() >= p && k+i < (*Table).size()) k++;
        if (k+i >= (*Table).size()) (*Table).push_back(a);
        (*Table)[i+k].push_front((*Table)[i].back());
        (*Table)[i].pop_back();
    }
    
}


template <class DataType>
int HashingTable<DataType>::hash (const DataType& data)
{
    return data[0] - 'A';
}




template <class DataType>
list<DataType> HashingTable<DataType>::operator [] (int k)
{
    //if ((k < 0) || (k >= capacity()))
    if ((k < 0) )
        throw HashTableBounds();
    return (*Table)[k];
}


template <class DataType>
HashingTable<DataType>& HashingTable<DataType>::operator = (HashingTable<DataType>& HT)
{
    copy (HT);
    return *this;
}



template <class DataType>
ostream& operator << (ostream& s, HashingTable<DataType>*& Table){
    
    for (int i = 0; i < (*Table).size(); i++)
    {
        list<char*> abc = ((*Table)[i]);
        int j = 0;
        if (!abc.empty()){
            s << "Table[" << i << "] = {";
           // for ( auto it = abc.begin(); it != abc.end(); ++it )
            while (!abc.empty())
            {
                if (j > 0)
                    s << ", ";
                s << "'" << abc.front() << "'";
                abc.pop_front();
                j++;
            }
            s << "}" << endl;
        };
    }
    
    return s;
}




#endif /* HashingTable_h */

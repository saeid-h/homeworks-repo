//
//  main.cpp
//  Project 3 New
//
//  Created by Saeid Hosseinipoor on 8/8/16.
//  Copyright © 2016 Saeid Hosseinipoor. All rights reserved.
//

#include <iostream>
#include <vector>
#include <list>

using namespace std;



template <class DataType>
class HashingTable : public vector<DataType>
{
protected:
    vector<list<DataType>>* Table;

public:
    HashingTable ();
    HashingTable (int n);
    HashingTable (const HashingTable<DataType>& HT);
    virtual ~HashingTable();
    bool collision (int Pos);
    DataType find(const DataType& key);
    void insert (const DataType& data);
    void remove (const DataType& key);
    void split(int i, int p);
    
    list<DataType> operator [] (int k);
    HashingTable<DataType>& operator = (HashingTable<DataType>& Table);


private:
    int hash (const DataType& data);
    int Find(const DataType& key);
    void copy (const HashingTable<DataType>& HT);
    
};


template <class DataType>
HashingTable<DataType>:: HashingTable ()
{
    Table = NULL;
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
}


template <class DataType>
int HashingTable<DataType>::size () const
{
    return ((*Table).size());
}


template <class DataType>
DataType HashingTable<DataType>::find(const DataType& key)
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
{
    int i ;
    i = Find(key);
    
    if (i != -1)
        (*Table)[i].remove(key);
}


template <class DataType>
void HashingTable<DataType>::insert (const DataType& data)
{
    int k;
    k = hash(data);
    list<DataType> a;
    if ((k < 0))
        throw HashTableBounds();
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





int main()
{
    char* Names[25] = { "Andy B", "Amy Dean", "Antonio G", "Andy Roberts",
        "Brian W","Bob Macy", "Brent James", "Buck Muck",
        "Cannon James", "Cart Wright", "Catherine Zeta", "Carl Lewis",
        "David Johnson", "Dowd Peter", "Daniel Fauchier", "Dawn Smith",
        "Yarda Varda", "Yami Jacob", "Yester Louis", "Yukon Oklahoma",
        "Zandi Rich", "Zea John", "Zelby Leon", "Ziert Paul", "Zanola Helen" };
    
    HashingTable<char*> test(26);
    for (int i=0; i < 26; i++)
        test[i] = new list<char*>();
    
    //for (int i=0; i < 25; i++)
    //cout << Names[i] << endl;
    
    for (int i=0; i < 25; i++)
    {
        int hash = Names[i][0] - 'A';
        //cout << i << " = " << hash << endl;
        (*test[hash]).push_back(Names[i]);
    }
    
    
    list<char*>::const_iterator iterator;
    
    for (int i=0; i < 26; i++) {
        if ((*test[i]).size() > 0) {
            cout << "Elements at position " << i << " of the hash table" << endl;
            for (iterator = (*test[i]).begin(); iterator != (*test[i]).end(); ++iterator) {
                cout << "****" << *iterator << endl;
            }
        }
    }
    
    
    return 0;
}

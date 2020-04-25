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



int hashing (char*& data)
{
    return data[0] - 'A';
}


bool collision (const vector<list<char*>*>& V, int Pos)
{
    return(! V[Pos]->empty());
}



char* find(const vector<list<char*>*>& V, char* key)
//returns the item stored in location hash(key)
{
    int i ;
    i = hashing(key);
	if (i < 0) return NULL;
	
    bool found = false;
	
    while (!found && i < V.size())
    {
        for ( auto it = V[i]->begin(); it != V[i]->end(); ++it )
            if (*it == key)
                found = true;
        i++;
    }
    
    if (found)
        return key;
    else
        return NULL;
}


int Find(const vector<list<char*>*>& V, char*& key)
{
    int i ;
    i = hashing(key);
	if (i < 0) return NULL;
	
    bool found = false;
	
    while (!found && i < V.size())
    {
        for ( auto it = V[i]->begin(); it != V[i]->end(); ++it )
            if (*it == key)
                found = true;
        i++;
    }
    
    if (found)
        return i-1;
    else
        return -1;
}


void remove(const vector<list<char*>*>& V, char*& key)
{
    int i ;
    i = Find(V, key);
    if (i != -1)
        V[i]->remove(key);
}


void insert (vector<list<char*>*>& V, char*& data)
{
    int k;
    k = hashing(data);
    list<char*> a;
    a.clear();
	
    if ((k < 0))
        return;
	
    int _size = V.size();
    if (k > _size-1)
        for (int i = 0; i < k - _size+1; i++)
            V.push_back(&a);
    
    if (!collision(V, k)) //no collisions
        V[k] = &a;
    
    V[k]->push_front(data);
}


void split(vector<list<char*>*>& V, int i, int p)
{
    if (V[i]->size() < p) return;
    
    list<char*> a;
    a.clear();
    
    int _size = V[i]->size();

    int k = 1;
    for (int j = p; j < _size; j++)
    {
        while (V[i+k]->size() >= p && k+i < V.size()) k++;
        if (k+i >= V.size()) V.push_back(&a);
        V[i+k]->push_front(V[i]->back());
        V[i]->pop_back();
    }
    
}





int main()
{
    char* Names[25] = { "Andy B", "Amy Dean", "Antonio G", "Andy Roberts",
        "Brian W","Bob Macy", "Brent James", "Buck Muck",
        "Cannon James", "Cart Wright", "Catherine Zeta", "Carl Lewis",
        "David Johnson", "Dowd Peter", "Daniel Fauchier", "Dawn Smith",
        "Yarda Varda", "Yami Jacob", "Yester Louis", "Yukon Oklahoma",
        "Zandi Rich", "Zea John", "Zelby Leon", "Ziert Paul", "Zanola Helen" };
    
    vector<list<char*>*> test(26);
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

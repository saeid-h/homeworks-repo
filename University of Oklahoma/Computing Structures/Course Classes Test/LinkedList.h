//
//  LinkedList.h
//  Course Classes Test
//
//  Created by Saeid Hosseinipoor on 7/29/16.
//  Copyright © 2016 Saeid Hosseinipoor. All rights reserved.
//

#ifndef LinkedList_h
#define LinkedList_h




#include "AbstractLinkedList.h"




/// ----------------------------------------------- LinkedList Class ---------------------------------------

template<class DataType>
class LinkedList //:public AbstractLinkedList<DataType>
{
protected:
    DataType* _info;
    LinkedList<DataType>* _next;
    
public:
    LinkedList();
    LinkedList(DataType& info);
    LinkedList(DataType& info,LinkedList<DataType>* next);
    void copy(const LinkedList<DataType>& ll);
    LinkedList(const LinkedList<DataType>& ll);
    
    ~LinkedList();
    
    bool isEmpty();
    DataType& info();
    int size();
    DataType& find(DataType& key);
    bool has (DataType& key);
    int indexOf (DataType& key);
    DataType& infoAt(int position);
    void add(DataType& object);
    void insertAt(DataType& newObj,int position);
    DataType remove();
    DataType removeAt(int position);
    LinkedList<DataType>* next();
    
    LinkedList<DataType>* setNext (LinkedList<DataType>* next) {};
    DataType remove (DataType& key) {};
    void display (ostream& s){};
    
    void operator=(const LinkedList<DataType>& ll);
};



template <class DataType>
LinkedList<DataType>::LinkedList ()
{
    _info = NULL;
    _next = NULL;
}


template <class DataType>
LinkedList<DataType>::LinkedList (DataType& info)
{
    _info = new DataType(info);
    if (_info == NULL) throw LinkedListMemory();
    _next = NULL;
}


template <class DataType>
LinkedList<DataType>::LinkedList(DataType&info,LinkedList<DataType>* next)
{
    _info = new DataType(info);
    if (_info == NULL) throw LinkedListMemory();
    _next = next;
}


template <class DataType>
LinkedList<DataType>::LinkedList (const LinkedList<DataType>& ll)
{
    copy (ll);
}


template <class DataType>
void LinkedList<DataType>::copy (const LinkedList<DataType>& ll)
{
    if (ll._info == NULL)
    {_info = NULL;}
    else
    {      _info = new DataType (*(ll._info));
        if (_info == NULL) throw LinkedListMemory();
    }
    if (ll._next == NULL)
    {_next = NULL;}
    else
    {
        _next = new LinkedList<DataType> (*(ll._next));
        if (_next == NULL) throw LinkedListMemory();
    }
}


template <class DataType>
LinkedList<DataType>::~LinkedList()
{
    if (_info != NULL)
    {
        delete _info;
        _info = NULL;
    }
    if (_next != NULL)
    {
        delete _next;	// this produces recursive call to destructor
        _next = NULL;
    }
}


template <class DataType>
bool LinkedList<DataType>::isEmpty ()
{
    return (_info == NULL);
}


template <class DataType>
DataType& LinkedList<DataType>::info ()
{
    if (isEmpty()) throw LinkedListBounds();
    return *_info;
}


template <class DataType>
void LinkedList<DataType>::add (DataType& object)
{
    if (_info == NULL)  { _info = new DataType(object); }
    else
    {
        LinkedList<DataType>* newList = new LinkedList<DataType>(*_info,_next);
        if (newList == NULL) throw LinkedListMemory ();
        *_info = object;
        _next = newList;
    }
}


template <class DataType>
DataType& LinkedList<DataType>::find (DataType& key)
{
    if (isEmpty()) throw LinkedListNotFound();
    if (key == *_info) { return *_info; }
    if (_next == NULL) throw LinkedListBounds();
    return _next->find (key);
}


template <class DataType>
bool LinkedList<DataType>::has (DataType& key)
{
    if (isEmpty()) return false;
    if (key == *_info) return true;
    if (_next == NULL) return false;
    return _next -> has(key);
}


template <class DataType>
int LinkedList<DataType>::indexOf (DataType& key)
{
    int pos = 0;
    if (!has(key)) throw LinkedListBounds();
    if (key == *_info) return pos;
    return _next -> indexOf(key) + 1;
}

template <class DataType>
LinkedList<DataType>* LinkedList<DataType>::next ()
{
    return _next;
}


template <class DataType>
int LinkedList<DataType>::size ()
{
    if (_next == NULL)
    {
        if (_info == NULL) return 0;
        else return 1;
    }
    else return 1 + _next->size();
}


template <class DataType>
DataType& LinkedList<DataType>::infoAt (int position)
{
    if (isEmpty()) throw LinkedListBounds();
    if (position == 0) { return *_info; }
    if (_next == NULL) throw LinkedListBounds();
    return _next->infoAt (position - 1);
}


template <class DataType>
void LinkedList<DataType>::insertAt (DataType& newObj, int position)
{
    if (position == 0)
    {
        add (newObj);
    }
    else
    {
        if (_next == NULL)
        {
            _next = new LinkedList (newObj);
            if (_next == NULL) throw LinkedListMemory();
        }
        else
        {
            _next->insertAt (newObj, position - 1);
        }
    }
}


template <class DataType>
DataType LinkedList<DataType>::remove ()
{
    if (isEmpty()) throw LinkedListBounds();
    DataType temp = *_info;
    delete _info;
    if (_next == NULL) { _info = NULL; }
    else
    {
        LinkedList<DataType>* oldnext = _next;
        _info = _next->_info;
        _next = _next->_next;
        // the purpose of these two lines is to remove any stray pointers into the linked list
        oldnext->_info = NULL;
        oldnext->_next = NULL;
    }
    return temp;
}


template <class DataType>
DataType LinkedList<DataType>::removeAt (int position)
{
    if (isEmpty()) throw LinkedListBounds();
    if (position == 0) { return remove(); }
    if (_next == NULL) throw LinkedListBounds();
    return _next->removeAt (position - 1);
}


template <class DataType>
void LinkedList<DataType>::operator= (const LinkedList<DataType>& ll)
{
    if (_info != NULL) delete _info;
    if (_next != NULL) delete _next;
    copy (ll);
}


#endif /* LinkedList_h */

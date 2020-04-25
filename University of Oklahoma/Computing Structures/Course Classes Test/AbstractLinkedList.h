//
//  AbstractLinkedList.h
//  Course Classes Test
//
//  Created by Saeid Hosseinipoor on 7/29/16.
//  Copyright © 2016 Saeid Hosseinipoor. All rights reserved.
//

#ifndef AbstractLinkedList_h
#define AbstractLinkedList_h




#include "Exception.h"



class LinkedListException : public Exception { };
class LinkedListMemory : public LinkedListException { };
class LinkedListBounds : public LinkedListException { };
class LinkedListNotFound : public LinkedListException { };
class LinkedListAttachToEmpty : public LinkedListException { };


/// ----------------------------------------------- AbstractLinkedList ---------------------------------------


template <class DataType>
class AbstractLinkedList{
public:
    virtual DataType& info () = 0;
    //returns the object in the head of the linked list, or throws a bounds error if the list is empty
    
    virtual AbstractLinkedList<DataType>* next () = 0;
    // returns the LinkedList pointed by this LinkedList
    
    virtual bool isEmpty()= 0;
    //returns true if the list is empty,otherwise false
    
    virtual void add (DataType& object) = 0;
    //adds object to the beginning of the list
    
    virtual AbstractLinkedList<DataType>* setNext (AbstractLinkedList<DataType>* next) = 0;
    // attaches next as _next field of list; returns old _next field. if current list is empty throws exception.
    
    virtual void insertAt (DataType& newObj, int position) = 0;
    //inserts newObj so that it will be at node number position (counting the head node as 0)
    
    virtual DataType& infoAt (int position) = 0;
    //return the object in the linked list at the location specified by position, or throws exception
    // position is beyond the end of the linked list
    
    virtual DataType& find (DataType& key) = 0;
    //returns a node matching key or throws exception if none matches
    
    virtual DataType remove () = 0;
    // deletes the first node of the linked list, if any, 	and returns it
    
    virtual DataType removeAt (int position) = 0;
    // deletes the node at position key, if any,and returns it.
    
    virtual DataType remove (DataType& key) = 0;
    //deletes the node matching key, if any, and returns it
    
    virtual int size()= 0;
    //returns the number of nodes in the list
    
    //virtual Enumeration<DataType>* enumerator ();
    // returns an enumeration of the data contained in the list
    
    virtual void display (ostream& s);
    // display the nodes of the linked list
};


#endif /* AbstractLinkedList_h */



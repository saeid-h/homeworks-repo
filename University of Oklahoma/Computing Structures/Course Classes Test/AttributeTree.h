//
//  AttributeTree.h
//  Course Classes Test
//
//  Created by Saeid Hosseinipoor on 7/29/16.
//  Copyright © 2016 Saeid Hosseinipoor. All rights reserved.
//

#ifndef AttributeTree_h
#define AttributeTree_h




/// ----------------------------------------------- AttributeTree Class ---------------------------------------


class AttributeTree //:public AbstractLinkedList<DataType>
{
protected:
    int* _value;
    int* _count;
    AttributeTree* _sister;
    AttributeTree* _daughter;
    
public:
    AttributeTree();
    AttributeTree(int& value, int& count);
    void copy(const AttributeTree& AT);
    AttributeTree(const AttributeTree& AT);
    
    ~AttributeTree();
    
    bool isEmpty();
    bool hasSister(int value);
    void Insert(Command& cmd);
    int Find(Command cmd);
    void add(int value, int count);
    bool hasDaughter(int value);
    AttributeTree* find(int value);
    int& value();
    int& count();
};



/// ----------------------------------------------- AttributeTree Methods ---------------------------------------


AttributeTree::AttributeTree()
{
    _value = NULL;
    _count = NULL;
    _sister = NULL;
    _daughter = NULL;
}


AttributeTree::AttributeTree(int& value, int& count)
{
    _value = new int(value);
    _count = new int(count);
    _sister = NULL;
    _daughter = NULL;
}


void AttributeTree::copy (const AttributeTree& AT)
{
    if (AT._value == NULL) _value = NULL;
    else
    {
        _value = new int(*(AT._value));
        if (_value == NULL) throw LinkedListMemory();
    }
    
    if (AT._count == NULL) _count = NULL;
    else
    {
        _count = new int(*(AT._count));
        if (_count == NULL) throw LinkedListMemory();
    }
    
    
    if (AT._sister == NULL) _sister = NULL;
    else
    {
        _sister = new AttributeTree (*(AT._sister));
        if (_sister == NULL) throw LinkedListMemory();
    }
    
    
    if (AT._daughter == NULL) _daughter = NULL;
    else
    {
        _daughter = new AttributeTree (*(AT._daughter));
        if (_daughter == NULL) throw LinkedListMemory();
    }
    
}



AttributeTree::AttributeTree (const AttributeTree& AT)
{
    copy (AT);
}


AttributeTree::~AttributeTree()
{
    if (_value != NULL)
    {
        delete _value;
        _value = NULL;
    }
    
    if (_count != NULL)
    {
        delete _count;
        _count = NULL;
    }
    
    if (_sister != NULL)
    {
        delete _sister;
        _sister = NULL;
    }
    
    if (_daughter != NULL)
    {
        delete _daughter;
        _daughter = NULL;
    }
    
}


int& AttributeTree::value()
{
    return *_value;
}


int& AttributeTree::count()
{
    return *_count;
}


bool AttributeTree::isEmpty()
{
    return (_count == NULL);
}


bool AttributeTree::hasSister(int value)
{
    if (isEmpty()) return false;
    if (value == *_value) return true;
    if (_sister == NULL) return false;
    return _sister -> hasSister(value);
}


bool AttributeTree::hasDaughter(int value)
{
    if (isEmpty()) return false;
    if (value == *_value) return true;
    if (_daughter == NULL) return false;
    return _daughter -> hasDaughter(value);
}


void AttributeTree::add(int value, int count)
{
    if (isEmpty())
    {
        _value = new int(value);
        _count = new int(count);
    }
    else if (*_value == value) *_count += count;
    else if (value < *_value)
    {
        AttributeTree* newNode = new AttributeTree(*_value, *_count);
        newNode->_sister = _sister;
        newNode->_daughter = _daughter;
        _sister = newNode;
        _daughter = NULL;
        *_value = value;
        *_count = count;
    }
    else if (_sister == NULL || ((_sister->value() > value)))
    {
        AttributeTree* newNode = new AttributeTree(value, count);
        newNode->_sister = _sister;
        _sister = newNode;
    }
    else _sister->add(value, count);
}


AttributeTree* AttributeTree::find(int value)
{
    if (isEmpty()) return NULL;
    if (*_value == value) return this;
    else if (_sister == NULL) return NULL;
    else return _sister->find(value);
}


void AttributeTree::Insert(Command& cmd)
{
    if (!cmd.isValid()) return;
    
    char c = cmd.com();
    if ( c != 'I' && c != 'i') return;
    
    stack<int> comStack = cmd.param();
    int count = cmd.count();
    
    AttributeTree* CurrentNode;
    CurrentNode = this;
    while (!comStack.empty())
    {
        CurrentNode->add(comStack.top(), count);
        CurrentNode = CurrentNode->find(comStack.top());
        comStack.pop();
        if (CurrentNode->_daughter == NULL && !comStack.empty())
        {
            AttributeTree* tempDaughter = new AttributeTree();
            CurrentNode->_daughter = tempDaughter;
        }
        CurrentNode = CurrentNode->_daughter;
    }
}


int AttributeTree::Find(Command cmd)
{
    //if (!cmd.isValid()) return -1;
    
    //char c = cmd.com();
    //if (c != 'F' && c != 'f') return -1;
    
    AttributeTree* CurrentNode;
    CurrentNode = this;
    
    stack<int> comStack = cmd.param();
    int val = comStack.top();
    int result = 0;
    comStack.pop();
    
    if (comStack.empty())
        if (val == -1)
            while (CurrentNode != NULL)
            {
                result += CurrentNode->count();
                CurrentNode = CurrentNode->_sister;
            }
        else
            result += (CurrentNode->find(val))->count();
        else
        {
            cmd.stepAhead();
            if (val == -1)
                while (CurrentNode != NULL)
                {
                    result += (CurrentNode->_daughter)->Find(cmd);
                    CurrentNode = CurrentNode->_sister;
                }
            else
                result += ((CurrentNode->find(val))->_daughter)->Find(cmd);
        }
    return result;
}



#endif /* AttributeTree_h */


//
//  main.cpp
//  Project 2
//
//  Created by Saeid Hosseinipoor on 7/11/16.
//  Copyright © 2016 Saeid Hosseinipoor. All rights reserved.
//

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <stack>


using namespace std;



/// ------------------------------------------- Exceptions Section -------------------------------------

//#include “Exception.h”
class Exception {};
class ArrayException : public Exception { };
class ArrayMemoryException : public ArrayException { };
class ArrayBoundsException : public ArrayException { };



/// ------------------------------------------- AbstractArrayClass -------------------------------------
/// ------------------------------------------- AbstractArrayClass -------------------------------------
/// ------------------------------------------- AbstractArrayClass -------------------------------------

template <class DataType>
class AbstractArrayClass{
public:
    virtual int size () const = 0;
    virtual DataType& operator [] (int k) = 0;
};


/// ----------------------------------------------- ArrayClass -----------------------------------------
/// ----------------------------------------------- ArrayClass -----------------------------------------
/// ----------------------------------------------- ArrayClass -----------------------------------------
// #include "ArrayClass.h"

template <class DataType>
class ArrayClass : virtual public AbstractArrayClass<DataType>{
// An array of type Object will be created and paObject will be the address of the array.
protected:
    DataType* paObject;
    int _size;
    void copy (const ArrayClass<DataType>& ac);
public:
    ArrayClass ();
    ArrayClass (int n);
    ArrayClass (int n, const DataType& val);
    ArrayClass (const ArrayClass<DataType>& ac);
    
    virtual ~ArrayClass();
    
    virtual int size () const;
    
    virtual DataType& operator [] (int k);
    void operator= (const ArrayClass<DataType>& ac);
};


// ------------------------------------------ ArrayClass Methods -----------------------------------------


template <class DataType>
ArrayClass<DataType>::ArrayClass (){
    _size = 0;                           // default in case allocation fails
    paObject = new DataType[1];
    if (paObject == NULL)
        throw ArrayMemoryException();
    _size = 1;
}

template <class DataType> ArrayClass<DataType>::ArrayClass (int n){
    _size = 0;                          // default in case allocation fails
    paObject = new DataType[n];
    if (paObject == NULL)
        throw ArrayMemoryException();
    _size = n;
}


template<class DataType>
ArrayClass<DataType>::ArrayClass (int n, const DataType& val){
    _size = 0;                          // default in case allocation fails
    paObject = new DataType[n];
    if (paObject == NULL)
        throw ArrayMemoryException();
    _size = n;
    for (int i = 0; i < n; i++)
        paObject[i] = val;
}


template <class DataType>
ArrayClass<DataType>::ArrayClass (const ArrayClass<DataType>& ac) {
    copy (ac);
}


template <class DataType>
void ArrayClass<DataType>::copy (const ArrayClass<DataType>& ac){
    _size = 0;                      // default in case allocation fails
    paObject = new DataType[ac._size];
    if (paObject == NULL)
        throw ArrayMemoryException();
    _size = ac._size;
    for (int i = 0; i < _size; i++)
        paObject[i] = ac.paObject[i];
}


template<class DataType>
ArrayClass<DataType>::~ArrayClass (){
    if (paObject != NULL)
        delete[] paObject;
    paObject = NULL;
    _size = 0;
}


template <class DataType>
int ArrayClass<DataType>::size () const{
return _size;
}


template <class DataType>
DataType& ArrayClass<DataType>::operator [] (int k) {
    if ((k < 0) || (k >= size()))
        throw ArrayBoundsException();
    return paObject[k];
}


template <class DataType>
void ArrayClass<DataType>::operator= (const ArrayClass<DataType>& ac) {
    
    if (paObject != NULL)
        delete[] paObject;
    copy (ac);
}


template <class DataType>
ostream& operator << (ostream& s, AbstractArrayClass<DataType>& ac){
    
    s << "[";
    for (int i = 0; i < ac.size (); i++){
        if (i > 0)
            s << ',';
        s << ac [i];
    }
    s << "]";
    return s;
}



/// -------------------------------------------- DataRecord Class -----------------------------------------
/// -------------------------------------------- DataRecord Class -----------------------------------------
/// -------------------------------------------- DataRecord Class -----------------------------------------


class DataRecord {
public:
    DataRecord (int no_atts);
    DataRecord ();
    
    void set_attribute(int att_no, string attrib);
    void set_count(int _cnt);
    string get_attribute(int att_no);
    int get_count();
    int size();
    
    string& operator [] (int k);
    void operator= (const DataRecord& ac);
    
private:
    ArrayClass<string> _Attribute;
    int _count;
    int _size;
};


/// ------------------------------------------- DataRecord Methods ----------------------------------------

DataRecord::DataRecord(int no_atts){
    ArrayClass<string> _att(no_atts, "");
    _Attribute = _att;
    _count = 0;
    _size = no_atts;
}

DataRecord::DataRecord(){
    ArrayClass<string> _att(1, "");
    _Attribute = _att;
    _count = 0;
    _size = 1;
}

void DataRecord::set_attribute(int att_no, string attrib){
 //   if (att_no > _Attribute.size())
   //     throw Exception;
    _Attribute[att_no] = attrib;
}

void DataRecord::set_count(int _cnt){
    _count = _cnt;
}

string DataRecord::get_attribute(int att_no){
    return _Attribute[att_no];
}

int DataRecord::get_count(){
    return _count;
}


int DataRecord::size(){
    return _Attribute.size();
}



 string& DataRecord::operator [] (int k) {
    if ((k < 0) || (k >= size()))
        throw ArrayBoundsException();
    return _Attribute[k];
}

ostream& operator << (ostream& s, DataRecord& ac){
    
    s << "[";
    for (int i = 0; i < ac.size (); i++){
        if (i > 0)
            s << ',';
        s << ac [i];
    }
    s << ',' << ac.get_count();
    s << "]";
    return s;
    
}

void DataRecord::operator= (const DataRecord& DR){
    
    _Attribute = DR._Attribute;
    _count = DR._count;
    
}



/// ----------------------------------------------- Matrix Class ---------------------------------------
/// ----------------------------------------------- Matrix Class ---------------------------------------
/// ----------------------------------------------- Matrix Class ---------------------------------------

class MatrixIncompatibleException : public ArrayException { };

template <class Object>
class Matrix : public AbstractArrayClass <ArrayClass <Object> > {
    
protected:
    ArrayClass <ArrayClass<Object>*>* theRows;
    void copy (Matrix& m);
    void deleteRows ();
    
public:
    Matrix ();
    Matrix (int n, int m);
    Matrix (int n, int m, Object v); Matrix (Matrix& m);
    
    virtual ~Matrix();
    
    int columns();
    int rows() const;
    virtual int size() const;
    
    virtual ArrayClass<Object>& operator[] (int index);
    
    void operator= (Matrix& m);
    void operator= (const Object* list);
};


/// --------------------------------------------- Matrix Methods ---------------------------------------

template <class Object>
Matrix<Object>::Matrix (int n, int m){
    
    theRows = new ArrayClass <ArrayClass <Object>* > (n,NULL);
    if (theRows == NULL)
        throw ArrayMemoryException();
    
    for (int i = 0; i < n; i++){
        (*theRows)[i] = new ArrayClass<Object> (m);
        if ((*theRows)[i] == NULL)
            throw ArrayMemoryException();
    }
}

    
template <class Object> Matrix<Object>::Matrix (){
    
    theRows = new ArrayClass <ArrayClass <Object>* > (1,NULL);
    if (theRows == NULL)
        throw ArrayMemoryException();
    
    (*theRows)[0] = new ArrayClass <Object> ();
    if ((*theRows)[0] == NULL)
        throw ArrayMemoryException();
}


template <class Object> Matrix<Object>::Matrix (int n, int m, Object v){
    
    theRows = new ArrayClass <ArrayClass <Object>* > (n,NULL);
    if (theRows == NULL)
        throw ArrayMemoryException();
    
    for (int i = 0; i < n; i++){
        (*theRows)[i] = new ArrayClass <Object> (m, v);
        if ((*theRows)[i] == NULL)
            throw ArrayMemoryException();
    }
}


template <class Object>
void Matrix<Object>::deleteRows (){
    
    if (theRows != NULL){
        for (int i = 0; i < theRows->size(); i++){
            if ((*theRows)[i] != NULL)
                delete (*theRows)[i];
            (*theRows)[i] = NULL;
        }
        delete theRows;
        theRows = NULL;
    }
}


template <class Object>
Matrix<Object>::~Matrix (){
    deleteRows();
}


template <class Object>
void Matrix<Object>::copy (Matrix<Object>& m){

    deleteRows();
    theRows = new ArrayClass <ArrayClass <Object>* > (m.size(), NULL);
    if (theRows == NULL)
        throw ArrayMemoryException();
    
    for (int i = 0; i < m.size(); i++){
        (*theRows)[i] = new ArrayClass <Object> (m[i]);
        if ((*theRows)[i] == NULL)
            throw ArrayMemoryException();
    }
}


template <class Object>
Matrix<Object>::Matrix (Matrix<Object>& m) {
    theRows = NULL;
    copy (m);
}


template <class Object>
int Matrix<Object>::size() const{
    
    return theRows->size();
}



template <class Object>
void Matrix<Object>::operator= (Matrix& m) {
    copy (m);
}


template <class Object>
int Matrix<Object>::rows() const{
    return theRows->size();
}


template <class Object>
int Matrix<Object>::columns(){
    return (*this)[0].size();
}


template <class Object>
ArrayClass<Object>& Matrix<Object>::operator[] (int index){
    return (*(*theRows)[index]);
}


template <class Object>
Matrix<Object> operator* (Matrix<Object>& matA, Matrix<Object>& matB) {
    if (matA.columns() != matB.rows())
        throw MatrixIncompatibleException();
    Matrix<Object> matC(matA.rows(),matB.columns(),0);
    for (int i=0; i < matA.rows(); i++)
        for (int j=0; j < matB.columns(); j++)
            for (int k=0; k < matA.columns(); k++)
                matC[i][j] = matC[i][j] + matA[i][k]*matB[k][j];
    return matC;
}




/// ----------------------------------------------- AbstractLinkedList ---------------------------------------
/// ----------------------------------------------- AbstractLinkedList ---------------------------------------
/// ----------------------------------------------- AbstractLinkedList ---------------------------------------

class LinkedListException : public Exception { };
class LinkedListMemory : public LinkedListException { };
class LinkedListBounds : public LinkedListException { };
class LinkedListNotFound : public LinkedListException { };
class LinkedListAttachToEmpty : public LinkedListException { };


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




/// ----------------------------------------------- LinkedList Class ---------------------------------------
/// ----------------------------------------------- LinkedList Class ---------------------------------------
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


/// -----------------------------------------------------------------------------------------------------------
/// -----------------------------------------------------------------------------------------------------------
/// -----------------------------------------------------------------------------------------------------------



typedef ArrayClass<LinkedList<string>> MapTable;


/// -----------------------------------------------------------------------------------------------------------
/// -----------------------------------------------------------------------------------------------------------
/// -----------------------------------------------------------------------------------------------------------



/// ----------------------------------------------- Command Class ---------------------------------------
/// ----------------------------------------------- Command Class ---------------------------------------
/// ----------------------------------------------- Command Class ---------------------------------------


class Command
{
protected:
    char _com;
    stack<int> _param;
    int _count;
    
private:
    stack<string> _pstring;
    
public:
    Command();
    Command(const string& input);
    void map(MapTable map);
    bool isValid();
    char com();
    stack<int> param();
    int count();
    void setCom(char com);
    void addParam(int param);
    void setCount(int count);
    void stepAhead();
    
};



/// ----------------------------------------------- Command Methods ---------------------------------------



Command::Command()
{
    //_isvalid = false;
}

Command::Command(const string& input)
{
    if (input.size() == 0) return;
   // _isvalid = false;
    
    int s_pos = 0;
    _com = input[s_pos++];
    
    while (s_pos < input.size())
    {
        string tempstr = "";
        for (int i = s_pos; input[i] != ' ' && input[i] != '\r' && i < input.size(); i++)
            tempstr.append(&input[i],1);
        if (tempstr == "")
            s_pos++;
        else
        {
            s_pos += tempstr.size() + 1;
            _pstring.push(tempstr);
        }

    }
    
    if (_com == 'I')
    {
        _count = stoi(_pstring.top());
        _pstring.pop();
    }

}


void Command::map(MapTable Table)
{
    
    if (_pstring.size() != Table.size()) return;
    for (int i = Table.size()-1; i >= 0; i--)
    {
        if (_pstring.top() == "*")
            _param.push(-1);
        else
            _param.push(Table[i].indexOf(_pstring.top()));
        _pstring.pop();
        // _isvalid = true;
    }

}


bool Command::isValid()
{
    if (_com == '\0') return false;
    if (_param.empty()) return false;
    return true;
}

char Command::com()
{
    return _com;
}


stack<int> Command::param()
{
    return _param;
}


int Command::count()
{
    return _count;
}


void Command::setCom(char com)
{
    _com = com;
}


void Command::addParam(int param)
{
    _param.push(param);
}


void Command::setCount(int count)
{
    _count = count;
}


void Command::stepAhead()
{
    _param.pop();
}



/// ----------------------------------------------- AttributeTree Class ---------------------------------------
/// ----------------------------------------------- AttributeTree Class ---------------------------------------
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



//----------------------------------------------- Get Filename -----------------------------------------

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



//------------------------------------------------- Main -------------------------------------------------
//------------------------------------------------- Main -------------------------------------------------
//------------------------------------------------- Main -------------------------------------------------



int main(int argc, const char * argv[]) {
    
    
    string file_name = "/Users/saeidhosseinipoor/Google Drive/Courses/02 OU/12 Computing Structures/02 Projects/Project 2/InputP2.txt";
    
    ifstream InputFile(file_name);
    
    if (argc == 2)
        file_name = argv[1];
    else
        get_file_name(file_name);
    

    string line;
    getline (InputFile,line);
    
    string ns = "";
    string ms = "";
    
    for (int i = 0; line[i] != ' ' && line[i] != '\r' && i < line.size(); i++)
        ns.append(&line[i], 1);

    for (int i = 2; line[i] != ' ' && line[i] != '\r' && i < line.size(); i++)
        ms.append(&line[i],1);

    int noAttributes = stoi(ns);
    int noRows = stoi(ms);


    DataRecord tmp_obj(noAttributes);
    ArrayClass<DataRecord> Record_Table(noRows, tmp_obj);
    
    for (int k = 0; k < noRows; k++)
    {
        getline (InputFile,line);
        int s_pos = 0;
        for (int j = 0; j <= noAttributes; j++){
            string tmp_att = "";
            for (int i = s_pos; line[i] != ' ' && line[i] != '\r' && i < line.size(); i++)
                tmp_att.append(&line[i],1);
            s_pos += tmp_att.size() + 1;
            if (j != noAttributes )
                tmp_obj.set_attribute(j,tmp_att);
            else
                tmp_obj.set_count(stoi(tmp_att));
        }
        
        Record_Table[k] = tmp_obj;
    }
    
    
    MapTable Unique_Attribute(noAttributes);
    string tempstr = "";
    for (int i = 0; i < noRows; i++)
    {
        for (int j = 0; j < noAttributes; j++)
        {
            tempstr = Record_Table[i][j];
            if (Unique_Attribute[j].isEmpty() || !Unique_Attribute[j].has(tempstr))
                Unique_Attribute[j].add(tempstr);
        }
    }
    
    
    Matrix<int> Value_Table(noRows, noAttributes + 1, 0);
    for (int i = 0; i < noRows; i++)
    {
        for (int j = 0; j < noAttributes; j++)
        {
            tempstr = Record_Table[i][j];
            Value_Table[i][j] = Unique_Attribute[j].indexOf(tempstr);
        }
        Value_Table[i][noAttributes] = Record_Table[i].get_count();
    }
    
    
    string teststrF = "F Afghanistan * * *";
    string teststrI = "I Afghanistan High Sparse 50% 60";
    
    getline (InputFile,line);
    int noCMD;
    noCMD = stoi(line);

    AttributeTree Attribute_Tree;
    for (int i = 0; i < noRows; i++)
    {
        Command comline;
        comline.setCom('I');
        
        for (int j = noAttributes-1; j >= 0; j--)
            comline.addParam(Value_Table[i][j]);
        
        comline.setCount(Value_Table[i][noAttributes]);
        
        comline.map(Unique_Attribute);
        Attribute_Tree.Insert(comline);
    }
    
    
    for (int i = 0; i < noCMD; i++)
    {
        getline (InputFile,line);
        Command comline(line);
        comline.map(Unique_Attribute);
        if (comline.com() == 'F' || comline.com() == 'f' )
        {
            line.resize(line.size()-2);
            cout << "The resultes for command (" << line << ") is: ";
            cout << Attribute_Tree.Find(comline) << ".\n";
        }
        else
            Attribute_Tree.Find(comline);
    }

}

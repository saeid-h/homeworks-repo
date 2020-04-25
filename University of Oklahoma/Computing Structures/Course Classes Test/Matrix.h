//
//  Matrix.h
//  Course Classes Test
//
//  Created by Saeid Hosseinipoor on 7/28/16.
//  Copyright © 2016 Saeid Hosseinipoor. All rights reserved.
//

#ifndef Matrix_h
#define Matrix_h



#include "ArrayClass.h"


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



#endif /* Matrix_h */


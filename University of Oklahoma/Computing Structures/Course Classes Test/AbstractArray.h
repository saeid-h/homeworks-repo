//
//  AbstractArray.h
//  Course Classes Test
//
//  Created by Saeid Hosseinipoor on 7/28/16.
//  Copyright © 2016 Saeid Hosseinipoor. All rights reserved.
//

#ifndef AbstractArray_h
#define AbstractArray_h




template <class DataType>
class AbstractArrayClass{
public:
    virtual int size () const = 0;
    virtual DataType& operator [] (int k) = 0;
};


#endif /* AbstractArray_h */

//
//  DataRecord.h
//  Course Classes Test
//
//  Created by Saeid Hosseinipoor on 7/28/16.
//  Copyright © 2016 Saeid Hosseinipoor. All rights reserved.
//

#ifndef DataRecord_h
#define DataRecord_h



using namespace std;

#include "ArrayClass.h"


///------------------------------------------------------------------------------------------------------
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


#endif /* DataRecord_h */



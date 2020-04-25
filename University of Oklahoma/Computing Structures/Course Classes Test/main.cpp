//
//  main.cpp
//  Course Classes Test
//
//  Created by Saeid Hosseinipoor on 7/28/16.
//  Copyright © 2016 Saeid Hosseinipoor. All rights reserved.
//


#include <iostream>
#include <fstream>
#include <string>
#include <stack>

#include "ArrayClass.h"
#include "DataRecord.h"
#include "Matrix.h"
#include "LinkedList.h"
#include "Command.h"
#include "AttributeTree.h"


using namespace std;




/// ------------------------------------------- Exceptions Section -------------------------------------
/// ------------------------------------------- AbstractArrayClass -------------------------------------
/// ----------------------------------------------- ArrayClass -----------------------------------------
/// -------------------------------------------- DataRecord Class -----------------------------------------
/// ----------------------------------------------- Matrix Class ---------------------------------------
/// ----------------------------------------------- AbstractLinkedList ---------------------------------------
/// ----------------------------------------------- LinkedList Class ---------------------------------------
/// ----------------------------------------------- Command Class ---------------------------------------
/// ----------------------------------------------- AttributeTree Class ---------------------------------------

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

//
//  Command.h
//  Course Classes Test
//
//  Created by Saeid Hosseinipoor on 7/29/16.
//  Copyright © 2016 Saeid Hosseinipoor. All rights reserved.
//

#ifndef Command_h
#define Command_h

#include <stack>


typedef ArrayClass<LinkedList<string>> MapTable;



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


#endif /* Command_h */


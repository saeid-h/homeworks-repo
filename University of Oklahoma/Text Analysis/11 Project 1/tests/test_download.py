
from redactor import redactor

options, args = redactor.flagRecognition ()

def test_function():
    inputFile_list = redactor.downloadFiles (options, inputFile_list='1.txt')
    assert  inputFile_list == '1.txt'

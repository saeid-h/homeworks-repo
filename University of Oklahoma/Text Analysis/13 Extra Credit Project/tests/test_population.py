
from extracredit import databasePopulation


def test_function():
    
    tuples = databasePopulation.create_tuples('*.txt')
    
    assert databasePopulation.populate_data_base(tuples)    


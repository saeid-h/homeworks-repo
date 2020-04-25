
from redactor import redactor

text = '121 Boorks Albany, NY 12224\n' + \
'(202) 225- 6371 \n' + \
'alan@doe.gov \n' + \
'Dear Mr. Attorney General,\n' + \
'The Committee on Science, Space, and Technology is conducting oversight of a coordinated attempt to deprive companies, nonprofit organizations, and scientists of their First Amendment rights and ability to fund and conduct scientific research free from intimidation and threats of prosecution. On March 29, 2016, you and other state attorneys general - the selfproclaimed " Green 20" - announced that you were cooperating on an unprecedented effort against those who have questioned the causes, magnitude, or best ways to address climate change. \n'

def test_function():
    (t, c, i) = redactor.redact_streets (text)
    assert  c == 1

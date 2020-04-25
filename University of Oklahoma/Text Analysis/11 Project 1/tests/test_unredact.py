
from redactor import unredactor


def test_function():
    
    print ('\nRunning an example ...')

    text = 'Working-class romantic drama from director ██████ ████ is as unbelievable as they come, yet there are moments of pleasure due mostly to the charisma of stars ████ █████ and ██████ ██ ████ (both terrific). She\'s a widow who can\'t move on, he\'s illiterate and a closet-inventor--you can probably guess the rest. Adaptation of ███ ██████\'s novel "█████ ██████" (a better title!) is so laid-back it verges on bland, and the film\'s editing is a mess, but it\'s still pleasant; a rosy-hued blue-collar fantasy. There are no overtures to serious issues (even the illiteracy angle is just a plot-tool for the ensuing love story) and no real fireworks, though the characters are intentionally a bit colorless and the leads are toned down to an interesting degree. The finale is pure fluff--and cynics will find it difficult to swallow--though these two characters deserve a happy ending and the picture wouldn\'t really be satisfying any other way. *** from ****'

    redactList, prediction, text = unredactor.unredact (text)

    print ("\nRedacted names:")

    for i in range(len(prediction)):
        print (redactList[i], ':', prediction[i])
        
    print ("\nRedacted text:\n")

    for i in range(len(prediction)):
        text = text.replace (redactList[i], prediction[i])

    print (text)

    
    assert  1 == 1



from nltk.corpus import stopwords
import glob
import re
from sklearn.feature_extraction import DictVectorizer
from sklearn.naive_bayes import GaussianNB
from nltk import sent_tokenize
from nltk import word_tokenize
from nltk import pos_tag
from nltk import ne_chunk
from sklearn.metrics import accuracy_score


# ------------------------------------------------------------------------------

def get_entity(text):
    """Prints the entity inside of the text."""
    names = list()
    for sent in sent_tokenize(text):
        for chunk in ne_chunk(pos_tag(word_tokenize(sent))):
            if hasattr(chunk, 'label') and chunk.label() == 'PERSON':
                names.append(' '.join(c[0] for c in chunk.leaves()))
    return list(set(names))



# ------------------------------------------------------------------------------

def convertWord (Word, ch='\u2588'):
    newWord = ''
    for letter in Word:
        if letter == ' ':
            newWord += ' '
        else:
            newWord += ch
            
    return newWord




# ------------------------------------------------------------------------------

def stripeText(text, labels=[]):
    stopWords = stopwords.words('english')
    text = text.replace('\n', '')
    for s in stopWords:
        text = re.sub('\\b'+s+'\\b', '', text , flags = re.IGNORECASE)
        text = re.sub('  ', ' ', text , flags = re.IGNORECASE)      
    for item in labels:
        text = text.replace (item, convertWord(item))
    return text


# ------------------------------------------------------------------------------

def getVector (currentNames, text):
    fList = list()
    Labels = list()
    words = word_tokenize (text)
    for eachName in currentNames:
        token = word_tokenize (eachName)
        
        rightWord = leftWord = hashString ('') 
        rightRightWord = leftLeftWord = hashString ('')               
        if token[0] in words:
            indxL = words.index(token[0])
            if indxL > 0:
                leftWord = hashString (words[indxL-1])
                if indxL > 1:
                    leftLeftWord = hashString (words[indxL-2])
        if token[-1] in words:
            indxR = words.index(token[-1])
            if indxR < len(words)-2:
                rightWord = hashString (words[indxR+1])
                if indxR < len(words)-3:
                    rightRightWord = hashString (words[indxR+2])                
                
        totalLength = len(eachName)
        splitedName = eachName.split(' ')
        numberOfParts = len(splitedName)
        
        parts = [0, 0, 0]
        for i in range(len(splitedName)):
            if i < 3:
                parts[i] = len(splitedName[i])
            else:
                parts[2] += len(splitedName[i])
                
        fList += [{'Total Length': totalLength, \
                             'Number of Parts' : numberOfParts*10, \
                             'Total Length' : totalLength*2, \
                             'Length of Part 1': parts[0]*3, \
                             'Length of Part 2': parts[1]*2, \
                             'Length of Part 3+': parts[2], \
                             'Left Word' : leftWord *.1, \
                             'Right Word' : rightWord *.05, \
                             'Left Left Word' : leftLeftWord *.01, \
                             'Right Right Word' : rightRightWord *.005, \
                             },]
        Labels += [eachName]
    
    return fList, Labels



# ------------------------------------------------------------------------------

def hashString (str, key=100):
    s = 0
    for ch in str:
        s += ord (ch)
        
    return s % key


# ------------------------------------------------------------------------------

def train():
    txtFiles  = glob.glob('../train/*.txt')
    txtFiles  += glob.glob('train/*.txt')
    
    
    nameSet = set()
    featureList = list()
    labels = list()
    
    for f in txtFiles:
        text = open(f, encoding='utf8').read()
        currentNames = get_entity(text)
        
        fList, Ls = getVector (set(currentNames) - nameSet, text)
        featureList += fList
        labels += Ls
        nameSet = nameSet.union(currentNames)
    
    #X_train = featureList[:-10]
    #Y_train = labels[:-10]
    
    vec = DictVectorizer()
    X_train = vec.fit_transform(featureList).toarray()
    Y_train = labels
    
    X_test = vec.fit_transform(featureList[-10:]).toarray()
    Y_test = labels[-10:]
    
    glf = GaussianNB()
    glf.fit(X_train,Y_train)
    
    print ('model accuracy is = ', accuracy_score(Y_train, glf.predict(X_train)))
      
    #y_pred = glf.fit(X_train, Y_train).predict_proba(X_train)
    #probs = y_pred.tolist() 

    return glf


# ------------------------------------------------------------------------------
def get_redacted (text, ch='\u2588'):
    textTokens = word_tokenize (text)
    redactedList = list()
    i = 0
    while i in range(len(textTokens)):
        found = ''
        while ch in textTokens[i]:
            if found != '':
                textTokens[i] = ' ' + textTokens[i]
            found = found + textTokens[i]
            i += 1
        if found == '':
            i += 1
        else:
            redactedList.append(found)
            found = ''
    return redactedList
        

# ------------------------------------------------------------------------------

def unredact (text, k=1):
    
    glf = train()
    
    redactedList = get_redacted (text)
    
    redactedList.sort(reverse=True, key=len)
    
    fList, _ = getVector (set(redactedList), text)
        
    Vector = DictVectorizer().fit_transform(fList).toarray()
    
    prediction = glf.predict(Vector)
    
    prediction_K = glf.predict_proba(Vector)
    predictionK = list()
    for j in range(len(prediction_K)):
        predictionK.append ([(glf.classes_[i], prediction_K[j][i]) for i in range(len(prediction_K[j])) if prediction_K[j][i] != 0])
    
    
    if k > 1:
        for i in range (len(predictionK)):
            predictionK[i] = predictionK[i][:k]
        prediction = predictionK
        
    return list(set(redactedList)), prediction, text


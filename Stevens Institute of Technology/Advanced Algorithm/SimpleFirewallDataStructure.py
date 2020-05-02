
#!/usr/bin/python3
from copy import deepcopy

class IPTree():
    def __init__(self, rootid="*"):
        self.parent = None
        self.left = None
        self.right = None
        self.rootid = rootid
        self.rules = list()

    def getParent(self):
        return self.parent
    def getLeftChild(self):
        return self.left
    def getRightChild(self):
        return self.right
    def getRuleList(self):
        return self.rules

    def findNode(self, IP):
        if self.rootid == IP:
            return self
        else:
            i = 0
            while i < len(IP) and i < len(self.rootid) and self.rootid[i] == IP[i]:
                i = i + 1
            if i == len(IP):
                return self

            if IP[i] == '0':
                if self.left != None:
                    return self.left.findNode(IP)
                else:
                    return self
            else:
                if self.right != None:
                    return self.right.findNode(IP)
                else:
                    return self


    def insertNode(self, IP):
        # srcIP = newRule[1]
        position = self
        if not self.rootid == IP:
            # self.rules.append([newRule[0], newRule[2], newRule[3]])
        # else:
            nid = self.rootid
            if nid[-1] == "*":
                nid = nid[:-1]
            n = len(nid)
            if IP[n:n+1] == "0":
                if self.left == None:
                    if n == 31:
                        self.left = IPTree(nid+"0")
                    else:
                        self.left = IPTree(nid+"0*")
                self.left.parent = self
                position = self.left.insertNode(IP)
            else:
                if self.right == None:
                    if n == 31:
                        self.right = IPTree(nid+"1")
                    else:
                        self.right = IPTree(nid+"1*")
                self.right.parent = self
                position = self.right.insertNode(IP)

        return position


    def printTree (self):
        if self.left != None:
            self.left.printTree()
        L = self.getRuleList()
        if L != []:
            # print (self.rootid, ':')
            for i  in range(len(L)):
                print ('{0:3d} {1:32s} {2:32s} {3:1d}'.format \
                    (L[i].p, L[i].srcIP.rootid, L[i].dstIP.rootid, L[i].Action))
        if self.right != None:
            self.right.printTree()



class RuleNode():
    def __init__(self, rule):
        self.p = rule[0]
        self.Action = rule[1]
        self.srcIP = None
        self.dstIP = None





class RuleTree():
    def __init__(self):
        self.srcIP = IPTree()
        self.dstIP = IPTree()

         
    def insertRule(self, newRule):
        sIP = newRule[1]
        dIP = newRule[2]
        sNode = self.srcIP.insertNode(sIP)
        dNode = self.dstIP.insertNode(dIP)

        sCurrentRules = set(sNode.rules)
        dCurrentRules = set(dNode.rules)
        intersect = sCurrentRules & dCurrentRules 

        if intersect:
            if list(intersect)[0].p > newRule[0]:
                return
        
        ruleNode = RuleNode([newRule[0], newRule[3]])
        ruleNode.srcIP = sNode
        ruleNode.dstIP = dNode
        sNode.rules.append(ruleNode)
        dNode.rules.append(ruleNode)


    def getRule(self, sIP, dIP):
        ultimateNodeSrc = self.srcIP.findNode(sIP).rootid
        ultimateNodeDst = self.srcIP.findNode(dIP).rootid
        if len(ultimateNodeSrc) < len(ultimateNodeDst):
            IP1 = sIP
            IP2 = dIP
            ultimateNode = ultimateNodeSrc
        else:
            IP1 = dIP
            IP2 = sIP
            ultimateNode = ultimateNodeDst
        currentNode = '*'
        currentRule = [0,1]
        s = 0
        # ultimateNode = self.srcIP.findNode(IP1).rootid

        while currentNode != ultimateNode:

            ruleList = self.srcIP.findNode(currentNode).getRuleList()
            
            if ruleList != []:
                for i in range(len(ruleList)):
                    if isInRange(IP2, ruleList[i].dstIP.rootid):
                        if ruleList[i].p > currentRule[0]:
                             currentRule = [ruleList[i].p, ruleList[i].Action]

            if IP1[s] != '*':
                currentNode =  IP1[:s+1] + '*'
            s = s + 1

        return currentRule[1]

    

    def getRuleOpt(self, sIP, dIP):
        srcNode = self.srcIP.findNode(sIP)
        dstNode = self.srcIP.findNode(dIP)
        srcruleSet = set(srcNode.getRuleList())
        dstruleSet = set(dstNode.getRuleList())
        rule = list(srcruleSet & dstruleSet) 
        print (sIP, srcNode.rootid, dIP, dstNode.rootid, rule)
        return rule[0].Action




    # def getRule(self, sIP, dIP):
    #     currentNode = '*'
    #     s = 0
    #     ultimateNode = self.srcIP.findNode(sIP).rootid
    #     srcRuleSet = set()

    #     while currentNode != ultimateNode:
    #         srcRuleSet = srcRuleSet | set(self.srcIP.findNode(currentNode).getRuleList())
    #         if sIP[s] != '*':
    #             currentNode =  sIP[:s+1] + '*'
    #         s = s + 1

    #     currentNode = '*'
    #     s = 0
    #     ultimateNode = self.dstIP.findNode(dIP).rootid
    #     dstRuleSet = set()

    #     while currentNode != ultimateNode:
    #         dstRuleSet = dstRuleSet | set(self.dstIP.findNode(currentNode).getRuleList())
    #         if dIP[s] != '*':
    #             currentNode =  dIP[:s+1] + '*'
    #         s = s + 1

    #     intersectRuleList = list(srcRuleSet & dstRuleSet)

    #     if len(intersectRuleList) == 0:
    #         return 1
    #     else:
    #         currentRule = [0,1]
    #         for i in range(len(intersectRuleList)):
    #             if intersectRuleList[i].p > currentRule[0]:
    #                 currentRule = [intersectRuleList[i].p, intersectRuleList[i].Action]
    #         return currentRule[1]


    def printTree (self):
        self.srcIP.printTree()
        self.dstIP.printTree()





def printTree(tree):
    if tree != None:
        printTree(tree.getLeftChild())
        print(tree.rootid, tree.getRuleList())
        printTree(tree.getRightChild())


def isInRange(targetIP, rangeIP):
    if len(targetIP) < len(rangeIP):
        return False
    if len(targetIP) == len(rangeIP):
        (rangeIP == targetIP)
    if rangeIP[-1] == '*':
        for i in range(len(rangeIP)-1):
            if rangeIP[i] != targetIP[i]:
                return False
        return True                
    else:
        return (rangeIP == targetIP)

    

def detectConflict(rule1, rule2):
    IPs1 = rule1[1]
    IPd1 = rule1[2]
    IPs2 = rule2[1]
    IPd2 = rule2[2]

    Cs1 = isInRange(IPs1, IPs2)
    Cs2 = isInRange(IPs2, IPs1)
    Cd1 = isInRange(IPd1, IPd2)
    Cd2 = isInRange(IPd2, IPd1)
    Cd = Cd1 or Cd2
    isRedundant = (IPs1 == IPs2 and IPd1 == IPd2)
    hasSamePriority = (rule1[0] == rule2[0])
    hasNoConflict = (rule1[3] == rule2[3])

    result = ['', '', '']
    if isRedundant:
        result[0] = 'Redundant'
    else:
        result[0] = 'Coverage'
    if hasNoConflict:
        result[1] = 'No Conflict'
    else:
        result[1] = 'Conflict'
    if hasSamePriority:
        result[2] = 'Same Prioratity'
    elif rule1[0] > rule2[0]:
        result[2] = '1'
    else:
        result[2] = '2'


    if (Cs1 & Cd) or (Cs2 & Cd):
        return result
    else:
        return ['No Coverage', 'No Conflict', '']
        


def splitRules (oldRules):

    i = 0
    newRules = deepcopy (oldRules)

    while i < len(newRules):
        j = i + 1

        while j < len(newRules):
            # print (i, j)
            # print (newRules[i],newRules[j])
            result = detectConflict(newRules[i],newRules[j])

            if result[0] == 'No Coverage':
                j = j + 1

            elif result[0] == 'Redundant':
                if newRules[i][0] > newRules[j][0]:
                    del newRules[j]
                else:
                    del newRules[i]
                    j = len(newRules)
                    i = i - 1
            else:
                if newRules[i][1] == newRules[j][1]:
                    if len(newRules[i][2]) < len(newRules[j][2]):
                        r1 = newRules[i]
                        r2 = newRules[i]
                        del newRules[i]
                        if len(r1[2]) < 31:
                            r1[2] = r1[2][:-1]+'0*'
                            r2[2] = r2[2][:-1]+'1*'
                        else:
                            r1[2] = r1[2]+'0'
                            r2[2] = r2[2]+'1'
                            # print(1)
                        newRules.append(r1)
                        newRules.append(r2)
                        j = len(newRules)
                        i = i - 1
                    else:
                        r1 = newRules[j]
                        r2 = newRules[j]
                        del newRules[j]
                        if len(r1[2]) < 31:
                            r1[2] = r1[2][:-1]+'0*'
                            r2[2] = r2[2][:-1]+'1*'
                        else:
                            r1[2] = r1[2]+'0'
                            r2[2] = r2[2]+'1'
                            # print(2)
                        newRules.append(r1)
                        newRules.append(r2)
                else:
                    if len(newRules[i][1]) < len(newRules[j][1]):
                        r1 = newRules[i]
                        r2 = newRules[i]
                        del newRules[i]
                        if len(r1[1]) < 31:
                            r1[1] = r1[1][:-1]+'0*'
                            r2[1] = r2[1][:-1]+'1*'
                        else:
                            r1[1] = r1[1]+'0'
                            r2[1] = r2[1]+'1'
                            # print(3)
                        newRules.append(r1)
                        newRules.append(r2)
                        j = len(newRules)
                        i = i - 1
                    else:
                        r1 = newRules[j]
                        r2 = newRules[j]
                        del newRules[j]
                        if len(r1[1]) < 31:
                            r1[1] = r1[1][:-1]+'0*'
                            r2[1] = r2[1][:-1]+'1*'
                            # newRules.append(r1)
                            # newRules.append(r2)
                        else:
                            r1[1] = r1[1]+'0'
                            r2[1] = r2[1]+'1'
                            print (newRules[i], newRules[j])
                            # print(4)
                        newRules.append(r1)
                        newRules.append(r2)
                        
        i = i + 1


    return newRules
"""
.. module:: theory.element
   :synopsis: Module holding the Element class and its methods.
    
.. moduleauthor:: Andre Lessa <lessa.a.p@gmail.com>
    
"""

from smodels.theory.particleNames import simParticles, elementsInStr
from smodels.theory.branch import Branch
from smodels.theory import crossSection
from particles import rEven, ptcDic
from smodels.theory.printer import Printer
import logging
import sys

logger = logging.getLogger(__name__)


class Element(Printer):
    """
    An instance of this class represents an element.    
    This class possesses a pair of branches and the element weight
    (cross-section * BR).
    
    :ivar branches: list of branches (Branch objects)
    :ivar weight: element weight (cross-section * BR)
    :ivar motherElements: only for elements generated from a parent element
                          by mass compression, invisible compression,etc.
                          Holds a pair of (whence, mother element), where
                          whence describes what process generated the element    
    """
    def __init__(self, info=None):
        """
        Initializes the element. If info is defined, tries to generate
        the element using it.
        
        :parameter info: string describing the element in bracket notation
                         (e.g. [[[e+],[jet]],[[e-],[jet]]])
        """
        self.branches = [Branch(), Branch()]
        self.weight = crossSection.XSectionList()
        self.motherElements = []
        
        if info:
            # Create element from particle string
            if type(info) == type(str()):
                elements = elementsInStr(info)
                if not elements or len(elements) > 1:
                    nel = 0
                    if elements:
                        nel = len(elements)
                    logging.error("Malformed input string. Number of elements "
                                  "is %d, expected 1: in ``%s''", nel, info)
                    return False
                else:
                    el = elements[0]
                    branches = elementsInStr(el[1:-1])                    
                    if not branches or len(branches) != 2:
                        logging.error("Malformed input string. Number of "
                                      "branches is %d, expected 2: in ``%s''",
                                      len(branches), info)
                        return False
                    self.branches = []
                    for branch in branches:
                        self.branches.append(Branch(branch))
            # Create element from branch pair
            elif type(info) == type([]) and type(info[0]) == type(Branch()):
                for ib, branch in enumerate(info):
                    self.branches[ib] = branch.copy()

    def combineMotherElements ( self, el2 ):
        """
        Combine mother elements from self and el2 into self
        
        :parameter el2: element (Element Object)  
        """
        if len(self.motherElements)==0: 
            # no mothers? then you yourself are mother!
            tmp=self.copy()
            self.motherElements.append ( ("combine", tmp) )
        for m in el2.motherElements:
            self.motherElements.append ( (m[0], m[1].copy()) )
        if len(el2.motherElements)==0: 
            # no mothers? then yo yourself are mother now
            tmp=el2.copy()
            self.motherElements.append ( ("combine", tmp) )

    def __eq__(self, other):
        return self.isEqual(other)


    def __hash__(self):
        return object.__hash__(self)


    def __ne__(self, other):
        return not self.isEqual(other)


    def __str__(self):
        """
        Create the element bracket notation string, e.g. [[[jet]],[[jet]].
        
        :returns: string representation of the element (in bracket notation)    
        """
        particleString = str(self.getParticles()).replace(" ", "").\
                replace("'", "")
        return particleString


    def isEqual(self, other, order=False, useDict=True):
        """
        Compare two Elements for equality.        
                
        :parameter other: element to be compared (Element object)
        :parameter order: if False, test both branch orderings.
        :parameter useDict: if True, allow for inclusive particle labels.
        :returns: True, if all masses and particles are equal; False, else;        
        """
        if type(self) != type(other):
            return False
        mass = self.getMasses()
        massA = other.getMasses()

        if self.particlesMatch(other, order=True, useDict=useDict) \
                and mass == massA:
            return True
        if not order:
            otherB = other.switchBranches()
            massB = otherB.getMasses()
            if self.particlesMatch(otherB, order=True, useDict=useDict) \
                    and mass == massB:
                return True

        return False


    def particlesMatch(self, other, order=False, useDict=True):
        """
        Compare two Elements for matching particles.
        
        :parameter other: element to be compared (Element object)
        :parameter order: if False, test both branch orderings.
        :parameter useDict: if True, allow for inclusive particle labels.
        :returns: True, if particles match; False, else;        
        """
        if type(self) != type(other):
            return False
        ptcs = self.getParticles()
        ptcsA = other.getParticles()
        if simParticles(ptcs, ptcsA, useDict):
            return True
        if not order:
            ptcsB = other.switchBranches().getParticles()
            if simParticles(ptcs, ptcsB, useDict):
                return True

        return False


    def copy(self):
        """
        Create a copy of self.        
        Faster than deepcopy.     
        
        :returns: copy of element (Element object)   
        """
        newel = Element()
        newel.branches = []
        for branch in self.branches:
            newel.branches.append(branch.copy())
        newel.weight = self.weight.copy()
        newel.motherElements = self.motherElements[:]
        return newel


    def setMasses(self, mass, sameOrder=True, opposOrder=False):
        """
        Set the element masses to the input mass array.
        
        
        :parameter mass: list of masses ([[masses for branch1],[masses for branch2]])
        :parameter sameOrder: if True, set the masses to the same branch ordering
                              If True and opposOrder=True, set the masses to the
                              smaller of the two orderings.
        :parameter opposOrder: if True, set the masses to the opposite branch ordering.
                               If True and sameOrder=True, set the masses to the
                               smaller of the two orderings.             
        """
        if sameOrder and opposOrder:
            if mass[0] == _smallerMass(mass[0], mass[1]):
                newmass = mass
            else:
                newmass = [mass[1], mass[0]]
        elif sameOrder:
            newmass = mass
        elif opposOrder:
            newmass = [mass[1], mass[0]]
        else:
            logger.error("Called with no possible ordering")            
            sys.exit()
        if len(newmass) != len(self.branches):
            logger.error("Called with wrong number of mass branches")
            sys.exit()

        for i, mass in enumerate(newmass):
            self.branches[i].masses = mass[:]


    def switchBranches(self):
        """
        Switch branches, if the element contains a pair of them.
        
        :returns: element with switched branches (Element object)                
        """
        
        newEl = self.copy()
        if len(self.branches) == 2:
            newEl.branches = [newEl.branches[1], newEl.branches[0]]
        return newEl


    def getParticles(self):
        """
        Get the array of particles in the element.
        
        :returns: list of particle strings                
        """
        
        ptcarray = []
        for branch in self.branches:
            ptcarray.append(branch.particles)
        return ptcarray


    def getMasses(self):
        """
        Get the array of masses in the element.    
        
        :returns: list of masses (mass array)            
        """
        massarray = []
        for branch in self.branches:
            massarray.append(branch.masses)
        return massarray


    def getDaughters(self):
        """
        Get a pair of daughter IDs (PDGs of the last intermediate state appearing the cascade decay).    
        Can be None, if the element does not have a definite daughter.
        
        :returns: list of PDG ids
        """
        
        return (self.branches[0].daughterID, self.branches[1].daughterID)


    def getMothers(self):
        """
        Get a pair of mother IDs (PDG ids of the primary mother intermediate state).      
        Can be None, if the element does not have a definite mother.
        
        :returns: list of PDG ids
        """
        
        return (self.branches[0].momID, self.branches[1].momID)


    def getEinfo(self):
        """
        Get topology info from particle string.
        
        :returns: dictionary containing vertices and number of final states information  
        """
        
        vertnumb = []
        vertparts = []
        for branch in self.branches:
            vertnumb.append(len(branch.masses))
            vertparts.append([len(ptcs) for ptcs in branch.particles])
            if len(vertparts[len(vertparts) - 1]) == \
                    vertnumb[len(vertnumb) - 1] - 1:
                # Append 0 for stable LSP
                vertparts[len(vertparts) - 1].append(0)
        return {"vertnumb" : vertnumb, "vertparts" : vertparts}


    def _getLength(self):
        """
        Get the maximum of the two branch lengths.    
        
        :returns: maximum length of the element branches (int)    
        """
        return max(self.branches[0].getLength(), self.branches[1].getLength())


    def isInList(self, listOfElements, igmass=False, useDict=True):
        """
        Check if the element is present in the element list.   
        
        :parameter      
        If igmass == False also check if the analysis has the element mass
        array.        
        """
        for el in listOfElements:
            if igmass:
                if self.particlesMatch(el, useDict):
                    return True
            else:
                if self.isEqual(el, useDict):
                    return True

        return False


    def checkConsistency(self):
        """
        Check if the particles defined in the element exist and are consistent
        with the element info.
        
        :returns: True if the element is consistent. Print error message
                  and exits otherwise.
        """
        info = self.getEinfo()
        for ib, branch in enumerate(self.branches):
            for iv, vertex in enumerate(branch.particles):
                if len(vertex) != info['vertparts'][ib][iv]:
                    logger.error("Wrong syntax")
                    sys.exit()
                for ptc in vertex:
                    if not ptc in rEven.values() and not ptc in ptcDic:
                        logger.error("Unknown particle. Add " + ptc + " to smodels/particle.py")
                        sys.exit()
        return True

    
    def compressElement(self, doCompress, doInvisible, minmassgap):
        """
        Keep compressing the original element and the derived ones till they
        can be compressed no more.
        
        :parameter doCompress: if True, perform mass compression
        :parameter doInvisible: if True, perform invisible compression
        :parameter minmassgap: value (in GeV) of the maximum 
                               mass difference for compression
                               (if mass difference < minmassgap, perform mass compression)
        :returns: list with the compressed elements (Element objects)        
        """
        added = True
        newElements = [self.copy()]
        # Keep compressing the new topologies generated so far until no new
        # compressions can happen:
        while added:
            added = False
            # Check for mass compressed topologies
            if doCompress:
                for element in newElements:
                    newel = element.massCompress(minmassgap)
                    # Avoids double counting (conservative)
                    if newel and not newel.hasTopInList(newElements):
                        newElements.append(newel)
                        added = True

            # Check for invisible compressed topologies (look for effective
            # LSP, such as LSP + neutrino = LSP')
            if doInvisible:
                for element in newElements:
                    newel = element.invisibleCompress()
                    # Avoids double counting (conservative)
                    if newel and not newel.hasTopInList(newElements):
                        newElements.append(newel)
                        added = True

        newElements.pop(0)  # Remove original element
        return newElements

    def massCompress(self, minmassgap):
        """
        Perform mass compression.
        
        :parameter minmassgap: value (in GeV) of the maximum 
                               mass difference for compression
                               (if mass difference < minmassgap -> perform mass compression)
        :returns: compressed copy of the element, if two masses in this
                  element are degenerate; None, if compression is not possible;        
        """
        
        masses = self.getMasses()
        massDiffs = []
        #Compute mass differences in each branch
        for massbr in masses:
            massDiffs.append([massbr[i]-massbr[i+1] for i in range(len(massbr)-1)])
        #Compute list of vertices to be compressed in each branch            
        compVertices = []
        for ibr,massbr in enumerate(massDiffs):
            compVertices.append([])
            for iv,massD in enumerate(massbr):            
                if massD < minmassgap: compVertices[ibr].append(iv)
        if not sum(compVertices,[]): return None #Nothing to be compressed
        else:
            newelement = self.copy()
            newelement.motherElements = [ ("mass", self.copy()) ]
            for ibr,compbr in enumerate(compVertices):
                if compbr:            
                    new_branch = newelement.branches[ibr]
                    ncomp = 0
                    for iv in compbr:
                        new_branch.masses.pop(iv-ncomp)
                        new_branch.particles.pop(iv-ncomp)
                        ncomp +=1

        return newelement
    

    def hasTopInList(self, elementList):
        """
        Check if the element topology matches any of the topologies in the
        element list.
        
        :parameter elementList: list of elements (Element objects)
        :returns: True, if element topology has a match in the list, False otherwise.        
        """
        if type(elementList) != type([]) or len(elementList) == 0:
            return False
        for element in elementList:
            if type(element) != type(self):
                continue
            info1 = self.getEinfo()
            info2 = element.getEinfo()
            info2B = element.switchBranches().getEinfo()
            if info1 == info2 or info1 == info2B:
                return True
        return False


    def invisibleCompress(self):
        """
        Perform invisible compression.
        
        :returns: compressed copy of the element, if element ends with invisible
                  particles; None, if compression is not possible
        """
        newelement = self.copy()
        newelement.motherElements = [ ("invisible", self.copy()) ]

        vertnumb = self.getEinfo()["vertnumb"]
        # Nothing to be compressed
        if max(vertnumb) < 2:
            return None
        # Loop over branches
        for ib, branch in enumerate(self.branches):
            if vertnumb[ib] < 2:
                continue
            particles = branch.particles
            for ivertex in range(vertnumb[ib] - 2, -1, -1):
                if particles[ivertex].count('nu') == len(particles[ivertex]):
                    newelement.branches[ib].masses.pop(ivertex + 1)
                    newelement.branches[ib].particles.pop(ivertex)
                else:
                    break

        if newelement.isEqual(self):
            return None
        else:
            return newelement

    def formatData(self,outputLevel):
        """
        Select data preparation method through dynamic binding.
        
        :parameter outputLevel: general control for the output depth to be printed 
                            (0 = no output, 1 = basic output, 2 = detailed output,...
        """
        return Printer.formatElementData(self,outputLevel)


def _smallerMass(mass1, mass2):
    """
    Select the smaller of two mass arrays.    
    Use an ordering criterion (machine-independent) for selection.
    
    :parameter mass1: mass array (list of masses)
    :parameter mass2: mass array (list of masses)
    :returns: mass1, if mass1 > mass2; mass2, otherwise 
    """
    mass1List = []
    mass2List = []
    if mass1 == mass2:
        return mass1
    try:
        for branch in mass1:
            mass1List.extend(branch)
        for branch in mass2:
            mass2List.extend(branch)
        if len(mass1List) == len(mass2List):
            for im, m1 in enumerate(mass1List):
                if m1 < mass2List[im]:
                    return mass1
                if m1 > mass2List[im]:
                    return mass2
    except:
        pass

    logger.error("Invalid input")
    sys.exit()

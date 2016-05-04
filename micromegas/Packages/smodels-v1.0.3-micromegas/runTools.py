#!/usr/bin/env python

"""
.. module:: smodels
   :synopsis: Command line program for SModelS tasks.

.. moduleauthor:: Wolfgang Magerl <wolfgang.magerl@gmail.com>

"""

import argparse, sys, os, logging
from smodels.installation import installDirectory
sys.path.append(installDirectory()+"/Unum-4.1.3-py2.7.egg/")
import logging.config
logging.config.fileConfig('%s/etc/logging.conf' % installDirectory(),
                                  disable_existing_loggers=False)
log = logging.getLogger(__name__)

def main():
    parser = argparse.ArgumentParser(description="SModelS command line tool.")
    subparsers = parser.add_subparsers(dest='subparser_name')
    
    xseccomputer = subparsers.add_parser('xseccomputer', description="Compute MSSM cross sections for a SLHA file.")        
    xseccomputer.add_argument('-s', '--sqrts', nargs='+', action='append', help="sqrt(s) TeV. Can supply more than one value.", type=int, default=[])
    xseccomputer.add_argument('-e', '--nevents', type=int, default=10000, help="number of events to be simulated.")
    xseccomputer.add_argument('-p', '--tofile', action='store_true', help="write cross sections to file")
    xseccomputer.add_argument('-k', '--keep', action='store_true', help="do not unlink temporary directory")
    xseccomputer.add_argument('-n', '--NLO', action='store_true', help="compute at the NLO level (default is LO)")
    xseccomputer.add_argument('-N', '--NLL', help="compute at the NLO+NLL level (takes precedence over NLO, default is LO)", action='store_true')
    xseccomputer.add_argument('-O', '--LOfromSLHA',help="use LO cross-sections from file to compute the NLO or NLL cross-sections", action='store_true')
    xseccomputer.add_argument('-f', '--filename', help="SLHA file to compute cross sections for", required=True)
    xseccomputer.add_argument('-particles', '--particlePath', help='path to directory where particles.py is located', default=installDirectory()+"/smodels")

    slhachecker = subparsers.add_parser('slhachecker', description="Perform several checks on a SLHA file.")    
    slhachecker.add_argument('-xS', '--xsec', help = 'turn off the check for xsection blocks', action = 'store_false')
    slhachecker.add_argument('-lsp', '--lsp', help = 'turn off the check for charged lsp', action = 'store_false')
    slhachecker.add_argument('-longlived', '--longlived', help = 'turn off the check for stable charged particles and visible displaced vertices', action = 'store_false')
    slhachecker.add_argument('-m', '--displacement', help = 'give maximum displacement of secondary vertex in m', default = .001, type = float)
    slhachecker.add_argument('-s','--sigmacut', help = 'give sigmacut in fb', default = .01, type = float)
    slhachecker.add_argument('-illegal','--illegal', help= 'turn on check for kinematically forbidden decays', action = 'store_true')
    slhachecker.add_argument('-dB','--decayBlocks', help = 'turn off the check for missing decay blocks', action = 'store_false')
    slhachecker.add_argument('-f', '--filename', help = 'name of input SLHA file', required=True)
    slhachecker.add_argument('-particles', '--particlePath', help='path to directory where particles.py is located', default=installDirectory()+"/smodels")
    
    lhechecker = subparsers.add_parser('lhechecker', description="Check if the input file has LHE format.")
    lhechecker.add_argument('-f', '--filename', help = 'name of input LHE file', required=True)
    lhechecker.add_argument('-particles', '--particlePath', help='path to directory where particles.py is located', default=installDirectory()+"/smodels")
    
    args = parser.parse_args()
    
    """
    check if particles.py exists in specified path, and add to sys.path
    """
    if not os.path.isfile(os.path.join(args.particlePath,"particles.py")):
        log.error("particle.py not found in %s" %args.particlePath )
        return
    else:
        sys.path.insert(1, args.particlePath)
        from smodels.tools import xsecComputer
        from smodels.tools import slhaChecks, lheChecks

    if args.subparser_name == 'xseccomputer':
        xsecComputer.main(args)
    if args.subparser_name == 'slhachecker':    
        slhaChecks.main(args)
    if args.subparser_name == 'lhechecker':
        lheChecks.main(args)

if __name__ == '__main__':
    main()
    

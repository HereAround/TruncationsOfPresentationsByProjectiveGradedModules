#
# TruncationsOfPresentationsByProjectiveGradedModules: Truncating a graded module presentation (for CAP) to an affine (cone) semigroup
#
# This file contains package meta data. For additional information on
# the meaning and correct usage of these fields, please consult the
# manual of the "Example" package as well as the comments in its
# PackageInfo.g file.
#
SetPackageInfo( rec(

PackageName := "TruncationsOfPresentationsByProjectiveGradedModules",

Subtitle := "Truncations of graded module presentations (for CAP) to affine semigroups",

Version := Maximum( [
  "2016.10.05", ## Martin's version
] ),

Date := ~.Version{[ 1 .. 10 ]},
Date := Concatenation( ~.Date{[ 9, 10 ]}, "/", ~.Date{[ 6, 7 ]}, "/", ~.Date{[ 1 .. 4 ]} ),

Persons := [
  rec(
    IsAuthor := true,
    IsMaintainer := true,
    FirstNames := "Martin",
    LastName := "Bies",
    WWWHome := "TODO",
    Email := "bies@thphys.uni-heidelberg.de",
    PostalAddress := Concatenation( 
                 "Institut für theoretische Physik - Heidelberg \n",
                 "Philosophenweg 19 \n",
                 "69120 Heidelberg \n",
                 "Germany" ), 
    Place := "Heidelberg",
    Institution := "ITP Heidelberg",
  ),
],

PackageWWWHome := "http://TODO/",

ArchiveURL     := Concatenation( ~.PackageWWWHome, "TruncationsOfPresentationsByProjectiveGradedModules-", ~.Version ),
README_URL     := Concatenation( ~.PackageWWWHome, "README" ),
PackageInfoURL := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),

ArchiveFormats := ".tar.gz",

##  Status information. Currently the following cases are recognized:
##    "accepted"      for successfully refereed packages
##    "submitted"     for packages submitted for the refereeing
##    "deposited"     for packages for which the GAP developers agreed
##                    to distribute them with the core GAP system
##    "dev"           for development versions of packages
##    "other"         for all other packages
##
Status := "dev",

AbstractHTML   :=  "",

PackageDoc := rec(
  BookName  := "TruncationsOfPresentationsByProjectiveGradedModules",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Truncations of graded module presentations (for CAP) to affine semigroups",
),

Dependencies := rec(
  GAP := ">= 4.6",
  NeededOtherPackages := [ [ "GAPDoc", ">= 1.5" ],
                           [ "AutoDoc", ">=2016.02.16" ],
                           [ "MatricesForHomalg", ">= 2015.11.06" ],
                           [ "GradedRingForHomalg", ">= 2015.12.04" ],
                           [ "CAP", ">= 2016.02.19" ],
                           [ "CAPCategoryOfProjectiveGradedModules", ">=2016.03.15" ],
                           [ "CAPPresentationCategory", ">=2016.03.15" ],
                           [ "ComplexesAndFilteredObjectsForCAP", ">=2015.10.20" ],
                           [ "PresentationsByProjectiveGradedModules", ">=2016.03.15" ],
                           [ "4ti2Interface", ">= 2015.11.06" ],
                           [ "NormalizInterface", ">=0.9.6" ]
                           ],
  SuggestedOtherPackages := [ ],
  ExternalConditions := [ ],
),

AvailabilityTest := function()
        return true;
    end,

TestFile := "tst/testall.g",

#Keywords := [ "TODO" ],

));
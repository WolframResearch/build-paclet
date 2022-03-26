#!/usr/bin/env wolframscript
(* ::Package:: *)

(* :!CodeAnalysis::BeginBlock:: *)
(* :!CodeAnalysis::Disable::SuspiciousSessionSymbol:: *)

(* ::**********************************************************************:: *)
(* ::Section::Closed:: *)
(*Initialization*)
print[ a___ ] := WriteString[ "stdout", a, "\n" ];

print[ "Loading Wolfram`PacletCICD` from ", FindFile[ "Wolfram`PacletCICD`" ] ];

Needs[ "Wolfram`PacletCICD`" ];

getInput[ name_String ] :=
    Module[ { val },
        val = Environment[ "INPUT_" <> name ];
        print[ name, "=", val ];
        val
    ];

print[ "Building paclet..." ];

(* ::**********************************************************************:: *)
(* ::Section::Closed:: *)
(*Inputs*)

(* ::**********************************************************************:: *)
(* ::Subsection::Closed:: *)
(*Check*)
check = Interpreter[ "Boolean" ][ getInput[ "CHECK" ] ];
If[ ! BooleanQ @ check,
    print[ "::error::Expected a boolean value for input 'check' instead of ",
           getInput[ "CHECK" ]
    ];
    Exit[ 1 ]
];

(* ::**********************************************************************:: *)
(* ::Subsection::Closed:: *)
(*Debug*)
debug = Interpreter[ "Boolean" ][ getInput[ "DEBUG" ] ];
If[ ! BooleanQ @ debug,
    print[ "::error::Expected a boolean value for input 'debug' instead of ",
           getInput[ "DEBUG" ]
    ];
    Exit[ 1 ]
];

(* ::**********************************************************************:: *)
(* ::Subsection::Closed:: *)
(*Definition Notebook*)
defNB = getInput[ "DEFINITION_NOTEBOOK" ];
If[ ! FileExistsQ @ ExpandFileName @ defNB,
    print[ "::error::Definition notebook not found: ", defNB ];
    Exit[ 1 ]
];

(* ::**********************************************************************:: *)
(* ::Subsection::Closed:: *)
(*ResourceSystemBase*)
rsBase     = getInput[ "RESOURCE_SYSTEM_BASE" ];
rsTestURL  = URLBuild @ { rsBase, "TestSystem" };
rsBaseTest = URLFetch[ rsTestURL, { "StatusCode", "Content" } ];
If[ ! MatchQ[ rsBaseTest, { 200, _String } ],
    print[ "::error::Invalid ResourceSystemBase: ", rsBase ];
    print[ "::error::ResourceSystemBase test output: ", rsBaseTest ];
    Exit[ 1 ]
];

Needs[ "ResourceSystemClient`" -> None ];
$ResourceSystemBase = rsBase;

(* ::**********************************************************************:: *)
(* ::Subsection::Closed:: *)
(*Target*)
target = getInput[ "TARGET" ];

(* ::**********************************************************************:: *)
(* ::Section::Closed:: *)
(*Run*)
result =
    Block[
        {
            Print = print,
            DefinitionNotebookClient`BeginConsoleGroup,
            DefinitionNotebookClient`EndConsoleGroup
        },
        Wolfram`PacletCICD`BuildPaclet[
            File @ defNB,
            "Check"       -> check,
            "Target"      -> target,
            "Debug"       -> debug,
            "ConsoleType" -> "GitHub"
        ]
    ];

print @ result;

If[ MatchQ[ result, _Wolfram`PacletCICD`BuildPaclet ],
    print[ "::error::Wolfram`PacletCICD`BuildPaclet not defined" ];
    Exit[ 1 ]
];

(* :!CodeAnalysis::EndBlock:: *)
#!/usr/bin/env wolframscript
(* ::Package:: *)

(* :!CodeAnalysis::BeginBlock:: *)
(* :!CodeAnalysis::Disable::SuspiciousSessionSymbol:: *)

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

target = getInput[ "TARGET" ];

check = Interpreter[ "Boolean" ][ getInput[ "CHECK" ] ];
If[ ! BooleanQ @ check,
    print[ "::error::Expected a boolean value for input 'check' instead of ",
           getInput[ "CHECK" ]
    ];
    Exit[ 1 ]
];

debug = Interpreter[ "Boolean" ][ getInput[ "DEBUG" ] ];
If[ ! BooleanQ @ debug,
    print[ "::error::Expected a boolean value for input 'debug' instead of ",
           getInput[ "DEBUG" ]
    ];
    Exit[ 1 ]
];

defNB = getInput[ "DEFINITION_NOTEBOOK" ];
If[ ! FileExistsQ @ ExpandFileName @ defNB,
    print[ "::error::Definition notebook not found: ", defNB ];
    Exit[ 1 ]
];

result = Block[ { Print = print },
    Wolfram`PacletCICD`BuildPaclet[
        File @ defNB,
        "Preflight"   -> check,
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
#!/usr/bin/env wolframscript
(* ::Package:: *)

(* :!CodeAnalysis::BeginBlock:: *)
(* :!CodeAnalysis::Disable::SuspiciousSessionSymbol:: *)

print[ a___ ] := WriteString[ "stdout", a, "\n" ];

pacletInstall[ url_ ] :=
    Module[ { installed },
        print[ "Installing paclet from: ", url ];
        installed = PacletInstall[ url, ForceVersionInstall -> True ];
        If[ PacletObjectQ @ installed,
            print[ "Paclet installed to: ", installed[ "Location" ] ],
            print[ "::error:: Paclet installation failed: ", installed ];
            Exit[ 1 ]
        ]
    ];

print[ "Installing dependencies..." ];

pacletInstall[ "https://www.wolframcloud.com/obj/rhennigan/Paclets/DefinitionNotebookClient.paclet"                ];
pacletInstall[ "https://www.wolframcloud.com/obj/rhennigan/Paclets/PacletResource.paclet"                          ];
pacletInstall[ "https://github.com/rhennigan/PacletCICD/releases/download/v0.1.1/Wolfram__PacletCICD-0.1.1.paclet" ];

(* :!CodeAnalysis::EndBlock:: *)
#!/usr/bin/env wolframscript
(* ::Package:: *)

(* :!CodeAnalysis::BeginBlock:: *)
(* :!CodeAnalysis::Disable::SuspiciousSessionSymbol:: *)

print[ a___ ] := WriteString[ "stdout", a, "\n" ];

getInput[ name_String ] :=
    Module[ { val },
        val = Environment[ "INPUT_" <> name ];
        print[ name, "=", val ];
        val
    ];

print[ "Installing dependencies..." ];

pacletInstall[ "https://www.wolframcloud.com/obj/rhennigan/Paclets/DefinitionNotebookClient.paclet" ];
pacletInstall[ "https://www.wolframcloud.com/obj/rhennigan/Paclets/PacletResource.paclet"           ];

pacletInstall[ url_ ] :=
    Module[ { zip, tmp, pacs, downloaded, installed },
        print[ "Installing paclet from: ", url ];
        If[ StringEndsQ[ url, ".zip" ],
            zip = URLDownload @ url;
            ExtractArchive[ zip, tmp = CreateDirectory[ ] ];
            pacs = FileNames[ "PacletInfo." ~~ ("m" | "wl"), tmp, Infinity ];
            downloaded = CreatePacletArchive @ First[ pacs, $Failed ],
            downloaded = url
        ];
        installed = PacletInstall[ downloaded, ForceVersionInstall -> True ];
        If[ PacletObjectQ @ installed,
            print[ "Paclet installed to: ", installed[ "Location" ] ],
            print[ "::error:: Paclet installation failed: ", installed ];
            Exit[ 1 ]
        ]
    ];


toPacletCICDURL[ "latest" ] :=
    Part[
        URLExecute[
            "https://api.github.com/repos/rhennigan/PacletCICD/releases/latest",
            "RawJSON"
        ],
        "assets",
        1,
        "browser_download_url"
    ];

toPacletCICDURL[ vers_String ] :=
    If[ StringMatchQ[ vers, (DigitCharacter..~~".")...~~(DigitCharacter..) ],
        TemplateApply[
            "https://github.com/rhennigan/PacletCICD/releases/download/v`1`/Wolfram__PacletCICD-`1`.paclet",
            { vers }
        ],
        TemplateApply[
            "https://github.com/rhennigan/PacletCICD/archive/refs/heads/`1`.zip",
            vers
        ]
    ];

pacVer = getInput[ "PACLET_CICD_VERSION" ];
pacURL = toPacletCICDURL @ pacVer;

If[ ! StringQ @ pacURL,
    Print[ "Could not determine URL for specified version" ];
    Exit[ 1 ]
];

pacletInstall @ pacURL;

(* :!CodeAnalysis::EndBlock:: *)
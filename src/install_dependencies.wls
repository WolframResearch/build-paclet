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

$pacletsRoot = "https://www.wolframcloud.com/obj/rhennigan/Paclets";

pacletInstall[ n_String -> v_String ] := pacletInstall[ n <> "-" <> v ];

pacletInstall[ url_String? urlQ ] := Enclose[
    Module[ { installed },
        print[ "Installing paclet from: ", url ];
        installed = PacletInstall[ url, ForceVersionInstall -> True ];
        If[ PacletObjectQ @ installed,
            print[ "Paclet installed to: ", installed[ "Location" ] ],
            print[ "::error:: Paclet installation failed: ", installed ];
            Exit[ 1 ]
        ]
    ],
    Function[
        print[ "::error:: Paclet installation failed: ", url ];
        Exit[ 1 ]
    ]
];

pacletInstall[ spec_String ] := Enclose[
    Module[ { url, zip, tmp, pacs, dir, downloaded, installed },
        url = URLBuild @ { $pacletsRoot, spec <> ".paclet" };
        ConfirmAssert @ StringQ @ url;
        print[ "Installing paclet from: ", url ];
        If[ StringEndsQ[ url, ".zip" ],
            zip = Confirm @ URLDownload @ url;
            Confirm @ ExtractArchive[ zip, tmp = CreateDirectory[ ] ];
            pacs = FileNames[ "PacletInfo." ~~ ("m"|"wl"), tmp, Infinity ];
            dir = DirectoryName @ Confirm @ First[ pacs, $Failed ];
            downloaded = CreatePacletArchive @ dir,
            downloaded = url
        ];
        installed = PacletInstall[ downloaded, ForceVersionInstall -> True ];
        If[ PacletObjectQ @ installed,
            print[ "Paclet installed to: ", installed[ "Location" ] ],
            print[ "::error:: Paclet installation failed: ", installed ];
            Exit[ 1 ]
        ]
    ],
    Function[
        print[ "::error:: Paclet installation failed: ", spec ];
        Exit[ 1 ]
    ]
];


urlQ[ url_String ] := StringQ @ URLParse[ url, "Scheme" ];
urlQ[ ___        ] := False;


toPacletCICDURL[ "latest" ] :=
    Part[
        URLExecute[
            "https://api.github.com/repos/WolframResearch/PacletCICD/releases/latest",
            "RawJSON"
        ],
        "assets",
        1,
        "browser_download_url"
    ];

toPacletCICDURL[ vers_String ] :=
    If[ StringMatchQ[ vers, (DigitCharacter..~~".")...~~(DigitCharacter..) ],
        TemplateApply[
            "https://github.com/WolframResearch/PacletCICD/releases/download/v`1`/Wolfram__PacletCICD-`1`.paclet",
            { vers }
        ],
        TemplateApply[
            "https://github.com/WolframResearch/PacletCICD/archive/refs/heads/`1`.zip",
            vers
        ]
    ];

pacletInstall[ "DefinitionNotebookClient" -> "1.9.0"  ];
pacletInstall[ "PacletResource"           -> "0.10.0" ];
pacletInstall[ "ResourceSystemClient"     -> "1.24.0" ];

pacVer = getInput[ "PACLET_CICD_VERSION" ];
pacURL = toPacletCICDURL @ pacVer;

If[ ! StringQ @ pacURL,
    Print[ "Could not determine URL for specified version" ];
    Exit[ 1 ]
];

pacletInstall @ pacURL;

(* :!CodeAnalysis::EndBlock:: *)
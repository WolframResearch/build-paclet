# Build Paclet for the [Wolfram Language Paclet Repository](https://resources.wolframcloud.com/PacletRepository/)

The Build Paclet action is an interface to the 
[BuildPaclet](https://resources.wolframcloud.com/PacletRepository/resources/Wolfram/PacletCICD/ref/BuildPaclet.html) 
function from 
[Wolfram/PacletCICD](https://resources.wolframcloud.com/PacletRepository/resources/Wolfram/PacletCICD/) 
and can be used to build your Wolfram Language paclet from source code within GitHub Actions. 
This is roughly equivalent to using the **Build > All** menu item from the resource definition notebook within 
Wolfram Desktop or Mathematica.

## Usage

A YAML file that uses this action can be automatically generated for your paclet using 
[WorkflowExport](https://resources.wolframcloud.com/PacletRepository/resources/Wolfram/PacletCICD/ref/WorkflowExport.html):

```Mathematica
PacletSymbol["Wolfram/PacletCICD", "WorkflowExport"]["path/to/paclet", "Build"]
```

Alternatively, using GitHub actions YAML syntax directly:
```yaml
name: Build Paclet
on: [push]
jobs: 
  Build: 
    name: Build Paclet
    runs-on: ubuntu-latest
    container: 
      image: wolframresearch/wolframengine:latest
      options: --user root
    env: 
      WOLFRAMSCRIPT_ENTITLEMENTID: ${{ secrets.WOLFRAMSCRIPT_ENTITLEMENTID }}
    steps: 
    - name: Checkout repository
      uses: actions/checkout@v2
    - name: Build paclet
      uses: WolframResearch/build-paclet@v1
    - name: UploadArtifact
      uses: actions/upload-artifact@v2
      with: 
        path: ${{ env.PACLET_BUILD_DIR }} # set during the build-paclet step
```

## Parameters

Input                     | Default                     | Description
------------------------- | --------------------------- | ---------------
`check`                   | `true`                      | Whether to check the paclet for errors prior to building
`target`                  | `"Submit"`                  | The named configuration to use for error checking when `check` is `true`. Some possible values are `"Build"`, `"Check"`, `"Deploy"`, and `"Submit"`.
`definition_notebook`     | `"./ResourceDefinition.nb"` | The relative path to the paclet's resource definition notebook
`paclet_cicd_version`     | `"latest"`                  | The version of [PacletCICD](https://resources.wolframcloud.com/PacletRepository/resources/Wolfram/PacletCICD/) to use

# Module Development with Sampler

https://github.com/gaelcolas/Sampler

## How to start a new module pipeline:
	
- Create a new structure with the command
``` powershell 
New-SampleModule -DestinationPath D:\ -ModuleType CompleteSample -ModuleAuthor Me -ModuleName FileSizeReporter -ModuleDescription 'Some reporting stuff' -ModuleVersion 0.1 -LicenseType MIT
```
- Use the build script to start the build.
- Cleanup the ```build.yml``` file until all errors are gone.

With Sampler you have:
- Build Pipeline
- Automated dependency resolution
- Unit and Integration Testing
  - Code Coverage
- Linting (enforces coding guidelines)
- Changelog Management
- Documentation is enforced
- Automated version management (GitVersion)

# Desired State Configuration

Basic sample in the file [SimpleConfig.ps1](./DSC/SimpleConfig.ps1).

DSC as it is doesn't scale and needs some tooling around it. Furthermore DSC makes most sense when integrated in DevOps processes as described in the whitepaper [The Release Pipeline Model](https://docs.microsoft.com/en-us/powershell/scripting/dsc/further-reading/whitepapers).

The principles and patters described in the whitepaper come to life in the [DscWorkshop](https://github.com/dsccommunity/dscworkshop). This template comes with some [exercises](https://github.com/dsccommunity/DscWorkshop/tree/main/Exercises) that should help a lot to get into the material in a structured way. In case things do not work as expected, please open a issue on GitHub and let us know.



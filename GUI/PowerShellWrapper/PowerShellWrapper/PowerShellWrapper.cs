using System;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Text;
using System.Threading.Tasks;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Threading;

namespace Aldi
{
    public class PowerShellWrapper : IDisposable
    {
        Runspace runspace = null;
        PowerShell powershell = null;
        CancellationTokenSource tokenSource = null;

        #region Constructor
        public PowerShellWrapper()
        {
            runspace = RunspaceFactory.CreateRunspace();
            runspace.Open();

            tokenSource = new CancellationTokenSource();
        }

        public PowerShellWrapper(string[] modules)
        {
            var sessionState = InitialSessionState.CreateDefault();
            sessionState.ImportPSModule(modules);

            runspace = RunspaceFactory.CreateRunspace(sessionState);
            runspace.Open();
        }
        #endregion Constructor

        async public Task<PSDataCollection<PSObject>> Invoke(string script)
        {
            powershell = PowerShell.Create();
            powershell.Runspace = runspace;

            powershell.AddScript(script);

            var task = Task.Factory.FromAsync(powershell.BeginInvoke(), result => powershell.EndInvoke(result));
            await task;

            return task.Result;
        }

        async public Task<PSDataCollection<PSObject>> Invoke(string script,
            Action<object, DataAddedEventArgs> errorHandler,
            Action<object, DataAddedEventArgs> warningHandler,
            Action<object, DataAddedEventArgs> verboseHandler,
            Action<object, DataAddedEventArgs> debugHandler,
            Action<object, DataAddedEventArgs> progressHandler)
        {
            powershell = PowerShell.Create();
            powershell.Runspace = runspace;

            powershell.AddScript(script);
            powershell.Streams.Error.DataAdded += (o, ea) => errorHandler(o, ea);
            powershell.Streams.Warning.DataAdded += (o, ea) => warningHandler(o, ea);
            powershell.Streams.Verbose.DataAdded += (o, ea) => verboseHandler(o, ea);
            powershell.Streams.Debug.DataAdded += (o, ea) => debugHandler(o, ea);
            powershell.Streams.Progress.DataAdded += (o, ea) => progressHandler(o, ea);

            
            var task = Task.Factory.FromAsync(powershell.BeginInvoke(), result => powershell.EndInvoke(result));

            await task;

            return task.Result;
        }

        public Collection<PSObject> InvokeSynchronous(string script)
        {
            var powershell = PowerShell.Create();
            powershell.Runspace = runspace;

            powershell.AddScript(script);

            var results = powershell.Invoke();

            return results;
        }

        public Collection<PSObject> InvokeScriptFileSynchronous(string path)
        {
            var script = System.IO.File.ReadAllText(path);

            var powershell = PowerShell.Create();
            powershell.Runspace = runspace;

            powershell.AddScript(script);

            var results = powershell.Invoke();

            return results;
        }

        public void Stop()
        {
            powershell.Stop();
        }

        #region Dispose
        public void Dispose()
        {
            if (powershell != null)
            {
                powershell.Stop();
                powershell.Dispose();
            }

            runspace.Dispose();
        }
        #endregion Dispose
    }
}
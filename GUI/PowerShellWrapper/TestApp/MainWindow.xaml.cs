using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using Aldi;
using System.Threading;
using System.Windows.Media.Animation;
using System.Management.Automation;

namespace TestApp
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        PowerShellWrapper ps = null;
        CancellationTokenSource cts = null;

        public MainWindow()
        {
            InitializeComponent();
        }

        void UpdateError(object sender, DataAddedEventArgs e)
        {
            var item = new PowerShellItem(DataType.Error, ((PSDataCollection<ErrorRecord>)sender)[e.Index].ToString());
            this.lstOutput.Dispatcher.Invoke(new Action(() => lstOutput.Items.Add(item)));
        }

        void UpdateWarning(object sender, DataAddedEventArgs e)
        {
            var item = new PowerShellItem(DataType.Warning, ((PSDataCollection<WarningRecord>)sender)[e.Index].ToString());
            this.lstOutput.Dispatcher.Invoke(new Action(() => lstOutput.Items.Add(item)));
        }

        void UpdateVerbose(object sender, DataAddedEventArgs e)
        {
            var item = new PowerShellItem(DataType.Verbose, ((PSDataCollection<VerboseRecord>)sender)[e.Index].ToString());
            this.lstOutput.Dispatcher.Invoke(new Action(() => lstOutput.Items.Add(item)));
        }

        void UpdateDebug(object sender, DataAddedEventArgs e)
        {
            var item = new PowerShellItem(DataType.Debug, ((PSDataCollection<DebugRecord>)sender)[e.Index].ToString());
            this.lstOutput.Dispatcher.Invoke(new Action(() => lstOutput.Items.Add(item)));
        }

        void UpdateProgress(object sender, DataAddedEventArgs e)
        {
            Action<double> dialog = (value) =>
            {
                Duration duration = new Duration(TimeSpan.FromMilliseconds(100));
                DoubleAnimation doubleanimation = new DoubleAnimation(value, duration);
                pgbStatus.BeginAnimation(ProgressBar.ValueProperty, doubleanimation);
            };
            var v = pgbStatus.Dispatcher.Invoke(() => pgbStatus.Value) + 1;
            pgbStatus.Dispatcher.Invoke(() => dialog(v));
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            var modules = new string[] { @"D:\TestModule.psm1" };
            ps = new PowerShellWrapper(modules);

            var results = ps.InvokeSynchronous(@"dir c:\");

            foreach (var directory in results)
            {
                cmbDirectories.Items.Add(directory);
            }

            var currentDate = ps.InvokeSynchronous(@"(Get-Date).AddMonths(3)");
            calCalendar.DisplayDate = (DateTime)currentDate[0].BaseObject;
        }

        private void Window_Closing(object sender, System.ComponentModel.CancelEventArgs e)
        {
            ps.Dispose();
        }

        private void btnClearListBox_Click(object sender, RoutedEventArgs e)
        {
            lstOutput.Items.Clear();
        }

        private void btnCancal_Click(object sender, RoutedEventArgs e)
        {
            cts.Cancel();
        }

        async private void btnParallelStartScript_Click(object sender, RoutedEventArgs e)
        {
            Duration duration = new Duration(TimeSpan.FromMilliseconds(100));
            DoubleAnimation doubleanimation = new DoubleAnimation(0, duration);
            pgbStatus.BeginAnimation(ProgressBar.ValueProperty, doubleanimation);
            btnCancal.IsEnabled = true;
            tabMain.IsEnabled = false;
            cts = new CancellationTokenSource();

            ((System.Windows.Controls.Button)sender).IsEnabled = false;

            var sb = new StringBuilder();
            sb.AppendLine(string.Format("1..{0} | ForEach-Object {{", txtParallelNumberOfIterations.Text));
            sb.Append(txtParallelCmd.Text);
            sb.AppendLine("}");

            var task = ps.Invoke(sb.ToString(),
                UpdateError,
                UpdateWarning,
                UpdateVerbose,
                UpdateDebug,
                UpdateProgress);

            try
            {
                await task.HandleCancellation(cts.Token, ps.Stop);

                var results = task.Result;

                foreach (var result in results)
                {
                    var item = new PowerShellItem(DataType.Data, result.ToString());
                    lstOutput.Items.Add(item);
                }
            }
            catch (OperationCanceledException)
            {
                lstOutput.Items.Add(new PowerShellItem(DataType.Error, "Processing cancelled by user request"));

                duration = new Duration(TimeSpan.FromMilliseconds(100));
                doubleanimation = new DoubleAnimation(0, duration);
                pgbStatus.BeginAnimation(ProgressBar.ValueProperty, doubleanimation);

                return;
            }
            catch (Exception ex)
            {
                lstOutput.Items.Add(new PowerShellItem(DataType.Error, string.Format("Error executing the script: '{0}'", ex.Message)));
                return;
            }
            finally
            {
                ((System.Windows.Controls.Button)sender).IsEnabled = true;
                btnCancal.IsEnabled = false;
                tabMain.IsEnabled = true;
            }
        }

        private void btnSerialStartScript_Click(object sender, RoutedEventArgs e)
        {
            Duration duration = new Duration(TimeSpan.FromMilliseconds(100));
            DoubleAnimation doubleanimation = new DoubleAnimation(0, duration);
            pgbStatus.BeginAnimation(ProgressBar.ValueProperty, doubleanimation);
            btnCancal.IsEnabled = true;
            tabMain.IsEnabled = false;
            cts = new CancellationTokenSource();

            ((System.Windows.Controls.Button)sender).IsEnabled = false;

            var sb = new StringBuilder();
            sb.AppendLine(string.Format("1..{0} | ForEach-Object {{", txtSerialNumberOfIterations.Text));
            sb.Append(txtSerialCmd.Text);
            sb.AppendLine("}");

            try
            {
                var results = ps.InvokeSynchronous(sb.ToString());

                foreach (var result in results)
                {
                    var item = new PowerShellItem(DataType.Data, result.ToString());
                    lstOutput.Items.Add(item);
                }
            }
            catch (Exception ex)
            {
                lstOutput.Items.Add(new PowerShellItem(DataType.Error, string.Format("Error executing the script: '{0}'", ex.Message)));
                return;
            }
            finally
            {
                ((System.Windows.Controls.Button)sender).IsEnabled = true;
                btnCancal.IsEnabled = false;
                tabMain.IsEnabled = true;
            }
        }

        private void btnInvokeScriptFile_Click(object sender, RoutedEventArgs e)
        {
            // Create OpenFileDialog 
            Microsoft.Win32.OpenFileDialog dialog = new Microsoft.Win32.OpenFileDialog();

            // Set filter for file extension and default file extension 
            dialog.DefaultExt = ".txt";
            dialog.Filter = "PowerShell Script (.ps1)|*.ps1";

            // Display OpenFileDialog by calling ShowDialog method 
            Nullable<bool> dialogResult = dialog.ShowDialog();

            // Get the selected file name and display in a TextBox 
            if (dialogResult == true)
            {
                // Open document 
                string filename = dialog.FileName;

                var results = ps.InvokeScriptFileSynchronous(filename);

                foreach (var result in results)
                {
                    var item = new PowerShellItem(DataType.Data, result.ToString());
                    lstOutput.Items.Add(item);
                }
            }
        }
    }

    public class PowerShellItem
    {
        public DataType Type { get; set; }
        public string Data { get; set; }

        public string Color { get; set; }

        public PowerShellItem(DataType type, string data)
        {
            this.Type = type;
            this.Data = data;

            switch (type)
            {
                case DataType.Data:
                    Color = "Black";
                    break;
                case DataType.Debug:
                    Color = "Khaki";
                    break;
                case DataType.Error:
                    Color = "Red";
                    break;
                case DataType.Verbose:
                    Color = "Turquoise";
                    break;
                case DataType.Warning:
                    Color = "Orange";
                    break;
                default:
                    Color = "Bkack";
                    break;
            }
        }
    }

    public enum DataType
    {
        Data,
        Error,
        Warning,
        Verbose,
        Debug
    }
}
using System;
using System.Diagnostics;

namespace Installer
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");
#if true
            ProcessStartInfo startInfo = new ProcessStartInfo()
            {
                WorkingDirectory = @"C:\Users\\access\Documents\GitHub\CyberXSecurity-Project-1\Tester",
                //FileName = "complete_install.yml",
                FileName = "installer.exe",
                CreateNoWindow = false,
                UseShellExecute = false,
                
                Arguments = "",
                WindowStyle = ProcessWindowStyle.Hidden,
                RedirectStandardOutput = true,
            };
            using Process process = new Process()
            {
                StartInfo = startInfo,
            };
            process.Start();
            //string output = process.StandardOutput.ReadToEnd();

            process.WaitForExit();
            
#endif
            Environment.Exit(0);
        }
    }
}

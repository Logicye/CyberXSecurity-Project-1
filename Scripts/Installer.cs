if(){
    Console.WriteLine($"Hello {System.Environment.GetEnvironmentVariable("USER")}! I'm {System.Environment.MachineName} and I'm talking to you from {System.IO.Directory.GetCurrentDirectory()}");
}
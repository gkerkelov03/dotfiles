#!/usr/bin/env dotnet

using System.Diagnostics;
using System.Diagnostics.CodeAnalysis;
using System.Text.Encodings.Web;
using System.Text.Json;
using System.Text.Json.Nodes;

var packageManager   = "paru";
var installPackagesShellCommand = $"{packageManager} -S --needed --noconfirm";
var uninstallPackagesShellCommand = $"{packageManager} -Rns --noconfirm";
var updatePackagesShellCommand = $"{packageManager} -S --noconfirm";
var updateAllPackagesShellCommand = $"{packageManager} -Syu";
var cleanupShellCommand = $"{packageManager} -c"; // runs after update-all, removes unneeded dependencies
var packageInfoShellCommand = $"{packageManager} -Qi";

var packagesFilePath    = $"{Environment.GetEnvironmentVariable("HOME")}/dotfiles/arch/packages.json";
var unsortedSectionName = "unsorted";
var addSilentlyFlag = "--silent";

var usage = """
    Usage:
      pkg add|a|install|i|get|g [--silent] <packages-list>
      pkg remove|r|delete|d|uninstall <packages-list>
      pkg update|upgrade <packages-list>
      pkg update-all|upgrade-all
      pkg check|c|info <packages-list>
      pkg help|h|--help|-h

    Options:
      --silent install without adding the packages to packages.json
    """;

// keeps characters like ' & □ readable instead of ' & □
var prettyJson = new JsonSerializerOptions { WriteIndented = true, Encoder = JavaScriptEncoder.UnsafeRelaxedJsonEscaping };

if (args.Length == 0)
{
  ExitWithErrorMessageAndDisplayTheUsage("No package operation specified");
}

var packageOperationPassedFromTheTerminal = args[0];

if(packageOperationPassedFromTheTerminal is "help" or "h" or "--help" or "-h")
{
  Console.WriteLine(usage);
  return;
}

var packageOperation = packageOperationPassedFromTheTerminal switch 
{
    "add" or "a" or "install" or "i" or "get" or "g" => PackageOperation.AddPackages, 
    "remove" or "r" or "delete" or "d" or "uninstall" or "u" => PackageOperation.RemovePackages,
    "update" or "upgrade" => PackageOperation.UpdatePackages,
    "update-all" or "upgrade-all" => PackageOperation.UpdateAllPackages,
    "check" or "c" or "info" => PackageOperation.ShowPackagesInfo,  
    _ => (PackageOperation?)null
};

if(packageOperation is null)
{
  ExitWithErrorMessageAndDisplayTheUsage($"Unknown command: {packageOperationPassedFromTheTerminal}");
}

var flagsPassedFromTheTerminal = args[1..].Where(IsFlag).ToList();
ValidateTheFlags();

var packagesPassedFromTheTerminal = args[1..].Where(argument => !IsFlag(argument)).ToArray();
var packagesFileJsonObject = new JsonObject();
IEnumerable<JsonObject> packagesFileSections = [];

if(packageOperation is not (PackageOperation.UpdateAllPackages or PackageOperation.UpdatePackages))
{
  RequireAtLeastOnePackageNameToBePassedFromTheTerminal();
  packagesFileJsonObject = LoadPackagesFileJsonObject();
  packagesFileSections = packagesFileJsonObject.Select(section => section.Value!.AsObject());
}

switch (packageOperation)
{
    case PackageOperation.AddPackages: AddThePackages(); break;
    case PackageOperation.RemovePackages: RemoveThePackages(); break;
    case PackageOperation.UpdatePackages : RunShellCommandSuccessfullyOrExitWithTheErrorMessageOfTheShellCommand(updatePackagesShellCommand, packagesPassedFromTheTerminal); break;
    case PackageOperation.UpdateAllPackages: UpdateAllThePackages(); break;
    case PackageOperation.ShowPackagesInfo: ShowThePackagesInfo(); break;
}

void AddThePackages()
{
   RunShellCommandSuccessfullyOrExitWithTheErrorMessageOfTheShellCommand(installPackagesShellCommand, packagesPassedFromTheTerminal);

    if (flagsPassedFromTheTerminal.Contains(addSilentlyFlag))
    {
      return;
    }

    var packagesThatAreNotAlreadyInThePackagesFile = packagesPassedFromTheTerminal.Where(
        package => !packagesFileSections.Any(section => section.ContainsKey(package))
    );

    foreach (var package in packagesThatAreNotAlreadyInThePackagesFile)
    {
        var description = AskForDescriptionOfThePackage(package);
        packagesFileJsonObject[unsortedSectionName]![package] = description;
        SaveTheModifiedPackagesFileJsonObjectIntoTheFile();

        Console.WriteLine();
        Console.WriteLine($"Successfully added the packages!");
    }
}

void RemoveThePackages()
{
    RunShellCommandSuccessfullyOrExitWithTheErrorMessageOfTheShellCommand(uninstallPackagesShellCommand, packagesPassedFromTheTerminal);

    foreach (var package in packagesPassedFromTheTerminal)
    {
      foreach (var section in packagesFileSections)
      {
        section.Remove(package);
      }
    }

    SaveTheModifiedPackagesFileJsonObjectIntoTheFile();
    Console.WriteLine($"Successfully removed the packages!");
}

void UpdateAllThePackages()
{
    if (packagesPassedFromTheTerminal.Length > 0) ExitWithErrorMessageAndDisplayTheUsage($"'{packageOperation}' takes no package names");
    RunShellCommandSuccessfullyOrExitWithTheErrorMessageOfTheShellCommand(updateAllPackagesShellCommand);
    RunShellCommandSuccessfullyOrExitWithTheErrorMessageOfTheShellCommand(cleanupShellCommand);
}

void ShowThePackagesInfo()
{
  foreach (var package in packagesPassedFromTheTerminal)
  {
    var sectionContainingThePackage = packagesFileSections.FirstOrDefault(section => section.ContainsKey(package));
    var packageDescription = sectionContainingThePackage?[package]?.GetValue<string>();

    if(packageDescription is null)
    {
      Console.WriteLine();
      Console.WriteLine($"The package {package} is not in our packages.json file");
      Console.WriteLine();
    }
    else 
    {
      Console.WriteLine("Package description from our packages.json file");
      Console.WriteLine();
      Console.WriteLine($"{package}: {packageDescription}");
      Console.WriteLine();
    }


    RunShellCommandSuccessfullyOrExitWithTheErrorMessageOfTheShellCommand(packageInfoShellCommand, package);
  }
}

JsonObject LoadPackagesFileJsonObject() 
{
    if(!File.Exists(packagesFilePath))
    {
      ExitWithErrorMessageAndDisplayTheUsage("The packages file doesn't exist yet!");
    }

    return JsonNode.Parse(File.ReadAllText(packagesFilePath))!.AsObject();
}

void SaveTheModifiedPackagesFileJsonObjectIntoTheFile() =>
    File.WriteAllText(packagesFilePath, packagesFileJsonObject.ToJsonString(prettyJson));

bool IsFlag(string argument) => argument.StartsWith('-');

void ValidateTheFlags()
{
  if(packageOperation == PackageOperation.AddPackages)
  {
      AllowOnlyFlags(addSilentlyFlag);
  }
  else
  {
    //Don't allow any flags
    AllowOnlyFlags();
  }
}

void AllowOnlyFlags(params string[] allowedFlags)
{
    var unknownFlag = flagsPassedFromTheTerminal.FirstOrDefault(flag => !allowedFlags.Contains(flag));
    if (unknownFlag is not null) ExitWithErrorMessageAndDisplayTheUsage($"Unknown option for '{packageOperation}': {unknownFlag}");
}

void RequireAtLeastOnePackageNameToBePassedFromTheTerminal()
{
    if (packagesPassedFromTheTerminal.Length == 0)
    {
        ExitWithErrorMessageAndDisplayTheUsage($"'{packageOperation}' needs at least one package name");
    }
}

string AskForDescriptionOfThePackage(string packageName)
{
    Console.Write($"Description for {packageName}: ");
    var description = Console.ReadLine()?.Trim();

    while (description == "")
    {
      Console.Write($"Description for {packageName}: ");
      description = Console.ReadLine()?.Trim();
    }

    return description ?? "";
}

void RunShellCommandSuccessfullyOrExitWithTheErrorMessageOfTheShellCommand(string shellCommand, params string[] packageNames)
{
    using var process = Process.Start("sh", ["-c", $"{shellCommand} \"$@\"", "pkg", .. packageNames]);
    process.WaitForExit();

    if (process.ExitCode != 0)
    {
      Environment.Exit(process.ExitCode);
    }
}

[DoesNotReturn]
void ExitWithErrorMessageAndDisplayTheUsage(string errorMessage)
{
    Console.Error.WriteLine($"Error: {errorMessage}\n");
    Console.Error.WriteLine(usage);
    Environment.Exit(1);
}

enum PackageOperation 
{
  AddPackages,
  RemovePackages,
  UpdatePackages,
  UpdateAllPackages,
  ShowPackagesInfo
}

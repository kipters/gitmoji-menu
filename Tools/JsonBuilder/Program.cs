using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Net.Http;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Newtonsoft.Json;
using static System.Console;

namespace JsonBuilder
{
    class Program
    {
        private const string GitmojiListUrl = "https://raw.githubusercontent.com/carloscuesta/gitmoji/master/src/data/gitmojis.json";
        private const string GitmojiVarsUrl = "https://raw.githubusercontent.com/carloscuesta/gitmoji/master/src/styles/_includes/_vars.scss";
        private const string tmpDir = "tmp";

        private static Regex ColorRegex = new Regex(@"[$]([a-zA-Z]*)[:\s#]*(.*)[;]", RegexOptions.Compiled);
        private static Regex MappingRegex = new Regex(@"\$gitmojis:\s*\((.*)\)", RegexOptions.Compiled);
        private static Regex MapParseRegex = new Regex(@"([a-zA-Z\-]*)\:\s*\$([a-zA-Z]*)", RegexOptions.Compiled);

        private static void Main(string[] args) => AsyncMain(args).ConfigureAwait(false).GetAwaiter().GetResult();
        
        private static async Task AsyncMain(string[] args)
        {
            var formatted = args.Contains("--format");
            var freshStart = args.Contains("--fresh");
            if (Directory.Exists(tmpDir))
                Directory.Delete(tmpDir, true);

            var client = new HttpClient();
            var gitmojis = await GetFileAsync("gitmojis.json", GitmojiListUrl);
            var vars = await GetFileAsync("_vars.scss", GitmojiVarsUrl);

            var definitionDictionary = JsonConvert.DeserializeObject<Dictionary<string, GitmojiDefinition[]>>(gitmojis);
            var definitions = definitionDictionary["gitmojis"];

            
            var colorMatches = ColorRegex.Matches(vars);

            var colors = new Dictionary<string, Color>();

            foreach (var omatch in colorMatches)
            {
                var match = (Match) omatch;
                var emoji = match.Groups[1].Value;
                var colorString = match.Groups[2].Value;

                if (!Color.TryParse(colorString, out Color color))
                    WriteLine($"Failed to parse {emoji} ({colorString})");

                colors.Add(emoji, color);
            }

            var mappingString = MappingRegex.Match(vars);
            var mappings = MapParseRegex.Matches(mappingString.Value);

            var colorMap = new Dictionary<string, string>();

            foreach (var omatch in mappings)
            {
                var match = (Match) omatch;
                var emojiName = match.Groups[1].Value;
                var colorName = match.Groups[2].Value;

                var emoji = definitions.First(x => x.Name == emojiName);
                var color = colors[colorName];
                emoji.Color = new [] { color.Red, color.Green, color.Blue };
            }

            var formatting = formatted ? Formatting.Indented : Formatting.None;
            var newDefinitions = JsonConvert.SerializeObject(definitions, formatting);
            Directory.CreateDirectory("out");
            File.WriteAllText(Path.Combine("out", "def.json"), newDefinitions);
        }

        private static async Task<string> GetFileAsync(string name, string downloadUrl)
        {
            Directory.CreateDirectory(tmpDir);
            var path = Path.Combine(tmpDir, name);
            string data;
            
            if (File.Exists(path))
            {
                WriteLine($"Loading {name} from disk");
                data = File.ReadAllText(path);
                return data;
            }

            WriteLine($"Loading {name} from the network");
            var client = new HttpClient();
            data = await client.GetStringAsync(downloadUrl);
            File.WriteAllText(path, data);
            return data;
        }
    }
}

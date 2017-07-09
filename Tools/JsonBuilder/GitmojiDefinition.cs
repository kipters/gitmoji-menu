namespace JsonBuilder
{
    internal class GitmojiDefinition
    {
        public string Emoji { get; set; }
        public string Code { get; set; }
        public string Description { get; set; }
        public string Name { get; set; }
        public int[] Color { get; set; }
        public override string ToString() => Name;
    }
}